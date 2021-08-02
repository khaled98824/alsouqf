// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:alsouqf/providers/auth.dart';
import 'package:alsouqf/providers/chats_provider.dart';

class NewMessage extends StatefulWidget {
  final String adId;
  final String userId;
  final String creatorId;
  final String adName;
  final bool isPrivate;
  final String chatId;

   NewMessage(
       {this.adId,
      this.isPrivate,
      this.userId,
      this.creatorId,
      this.adName,
      this.chatId});
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  String _enteredMessage = '';
  String userName;
  _sendMessage(userId,adId) async {
    if(!widget.isPrivate && widget.creatorId!=userId){_sendNotification();}else{
    }
    FocusScope.of(context).unfocus();
    //final user = FirebaseAuth.instance.currentUser;
    final userData = await Firestore.instance
        .collection('users')
        .document(userId)
        .get();
    Firestore.instance.collection('chat').document(chatName).collection(chatName).add({
      'adId':widget.adId,
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userName': userData['name'],
      'userId': userId,
      'user_image': userData['imageUrl']
    });
    final a = Provider.of<ChatsProvider>(context,listen: false).futureChats(adId, userId,chatName,userData['name'],widget.creatorId,widget.adName);
    _controller.clear();
    setState(() {
      _enteredMessage = '';
    });
  }

  String chatName;
  void privateOrG(userIdA,String chatId){

    if(widget.isPrivate && chatId.isNotEmpty){
     chatName = chatId;
    }else if(widget.isPrivate){
      chatName = userIdA.toString()+widget.adId+widget.creatorId;
      print('chatName $chatName');
    }else{
      chatName=widget.adId;
    }
  }

  //send notification
  _sendNotification() {
    OneSignal.shared.postNotification(OSCreateNotification(
      additionalData: {
        'data': 'this is our data',
      },
      subtitle: 'سوق الفرات',

      playerIds: [osUserID],
      content: 'قام $name بالتعليق على إعلانك ${widget.adName} ,${_controller.text}',
    ));
  }
  //get id to send
  String osUserID;
  String name;

  Future gitUserInfo()async{
    DocumentSnapshot documentsUser;
    DocumentReference documentRef =
    Firestore.instance.collection('users').document(widget.creatorId);
    documentsUser = await documentRef.get();
    name = documentsUser['name'];
    osUserID =documentsUser['osUserID'];
    return documentsUser;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gitUserInfo();
  }
  @override
  Widget build(BuildContext context) {
    final userName= Provider.of<Auth>(context).nameUser;
    final userIdG= Provider.of<Auth>(context).userId;
    privateOrG(userIdG,widget.chatId);

    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              autocorrect: true,
              enableSuggestions: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                  hintText: 'Send a message',
                  hintStyle: TextStyle(color: Theme.of(context).primaryColor),
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor))),
              onChanged: (val) {
                setState(() {
                  _enteredMessage = val;
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            onPressed: () {
              _enteredMessage.trim().isEmpty ? null : _sendMessage(userIdG,widget.adId);
            },
            icon: Icon(Icons.send),
          )
        ],
      ),
    );
  }
}
