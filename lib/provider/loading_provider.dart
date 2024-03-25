import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimationProvider extends ChangeNotifier {
  bool _isLoading = false;

  get isLoading => _isLoading;

  void showLoading() {
    _isLoading = true;

    notifyListeners();
  }

  void hideLoading() {
    _isLoading = false;

    notifyListeners();
  }
}
