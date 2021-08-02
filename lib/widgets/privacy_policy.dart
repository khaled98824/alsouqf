import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<Null> chosePage(BuildContext context) async {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            ': اختر ماتريد رؤيته ',
            textAlign: TextAlign.right,
            style:
            TextStyle(fontSize: 17, fontFamily: 'AmiriQuran', height: 1.5),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    String urlPrivacyPolicy =
                        'https://sites.google.com/view/privacy-policy-for-sooq/%D8%A7%D9%84%D8%B5%D9%81%D8%AD%D8%A9-%D8%A7%D9%84%D8%B1%D8%A6%D9%8A%D8%B3%D9%8A%D8%A9';
                    launch(urlPrivacyPolicy);
                  },
                  child: Text(
                    'اذهب الى سياسة الخصوصية',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'AmiriQuran',
                        color: Colors.white,
                        height: 1.5),
                  ),
                  color: Colors.blueAccent,
                ),
                FlatButton(
                  onPressed: () {
                    String url =
                        'https://sites.google.com/view/privacy-policy-sooqalfurat/%D8%A7%D9%84%D8%B5%D9%81%D8%AD%D8%A9-%D8%A7%D9%84%D8%B1%D8%A6%D9%8A%D8%B3%D9%8A%D8%A9';
                    launch(url);
                  },
                  child: Text(
                    'اذهب الى سياسة الخصوصية بالانجليزية',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'AmiriQuran',
                        color: Colors.white,
                        height: 1.5),
                  ),
                  color: Colors.blueAccent,
                ),
                FlatButton(
                  onPressed: () {
                    String urlPrivacyPolicy =
                        'https://sites.google.com/view/terms-of-use-sooq/%D8%A7%D9%84%D8%B5%D9%81%D8%AD%D8%A9-%D8%A7%D9%84%D8%B1%D8%A6%D9%8A%D8%B3%D9%8A%D8%A9';
                    launch(urlPrivacyPolicy);
                  },
                  child: Text(
                    'اذهب الى شروط الاستخدام',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'AmiriQuran',
                        color: Colors.white,
                        height: 1.5),
                  ),
                  color: Colors.blueAccent,
                ),

              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'إلغاء',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'AmiriQuran',
                    color: Colors.white,
                    height: 1.5),
              ),
              color: Colors.blueAccent,
            ),
            SizedBox(
              width: 10,
            ),
          ],
        );
      });
}