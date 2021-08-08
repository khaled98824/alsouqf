// @dart=2.9

import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/ads_provider.dart';
import '../providers/chats_provider.dart';
import '../providers/full_provider.dart';
import '../screens/about_us.dart';
import '../screens/add_new_ad.dart';
import '../screens/add_suggestion.dart';
import '../screens/ads_of_category.dart';
import '../screens/contact.dart';
import '../screens/edit_account.dart';
import '../screens/home.dart';
import '../screens/my_chats.dart';
import '../screens/profile_screen.dart';
import '../screens/requests.dart';
import '../screens/user_ads_screen.dart';
import '../screens/splash_screen.dart';
import 'providers/auth.dart';
import 'screens/auth_screen.dart';
import 'screens/my_Ads.dart';
import 'screens/show_ad.dart';
import 'package:firebase_core/firebase_core.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();

  OneSignal.shared.init('8fc8b90f-d3a0-483c-938a-2af0f7b38bc5', iOSSettings: {
    OSiOSSettings.autoPrompt: false,
    OSiOSSettings.inAppLaunchUrl: false
  });
  OneSignal.shared
      .setInFocusDisplayType(OSNotificationDisplayType.notification);
  await OneSignal.shared
      .promptUserForPushNotificationPermission(fallbackToSettings: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: Products()),
        ChangeNotifierProvider.value(value: ChatsProvider()),
        ChangeNotifierProvider.value(value: FullDataProvider()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products(),
          update: (ctx, authValue, previousProduct) => previousProduct
            ..getData(
              authValue.token,
              authValue.userId,
              previousProduct == null ? null : previousProduct.items,
            ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              fontFamily: 'Montserrat-Arabic Regular',
              textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                      fontFamily: 'Montserrat-Arabic Regular',
                      fontSize: 44,
                      color: Colors.white),
                  headline5: TextStyle(
                      fontFamily: 'Montserrat-Arabic Regular',
                      fontSize: 16,
                      color: Colors.black),
                  headline4: TextStyle(
                      fontFamily: 'Montserrat-Arabic Regular',
                      fontSize: 15,
                      wordSpacing: 1,
                      letterSpacing: 1,
                      height: 1.4,
                      color: Colors.white),
                  headline3: TextStyle(
                    fontFamily: 'Montserrat-Arabic Regular',
                    fontSize: 12,
                    color: Colors.black.withOpacity(0.8),
                  )),
              appBarTheme: AppBarTheme(
                  textTheme: ThemeData.light().textTheme.copyWith(
                      headline6: TextStyle(
                          fontFamily: 'Montserrat-Arabic Regular',
                          fontSize: 22)))),
          routes: {
            HomeScreen.routeName: (_) => HomeScreen(),
            Profile.routeName: (_) => Profile(),
            MyChats.routeName: (_) => MyChats(),
            MyAds.routeName: (_) => MyAds(),
            AddNewAd.routeName: (_) => AddNewAd(context, '',null),
            AuthScreen.routeName: (_) => AuthScreen(),
            UserAdsScreen.routeName: (_) => UserAdsScreen(),
            ShowAd.routeName: (_) => ShowAd(),
            EditUserInfo.routeName: (_) => EditUserInfo(),
            AdsOfCategory.routeName:(_)=>AdsOfCategory(''),
            Requests.routeName: (_) => Requests(),
            ComplaintsAndSuggestions.routeName: (_) => ComplaintsAndSuggestions(),
            Contact.routeName: (_) => Contact(),
            AboutUs.routeName: (_) => AboutUs(),




          },
          home: SplashScreen()
        ),
      ),
    );
  }
}
