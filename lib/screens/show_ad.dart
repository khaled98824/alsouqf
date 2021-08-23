// @dart=2.9

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import '../providers/ads_provider.dart';
import '../providers/auth.dart';
import '../providers/chats_provider.dart';
import '../screens/chatScreen.dart';
import '../widgets/chat/messages.dart';
import '../widgets/chat/new_message.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowAd extends StatefulWidget {
  static const routeName = "/show-ad";
  String adId;
  int indexAd;

  ShowAd({this.adId, this.indexAd});

  @override
  _ShowAdState createState() => _ShowAdState(adId: adId);
}

List<DocumentSnapshot> docs;
QuerySnapshot qusViews;
DocumentSnapshot documentsAds;
DocumentSnapshot documentsUser;
DocumentSnapshot documentMessages;
List<Widget> messages;
bool showMessages = false;
String currentUserName;
TextEditingController messageController = TextEditingController();
ScrollController scrollController = ScrollController();
int imageUrl4Show = 0;
bool isRequest = true;

var adImagesUrl = List<dynamic>();
bool showSlider = false;
bool showBody = false;
var ads;

class _ShowAdState extends State<ShowAd> {
  String Messgetext;
  String adId;
  int indexDocument;

  _ShowAdState({this.adId});

  get loginStatus => null;
  bool showSlider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    print(adId);
    var ads = Provider.of<Products>(context, listen: false).findById(adId);
    final userId = Provider.of<Auth>(context, listen: false).uid2;
    final userId2 = Provider.of<Auth>(context, listen: false).userId;
    final String chatName = userId2 != null && adId != null
        ? userId2 + adId + ads['creatorId']
        : '';
    final List imagesUrl = ads['imagesUrl'];
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title:
                Text(ads['name'], style: Theme.of(context).textTheme.headline4),
            centerTitle: true,
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    Consumer<Products>(
                      builder: (ctx, data, _) => CarouselSlider(
                        items: imagesUrl
                            .map((url) => InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PageImage(
                                                  url,
                                                )));
                                  },
                                  child: FadeInImage(
                                      fit: BoxFit.fill,
                                      placeholder: AssetImage(
                                        'assets/images/1024.jpg',
                                      ),
                                      image: NetworkImage(url, scale: 1)),
                                ))
                            .toList(),
                        options: CarouselOptions(
                          initialPage: 0,
                          autoPlay: true,
                          onPageChanged: (a, b) {
                            imageUrl4Show = a;
                          },
                          pauseAutoPlayOnTouch: true,
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 900),
                          disableCenter: false,
                          height: 250,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        InkWell(
                          onTap: () {},
                          child: Container(
                            width: size.width *0.2,
                            height: 34,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.blueAccent),
                            child: InkWell(
                              onTap: () {
                                messageController.clear();
                                scrollController.animateTo(
                                    scrollController.position.maxScrollExtent,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOut);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text('علق',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Icon(
                                    Icons.comment,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            chatName.length > 1
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                            adId,
                                            true,
                                            userId,
                                            ads['creatorId'],
                                            ads['name'],
                                            '')))
                                : Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text('try after login again')));
                          },
                          child: Container(
                            width: size.width*0.4,
                            height: 34,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.blueAccent),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('دردشة خاصة',
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.headline4),
                                SizedBox(
                                  width: 4,
                                ),
                                Icon(
                                  Icons.mark_chat_read_outlined,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            launch('tel:${ads['phone']}');
                          },
                          child: Container(
                            width: size.width*0.3,
                            height: 34,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.blueAccent),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('اتصل',
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.headline4),
                                SizedBox(
                                  width: 6,
                                ),
                                Icon(
                                  Icons.call,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 12, bottom: 4, right: 10),
                        child: Text(ads['creatorName'],
                            textAlign: TextAlign.right,
                            style: Theme.of(context).textTheme.headline5)),
                    Padding(
                        padding: EdgeInsets.only(top: 0, bottom: 4, right: 10),
                        child: Text(ads['area'],
                            textAlign: TextAlign.right,
                            style: Theme.of(context).textTheme.headline3)),
                    Padding(
                        padding: EdgeInsets.only(top: 4, bottom: 5, right: 10),
                        child: Text(ads['date'],
                            textAlign: TextAlign.right,
                            style: Theme.of(context).textTheme.headline3)),
                    Container(
                      width: MediaQuery.of(context).size.width - 6,
                      height: 5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 6,
                      height: 2,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey[300]),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    info(ads['category'], () {}, 'القسم الرئيسي'),
                    info(ads['department'], () {}, 'القسم الفرعي'),
                    info(ads['status'], () {}, 'الحالة'),
                    info(ads['description'], () {}, 'الوصف'),
                    info(ads['price'], () {}, 'السعر'),
                    info(ads.id, () {}, '    Id'),
                    Center(
                      child: InkWell(
                        onTap: () {
                          // Navigator.push(context, BouncyPageRoute(widget: Report(adId: documentId,)));
                        },
                        child: Container(
                            child: Column(
                          children: [
                            Icon(
                              Icons.report_problem_outlined,
                              color: Colors.red,
                              size: 32,
                            ),
                            Text('الإبلاغ عن محتوى مخالف',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline3),
                          ],
                        )),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 6,
                      height: 5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.deepOrange.withOpacity(0.6)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height - 300,
                        child: Stack(
                          children: [
                            Messages(
                                adId,
                                false,
                                Provider.of<Auth>(context, listen: true).userId,
                                ads['creatorId'],
                                ''),
                            Positioned(
                                top:
                                    MediaQuery.of(context).size.height / 2 + 37,
                                left:
                                    MediaQuery.of(context).size.width / 2 - 20,
                                child: IconButton(
                                  onPressed: () {
                                    scrollController.animateTo(
                                        scrollController
                                            .position.minScrollExtent,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeOut);
                                  },
                                  icon: Icon(
                                    FontAwesomeIcons.angleDoubleUp,
                                    color: Colors.deepOrange.withOpacity(0.5),
                                    size: 30,
                                  ),
                                ))
                          ],
                        )),
                    NewMessage(
                        adId: adId,
                        isPrivate: false,
                        userId: userId,
                        creatorId: ads['creatorId'],
                        adName: ads['name'],
                        chatId: ''),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    showBody = false;
    //docs.clear();
  }

  Widget info(value, callback, title) {
    return Column(
      children: [
        InkWell(
          onTap: callback,
          child: Container(
            color: Colors.grey.shade300,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4, top: 4),
                  child: SizedBox(
                    width: 200,
                    child: Text(
                      value.toString(),
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline3,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4, top: 4),
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline3,
                    textAlign: TextAlign.end,
                  ),
                ),
                SizedBox(
                  width: 8,
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          width: MediaQuery.of(context).size.width - 6,
          height: 2,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.grey[300]),
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }
}

class PageImage extends StatefulWidget {
  String imageUrl;

  PageImage(this.imageUrl);

  @override
  _PageImageState createState() => _PageImageState(imageUrl);
}

class _PageImageState extends State<PageImage> {
  String imageUrl;

  _PageImageState(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'الصورة',
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 50),
              child: PhotoViewGallery.builder(
                itemCount: 1,
                builder: (context, index) {
                  return PhotoViewGalleryPageOptions(
                      imageProvider: NetworkImage(imageUrl),
                      minScale: PhotoViewComputedScale.contained * 0.8,
                      maxScale: PhotoViewComputedScale.covered * 2);
                },
                enableRotation: true,
                scrollPhysics: BouncingScrollPhysics(),
                backgroundDecoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                ),
                //loadingChild: CircularProgressIndicator(),
              ),
            ),
          ],
        ));
  }
}
