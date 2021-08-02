import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ads_model.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  List<DocumentSnapshot> newItems = [];
  List<DocumentSnapshot> myAds = [];
  List<DocumentSnapshot> requests = [];
  List<DocumentSnapshot> itemsCategory = [];
  late int itemsCategoryCount;
  late int itemsRequestsCount;


  List<Product> allItems = [];

  late String authToken;
  late String userId;

  getData(String auth, String uId, List<Product> products) {
    authToken = auth;
    userId = uId;
    _items = products;

    notifyListeners();
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoritesItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  DocumentSnapshot findById(String id) {
    return newItems.firstWhere((prod) => prod.documentID == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    var url = 'https://souq-alfurat-89023.firebaseio.com/products.json';
    try {
      final res = await http.get(Uri.parse(url));
      final extractedData = json.decode(res.body) as Map<String, dynamic>;

      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            time: prodData['date'],
            id: prodId,
            creatorName: prodData['creatorName'],
            name: prodData['name'],
            description: prodData['description'],
            price: prodData['price'],
            isFavorite: false,
            imagesUrl: prodData['imagesUrl'],
            creatorId: prodData['creatorId'],
            area: prodData['area'],
            phone: prodData['phone'],
            status: prodData['status'],
            deviceNo: prodData['deviceNo'],
            category: prodData['category'],
            uid: prodData['uid'],
            department: prodData['department'],
            isRequest: prodData['isRequest'],
            views: prodData['views'],
            likes: prodData['likes'],
          ),
        );
      });
      allItems = loadedProducts;
      final Iterable<Product> aList =
          loadedProducts.where((element) => element.creatorId == userId);
      _items = aList.toList();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addProduct(Product product) async {
    //add by firesrore
    Firestore.instance.collection('Ads2').add({
      'date': product.time,
      'creatorName': product.creatorName,
      'name': product.name,
      'description': product.description,
      'price': product.price,
      'creatorId': userId,
      'area': product.area,
      'phone': product.phone,
      'status': product.status,
      'deviceNo': product.deviceNo,
      'category': product.category,
      'uid': product.uid,
      'department': product.department,
      'imagesUrl': product.imagesUrl,
      'isFavorite': product.isFavorite,
      'isRequest': product.isRequest,
      'views': product.views,
      'likes': product.likes,
    });

    //add by api
    // final url = 'https://souq-alfurat-89023.firebaseio.com/products.json';
    // try {
    //   final res = await http.post(Uri.parse(url),
    //       body: json.encode({
    //         'date':product.time,
    //         'creatorName':product.creatorName,
    //         'name': product.name,
    //         'description': product.description,
    //         'price': product.price,
    //         'creatorId': userId,
    //         'area': product.area,
    //         'phone': product.phone,
    //         'status': product.status,
    //         'deviceNo': product.deviceNo,
    //         'category': product.category,
    //         'uid': product.uid,
    //         'department': product.department,
    //         'imagesUrl': product.imagesUrl,
    //         'isFavorite': product.isFavorite,
    //         'isRequest': product.isRequest,
    //         'views': product.views,
    //         'likes': product.likes,
    //       }));
    //   final newProduct = Product(
    //     id: json.decode(res.body)['name'],
    //     name: product.name,
    //     description: product.description,
    //     imagesUrl: product.imagesUrl,
    //     price: product.price,
    //   );
    //
    //   _items.add(newProduct);
    //   notifyListeners();
    // } catch (e) {
    //   throw e;
    // }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);

    print(newProduct.department);
      //update by firestor
      Firestore.instance.collection('Ads2').document(id).setData({
        'date': newProduct.time,
        'updateDate': DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now()),
        'name': newProduct.name,
        'creatorName': newProduct.creatorName,
        'description': newProduct.description,
        'price': newProduct.price,

        'area': newProduct.area,
        'phone': newProduct.phone,
        'status': newProduct.status,
        'deviceNo': newProduct.deviceNo,
        'category': newProduct.category,

        'department': newProduct.department,
        'imagesUrl': newProduct.imagesUrl,
        'isFavorite': newProduct.isFavorite,
        'isRequest': newProduct.isRequest,
        'views': newProduct.views,
        'likes': newProduct.likes,
      });

      //update by api

      // final url = 'https://souq-alfurat-89023.firebaseio.com/products/$id.json';
      // await http.patch(Uri.parse(url),
      //     body: json.encode({
      //       'date':newProduct.time,
      //       'updateDate':DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now()),
      //       'name': newProduct.name,
      //       'description': newProduct.description,
      //       'price': newProduct.price,
      //       'creatorId': userId,
      //       'area': newProduct.area,
      //       'phone': newProduct.phone,
      //       'status': newProduct.status,
      //       'deviceNo': newProduct.deviceNo,
      //       'category': newProduct.category,
      //       'uid': newProduct.uid,
      //       'department': newProduct.department,
      //       'imagesUrl': newProduct.imagesUrl,
      //       'isFavorite': newProduct.isFavorite,
      //       'isRequest': newProduct.isRequest,
      //       'views': newProduct.views,
      //       'likes': newProduct.likes,
      //     }));

      //_items[prodIndex] = newProduct;
      notifyListeners();

  }

  Future<void> updateLikes(String id, likes, index,String txt) async {
    if (id.length >= 0) {
      //update like by firestore
      Firestore.instance.collection('Ads2').document(id).updateData({
        'likes': likes + 1,
      });
      newItems[index].data['likes'] = newItems[index].data['likes'] + 1;
      notifyListeners();

      print('like++');
     // if(txt =='request')requests[index].data['likes'] = requests[index].data['likes'] + 1;
      //update like by api
      // final url = 'https://souq-alfurat-89023.firebaseio.com/products/$id.json';
      // await http.patch(Uri.parse(url),
      //     body: json.encode({
      //       'likes': likes + 1,
      //     }));
      // //fetchNewAds(false);
      // newItems[index].likes = newItems[index].likes + 1;
      notifyListeners();
    } else {}
  }

  Future<void> updateViews(String id, views, index , String txt) async {
    if (id.length >= 0) {
      //update like by firestore
      Firestore.instance.collection('Ads2').document(id).updateData({
        'views': views + 1,
      });
      newItems[index].data['views'] = newItems[index].data['views'] + 1;
      if(txt =='request'){
        requests[index].data['views'] = requests[index].data['views'] + 1;
      }else{

      }

      //update like by api
      // final url = 'https://souq-alfurat-89023.firebaseio.com/products/$id.json';
      // await http.patch(Uri.parse(url),
      //     body: json.encode({
      //       'likes': likes + 1,
      //     }));
      // //fetchNewAds(false);
      // newItems[index].likes = newItems[index].likes + 1;
      notifyListeners();
    } else {}
  }

  Future<void> deleteAd(String id) async {
    try{
      Firestore.instance.collection('Ads2').document(id).delete();
      newItems.removeWhere((element) => element.documentID==id);
      notifyListeners();
    }catch(err){
      throw err;
    }


    // //delete by api
    // final url =
    //     'https://shop-1d972-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken';
    // final existingproductIndex = _items.indexWhere((prod) => prod.id == id);
    // Product? existingProduct = _items[existingproductIndex];
    // _items.removeAt(existingproductIndex);
    // notifyListeners();
    //
    // final res = await http.delete(Uri.parse(url));
    //
    // if (res.statusCode >= 400) {
    //   _items.insert(existingproductIndex, existingProduct);
    //   notifyListeners();
    //   throw HttpException('Could Not delete');
    // }
    // existingProduct = null;
  }

  //get new Ads
  Future<void> fetchNewAds([bool filterByUser = false]) async {
    final filteredString =
        filterByUser ? '?orderBy="creatorId"equalTo="$userId' : '';
    print('userId from fetch new ad $userId');
    //var url = 'https://souq-alfurat-89023.firebaseio.com/products.json';
    try {
      QuerySnapshot querySnapshot =
          await Firestore.instance.collection("Ads2").getDocuments();
      final List<DocumentSnapshot> snap = querySnapshot.documents.toList();
      newItems = snap;
      // final res = await http.get(Uri.parse(url));
      // final extractedData = json.decode(res.body) as Map<String, dynamic>;
      //
      // final List<Product> loadedProducts = [];
      // extractedData.forEach((prodId, prodData) {
      //   loadedProducts.add(
      //     Product(
      //       id: prodId,
      //       time: prodData['date'],
      //       creatorName: prodData['creatorName'],
      //       name: prodData['name'],
      //       description: prodData['description'],
      //       price: prodData['price'],
      //       isFavorite: false,
      //       imagesUrl: prodData['imagesUrl'],
      //       creatorId: prodData['creatorId'],
      //       area: prodData['area'],
      //       phone: prodData['phone'],
      //       status: prodData['status'],
      //       deviceNo: prodData['deviceNo'],
      //       category: prodData['category'],
      //       uid: prodData['uid'],
      //       department: prodData['department'],
      //       isRequest: prodData['isRequest'],
      //       views: prodData['views'],
      //       likes: prodData['likes'],
      //     ),
      //   );
      // });
      //
      // newItems = loadedProducts;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> fetchCategoryAds(category) async {
    try {
      QuerySnapshot querySnapshot = await Firestore.instance
          .collection("Ads2")
          .where('category', isEqualTo: category)
          .getDocuments();
      final List<DocumentSnapshot> snap = querySnapshot.documents.toList();
      itemsCategory = snap;
      print(itemsCategory.length);
      itemsCategoryCount = itemsCategory.length;
      newItems = snap;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  //fetch requests
  Future<void> fetchRequests() async {
    try {
      QuerySnapshot querySnapshot = await Firestore.instance
          .collection("Ads2")
          .where('isRequest', isEqualTo: true)
          .getDocuments();
      final List<DocumentSnapshot> snap = querySnapshot.documents.toList();
      itemsCategory = snap;
      print(itemsCategory.length);
      itemsRequestsCount = itemsCategory.length;
      requests = snap;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }


  //fetch my ads

  Future<void> fetchMyAds(creatorId) async {
    print('crator id f $creatorId');
    try {
      QuerySnapshot querySnapshot = await Firestore.instance
          .collection("Ads2")
          .where('creatorId', isEqualTo: creatorId)
          .getDocuments();
      final List<DocumentSnapshot> snap = querySnapshot.documents.toList();
      myAds = snap;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
