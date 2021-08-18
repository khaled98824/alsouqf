
import 'package:flutter/material.dart';


class FullDataProvider with ChangeNotifier {
  var adImagesUrlF = [];
  bool bottomIsVisible = true;

  showBottom(){
   bottomIsVisible=true;
    notifyListeners();
  }
  hideBottom(){
    bottomIsVisible=false;
    notifyListeners();
  }


  notifyListeners() ;
}