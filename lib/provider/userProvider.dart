import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vote_app/api/api_base/api_response.dart';
import 'package:vote_app/api/api_base/api_response_http.dart';
import 'package:vote_app/api/api_request.dart';

import 'package:vote_app/model/user.dart';

// class UserProvider extends ChangeNotifier {
//   User modelLogIn = User();
//   Future<String> getDataUserProfile(String username, String passWord) async {
//     ApiResponse res = await ApiRequest.userLogin(username, passWord);
//     if (res.result == true) {
//       String token = res.data["accessToken"];
//       String refreshToken=res.data["refreshToken"] ;
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setString('jwt', token);
//        await prefs.setString('jwtrefresh', refreshToken);
//         SharedPreferences preferences = await SharedPreferences.getInstance();
//        Timer.periodic(Duration(hours: 2), (Timer t) => FunctionrefreshToken(preferences.getString('jwt'), preferences.getString('jwtrefresh') ));
//       User user = User.fromJson(res.data);
//       modelLogIn = user;
//       notifyListeners();
//       return "success";
//     } else {
//       notifyListeners();
//       return res.message ?? "Lỗi";
//     }
//   }

//   void logout() {
//     modelLogIn = User();
//     notifyListeners();
//   }
//   Future<void> FunctionrefreshToken(String? token,String? refreshToken) async {
//     ApiResponse res = await ApiRequest.getTokenByRefreshtoken(token, refreshToken);
//      if (res.result == true) {
//       String token = res.data["accessToken"];
//       String refreshToken=res.data["refreshToken"] ;
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setString('jwt', token);
//        await prefs.setString('jwtrefresh', refreshToken);
//   }
//   }
// }
class UserProvider extends ChangeNotifier {
  User modelLogIn = User();
  User get loggedInUser => modelLogIn;
  late Timer _refreshTimer; // Timer để gọi hàm FunctionrefreshToken

  Future<String> getDataUserProfile(String username, String passWord) async {
    ApiResponse res = await ApiRequest.userLogin(username, passWord);
    print(res.code);
    if (res.code == 200) {
      String token = res.data["accessToken"];
      String refreshToken = res.data["refreshToken"];
      int role = res.data["role"];
      String codeBr = res.data["branchCode"];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('role', role);
      await prefs.setString('codeBr', codeBr);
      await prefs.setString('jwt', token);
      await prefs.setString('jwtrefresh', refreshToken);

      // Gọi hàm refresh token một lần sau khi nhận được token mới
      // FunctionrefreshToken(token, refreshToken);
      // startTokenRefreshTimer(token, refreshToken);

      User user = User.fromJson(res.data);
      modelLogIn = user;
      notifyListeners();
      return "success";
    } else {
      notifyListeners();
      return res.message ?? "Lỗi";
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('role'); // Xóa thông tin về vai trò của người dùng
    await prefs.remove('codeBr'); // Xóa mã chi nhánh
    await prefs.remove('jwt'); // Xóa mã token
    await prefs.remove('jwtrefresh');
    modelLogIn = User();
    notifyListeners();
  }

  // Hàm này sẽ được gọi mỗi 2 giờ để refresh token
  void startTokenRefreshTimer(String? token, String? refreshToken) {
    // Tạo Timer.periodic và gọi hàm refresh token mỗi 2 giờ
    _refreshTimer = Timer.periodic(Duration(minutes: 30), (timer) {
      FunctionrefreshToken(token, refreshToken);
    });
  }

  // Hàm refresh token
  Future<void> FunctionrefreshToken(String? token, String? refreshToken) async {
    // Kiểm tra xem token và refreshToken có giá trị không
    if (token != null && refreshToken != null) {
      ApiResponse res =
          await ApiRequest.getTokenByRefreshtoken(token, refreshToken);
      if (res.result == true) {
        String newToken = res.data["accessToken"];
        String newRefreshToken = res.data["refreshToken"];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt', newToken);
        await prefs.setString('jwtrefresh', newRefreshToken);
      }
    }
  }
}
