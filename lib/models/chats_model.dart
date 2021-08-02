// @dart=2.9

import 'package:flutter/cupertino.dart';

class ChatsModel {
  final String chatId;
  final String creatorAdId;
  final String adId;
  final String userId;
  final String userName;
  final DateTime createdAt;

  ChatsModel({
    @required this.chatId,
    @required this.creatorAdId,
    @required this.adId,
    @required this.userId,
    @required this.userName,
    @required this.createdAt,
  });
}
