import 'package:flutter/material.dart';
import 'package:vote_app/api/api_base/api_response.dart';
import 'package:vote_app/api/api_request.dart';
import 'package:vote_app/model/comment.dart';

class ImagesProvider extends ChangeNotifier {
  List<dynamic> listImage = [];

  Future<void> getApi() async {
    listImage.clear();
    ApiResponse res = await ApiRequest.getImage();

    if (res.code == 200) {
      listImage = res.data;

      print(listImage);
      notifyListeners();
      print(listImage);
    } else {
      notifyListeners();
      print(res.message ?? "Lỗi");
    }
  }
}
