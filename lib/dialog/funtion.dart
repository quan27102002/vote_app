import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vote_app/dialog/nomarlDialog.dart';
import 'package:vote_app/provider/loading.dart';

class AppFuntion{
   static void showDialogError(
    BuildContext context,
    String errText, {
    String? title,
    Function()? onPressButton,
    String? textButton,
    String? description,
    bool? dialogDismiss,
  }) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return NormalDialog(
           
            onPress1stButton: onPressButton,
            title: title ?? "Lỗi",
            description: description,
            text1stButton: textButton ?? "Đăng nhập",
            dialogDismiss: dialogDismiss,
          
          );
        });
  }
    static showLoading(BuildContext context) async {
    context.read<LoadingProvider>().showLoading();
  }

  static hideLoading(BuildContext context) async {
    context.read<LoadingProvider>().hideLoading();
  }
}