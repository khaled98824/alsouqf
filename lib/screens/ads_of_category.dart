// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/ads_provider.dart';
import '../widgets/ads_items_category.dart';

class AdsOfCategory extends StatefulWidget {
  static const routeName = "/ads-0f-category";
  final String categoryName;


  const AdsOfCategory( this.categoryName);
  @override
  _AdsOfCategoryState createState() => _AdsOfCategoryState();
}

class _AdsOfCategoryState extends State<AdsOfCategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
          future: widget.categoryName!=""? Provider.of<Products>(context,listen: false).fetchCategoryAds(widget.categoryName):Provider.of<Products>(context,listen: false).fetchLastAds(''),
          builder: (context,data){
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
                            title: Text(widget.categoryName!=""?widget.categoryName:'آخر الإعلانات',
                              style: Theme.of(context).textTheme.headline4,),
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
                            itemCount: Provider.of<Products>(context,listen: false).itemsCategoryCount,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent: 260,
                              mainAxisSpacing: 2,
                              crossAxisSpacing: 2,
                              childAspectRatio: 0.5,
                            ),
                            primary: false,
                            shrinkWrap: true,
                            itemBuilder: (context, index) =>
                                AdsOfCategoryItems(index,widget.categoryName),
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

class AdsOfCategoryItems extends StatelessWidget {
  final int index;
  final String category;
  const AdsOfCategoryItems(
    this.index,this.category
  );

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<QuerySnapshot>(
                  stream:Firestore.instance.collection('Ads2').snapshots() ,
                  builder: (context,snapShots){
                    if(snapShots.hasError)return Text('error ${snapShots.error}');
                    switch (snapShots.connectionState){
                      case ConnectionState.waiting: return CircularProgressIndicator();
                      default:
                        return CategoryAdsItemsCard(
                        image: snapShots.data.documents[index]['imagesUrl'][0],
                        title: snapShots.data.documents[index]['name'],
                        country: snapShots.data.documents[index]['area'],
                        price: snapShots.data.documents[index]['price'],
                        likes: snapShots.data.documents[index]['likes'],
                        views: snapShots.data.documents[index]['views'],
                        id: snapShots.data.documents[index].documentID,
                        date: snapShots.data.documents[index]['date'],
                        index: index,
                        kindLike: 'category',
                      );
                    }

                  }
                );
              }


}
