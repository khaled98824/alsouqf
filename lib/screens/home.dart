// @dart=2.9

import 'package:alsouqf/providers/full_provider.dart';
import 'package:alsouqf/screens/requests.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/ads_provider.dart';
import '../providers/auth.dart';
import '../widgets/bottomNavBar.dart';
import '../widgets/head.dart';
import '../widgets/searchArea.dart';
import 'ads_of_category.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _listItem = [
    'assets/images/Elct2.jpg',
    'assets/images/cars.jpg',
    'assets/images/mobile3.jpg',
    'assets/images/jobs3.jpg',
    'assets/images/SERV3.jpg',
    'assets/images/home3.jpg',
    'assets/images/trucks3.jpg',
    'assets/images/farm7.jpg',
    'assets/images/farming3.jpg',
    'assets/images/game.jpg',
    'assets/images/clothes.jpg',
    'assets/images/food.jpg',
    'assets/images/requests.jpg'
  ];

  var adImagesUrlF = List<dynamic>();
  bool adsOrCategory = false;
  ScrollController controller;
  bool bottomIsVisible = true;

  getUrlsForAds() async {
    DocumentSnapshot documentsAds;
    DocumentReference documentRef = Firestore.instance
        .collection('UrlsForAds')
        .document('gocqpQlhow2tfetqlGpP');
    documentsAds = await documentRef.get();
    adImagesUrlF = documentsAds.data['urls'];
    setState(() {
      showSliderAds = true;
    });
  }

  bool showSliderAds = false;
  String subtitle = '';
  String content = '';
  String data = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = ScrollController();
    controller.addListener(listenBottom);
    Provider.of<Auth>(context, listen: false).gitCurrentUserInfo();

    //notification
    OneSignal.shared
        .setNotificationReceivedHandler((OSNotification notification) {

        subtitle = notification.payload.subtitle;
        content = notification.payload.body;
        data = notification.payload.additionalData['data'];
        print(subtitle);
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print('Notification Opened');
    });

    OneSignal.shared.getPermissionSubscriptionState().then((state) {
      DocumentReference ref = Firestore.instance
          .collection('users')
          .document(Provider.of<Auth>(context, listen: false).userId);

      ref.updateData({
        'osUserID': '${state.subscriptionStatus.userId}',
      });
    });
    getUrlsForAds();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
     controller.removeListener(listenBottom);
    controller.dispose();
  }

  void listenBottom() {
    //final direction = controller.position.userScrollDirection;
    if (controller.position.pixels >= 200) {
      Provider.of<FullDataProvider>(context,listen: false).hideBottom();
    } else {
      Provider.of<FullDataProvider>(context,listen: false).showBottom();
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenSizeWidth = MediaQuery.of(context).size.width;
    final screenSize = MediaQuery.of(context);
    final ads = Provider.of<Products>(context,listen: false).fetchNewAds(false);
    return Scaffold(
        backgroundColor: Colors.blue.shade50,
        body: SafeArea(
          child: SingleChildScrollView(
            controller: controller,
            child: Column(
              children: [
                Container(

                  height:(screenSize.size.height - screenSize.padding.top) *0.1 -20 ,
                    child: head(screenSize)),
                Container(
                    padding: EdgeInsets.only(bottom: 5),
                    child: SearchAreaDesign()),
                Container(
                  height: (screenSize.size.height - screenSize.padding.top) *0.1 -34,
                  width: MediaQuery.of(context).size.width - 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey[100]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, Requests.routeName);
                        },
                        child: Container(
                          child: Row(
                            children: [
                              Text('الطلبات',
                                  style: Theme.of(context).textTheme.headline5),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.grey[400]),
                        height: 30,
                        width: 1,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdsOfCategory("")));
                        },
                        child: Container(
                            child: Row(
                          children: [
                            Text('الإعلانات',
                                style: Theme.of(context).textTheme.headline5)
                          ],
                        )),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.grey[400]),
                        height: 30,
                        width: 1,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            adsOrCategory = false;
                          });
                        },
                        child: Container(
                            child: Row(
                          children: [
                            Text('الأقسام',
                                style: Theme.of(context).textTheme.headline5)
                          ],
                        )),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                showSliderAds
                    ? Container(
                        width: screenSizeWidth - 3,
                        height: (screenSize.size.height - screenSize.padding.top) *0.1 +36,
                        child: CarouselSlider(
                            items: adImagesUrlF
                                .map((url) => FadeInImage(
                              fit: BoxFit.fill,
                                    placeholder:
                                        AssetImage('assets/images/NEWLOGO.jpg',),
                                    image: NetworkImage(url,scale: 1)))
                                .toList(),
                            options: CarouselOptions(
                              autoPlay: true,
                              aspectRatio: 1,
                              pauseAutoPlayOnTouch: true,
                              viewportFraction: 1,
                              pauseAutoPlayOnManualNavigate: true,
                              autoPlayAnimationDuration: Duration(seconds: 2),
                              autoPlayInterval: Duration(seconds: 11),
                              enableInfiniteScroll: true,
                              pageSnapping: true,
                              pauseAutoPlayInFiniteScroll: true,
                            )))
                    : CircularProgressIndicator(),
                SizedBox(
                  height: 4,
                ),
                Column(
                  children: [
                    Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.spaceAround,
                        children: <Widget>[
                          ItemCategory(
                            text: "أجهزة - إلكترونيات",
                            imagePath: _listItem[0],
                            callback: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AdsOfCategory("أجهزة - إلكترونيات")));
                            },
                            screenSize: screenSize,
                          ),
                          ItemCategory(
                            text: "السيارات - الدراجات",
                            imagePath: _listItem[1],
                            callback: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AdsOfCategory(
                                          "السيارات - الدراجات")));
                            },
                            screenSize: screenSize,
                          )
                        ]),
                    Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.spaceAround,
                        children: <Widget>[
                          ItemCategory(
                            text: "الموبايل",
                            imagePath: _listItem[2],
                            callback: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AdsOfCategory("الموبايل")));
                            },
                            screenSize: screenSize,
                          ),
                          ItemCategory(
                            text: "وظائف وأعمال",
                            imagePath: _listItem[3],
                            callback: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AdsOfCategory("وظائف وأعمال")));
                            },
                            screenSize: screenSize,
                          )
                        ]),
                    Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.spaceAround,
                        children: <Widget>[
                          ItemCategory(
                            text: "مهن وخدمات",
                            imagePath: _listItem[4],
                            callback: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AdsOfCategory("مهن وخدمات")));
                            },
                            screenSize: screenSize,
                          ),
                          ItemCategory(
                            text: "المنزل",
                            imagePath: _listItem[5],
                            callback: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AdsOfCategory("المنزل")));
                            },
                            screenSize: screenSize,
                          )
                        ]),
                    Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.spaceAround,
                        children: <Widget>[
                          ItemCategory(
                            text: "المعدات والشاحنات",
                            imagePath: _listItem[6],
                            callback: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AdsOfCategory("المعدات والشاحنات")));
                            },
                            screenSize: screenSize,
                          ),
                          ItemCategory(
                            text: "المواشي",
                            imagePath: _listItem[7],
                            callback: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AdsOfCategory("المواشي")));
                            },
                            screenSize: screenSize,
                          )
                        ]),
                    Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.spaceAround,
                        children: <Widget>[
                          ItemCategory(
                            text: "الزراعة",
                            imagePath: _listItem[8],
                            callback: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AdsOfCategory("الزراعة")));
                            },
                            screenSize: screenSize,
                          ),
                          ItemCategory(
                            text: "ألعاب",
                            imagePath: _listItem[9],
                            callback: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AdsOfCategory("ألعاب")));
                            },
                            screenSize: screenSize,
                          )
                        ]),
                    Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.spaceAround,
                        children: <Widget>[
                          ItemCategory(
                            text: "ألبسة",
                            imagePath: _listItem[10],
                            callback: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AdsOfCategory("ألبسة")));
                            },
                            screenSize: screenSize,
                          ),
                          ItemCategory(
                            text: "أطعمة",
                            imagePath: _listItem[11],
                            callback: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AdsOfCategory("أطعمة")));
                            },
                            screenSize: screenSize,
                          )
                        ]),
                    Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.spaceAround,
                        children: <Widget>[
                          ItemCategory(
                            text: "طلبات المستخدمين",
                            imagePath: _listItem[12],
                            callback: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AdsOfCategory("طلبات المستخدمين")));
                            },
                            screenSize: screenSize,
                          ),
                        ]),
                  ],
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Consumer<FullDataProvider>(
          builder: (context,data,_)=> AnimatedContainer(
              duration: Duration(milliseconds: 500),
              height: data.bottomIsVisible ? 66 : 0,
              child: BottomNavB()),
        ));
  }
}

class ItemCategory extends StatelessWidget {
  final String text;
  final VoidCallback callback;
  final String imagePath;
  final MediaQueryData screenSize;

  ItemCategory({
    this.text,
    this.callback,
    this.imagePath,
    this.screenSize,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Card(
        elevation: 0,
        child: SizedBox(
          width: screenSize.size.width *0.4+20,
          height: 170,
          child: Container(
           // width: 100,
            //width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              image: DecorationImage(
                  image: AssetImage(imagePath), fit: BoxFit.fill),
              color: Colors.redAccent,
            ),
            child: Transform.translate(
                offset: Offset(11, -68),
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 13, vertical: 71),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[100]),
                    child: Center(
                      child: Text(text,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline3),
                    ))),
          ),
        ),
      ),
    );
  }
}
