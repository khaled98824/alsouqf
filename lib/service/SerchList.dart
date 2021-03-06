// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ads_provider.dart';
import '../screens/show_ad.dart';

class SerchList extends StatelessWidget {
  final DocumentSnapshot lis;

  SerchList(this.lis);

  @override
  Widget build(BuildContext context) {
    double swidth = MediaQuery.of(context).size.width;
    double sheight = MediaQuery.of(context).size.height;
    Provider.of<Products>(context, listen: false).fetchNewAds();
    return Padding(
      padding:
          EdgeInsets.only(left: swidth * 0.02, right: swidth * 0.02, bottom: 0),
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          child: InkWell(
            onTap: () {
              //§String idD=lis.documentID;
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ShowAd(
                        adId: lis.id,
                      )));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(swidth * 0.050),
              child: Container(
                width: swidth,
                height: sheight * 0.15,
                child: Card(
                  color: Colors.transparent,
                  elevation: 1,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 200,
                          child: Image.network(
                            lis["imagesUrl"][0],
                            fit: BoxFit.fill,
                            height: 200,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: sheight * 0.005,
                        right: 2,
                        child: Container(
                            padding: EdgeInsets.all(swidth * 0.015),
                            height: sheight * 0.09,
                            //width: MediaQuery.of(context).size.width*0.75,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Colors.black.withOpacity(0.5),
                              // set border width
                              // set rounded corner radius
                              // make rounded corner of border
                            ),
                            child: Center(
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                      width: swidth * 0.3,
                                      child: Text(
                                        lis["name"],
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: sheight * 0.014,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  SizedBox(
                                    width: swidth*0.3,
                                    child: Text(
                                      lis["area"],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: sheight * 0.014,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(
                                    "${lis["price"]}",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: sheight * 0.014,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
/*
 print(desc.contains("${query}")||cat.contains("${query}")||dep.contains("${query}"));
 */
