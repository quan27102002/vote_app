import 'package:flutter/material.dart';
import 'package:vote_app/theme/spacing.dart';

class NormalDialog extends StatelessWidget {
  final void Function()? onPress1stButton;
  final String? title, description, text1stButton;
  final bool? dialogDismiss;
  const NormalDialog(
      {super.key,
      this.onPress1stButton,
      required this.title,
      required this.description,
      required this.text1stButton,
      required this.dialogDismiss});
  Future<bool> onWillPop() {
    return Future.value(dialogDismiss ?? false);
  }

  closePopup(BuildContext context) {
    dialogDismiss:
    true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onWillPop,
        child: Dialog(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: Stack(children: <Widget>[
              Container(
                height: 200,
                width: 300,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title ?? "Thông báo",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(40, 41, 61, 1)),
                        ),
                        Spacing.h12,
                        Text(description ?? "",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(85, 87, 112, 1))),
                      
                      ],
                    ),
                     
                        ElevatedButton(
                            onPressed: onPress1stButton ?? closePopup(context),
                            child: Text(text1stButton ?? " Thoát"))
                  ],
                ),
              )
            ])));
  }
}
