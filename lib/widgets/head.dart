import 'package:flutter/material.dart';

Widget head(MediaQueryData screenSize) {
  return Column(
    children: <Widget>[
      Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
         SizedBox(
                  width: screenSize.size.width *0.1 -10,
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
          Image.asset(
            'assets/images/logo.png',
            height: screenSize.size.height *0.1-25,
            width: screenSize.size.width *0.2+5,
            fit: BoxFit.fill,
          )
        ],
      )),
    ],
  );
}
