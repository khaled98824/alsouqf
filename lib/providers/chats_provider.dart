// @dart=2.9

import 'package:alsouqf/screens/local_notification_service/local_notificaion_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class ChatsProvider with ChangeNotifier {
  List<DocumentSnapshot> listChats;

  bool isCreate;

  Future<List<DocumentSnapshot>> futureChats(
      adId, userId, chatName, userName, creatorId, adName) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("private_chats").get();
    final List<DocumentSnapshot> snap = querySnapshot.docs
        .where((DocumentSnapshot documentSnapshot) =>
            documentSnapshot['adId'] == adId &&
            documentSnapshot['creatorChatId'] == userId)
        .toList();
    if (snap.isNotEmpty) {
      isCreate = true;
      print(isCreate);
    } else {
      print('save chat');
      isCreate = false;
      FirebaseFirestore.instance.collection('private_chats').add({
        'chatId': chatName,
        'adId': adId,
        'adName': adName,
        'creatorAdId': creatorId,
        'chatDate': DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now()),
        'createdAt': Timestamp.now(),
        'creatorChatName': userName,
        'creatorChatId': userId,
      });
      await getUserInfo(adName: adName, creatorId: creatorId,userName: userName);
      sendAndRetrieveMessagePrivate(fcmToken,'',userName,adName);
    }
    notifyListeners();

    return snap;
  }

//fetch my chats
  Future<List<DocumentSnapshot>> fetchMyChats(
      [adId, userId, chatName, userName, creatorId]) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("private_chats").get();
    final List<DocumentSnapshot> snap = querySnapshot.docs
        .where((DocumentSnapshot documentSnapshot) =>
            documentSnapshot['creatorAdId'] == userId ||documentSnapshot['creatorChatId'] == userId)
        .toList();
    listChats =snap;
    notifyListeners();
    return snap;
  }
  notifyListeners();

  String name;
  String fcmToken ;
  Future getUserInfo({@required String adName, @required String creatorId,@required String userName,})async{
    DocumentSnapshot documentsUser;
    DocumentReference documentRef =
    FirebaseFirestore.instance.collection('users').doc(creatorId);
    documentsUser = await documentRef.get();
    name = documentsUser['name'];
    fcmToken =documentsUser['fcmToken'];
    return documentsUser;
  }
}

