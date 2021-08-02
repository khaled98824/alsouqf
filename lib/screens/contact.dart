import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class Contact extends StatefulWidget {
  static const routeName = "/contact";

  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('تواصل معنا', style: Theme.of(context).textTheme.headline4),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 70)),
            Padding(
              padding: EdgeInsets.only(right: 5, left: 5),
              child: Card(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white),
                  child: InkWell(
                    onTap: () {
                      launch('mailto:App@souqalfurat.com');
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          'App@souqalfurat.com',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'AmiriQuran',
                            color: Colors.blue[900],
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 40),
                            child: Icon(
                              Icons.email,
                              color: Colors.blue,
                              size: 40,
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 5, left: 5),
              child: Card(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white),
                  child: InkWell(
                    onTap: () {
                      launch('mailto:khaled_salehalali@hotmail.com');
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          'khaled_salehalali@hotmail.com',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'AmiriQuran',
                            color: Colors.blue[900],
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 40),
                            child: Icon(
                              Icons.email,
                              color: Colors.blue,
                              size: 40,
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 5, left: 5),
              child: Card(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white),
                  child: InkWell(
                    onTap: () async {
                      late String url;
                      if (Platform.isIOS) {
                        url =
                            'whatsapp://wa.me/0096598824567/?text=${Uri.parse('hi')}';
                      } else if (Platform.isAndroid) {
                        url = 'whatsapp://send?phone=0096598824567&text=Hello';
                      }
                      await canLaunch(url)
                          ? launch(url)
                          : ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('تطبيق واتساب غير مثبت')));
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          ' 0096598824567 ',
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'AmiriQuran',
                              color: Colors.blue[900],
                              height: 1.5),
                        ),
                        Text(
                          ':واتساب ',
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'AmiriQuran',
                              color: Colors.blue[900],
                              height: 1.5),
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 40),
                            child: Icon(
                              Icons.phone_iphone,
                              color: Colors.blue,
                              size: 40,
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
