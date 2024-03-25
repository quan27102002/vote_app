import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:vote_app/provider/loading.dart';

class AppFunctions {
  static showLoading(BuildContext context) {
    context.read<LoadingProvider>().showLoading();
  }

  static hideLoading(BuildContext context) {
    context.read<LoadingProvider>().hideLoading();
  }

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
}
