import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';

class AppFunctions {
  // static showLoading(BuildContext context) {
  //   context.read<LoadingProvider>().showLoading();
  // }

  // static hideLoading(BuildContext context) {
  //   context.read<LoadingProvider>().hideLoading();
  // }

  static void hideKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static bool checkNullAndFalse(bool? check) {
    if (check == null) {
      return false;
    } else if (check == false) {
      return false;
    }
    return true;
  }

  static void log(String text) {
    final pattern = RegExp('.{1,800}');
    pattern.allMatches(text).forEach((match) => debugPrint(match.group(0)));
  }

  static bool isNullEmpty(Object o) => "" == o;

  // static void customBottomSheet(
  //     {required BuildContext context, //bắt buộc phải có để show
  //       required Widget body, //phần thân
  //       Color? bodyColors, //màu của bottomsheeet
  //       String? title, //phần tittle k truyền vào sẽ k có nút close và devider
  //       bool? showButtonClose, // có show nút close k
  //       Color? backgroundColors, // màu đằng sau của mà hình khi có bottom sheeet
  //       bool? closeWhenTouch, //khi bấm ra màn hình sẽ close bottom sheet
  //       bool? isScroll, // bottom sheet có thể scroll hay k
  //       bool isPadding = true,
  //       Color? colorDivider,
  //       double? height}) {
  //   showModalBottomSheet(
  //       context: context,
  //       isScrollControlled: isScroll ?? true,
  //       isDismissible: true,
  //       barrierColor: backgroundColors ?? AppColors.dark1.withOpacity(0.6),
  //       backgroundColor: Colors.transparent,
  //       builder: (BuildContext context) {
  //         return SingleChildScrollView(
  //           child: Padding(
  //             padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
  //             child: Container(
  //               height: height ?? MediaQuery.of(context).size.height * 0.3,
  //               width: MediaQuery.of(context).size.width,
  //               decoration: BoxDecoration(
  //                 borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
  //                 color: bodyColors ?? Colors.white,
  //               ),
  //               child: Column(
  //                 children: [
  //                   Container(
  //                     width: MediaQuery.of(context).size.width,
  //                     height: 24,
  //                     alignment: Alignment.center,
  //                     padding: EdgeInsets.symmetric(vertical: 10),
  //                     child: Container(
  //                       width: 33,
  //                       decoration: BoxDecoration(
  //                         color: const Color(0xff171A1D26).withOpacity(0.15),
  //                         borderRadius: BorderRadius.circular(2),
  //                       ),
  //                     ),
  //                   ),
  //                   (title != null && title != "")
  //                       ? Container(
  //                     width: MediaQuery.of(context).size.width,
  //                     decoration: const BoxDecoration(
  //                         borderRadius:
  //                         BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
  //                     child: Padding(
  //                       padding: const EdgeInsets.only(top: 20, bottom: 12),
  //                       child: Row(
  //                         children: [
  //                           const Expanded(flex: 1, child: SizedBox()),
  //                           Expanded(
  //                             flex: 4,
  //                             child: Center(
  //                               child: Text(
  //                                 title,
  //                                 style: TextStyle(
  //                                   color: AppColors.dark1,
  //                                   fontFamily: AppFonts.sfProDisplay,
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                           Expanded(
  //                             flex: 1,
  //                             child: (showButtonClose != null && showButtonClose)
  //                                 ? TouchableWidget(
  //                               onPressed: () {
  //                                 Navigator.of(context).pop();
  //                               },
  //                               child: const Icon(
  //                                 Icons.close,
  //                                 size: 25,
  //                                 weight: 10,
  //                               ),
  //                             )
  //                                 : const SizedBox.shrink(),
  //                           )
  //                         ],
  //                       ),
  //                     ),
  //                   )
  //                       : const SizedBox.shrink(),
  //                   (title != null && title != "")
  //                       ? Container(
  //                     height: 1,
  //                     color: colorDivider ?? AppColors.white,
  //                     width: MediaQuery.of(context).size.width,
  //                   )
  //                       : const SizedBox.shrink(),
  //                   Expanded(
  //                       child: Padding(
  //                         padding: isPadding
  //                             ? const EdgeInsets.only(
  //                           left: 24,
  //                           right: 24,
  //                         )
  //                             : EdgeInsets.zero,
  //                         child: Center(child: body),
  //                       ))
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  // }

  // //show dialog
  // static void showDialogAlert(BuildContext context,
  //     {String? title,
  //     String? textConfirm,
  //     String? textCancel,
  //     Widget? description,
  //     Widget? customTitle,
  //     String? image,
  //     void Function()? onPressConfirm,
  //     void Function()? onPressCancel,
  //     bool? hideButtonClose,
  //     bool? canScroll,
  //     Color? backgroundColor,
  //     Color? titleColor,
  //     bool? dialogDismiss}) {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return NormalDialog(
  //           title: title,
  //           textConfirm: textConfirm,
  //           description: description,
  //           image: image,
  //          // imageSize: imageSize,
  //           onPressConfirm: onPressConfirm,
  //           hideButtonClose: hideButtonClose,
  //           customTitle: customTitle,
  //           dialogDismiss: dialogDismiss,
  //           backgroundColor: backgroundColor,
  //           canScroll: canScroll,
  //           textCancel: textCancel,
  //           onPressCancel: onPressCancel,
  //           titleColor: titleColor,
  //         );
  //       });
  // }

  // // static void showDialogError(
  // //   BuildContext context, {
  // //   String? title,
  // //   void Function()? onPressConfirm,
  // // }) {
  // //   showDialog(
  // //       context: context,
  // //       builder: (BuildContext contextSon) {
  // //         return NormalDialog(
  // //           title: "ERROR",
  // //           description: Text(
  // //             title ?? AppLocalizations.of(context)?.anUnexpectedErrorOccurred ?? '',
  // //             textAlign: TextAlign.center,
  // //             style: AppFonts.be500(14, AppColors.dark0),
  // //           ),
  // //           titleColor: AppColors.red0,
  // //           dialogDismiss: true,
  // //           hideButtonClose: true,
  // //           textConfirm: AppLocalizations.of(context)?.close,
  // //           onPressConfirm: title == 'Tài khoản được đăng nhập ở nơi khác !'
  // //               ? () async {
  // //                   Navigator.of(contextSon, rootNavigator: true).pop();
  // //                   final SharedPreferences prefs = await SharedPreferences.getInstance();
  // //                   prefs.remove('jwt');
  // //                   SystemNavigator.pop();
  // //                 }
  //               : onPressConfirm,
  //         );
  //       });
  // }

//   static checkValidPhone(String phone) {
//     // String phoneNumber = AppUtils.convertPhoneToOrigin(phone);
//     bool isValid = false;
//     String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
//     RegExp regExp = RegExp(pattern);
//     if (phone.length == 10) {
//       String firstNumber = phone.substring(0, 2);
//       isValid = (firstNumber == '09' ||
//           firstNumber == '08' ||
//           firstNumber == '07' ||
//           firstNumber == '03' ||
//           firstNumber == '05');
//     }
//     if (!regExp.hasMatch(phone)) {
//       isValid = false;
//     }
//     return isValid;
//   }

//   static bool checkValidNumber(String number) {
//     bool isValid = false;
//     String pattern = r'^\d+$'; // Chấp nhận số nguyên dương
//     RegExp regExp = RegExp(pattern);

//     if (regExp.hasMatch(number)) {
//       isValid = true;
//     }

//     return isValid;
//   }

//   static String formatNum(num? input) {
//     if (input != null) {
//       final formatter = NumberFormat("#,###,###");
//       return formatter.format(input);
//     } else {
//       return "";
//     }
//   }

//   static String formatDate(DateTime input) {
//     final DateFormat formatter = DateFormat('dd/MM/yyyy');
//     final String formatted = formatter.format(input);
//     return formatted;
//   }

//   static String formatDateString(String? input, {bool? haveTime}) {
//     if (input != null) {
//       final date = DateTime.parse(input);
//       if (haveTime == true) {
//         final DateFormat formatter = DateFormat('dd/MM/yyyy hh:mm');
//         final String formatted = formatter.format(date);
//         return formatted;
//       } else {
//         final DateFormat formatter = DateFormat('dd/MM/yyyy');
//         final String formatted = formatter.format(date);
//         return formatted;
//       }
//     } else {
//       return "";
//     }
//   }

//   static String timeAgo(String? createTimeStr) {
//     if (createTimeStr == null) {
//       return "";
//     } else {
//       DateTime dateCreate = DateTime.parse(createTimeStr);
//       DateTime now = DateTime.now();
//       Duration difference = now.difference(dateCreate);
//       if (difference.inDays > 0) {
//         return '${difference.inDays} ngày';
//       } else if (difference.inHours > 0) {
//         return '${difference.inHours} giờ';
//       } else if (difference.inMinutes > 0) {
//         return '${difference.inMinutes} phút';
//       } else {
//         return 'vừa xong';
//       }
//     }
//   }

//   static String hidePartOfString(String? input) {
//     if (input == null) {
//       return "***";
//     } else {
//       if (input.length <= 3) {
//         return "***";
//       }
//       String visiblePart = input.substring(0, input.length - 3);
//       String maskedPart = '*' * (3);
//       return '$visiblePart$maskedPart';
//     }
//   }

//   static double calculateFontSize(BuildContext context, double desiredFontSize) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     return (desiredFontSize * screenWidth) / 375.0; // 375.0 là chiều rộng màn hình cơ bản bạn muốn cân nhắc
//   }

//   static double heightAccording(BuildContext context, double heightAccording) {
//     double screenHeight = MediaQuery.of(context).size.height;
//     return (heightAccording * screenHeight) / 812.0;
//   }
// }
}
