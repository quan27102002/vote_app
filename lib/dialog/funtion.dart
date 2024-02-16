import 'package:flutter/material.dart';
import 'package:vote_app/dialog/nomarlDialog.dart';

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
            text1stButton: textButton ?? "Vào đăng nhập",
            dialogDismiss: dialogDismiss,
          
          );
        });
  }
}