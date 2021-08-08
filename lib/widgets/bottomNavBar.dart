import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../screens/add_new_ad.dart';
import '../screens/home.dart';
import '../screens/my_Ads.dart';
import '../screens/my_chats.dart';
import '../screens/profile_screen.dart';
bool bottomIsVisible = true;

class BottomNavB extends StatefulWidget {
  const BottomNavB({Key? key}) : super(key: key);

  @override
  _bottomNavBState createState() => _bottomNavBState();
}
late int _currentIndex =4;

class _bottomNavBState extends State<BottomNavB> {
  void onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (_currentIndex == 4) {
      Navigator.popAndPushNamed(context, HomeScreen.routeName);
    } else if (_currentIndex == 3) {
      Navigator.popAndPushNamed(context, MyChats.routeName);
    } else if (_currentIndex == 2) {
      Navigator.of(context).pop();
      Navigator.push(context,
          MaterialPageRoute(builder: (ctx) => AddNewAd(ctx, null,false)));
    } else if (_currentIndex == 1) {
      Navigator.popAndPushNamed(context, MyAds.routeName);
    } else if (_currentIndex == 0) {
      Navigator.popAndPushNamed(context, Profile.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        BottomNavigationBar(
          unselectedIconTheme: IconThemeData(color: Colors.grey[400]),
          selectedIconTheme: IconThemeData(color: Colors.black),
          unselectedLabelStyle: TextStyle(
              color: Colors.grey[400],
              fontFamily: 'Montserrat-Arabic Regular'),
          selectedLabelStyle: TextStyle(
              color: Colors.black,
              fontFamily: 'Montserrat-Arabic Regular'),
          fixedColor: Colors.green,
          type: BottomNavigationBarType.fixed,
          onTap: onTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.userTie),
              label: 'حسابي',
            ),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.images), label: 'إعلاناتي'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.add_a_photo_outlined,
                  size: 35,
                  color: Colors.orange,
                ),
                label: 'أضف إعلان'),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.comments),
              label: 'محادثاتي',
            ),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.home), label: 'الرئيسية'),
          ],
        ),
      ],
    );
  }
}
