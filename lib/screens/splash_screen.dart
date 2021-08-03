import 'package:alsouqf/providers/auth.dart';
import 'package:alsouqf/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'home.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash-screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool done = false;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 2600), () {
      setState(() {
        done = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return done
        ? Consumer<Auth>(
            builder: (context, auth, _) => auth.isAuth
                ? HomeScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, snapshot) => snapshot.connectionState ==
                            ConnectionState.waiting
                        ? Scaffold(
                            body: Container(
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 330,
                                    width: 330,
                                    child: Lottie.asset(
                                        'assets/lottie/shopping.json'),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    "سوق الفرات",
                                    style: TextStyle(
                                      color: Color.fromRGBO(239, 71, 35, 0.9),
                                      fontSize: 30,
                                      fontFamily: 'Montserrat-Arabic Regular',
                                    )
                                  ),
                                ],
                              ),
                            ),
                          )
                        : AuthScreen()),
          )
        : Scaffold(
            body: Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 330,
                    width: 330,
                    child: Lottie.asset('assets/lottie/shopping.json'),
                  ),
                  SizedBox(height: 20),
                  Text(
                      "سوق الفرات",
                      style: TextStyle(
                        color: Color.fromRGBO(239, 71, 35, 0.9),
                        fontSize: 30,
                        fontFamily: 'Montserrat-Arabic Regular',
                      )
                  ),
                ],
              ),
            ),
          );
  }
}
