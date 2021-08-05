// @dart=2.9

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:sign_in_apple/sign_in_apple.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../models/http_exception.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;
  String uid2;

  String nameUser;
  String emailUser;
  String areaUser;
  String dateUser;
  String imageUserUrl;

  bool get isAuth {
    return _token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      [String email,
      String password,
      String urlSegment,
      String name,
      String area,
      bool signUp,
      String imageUrl]) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBMhYCade8T5qN9HQoFINqPaXHbBX4-aNk';
    try {
      final res = await http.post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(res.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      uid2 = _userId;
      emailUser = email;
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _autoLoguot();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final prefs2 = await SharedPreferences.getInstance();
      String userData2 = json.encode({
        'email': email,
        'password': password,
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs2.setString('info', userData2);

      String userData = json.encode({
        'email': email,
        'password': password,
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);

      // save user info firestore
      if (signUp)
        Firestore.instance.collection('users').document(_userId).setData({
          'token': _token,
          'name': name,
          'user_uid': _userId,
          'area': area,
          'email': email,
          'password': password,
          "time": DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now()),
          'imageUrl': imageUrl,
        });

      //update token
      if (!signUp)
        Firestore.instance.collection('users').document(_userId).updateData({
          'token': _token,
        });
    } catch (e) {
      throw e;
    }
  }

  Future<void> signUp(String email, String password, String name, String area,
      String imageUrl) async {
    print('SignUp');
    return _authenticate(email, password, 'signUp', name, area, true, imageUrl);
  }

  Future<void> logIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword', '', '', false);
  }

  //get user info
  Future gitCurrentUserInfo() async {
    DocumentSnapshot documentsUser;
    DocumentReference documentRef =
        Firestore.instance.collection('users').document(_userId);
    documentsUser = await documentRef.get();
    nameUser = documentsUser['name'];
    areaUser = documentsUser['area'];
    dateUser = documentsUser['time'];
    imageUserUrl = documentsUser['imageUrl'];
    notifyListeners();
    return documentsUser;
  }

  //update user info
  Future updateUserInfo(name, area) async {
    await Firestore.instance.collection('users').document(_userId).updateData({
      'name': name,
      'area': area,
    });
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) return false;

    final extractedData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;

    final expiryDate = DateTime.parse(extractedData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) return false;
    _token = extractedData['token'];
    _userId = extractedData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLoguot();
    return true;
  }

  Future<void> loguot() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
      googleSignIn.disconnect();
      FirebaseAuth.instance.signOut();
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLoguot() async {
    if (_authTimer != null) {
      _authTimer.cancel();
    }

    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), loguot);
  }

  //google
  GoogleSignInAccount _user;

  GoogleSignInAccount get user => _user;
  final googleSignIn = GoogleSignIn();

  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    _user = googleUser;
    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.getCredential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((value) => {
              _token = googleAuth.idToken,
              uid2 = googleUser.id,
              _userId = googleUser.id,
              nameUser = googleUser.displayName,
              emailUser = googleUser.email,
              isAuth,
              imageUserUrl = googleUser.photoUrl,
              Firestore.instance.collection('users').document(_userId).setData({
                'token': _token,
                'name': nameUser,
                'user_uid': _userId,
                'area': 'google',
                'email': emailUser,
                'password': 'google',
                "time": DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now()),
                'imageUrl': imageUserUrl,
              }),
            });
    isAuth;
    print(_user.email);
    notifyListeners();
  }

  //apple sign in
  Future<void> signInWithApple() async {
    final appleIdCredential =
        await SignInWithApple.getAppleIDCredential(scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ]);
    final oAuthProvider = OAuthProvider(providerId: 'apple.com');
    final credential = oAuthProvider.getCredential(
        idToken: appleIdCredential.identityToken,
        accessToken: appleIdCredential.authorizationCode);
    await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      _token = appleIdCredential.identityToken;
      uid2 = appleIdCredential.userIdentifier;
      _userId = appleIdCredential.userIdentifier;
      nameUser = appleIdCredential.familyName;
      emailUser = appleIdCredential.email;
      isAuth;
      imageUserUrl = appleIdCredential.state;
      Firestore.instance.collection('users').document(_userId).setData({
      'token': _token,
      'name': nameUser,
      'user_uid': _userId,
      'area': 'Apple',
      'email': emailUser,
      'password': 'Apple',
      "time": DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now()),
      'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/souq-alfurat-89023.appspot.com/o/png-clipart-apple-icon-format-computer-icons-graphics-ericsson-heart-logo.png?alt=media&token=48827bf4-2795-4051-b6fe-4a15adac94f7',
      });
      notifyListeners();
    });
  }
}
