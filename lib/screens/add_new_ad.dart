// @dart=2.9
import 'dart:async';
import 'dart:io';
import 'package:alsouqf/models/action_chip_data.dart';
import 'package:alsouqf/models/filter_chip_data.dart';
import 'package:alsouqf/providers/action_chips.dart';
import 'package:alsouqf/providers/filter_chips.dart';
import 'package:alsouqf/service/location_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/ads_model.dart';
import '../providers/ads_provider.dart';
import '../providers/auth.dart';
import '../screens/home.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../utils.dart';

class AddNewAd extends StatefulWidget {
  static const routeName = "AddNewAd";
  final BuildContext ctx;
  final isEdit;
  String id;

  AddNewAd(this.ctx, this.id, this.isEdit);

  @override
  _AddNewAdState createState() => _AddNewAdState();
}

bool loadingImage = false;
var time = DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now());
String priceText;
double price = 0;
int views = 0;
int likes = 0;
File imageG;
File image;
File image2;
File image3;
File image4;
File image5;
File image6;
File image7;
String imageUrl;
String imageUrl2;
String imageUrl3;
String imageUrl4;
String imageUrl5;
String imageUrl6;
String imageUrl7;
int phone;

var _editedProduct;

DocumentSnapshot oldData;

var _initialValues = {
  "date": '',
  "name": '',
  "description": '',
  "price": 0.0,
  "imagesUrl": '',
  "area": '',
  "category": '',
  "department": '',
  "status": '',
  "isFavorite": '',
  "uid": '',
  "likes": '',
  "views": '',
  "phone": 0,
  "isRequest": '',
};

