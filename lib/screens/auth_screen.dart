// @dart=2.9

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/auth.dart';
import '../models/http_exception.dart';
import 'home.dart';

File imageFile;

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth-screen';
  String imageUrl;

  @override
  Widget build(BuildContext context) {
    final devicesize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'التسجيل',
            style: TextStyle(fontFamily: 'Montserrat-Arabic Regular'),
          ),
          backgroundColor: Color.fromRGBO(243, 110, 41, 1),
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(243, 110, 41, 0.5),
                      Color.fromRGBO(239, 71, 35, 0.9)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0, 1]),
              ),
              child: SingleChildScrollView(
                child: Container(
                  height: devicesize.height,
                  width: devicesize.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Image.asset('assets/images/1024.jpg'),
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 80),
                          transform: Matrix4.rotationZ(-8 * pi / 180)
                            ..translate(-10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.deepOrange.shade800,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 8,
                                    color: Colors.black26,
                                    offset: Offset(0, 4))
                              ]),
                          child: Text('سوق الفرات',
                              style: TextStyle(
                                  fontSize: 32,
                                  fontFamily: 'Montserrat-Arabic Regular',
                                  color: Colors.white)),
                        ),
                      ),
                      Flexible(
                        flex: devicesize.width > 600 ? 0 : 3,
                        child: AuthCard(),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

enum AuthMode { Login, SignUp }

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  File userImageFile;

  void _packedImage(File packedImage) {
    userImageFile = packedImage;
  }

  final GlobalKey<FormState> _formlKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'name': '',
    'area': ''
  };

  var _isLoading = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _areaController = TextEditingController();

  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(milliseconds: 900), () {
      autoFillFields();
    });
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.15),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  autoFillFields() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('info')) return false;

    final extractedData =
        json.decode(prefs.getString('info')) as Map<String, Object>;
    setState(() {
      _emailController = TextEditingController(text: extractedData['email']);
      _passwordController =
          TextEditingController(text: extractedData['password']);
    });
  }

  Future<void> _submit() async {
    if (_authMode == AuthMode.SignUp && imageFile == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('رجائاَ اختر صورة شخصية'),
      ));
      return;
    }

    print('sup1');
    if (!_formlKey.currentState.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    _formlKey.currentState.save();

    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false).logIn(
          _authData['email'],
          _authData['password'],
        );
      }

      await Provider.of<Auth>(context, listen: false).signUp(
          _authData['email'],
          _authData['password'],
          _authData['name'],
          _authData['area'],
          imageUrl);
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';

      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'EMAIL IS ALREADY USE';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'invalid email';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'weak password';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'invalid PASSWORD';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find user with that email';
      }
      _showErrorDialog(errorMessage);
    } catch (e) {
      const errorMessage = 'PLEASE TRY AGAIN LATER';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    _passwordController.dispose();
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('An Error Occurred !'),
        content: Text(errorMessage),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(), child: Text('Okay'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final devicesize = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: Duration(microseconds: 300),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.SignUp ? 530 : 330,
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.SignUp ? 541 : 380,
          maxHeight: _authMode == AuthMode.SignUp ? 652 : 390,
        ),
        width: devicesize.width * 0.75,
        padding: EdgeInsets.only(top: 5, right: 20, left: 20),
        child: Form(
            key: _formlKey,
            child: Wrap(
              children: [
                Column(
                  children: [
                    if (_authMode == AuthMode.SignUp)
                      Center(child: UserImagePicker()),
                    TextFormField(
                        decoration: InputDecoration(labelText: 'E-mail'),
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          if (val.isEmpty || !val.contains('@')) {
                            return 'Invalid email';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          _authData['email'] = val;
                        }),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                        decoration: InputDecoration(labelText: 'Password'),
                        controller: _passwordController,
                        obscureText: true,
                        validator: (val) {
                          if (val.isEmpty || val.length < 5) {
                            return 'Invalid Sort Password';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          _authData['password'] = val;
                        }),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      constraints: BoxConstraints(
                        minHeight: _authMode == AuthMode.SignUp ? 50 : 0,
                        maxHeight: _authMode == AuthMode.SignUp ? 50 : 0,
                      ),
                      curve: Curves.easeIn,
                      child: FadeTransition(
                        opacity: _opacityAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: TextFormField(
                              decoration: InputDecoration(
                                  labelText: 'Confirm Password'),
                              enabled: true,
                              validator: AuthMode == AuthMode.SignUp
                                  ? (val) {
                                      if (val != _passwordController.text) {
                                        return ' Password do not Match';
                                      }
                                      return null;
                                    }
                                  : null,
                              onSaved: (val) {
                                _authData['pa'] = val;
                              }),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      constraints: BoxConstraints(
                        minHeight: _authMode == AuthMode.SignUp ? 50 : 0,
                        maxHeight: _authMode == AuthMode.SignUp ? 50 : 0,
                      ),
                      curve: Curves.easeIn,
                      child: FadeTransition(
                        opacity: _opacityAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Enter Yor Name'),
                              enabled: true,
                              validator: AuthMode == AuthMode.SignUp
                                  ? (val) {
                                      if (val.length < 4) {
                                        return 'name so short';
                                      }
                                      return null;
                                    }
                                  : null,
                              onSaved: (val) {
                                _authData['name'] = val;
                              }),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      constraints: BoxConstraints(
                        minHeight: _authMode == AuthMode.SignUp ? 50 : 0,
                        maxHeight: _authMode == AuthMode.SignUp ? 50 : 0,
                      ),
                      curve: Curves.easeIn,
                      child: FadeTransition(
                        opacity: _opacityAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Enter Your Area'),
                              enabled: true,
                              validator: AuthMode == AuthMode.SignUp
                                  ? (val) {
                                      if (val.length < 4) {
                                        return ' area so short';
                                      }
                                      return null;
                                    }
                                  : null,
                              onSaved: (val) {
                                _authData['area'] = val;
                              }),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    if (_isLoading) CircularProgressIndicator(),
                    RaisedButton(
                      child: Text(
                          _authMode == AuthMode.Login ? 'LOGIN' : 'SIGNUP'),
                      onPressed: _submit,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                      color: Theme.of(context).primaryColor,
                      textColor:
                          Theme.of(context).primaryTextTheme.bodyText2.color,
                    ),
                    FlatButton(
                      onPressed: _switchAuthMode,
                      child: Text(
                          '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                      textColor: Colors.black.withOpacity(0.6),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Container(
                      height: 4,
                      width: MediaQuery.of(context).size.width - 14,
                      decoration: BoxDecoration(
                          color: Colors.deepOrange.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {

                              Provider.of<Auth>(context,listen: false).googleLogin();

                          },
                          icon: Icon(FontAwesomeIcons.google),
                          label: Text('Sign in'),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(FontAwesomeIcons.apple),
                          label: Text('Sign in'),
                        )
                      ],
                    )
                  ],
                ),
              ],
            )),
      ),
    );
  }
}

String imageUrl;
File _pickedImage;

class UserImagePicker extends StatefulWidget {
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  final ImagePicker _picker = ImagePicker();

  void _pickImage(ImageSource src) async {
    final pickedImageFile = await _picker.getImage(
        source: src, imageQuality: 100, maxWidth: 100, maxHeight: 150);

    if (pickedImageFile != null) {
      setState(() {
        imageFile = _pickedImage;
        _pickedImage = File(pickedImageFile.path);
      });

      final ref = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child('userId' + '.jpg');
      await ref.putFile(_pickedImage);
      imageUrl = await ref.getDownloadURL();

      print(imageUrl);
    } else {
      print('no image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage) : null,
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FlatButton.icon(
              onPressed: () => _pickImage(ImageSource.gallery),
              textColor: Theme.of(context).primaryColor,
              icon: Icon(
                Icons.image_outlined,
                size: 33,
              ),
              label: Text(
                ' أضف صورة \n من الإستوديو',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14, fontFamily: 'Montserrat-Arabic Regular'),
              ),
            ),
          ],
        )
      ],
    );
  }
}
