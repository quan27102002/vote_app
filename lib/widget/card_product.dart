// import 'package:flutter/material.dart';

// class CardProductCheck extends StatelessWidget {
//   const CardProductCheck({
//     super.key,
//     required this.listData,
//     this.numberCard,
//     required this.onPressed,
//     this.haveIcon = false,
//     this.noCheckBox = false,
//     this.isCheck = false,
//     this.onTapCheckBox,
//     this.onTapEdit,
//     this.onTapDelete,
//   });
//   final List<Map> listData;
//   final int? numberCard;
//   final bool noCheckBox;
//   final Function() onPressed;
//   final bool haveIcon;
//   final bool isCheck;
//   final Function()? onTapCheckBox;
//   final Function()? onTapEdit;
//   final Function()? onTapDelete;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12, right: 20, left: 20, top: 0),
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//           boxShadow: [
//             BoxShadow(
//                 color: const Color(0xff606170).withOpacity(0.16),
//                 offset: const Offset(0, 16),
//                 blurRadius: 24,
//                 spreadRadius: 0),
//             BoxShadow(
//                 color: const Color(0xff28293D).withOpacity(0.04),
//                 offset: const Offset(0, 2),
//                 blurRadius: 8,
//                 spreadRadius: 0),
//           ]),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           TouchableWidget(
//             onPressed: onPressed,
//             padding: const EdgeInsets.all(0),
//             child: Column(
//               children: listData
//                   .map((e) => RowInCardProduct(
//                         titleRight:
//                             e["titleRight"] ?? "Mã nhập hàng".toString(),
//                         titleLeft: e["titleLeft"] ?? "PN220930105557",
//                         isFinal: e["isFinal"] ?? false,
//                         isTextBlue: e["isTextBlue"] ?? false,
//                         isStatus: e["isStatus"] ?? false,
//                         isTextRed: e["isTextRed"] ?? false,
//                       ))
//                   .toList(),
//             ),
//           ),
//           haveIcon
//               ? Container(
//                   alignment: Alignment.centerRight,
//                   margin: const EdgeInsets.only(
//                     right: 16,
//                     left: 16,
//                     top: 24,
//                     bottom: 16,
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       InkWell(
//                         onTap: onTapEdit,
//                         child: Container(
//                           height: 44,
//                           width: 44,
//                           decoration: const BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: AppThemes.blue4,
//                           ),
//                           child: Center(
//                               child: Image.asset(
//                             AppImages.iconPenRed,
//                             height: 24,
//                             width: 24,
//                             fit: BoxFit.fill,
//                           )),
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 24,
//                       ),
//                       InkWell(
//                         onTap: onTapDelete,
//                         child: Container(
//                           height: 44,
//                           width: 44,
//                           decoration: const BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: AppThemes.blue4,
//                           ),
//                           child: Center(
//                               child: Image.asset(
//                             AppImages.iconTrashGrey,
//                             height: 24,
//                             width: 24,
//                             color: AppThemes.red0,
//                             fit: BoxFit.fill,
//                           )),
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               : const SizedBox.shrink(),
//         ],
//       ),
//     );
//   }
// }
