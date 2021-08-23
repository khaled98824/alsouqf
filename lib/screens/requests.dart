// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/ads_provider.dart';
import '../widgets/new_Ads.dart';

class Requests extends StatefulWidget {
  static const routeName = "/requests";

  @override
  _RequestsState createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: Provider.of<Products>(context,listen: false).fetchRequests(),
            builder: (ctx,data){
              if(data.connectionState ==ConnectionState.waiting){
                return  Center(child: CircularProgressIndicator());
              }else{
                return Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: CustomScrollView(
                        slivers: [
                          SliverAppBar(
                            backgroundColor: Colors.red,
                            expandedHeight: 160,
                            floating: true,
                            pinned: true,
                            flexibleSpace: FlexibleSpaceBar(
                              background: Image.network(
                                'https://firebasestorage.googleapis.com/v0/b/souq-alfurat-89023.appspot.com/o/WhatsApp%20Image%202020-09-15%20at%2011.23.35%20AM.jpeg?alt=media&token=a7c3f2d7-2629-4519-9c61-93444f989688',
                                fit: BoxFit.cover,
                              ),
                              title: Text('الطلبات',style: Theme.of(context).textTheme.headline4,),
                              centerTitle: true,
                            ),
                            //title: Text('My App Bar'),
                            leading: IconButton(icon: Icon(FontAwesomeIcons.arrowLeft),onPressed: (){
                              Navigator.of(context).pop();
                            },),
                            actions: [
                              //Icon(Icons.settings),
                              SizedBox(width: 12),
                            ],
                          ),
                          SliverToBoxAdapter(
                            child: GridView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: Provider.of<Products>(context,listen: false).itemsRequestsCount,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisExtent: 260,
                                mainAxisSpacing: 2,
                                crossAxisSpacing: 2,
                                childAspectRatio: 0.5,
                              ),
                              primary: false,
                              shrinkWrap: true,
                              itemBuilder: (ctx, index) =>
                                  RequestsItems(index),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );


              }
            }
        ));
  }
}

class RequestsItems extends StatelessWidget {
  final int index;
  const RequestsItems(
      this.index,
      );

  @override
  Widget build(BuildContext context) {
    String kindLike = 'request';
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
                kindLike:kindLike,
              );
          }

        }
    );
  }
}