class _AddNewAdState extends State<AddNewAd> {
  @override
  didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (widget.isEdit == true) getEditInfo();
  }

  bool choseCategory = false;
  bool choseCategory2 = true;
  bool showInfoSelected = false;
  bool statusShow = true;
  bool showAreaTextField = false;
  bool valueSelectGps = false;
  bool allZonesShow = true;
  bool currentZoneShow = false;

  String category2 = '';

  String category = '';
  List<String> dropItemsArea = [];

  var dropSelectItemArea;

  String area = '';
  String area2 = '';
  String description;
  String name;
  bool chacked = false;
  bool chacked2 = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  LocationService _locationService = LocationService();

  final _formkey = GlobalKey<FormState>();

  var status = 'مستعمل';
  List<String> urlImages = [];
  String imageUrl;

  upImage() async {
    loadingImage = true;

    var storageImage = FirebaseStorage.instance.ref().child(_image.path);
    var taskUpload = storageImage.putFile(_image);
    imageUrl = await (await taskUpload.onComplete).ref.getDownloadURL();
    print(imageUrl);
    loadingImage = false;
    setState(() {
      urlImages.add(imageUrl);
      loadingImage = false;

      //show
      if (image == null) {
        image = _image;
      } else if (image2 == null) {
        image2 = _image;
      } else if (image3 == null) {
        image3 = _image;
      } else if (image4 == null) {
        image4 = _image;
      } else if (image5 == null) {
        image5 = _image;
      } else if (image6 == null) {
        image6 = _image;
      } else if (image7 == null) {
        image7 = _image;
      }
    });
  }

  File _image;

  Future getImage(context) async {
    imageG = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxWidth: 1800,
      maxHeight: 1150,
    );
    setState(() {
      _image = imageG;
    });
    upImage();
  }

  getInfoDevice() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    var infoData = androidInfo.androidId;
    setState(() {
      deviceNo = infoData;
    });
  }

  getIosInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    setState(() {
      deviceNo = iosInfo.identifierForVendor;
      print(deviceNo);
    });
  }

  String deviceNo = '';

  int currentIndex = 3;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) {
      getInfoDevice();
    } else {
      getIosInfo();
    }
    addNewZ();
  }

  QuerySnapshot documentsAds;
  List<String> newZList = [];
  DocumentSnapshot usersList;

  //get edit info

  addNewZ() async {
    var firestore = Firestore.instance;

    QuerySnapshot qusListUsers =
        await firestore.collection('ZonesIOS').getDocuments();
    if (qusListUsers != null) {
      for (int i = 0; qusListUsers.documents.length > newZList.length; i++) {
        setState(() {
          newZList.add(qusListUsers.documents[i]['Z']);
        });
      }
      if (newZList.length > 1) {
        setState(() {
          dropItemsArea = newZList;
        });
      }
    }
  }

  getEditInfo() {
    if (widget.isEdit == true) {
      print('from did change');
      oldData =
          Provider.of<Products>(context, listen: false).findById(widget.id);
      _initialValues = {
        'id': oldData['id'],
        'name': oldData['name'],
        'description': oldData['description'],
        'price': oldData['price'],
        'area': oldData['area'],
        'phone': oldData['phone'],
        'status': oldData['status'],
        'deviceNo': oldData['deviceNo'],
        'category': oldData['category'],
        'uid': oldData['uid'],
        'department': oldData['department'],
        'imagesUrl': oldData['imagesUrl'],
        'isFavorite': oldData['isFavorite'],
        'isRequest': oldData['isRequest'],
        'views': oldData['views'],
        'likes': oldData['likes'],
        'creatorId': oldData['creatorId'],
        'creatorName': oldData['creatorName']
      };
      //urlImages = oldData['imagesUrl'];
      category = oldData['category'];
      category2 = oldData['department'];
      status = oldData['status'];
      area = oldData['area'];
      likes = oldData['likes'];
      views = oldData['views'];
    }
    print(oldData['department']);
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
    newZList.clear();
    nameController.clear();

    image = null;
    image2 = null;
    image3 = null;
    image4 = null;
    image5 = null;
    image6 = null;
    image7 = null;
    imageUrl = null;
    imageUrl2 = null;
    imageUrl3 = null;
    imageUrl4 = null;
    imageUrl5 = null;
    imageUrl6 = null;
    imageUrl7 = null;
    urlImages.clear();

    _initialValues = {
      "date": '',
      "name": '',
      "description": '',
      "price": 0.0,
      "imagesUrl": '',
      "area": '',
      "category": '',
      "department": '',
      "status": '',
      "isFavorite": false,
      "uid": '',
      "likes": '',
      "views": '',
      "phone": 0,
      "isRequest": false,
    };
  }

  getCurrentAddress() async {
    LocationService _location = LocationService();
    await _location.sendLocationToDataBase(context);
    area = '${_location.countryName} -${_location.adminArea}';
    setState(() {
      currentZoneShow = true;
    });
    print('area == $area');
  }

  Widget build(BuildContext context) {
    final userGetData =
        Provider.of<Auth>(context, listen: false).gitCurrentUserInfo();
    final creatorName = Provider.of<Auth>(context, listen: false).nameUser;
    final userId = Provider.of<Auth>(context, listen: false).userId;
    return Material(
        color: Colors.white60,
        child: Stack(overflow: Overflow.visible, children: <Widget>[
          Scaffold(
            body: Form(
              key: _formkey,
              child: Container(
                child: ListView(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: 1,
                        ),
                        InkWell(
                          onTap: () {
                            _locationService.sendLocationToDataBase(context);
                          },
                          child: Text(
                            'أضف إعلانك',
                            style: TextStyle(
                                fontSize: 22,
                                fontFamily: 'Montserrat-Arabic Regular',
                                height: 1.5),
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              loadingImage = false;
                              widget.id = '';
                              Navigator.pushReplacementNamed(
                                  context, HomeScreen.routeName);
                            },
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 33,
                            )),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 5)),
                    Container(
                      color: Colors.grey[300],
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(right: 4)),
                          Padding(
                              padding:
                                  EdgeInsets.only(bottom: 5, top: 3, right: 5),
                              child: Stack(
                                alignment: Alignment(1, -2),
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      getImage(context);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.blue),
                                      height: 60,
                                      width: 85,
                                      child: Column(
                                        children: <Widget>[
                                          Icon(
                                            Icons.add_a_photo,
                                            size: 36,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            'أضف صورة',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily:
                                                    'Montserrat-Arabic Regular',
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(-1, 0),
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.delete_forever,
                                          size: 30,
                                          color: Colors.red,
                                        ),
                                        onPressed: deleteImage),
                                  ),
                                  loadingImage
                                      ? Opacity(
                                          opacity: 0.6,
                                          child: Container(
                                            color: Colors.white,
                                            height: 60,
                                            width: 85,
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 18),
                                              child: Center(
                                                child: SpinKitFadingCircle(
                                                  color: Colors.red,
                                                  size: 70,
                                                  duration:
                                                      Duration(seconds: 2),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Center(),
                                ],
                              )),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.end,
                            alignment: WrapAlignment.end,
                            children: <Widget>[
                              image7 != null
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      width: 50,
                                      height: 50,
                                      child: image7 != null
                                          ? Image.file(
                                              image7,
                                              fit: BoxFit.fill,
                                            )
                                          : Container(),
                                    )
                                  : Container(),
                              Padding(padding: EdgeInsets.only(right: 4)),
                              image6 != null
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      width: 50,
                                      height: 50,
                                      child: image6 != null
                                          ? Image.file(
                                              image6,
                                              fit: BoxFit.fill,
                                            )
                                          : Container(),
                                    )
                                  : Container(),
                              Padding(padding: EdgeInsets.only(right: 4)),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: 50,
                                height: 50,
                                child: image5 != null
                                    ? Image.file(
                                        image5,
                                        fit: BoxFit.fill,
                                      )
                                    : Container(),
                              ),
                              Padding(padding: EdgeInsets.only(right: 4)),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: 50,
                                height: 50,
                                child: image4 != null
                                    ? Image.file(
                                        image4,
                                        fit: BoxFit.fill,
                                      )
                                    : Container(),
                              ),
                              Padding(padding: EdgeInsets.only(right: 4)),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: 50,
                                height: 50,
                                child: image3 != null
                                    ? Image.file(
                                        image3,
                                        fit: BoxFit.fill,
                                      )
                                    : Container(),
                              ),
                              Padding(padding: EdgeInsets.only(right: 4)),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: 50,
                                height: 50,
                                child: image2 != null
                                    ? Image.file(
                                        image2,
                                        fit: BoxFit.fill,
                                      )
                                    : Container(),
                              ),
                              Padding(padding: EdgeInsets.only(right: 4)),
                              Padding(
                                padding: EdgeInsets.only(right: 4),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width: 50,
                                  height: 50,
                                  child: image != null
                                      ? Image.file(
                                          image,
                                          fit: BoxFit.fill,
                                        )
                                      : Container(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    lineBorder(),
                    InkWell(
                      onTap: () {
                        setState(() {
                          choseCategory = !choseCategory;
                        });
                      },
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Icon(
                                Icons.arrow_back_ios,
                                size: 26,
                                color: Colors.grey[600],
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 3),
                                  child: Text(
                                    'ما الذي تريد بيعه أو الإعلان عنه ؟',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Montserrat-Arabic Regular',
                                        height: 1.5),
                                  )),
                            ],
                          ),
                          showInfoSelected ? infoSelected() : Container()
                        ],
                      ),
                    ),
                    lineBorder(),
                    choseCategory
                        ? Column(
                            children: [
                              buildFilterChips(),
                              lineBorder(),
                              choseFirstChip ? buildActionChips() : Container(),
                            ],
                          )
                        : Container(),
                    !choseCategory
                        ? Column(
                            children: [
                              Wrap(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: 10, left: 10, bottom: 2, top: 2),
                                    child: SizedBox(
                                      height: 54,
                                      width: 240,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'أدخل إسم لإعلانك';
                                          }
                                          return null;
                                        },
                                        onSaved: (val) {
                                          name = val;
                                        },
                                        onChanged: (val) {
                                          name = val;
                                        },
                                        maxLines: 1,
                                        initialValue:
                                            _initialValues['name'].toString(),
                                        maxLength: 32,
                                        //controller: nameController,
                                        textAlign: TextAlign.right,
                                        decoration: InputDecoration(
                                          hintText: '"مثال : "آيفون ٧ للبيع',
                                          hintStyle: TextStyle(
                                              fontSize: 12, height: 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'ضع إسم للإعلان',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Montserrat-Arabic Regular',
                                        height: 1),
                                  ),
                                ],
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                              ),
                              lineBorder(),
                              Wrap(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: 10, left: 5, bottom: 2, top: 4),
                                    child: SizedBox(
                                      height: 80,
                                      width: 230,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'أدخل تفاصيل اكثر لإعلانك';
                                          }
                                          return null;
                                        },
                                        initialValue:
                                            _initialValues['description']
                                                .toString(),
                                        onSaved: (val) {
                                          description = val;
                                        },
                                        maxLines: 10,
                                        textAlign: TextAlign.right,
                                        decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blue),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          hintText: 'ضع تفاصيل أكثر لإعلانك ',
                                          fillColor: Colors.grey,
                                          hoverColor: Colors.grey,
                                        ),
                                        cursorRadius: Radius.circular(5),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 12),
                                    child: Text(
                                      'ضع وصف للإعلان',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily:
                                              'Montserrat-Arabic Regular',
                                          height: 1.8),
                                    ),
                                  ),
                                  lineBorder(),
                                ],
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.start,
                              ),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                alignment: WrapAlignment.end,
                                children: <Widget>[
                                  Text(
                                    ': إختر الحالة جديد أم مستعمل ',
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Montserrat-Arabic Regular',
                                        height: 1.8),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: <Widget>[
                                      CheckboxListTile(
                                        title: Text(
                                          'جديد',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontFamily:
                                                  'Montserrat-Arabic Regular',
                                              height: 0.5),
                                        ),
                                        controlAffinity:
                                            ListTileControlAffinity.trailing,
                                        value: chacked,
                                        onChanged: (value) {
                                          setState(() {
                                            chacked = value;
                                            chacked2 = false;
                                            status = 'جديد';
                                          });
                                        },
                                      ),
                                      CheckboxListTile(
                                        title: Text(
                                          'مستعمل',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontFamily:
                                                  'Montserrat-Arabic Regular',
                                              height: 0.5),
                                        ),
                                        controlAffinity:
                                            ListTileControlAffinity.trailing,
                                        value: chacked2,
                                        onChanged: (value) {
                                          setState(() {
                                            chacked2 = value;
                                            chacked = false;
                                            status = 'مستعمل';
                                          });
                                        },
                                      )
                                    ],
                                  )
                                ],
                              ),
                              lineBorder(),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 1, horizontal: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Transform.scale(
                                        scale: 1.1,
                                        child: Switch.adaptive(
                                            value: valueSelectGps,
                                            onChanged: (val) {
                                              setState(() {
                                                allZonesShow = !allZonesShow;
                                                this.valueSelectGps = val;
                                                if (val) {
                                                  print(val);
                                                  allZonesShow = false;
                                                  Utils.showSnackBar(
                                                    context,
                                                    'انتظر حتى يتم التقاط موقعك الحالي..',
                                                  );
                                                  getCurrentAddress();
                                                } else {
                                                  area = '';
                                                  area2 = '';
                                                  print(val);
                                                }
                                              });
                                            })),
                                    Text(
                                      'تحديد الموقع الحالي ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily:
                                              'Montserrat-Arabic Regular',
                                          height: 1),
                                    ),
                                  ],
                                ),
                              ),
                              lineBorder(),
                              currentZoneShow
                                  ? Container(
                                      color: Colors.grey.shade300,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 4, top: 4),
                                            child: Text(
                                              '  $area',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline3,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 4, top: 4),
                                            child: Text(
                                              ': المنطقة ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline3,
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(),
                              allZonesShow
                                  ? Container(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(right: 10, top: 5),
                                        child: Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          alignment: WrapAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              ' : إختر المنطقة ',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontFamily:
                                                      'Montserrat-Arabic Regular',
                                                  height: 1),
                                            ),
                                            buildActionChipsArea(),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(),
                              lineBorder(),
                              Container(
                                child: Wrap(
                                  alignment: WrapAlignment.end,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.blueAccent,
                                      ),
                                      height: 30,
                                      width: 1,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 5, bottom: 3, left: 3, right: 1),
                                      child: SizedBox(
                                        width: 230,
                                        height: 38,
                                        child: TextFormField(
                                          initialValue: _initialValues['price']
                                              .toString(),
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return ' ضع سعر لإعلانك';
                                            }
                                            if (double.tryParse(value) ==
                                                null) {
                                              return ' Please provide a valid number';
                                            }
                                            if (double.parse(value) <= 0) {
                                              return ' Please enter a number';
                                            }
                                            return null;
                                          },
                                          onSaved: (val) {
                                            price = double.parse(val);
                                          },
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                  decimal: true),
                                          textAlign: TextAlign.right,
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blueAccent),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.green),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            hintText:
                                                '!... أدخل السعر المطلوب ,ارقام انجليزية',
                                            hintStyle: TextStyle(
                                                fontSize: 12, height: 1),
                                            fillColor: Colors.white,
                                            hoverColor: Colors.white,
                                          ),
                                          cursorRadius: Radius.circular(10),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding:
                                            EdgeInsets.only(right: 2, top: 1),
                                        child: Icon(
                                          Icons.attach_money,
                                          size: 40,
                                          color: Colors.blueAccent,
                                        )),
                                  ],
                                ),
                              ),
                              lineBorder(),
                              Container(
                                child: Wrap(
                                  alignment: WrapAlignment.end,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 6, bottom: 3, left: 3, right: 1),
                                      child: SizedBox(
                                        width: 230,
                                        height: 38,
                                        child: TextFormField(
                                          initialValue: _initialValues['phone']
                                              .toString(),
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return '!... أدخل رقم جوالك';
                                            }
                                            return null;
                                          },
                                          onSaved: (val) {
                                            phone = int.parse(val);
                                          },
                                          textAlign: TextAlign.right,
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                  decimal: true),
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blueAccent),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.green),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            hintText:
                                                '!... أدخل رقم جوالك, ارقام انجليزية',
                                            hintStyle: TextStyle(
                                                fontSize: 12, height: 1),
                                            fillColor: Colors.white,
                                            hoverColor: Colors.white,
                                          ),
                                          cursorRadius: Radius.circular(10),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding:
                                            EdgeInsets.only(right: 2, top: 1),
                                        child: Icon(
                                          Icons.phone_iphone,
                                          size: 40,
                                          color: Colors.blueAccent,
                                        )),
                                  ],
                                ),
                              ),
                              lineBorder(),
                              Padding(
                                padding: EdgeInsets.only(top: 3, bottom: 10),
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 140,
                                      height: 54,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: InkWell(
                                          onTap: () async {
                                            final isValid = _formkey
                                                .currentState
                                                .validate();
                                            _formkey.currentState.save();
                                            FocusScope.of(context).unfocus();
                                            _editedProduct = Product(
                                              time:
                                                  DateFormat('yyyy-MM-dd-HH:mm')
                                                      .format(DateTime.now()),
                                              creatorName: creatorName,
                                              id: '',
                                              name: name,
                                              creatorId: userId,
                                              description: description,
                                              price: price,
                                              area: area,
                                              phone: phone,
                                              status: status,
                                              deviceNo: deviceNo,
                                              category: category,
                                              uid: userId,
                                              department: category2,
                                              imagesUrl: urlImages,
                                              isFavorite: false,
                                              isRequest: false,
                                              views: views,
                                              likes: likes,
                                            );

                                            if (urlImages.length > 0) {
                                              if (widget.isEdit) {
                                                print(widget.id);
                                                try {
                                                  print(_editedProduct.area);
                                                  await Provider.of<Products>(
                                                          context,
                                                          listen: false)
                                                      .updateProduct(widget.id,
                                                          _editedProduct);
                                                  Navigator.popAndPushNamed(
                                                      context,
                                                      HomeScreen.routeName);
                                                } catch (e) {
                                                  await showDialog(
                                                      context: context,
                                                      builder:
                                                          (ctx) => AlertDialog(
                                                                title: Text(
                                                                    'An error occurred!'),
                                                                content: Text(
                                                                    'SomeThing Wrong'),
                                                                actions: [
                                                                  FlatButton(
                                                                    onPressed: () =>
                                                                        Navigator.of(ctx)
                                                                            .pop(),
                                                                    child: Text(
                                                                        'Okay!'),
                                                                  )
                                                                ],
                                                              ));
                                                }
                                              } else {
                                                try {
                                                  await Provider.of<Products>(
                                                          context,
                                                          listen: false)
                                                      .addProduct(
                                                          _editedProduct);
                                                  Navigator.popAndPushNamed(
                                                      context,
                                                      HomeScreen.routeName);
                                                  Utils.showSnackBar(
                                                      context, 'تم حفظ إعلانك');
                                                } catch (e) {
                                                  await showDialog(
                                                      context: context,
                                                      builder:
                                                          (ctx) => AlertDialog(
                                                                title: Text(
                                                                    'An error occurred!'),
                                                                content: Text(
                                                                    'SomeThing Wrong'),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.of(ctx)
                                                                            .pop(),
                                                                    child: Text(
                                                                        'Okay!'),
                                                                  )
                                                                ],
                                                              ));
                                                }
                                              }
                                            } else {
                                              await showDialog(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                        title: Text(
                                                          'لا يوجد صورة',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline3,
                                                        ),
                                                        content: Text(
                                                            'اضف صورة رجاءاً',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline3),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.of(
                                                                        ctx)
                                                                    .pop(),
                                                            child: Text(
                                                                'Okay !',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headline3),
                                                          )
                                                        ],
                                                      ));
                                            }
                                          },
                                          child: Card(
                                            color: Colors.blue[900],
                                            child: Center(
                                              child: Text('انشر إعلانك',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontFamily:
                                                          'Montserrat-Arabic Regular',
                                                      height: 1,
                                                      color: Colors.white)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    lineBorder(),
                  ],
                ),
              ),
            ),
          ),
        ]));
  }

  deleteImage() {
    setState(() {
      image = null;
      image2 = null;
      image3 = null;
      image4 = null;
      image5 = null;
      image6 = null;
      image7 = null;
      imageUrl = null;
      imageUrl2 = null;
      imageUrl3 = null;
      imageUrl4 = null;
      imageUrl5 = null;
      imageUrl6 = null;
      imageUrl7 = null;
      urlImages.clear();
    });
  }

  showMessage(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.blue,
        fontSize: 17,
        textColor: Colors.white);
  }

  Widget lineBorder() {
    return Padding(
      padding: EdgeInsets.only(top: 2),
      child: Container(
        width: MediaQuery.of(context).size.width - 5,
        height: 4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1),
          color: Colors.grey[300],
        ),
      ),
    );
  }

  final double spacing = 8;
  List<ActionChipData> devicesAndElectronicsList =
      DevicesAndElectronicsList.all;
  List<ActionChipData> mobileList = MobileList.all;
  List<ActionChipData> homeList = HomeList.all;
  List<ActionChipData> clothesList = ClothesList.all;
  List<ActionChipData> farmingList = FarmingList.all;
  List<ActionChipData> livestocksList = LivestocksList.all;
  List<ActionChipData> foodList = FoodList.all;
  List<ActionChipData> occupationsAndServicesList =
      OccupationsAndServicesList.all;
  List<ActionChipData> gamesList = GamesList.all;

  List<ActionChipData> carsList = CarsList.all;
  List<ActionChipData> actionChips3;
  List<FilterChipData> filterChips = FilterChips.all;
  bool choseFirstChip = false;

