import 'package:flutter/material.dart';

class RowInCardProduct extends StatelessWidget {
  const RowInCardProduct({
    super.key,
    this.titleLeft,
    this.titleRight,
  });
  final String? titleLeft;
  final String? titleRight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              titleLeft ?? "",
              maxLines: 1,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              titleRight ?? "",
              maxLines: 1,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),

              // style: AppFonts.normalBold(
              //   14,
              //   isTextRed
              //       ? AppThemes.red0
              //       : isTextBlue
              //           ? AppThemes.kPrimary
              //           : AppThemes.dark1,
              // ).copyWith(
              //   height: 18 / 14,
              // ),
            ),
          )
        ],
      ),
    );
  }
}
