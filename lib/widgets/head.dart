import 'package:flutter/material.dart';

Widget head(screenSizeWidth2) {
  return Column(
    children: <Widget>[
      Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          screenSizeWidth2 < 380
              ? SizedBox(
                  width: 3,
                )
              : SizedBox(
                  width: 5,
                ),
          Text(
            'بيع واشتري كل ما تريد بكل سهولة',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Montserrat-Arabic Regular',
              height: 1,
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
                  right: screenSizeWidth2 < 380 ? 8 : 13, left: 2),
              child: Image.asset(
                'assets/images/logo.png',
                height: 60,
                width: 113,
                fit: BoxFit.fill,
              ))
        ],
      )),
    ],
  );
}
