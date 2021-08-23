import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart'as http;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"));

    _notificationsPlugin.initialize(initializationSettings,onSelectNotification: (String? route) async{
      if(route != null){
        Navigator.of(context).pushNamed(route);
      }
    });
  }

  static void display(RemoteMessage message) async {

    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/1000;

      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            "easyapproach",
            "easyapproach channel",
            "this is our channel",
            importance: Importance.max,
            priority: Priority.high,
          )
      );


      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data["route"],
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}

///send notification general
final serverToken = 'AAAAEqhhPwA:APA91bFNtgChlqlvVRjG0sYMUQUUKJpQlreNC1a0IAV_4ZZTIhdqYGq72IgGdRxnt4vt-9-yoowVbYwHzS6azKwV4GGCEm3WzVdQqS2t2JjyQcPZ5ZR_EQTmyJ69abl4cSE5nFymWR2F';
Future<Map<String, dynamic>> sendAndRetrieveMessage(String token, String text,String nameSender,String adName) async {
  await http.post(Uri.parse( 'https://fcm.googleapis.com/fcm/send'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken',
    },
    body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'body': 'تعليق جديد على $adName "$text"',
          'title': 'قام $nameSender بالتعليق على $adName '
        },
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done'
        },
        'to': token,
      },
    ),
  );

  final Completer<Map<String, dynamic>> completer =
  Completer<Map<String, dynamic>>();

  // _fcm.configure(
  //   onMessage: (Map<String, dynamic> message) async {
  //     completer.complete(message);
  //   },
  // );

  return completer.future;
}

///send notification private
Future<Map<String, dynamic>> sendAndRetrieveMessagePrivate(String token, String text,String nameSender,String adName) async {
  await http.post(Uri.parse( 'https://fcm.googleapis.com/fcm/send'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken',
    },
    body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'body': 'تعليق جديد على $adName ',
          'title': 'قام $nameSender بتعليق خاص على $adName '
        },
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done'
        },
        'to': token,
      },
    ),
  );

  final Completer<Map<String, dynamic>> completer =
  Completer<Map<String, dynamic>>();

  return completer.future;
}