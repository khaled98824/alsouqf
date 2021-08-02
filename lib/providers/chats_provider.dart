// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class ChatsProvider with ChangeNotifier {
  List<DocumentSnapshot> listChats;

  bool isCreate;

  Future<List<DocumentSnapshot>> futureChats(
      adId, userId, chatName, userName, creatorId, adName) async {
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("private_chats").getDocuments();
    final List<DocumentSnapshot> snap = querySnapshot.documents
        .where((DocumentSnapshot documentSnapshot) =>
            documentSnapshot['adId'] == adId &&
            documentSnapshot['creatorChatId'] == userId)
        .toList();
    if (snap.isNotEmpty) {
      print('snap= ${snap[0]['userName']}');
      isCreate = true;
      print(isCreate);
    } else {
      print('save chat');
      isCreate = false;
      Firestore.instance.collection('private_chats').add({
        'chatId': chatName,
        'adId': adId,
        'adName': adName,
        'creatorAdId': creatorId,
        'chatDate': DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now()),
        'createdAt': Timestamp.now(),
        'creatorChatName': userName,
        'creatorChatId': userId,
      });
      getUserInfo(adName: adName, creatorId: creatorId,userName: userName);
    }
    notifyListeners();

    return snap;
  }

//fetch my chats
  Future<List<DocumentSnapshot>> fetchMyChats(
      [adId, userId, chatName, userName, creatorId]) async {
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("private_chats").getDocuments();
    final List<DocumentSnapshot> snap = querySnapshot.documents
        .where((DocumentSnapshot documentSnapshot) =>
            documentSnapshot['creatorAdId'] == userId ||documentSnapshot['creatorChatId'] == userId)
        .toList();
    listChats =snap;
    notifyListeners();
    return snap;
  }
  notifyListeners();

  //send notification
  _sendNotification(adName,userName) {
    OneSignal.shared.postNotification(OSCreateNotification(
      additionalData: {
        'data': 'this is our data',
      },
      subtitle: 'سوق الفرات',

      playerIds: [osUserID],
      content: 'قام $userName بارسال رسالة خاصة لإعلان $adName ',
    ));
  }
//get id to send
  String osUserID;
  String name;

  Future getUserInfo({@required String adName, @required String creatorId,@required String userName,})async{
    DocumentSnapshot documentsUser;
    DocumentReference documentRef =
    Firestore.instance.collection('users').document(creatorId);
    documentsUser = await documentRef.get();
    name = documentsUser['name'];
    osUserID =documentsUser['osUserID'];
    _sendNotification(adName,userName);
    return documentsUser;
  }
}

