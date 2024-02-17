import 'package:flutter/material.dart';
import 'package:vote_app/api/api_base/api_response.dart';
import 'package:vote_app/api/api_request.dart';
import 'package:vote_app/model/comment.dart';

class CommentProvider extends ChangeNotifier {
  // final List<ListComment> comment = [];
  late List comment;
  Future<void> getDataDetailCustomer(BuildContext context, String? id) async {
    // AppFunction.showLoading(context);
    ApiResponse resCustomer = await ApiRequest.getComment();
    if (resCustomer.result == true) {
      // AppFunction.hideLoading(context);
      // CustomerDetailModel detail =
      //     CustomerDetailModel.fromJson(resCustomer.data);
      // detailCustomer = detail;
    } else {
      // AppFunction.hideLoading(context);
      // AppFunction.showDialogError(
      //     context, resCustomer.message ?? "Lỗi không xác định");
    }
    notifyListeners();
  }
}