//filter chip
  Widget buildFilterChips() => Wrap(
        alignment: WrapAlignment.spaceEvenly,
        runSpacing: spacing,
        crossAxisAlignment: WrapCrossAlignment.end,
        spacing: spacing,
        children: filterChips
            .map((filterChip) => FilterChip(
                  label: Padding(
                    padding: EdgeInsets.symmetric(vertical: 1, horizontal: 2),
                    child: Text(
                      filterChip.label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Montserrat-Arabic Regular'),
                    ),
                  ),
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: filterChip.color,
                  ),
                  backgroundColor: filterChip.color.withOpacity(0.1),
                  onSelected: (isSelected) {
                    setState(() {
                      category2 = '';
                      filterChips = filterChips.map((otherChip) {
                        return filterChip == otherChip
                            ? otherChip.copy(isSelected: isSelected)
                            : otherChip.copy(isSelected: false);
                      }).toList();
                      switch (filterChip.label) {
                        case 'الموبايل':
                          actionChips3 = mobileList;
                          choseFirstChip = true;
                          break;

                        case 'أجهزة - إلكترونيات':
                          actionChips3 = devicesAndElectronicsList;
                          choseFirstChip = true;
                          break;
                        case 'السيارات - الدراجات':
                          actionChips3 = carsList;
                          choseFirstChip = true;
                          break;
                        case 'المنزل':
                          actionChips3 = homeList;
                          choseFirstChip = true;
                          break;
                        case 'ألبسة':
                          actionChips3 = clothesList;
                          choseFirstChip = true;
                          break;
                        case 'الزراعة':
                          actionChips3 = farmingList;
                          choseFirstChip = true;
                          break;
                        case 'المواشي':
                          actionChips3 = livestocksList;
                          choseFirstChip = true;
                          break;
                        case 'أطعمة':
                          actionChips3 = foodList;
                          choseFirstChip = true;
                          break;
                        case 'مهن وخدمات':
                          actionChips3 = occupationsAndServicesList;
                          choseFirstChip = true;
                          break;
                        case 'ألعاب':
                          actionChips3 = gamesList;
                          choseFirstChip = true;
                          break;
                        case 'المعدات والشاحنات':
                          choseFirstChip = false;
                          choseCategory = false;
                          break;
                        case 'وظائف وأعمال':
                          choseFirstChip = false;
                          choseCategory = false;
                          break;
                      }
                      showInfoSelected = true;
                      category = filterChip.label;
                    });
                  },
                  selected: filterChip.isSelected,
                  checkmarkColor: filterChip.color,
                  selectedColor: filterChip.color.withOpacity(0.25),
                ))
            .toList(),
      );

