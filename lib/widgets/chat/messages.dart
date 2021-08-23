// @dart=2.9

import 'package:alsouqf/providers/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alsouqf/providers/auth.dart';

import 'message_bubble.dart';

class Messages extends StatelessWidget {
  final String adId;
  final String userId;
  final String creatorId;
  final bool isPrivate;
  final String chatId;

  Messages(this.adId, this.isPrivate, this.userId, this.creatorId, this.chatId);

  String chatName;

  void privateOrG(userIdA,String chatId) {
    if (isPrivate &&chatId.isNotEmpty) {
      chatName = chatId;
    } else if(isPrivate){
      chatName=adId;
      chatName = userIdA.toString()+adId+creatorId;
      print('chatName $chatName');
    }
    else {
      chatName = adId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userIdA = Provider.of<Auth>(context, listen: false).userId;
    privateOrG(userIdA, chatId);
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .doc(chatName)
          .collection(chatName)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        final docs = snapShot.data;
        return ListView.builder(
            reverse: true,
            shrinkWrap: true,
            itemCount: docs.docs.length,
            itemBuilder: (ctx, index) => MessageBubble(
                  docs.docs[index]['text'],
                  docs.docs[index]['userId'] == userId,
                  docs.docs[index]['userName'],
                  docs.docs[index]['user_image'],
                  key: ValueKey(
                    docs.docs[index]['text'] +
                        docs.docs[index]['userName'],
                  ),
                ));
      },
    );
  }
}
