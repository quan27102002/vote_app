import 'package:flutter/material.dart';
import 'package:vote_app/api/api_base/api_response.dart';
import 'package:vote_app/api/api_request.dart';
import 'package:vote_app/model/comment.dart';

class CommentProvider extends ChangeNotifier {
  List<ListComment> listComment = [];

  Future<void> getApi() async {
    listComment.clear();
    ApiResponse res = await ApiRequest.getComment();

    if (res.code == 200) {
      for (var e in res.data) {
        listComment.add(ListComment.fromJson(e));
      }
      notifyListeners();
      print(listComment);
    } else {
      notifyListeners();
      print(res.message ?? "Lỗi");
    }
  }
}
