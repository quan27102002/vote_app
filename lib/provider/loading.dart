import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class LoadingProvider extends ChangeNotifier{
  bool isLoading =false;
  void showLoading(  ){
    isLoading = true ;
    notifyListeners();
  }
  void hideLoading(){
    isLoading = false;
    notifyListeners();
  }
}