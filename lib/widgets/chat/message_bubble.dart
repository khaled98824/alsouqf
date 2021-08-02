// @dart=2.9

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(this.message, this.isMe, this.userName, this.imageUrl,
      {this.key});

  final Key key;
  final String message;
  final String userName;
  final bool isMe;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: isMe ? Theme.of(context).accentColor : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                  bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(14),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(14),
                ),
              ),
              width: 130,
              padding: EdgeInsets.symmetric(vertical: 7, horizontal: 14),
              margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    userName,
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                    style: TextStyle(
                        color: !isMe ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    message,
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                    style: TextStyle(
                      color: !isMe ? Colors.black : Colors.white,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        Positioned(
          top: -2,
          left: isMe ?230:null,
          right: !isMe ?230:null,
          child: CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(imageUrl),
          ),
        ),
      ],
      overflow: Overflow.visible,
    );
  }
}
