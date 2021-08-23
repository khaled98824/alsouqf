// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/ads_provider.dart';
import '../screens/constants.dart';
import '../screens/show_ad.dart';

class NewAds extends StatelessWidget {
  final int index;

  const NewAds({
    Key key,
    @required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
        stream:FirebaseFirestore.instance.collection('Ads2').snapshots() ,
        builder: (context,snapShots){
          if(snapShots.hasError)return Text('error ${snapShots.error}');
          switch (snapShots.connectionState){
            case ConnectionState.waiting: return CircularProgressIndicator();
            default:
              return NewAdsCard(
                image: snapShots.data.docs[index]['imagesUrl'][0],
                title: snapShots.data.docs[index]['name'],
                country: snapShots.data.docs[index]['area'],
                price: snapShots.data.docs[index]['price'],
                likes: snapShots.data.docs[index]['likes'],
                views: snapShots.data.docs[index]['views'],
                id: snapShots.data.docs[index].id,
                date: snapShots.data.docs[index]['date'],
                index: index,
                kindLike: 'newAds',
              );
          }

        }
    );
  }
}

Widget buildAds(ctx) => SliverToBoxAdapter(
      child: GridView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 5,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 260,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          childAspectRatio: 0.5,
        ),
        primary: false,
        shrinkWrap: true,
        itemBuilder: (context, index) => NewAds(index: index),
      ),
    );

List likesList = [];

bool like = false;

class NewAdsCard extends StatelessWidget {
  const NewAdsCard({
    Key key,
    this.kindLike,
    this.date,
    this.index,
    this.id,
    this.likes,
    this.views,
    this.image,
    this.title,
    this.country,
    this.price,
    this.press,
  }) : super(key: key);

  final String image, title, country, id, date,kindLike;
  final int likes, views, index;
  final double price;
  final Function press;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isLike;

    return Container(
      margin: EdgeInsets.only(
        left: kDefaultPadding / 4,
        //top: kDefaultPadding / 2,
        right: kDefaultPadding / 4,
        //bottom: kDefaultPadding  ,
      ),
      width: size.width * 0.4,
      child: Column(
        children: <Widget>[
          GestureDetector(
              onTap: () {
                Provider.of<Products>(context, listen: false)
                    .updateViews(id, views, index,'');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShowAd(
                              adId: id,
                            )));
              },
              child: Image.network(
                image,
                fit: BoxFit.contain,
                height: 100,
                width: 300,
              )),
          Container(
              height: 150,
              //width: 240,
              padding: EdgeInsets.all(kDefaultPadding / 3),
              margin: EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 50,
                    color: kPrimaryColor.withOpacity(0.23),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Provider.of<Products>(context, listen: false)
                          .updateViews(id, views, index,'request');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShowAd(
                                    adId: id,
                                  )));
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 8.0),
                              child: SizedBox(
                                width: size.width *0.4,
                                child: Text("$title".toUpperCase(),
                                    textAlign: TextAlign.right,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.headline3),
                              ),
                            ),
                            SizedBox(
                              width: size.width *0.4,
                              child: Text(
                                "$country".toUpperCase(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontFamily: 'Montserrat-Arabic Regular',
                                    color: kPrimaryColor.withOpacity(0.5),
                                    fontSize: 12),
                              ),
                            ),
                            Text(
                              "$date".toUpperCase(),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontFamily: 'Montserrat-Arabic Regular',
                                  color: kPrimaryColor.withOpacity(0.5),
                                  fontSize: 11),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Text(
                                '\$$price'.toUpperCase(),
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontFamily: 'Montserrat-Arabic Regular',
                                    color: kPrimaryColor.withOpacity(0.8),
                                    fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          if (likesList.length > 0) {
                            for (int i = 0; i < likesList.length; i++) {
                              if (likesList[i] == id) {
                                isLike = true;
                                break;
                              } else {
                                isLike = false;
                              }
                            }
                            print(isLike);
                            if (isLike) {
                            } else {
                              Provider.of<Products>(context, listen: false)
                                  .updateLikes(id, likes, index,kindLike);
                              likesList.add(id);
                            }
                          } else {
                            Provider.of<Products>(context, listen: false)
                                .updateLikes(id, likes, index,kindLike);
                            likesList.add(id);
                          }
                        },
                        child: Column(
                          children: [
                            Icon(
                              like
                                  ? FontAwesomeIcons.heart
                                  : FontAwesomeIcons.heart,
                              size: 23,
                              color: Colors.orange,
                            ),
                            Consumer<Products>(
                              builder: (context, data, _) => Text(
                                'لايك : $likes',
                                style: TextStyle(
                                    fontFamily: 'Montserrat-Arabic Regular',
                                    fontSize: 13,
                                    color: Colors.orange),
                              ),
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {},
                        child: Column(
                          children: [
                            Icon(
                              FontAwesomeIcons.eye,
                              size: 22,
                              color: Colors.orange,
                            ),
                            Text(
                              'مشاهدة : $views',
                              style: TextStyle(
                                  fontFamily: 'Montserrat-Arabic Regular',
                                  fontSize: 13,
                                  color: Colors.orange),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              )),
        ],
      ),
    );
  }
}