//action chips category
  Widget buildActionChips() => Wrap(
        crossAxisAlignment: WrapCrossAlignment.end,
        alignment: WrapAlignment.spaceEvenly,
        runSpacing: spacing,
        spacing: spacing,
        children: actionChips3
            .map((actionChip) => ActionChip(
                avatar: Icon(
                  actionChip.icon,
                  color: actionChip.iconColor,
                ),
                backgroundColor: Colors.grey[200],
                label: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 1.0, horizontal: 4.0),
                  child: Text(
                    actionChip.label,
                    textAlign: TextAlign.center,
                  ),
                ),
                labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Montserrat-Arabic Regular'),
                onPressed: () {
                  setState(() {
                    choseCategory = false;
                  });
                  category2 = actionChip.label;
                  // Utils.showSnackBar(
                  //   context,
                  //   'Do action "${actionChip.label}"...',
                  // );
                }))
            .toList(),
      );

  //action chips category
  Widget buildActionChipsArea() => Wrap(
        crossAxisAlignment: WrapCrossAlignment.end,
        alignment: WrapAlignment.spaceEvenly,
        runSpacing: spacing,
        spacing: spacing,
        children: dropItemsArea
            .map((actionChip) => ActionChip(
                avatar: Icon(
                  Icons.location_city,
                  color: Colors.amber,
                ),
                backgroundColor: Colors.grey[200],
                label: Text(
                  actionChip,
                  textAlign: TextAlign.center,
                ),
                labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Montserrat-Arabic Regular'),
                onPressed: () {
                  setState(() {
                    area = actionChip;
                    currentZoneShow = true;
                    allZonesShow = false;
                  });

                  // Utils.showSnackBar(
                  //   context,
                  //   'Do action "${actionChip.label}"...',
                  // );
                }))
            .toList(),
      );

  Widget infoSelected() {
    return Column(
      children: [
        Container(
          color: Colors.grey.shade300,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 4, top: 4),
                child: Text(
                  '  $category',
                  style: Theme.of(context).textTheme.headline3,
                  textAlign: TextAlign.center,
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 4, top: 4),
                child: Text(
                  ': القسم الرئيسي  ',
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
        Container(
          width: MediaQuery.of(context).size.width - 5,
          height: 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1),
            color: Colors.grey[100],
          ),
        ),
        Container(
          color: Colors.grey.shade300,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 4, top: 4),
                child: Text(
                  '  $category2',
                  style: Theme.of(context).textTheme.headline3,
                  textAlign: TextAlign.center,
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 4, top: 4),
                child: Text(
                  ': القسم الفرعي  ',
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
      ],
    );
  }
}
