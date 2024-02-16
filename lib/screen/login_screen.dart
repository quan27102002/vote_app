import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vote_app/api/api_base/api_response.dart';
import 'package:vote_app/api/api_request.dart';
import 'package:vote_app/dialog/funtion.dart';
import 'package:vote_app/provider/userProvider.dart';
import 'package:vote_app/router/app_router.dart';
import 'package:vote_app/router/router_name.dart';
import 'package:vote_app/screen/logout_screen.dart';
import 'package:vote_app/theme/spacing.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _check = false;
  bool _isObscure3 = true;
  late bool rememberToken = false;
  bool visible = false;
  final TextEditingController usernameController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color.fromRGBO(47, 179, 178, 1),
        body:  Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(children: [
                Text(
                  "Đăng nhập",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Username của người dùng",
                        style: TextStyle(
                          fontFamily: 'SF Pro Rounded',
                          color: Color(0xFF848496),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        )),
                  ],
                ),
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Username',
                    enabled: true,
                    contentPadding:
                        const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.white),
                      borderRadius: new BorderRadius.circular(10),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: new BorderSide(color: Colors.white),
                      borderRadius: new BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value!.length == 0) {
                      return "Username cannot be empty";
                    }
                  },
                  onSaved: (value) {
                    usernameController.text = value!;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Mật khẩu của người dùng",
                        style: TextStyle(
                          fontFamily: 'SF Pro Rounded',
                          color: Color(0xFF848496),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        )),
                  ],
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: _isObscure3,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        icon: Icon(_isObscure3
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscure3 = !_isObscure3;
                          });
                        }),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Password',
                    enabled: true,
                    contentPadding:
                        const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 15.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.white),
                      borderRadius: new BorderRadius.circular(10),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: new BorderSide(color: Colors.white),
                      borderRadius: new BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    RegExp regex = new RegExp(r'^.{6,}$');
                    if (value!.isEmpty) {
                      return "Password cannot be empty";
                    }
                    if (!regex.hasMatch(value)) {
                      return ("please enter valid password min. 6 character");
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    passwordController.text = value!;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                Spacing.h32,
                ElevatedButton(
                  onPressed: () {
                    // login();
                    logIn(usernameController.text, passwordController.text);
                  },
                  child: Text(
                    "Đăng nhập",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                )
              ]),
            ),
          ),
        );
  }

  Future<void> logIn(String username, String pass) async {
// final data = {
//     'username': username,
//     'password': pass,
//   };

  // Chuyển đổi dữ liệu sang định dạng JSON


  // Tạo header cho yêu cầu POST
  // Map<String, String> headers = {
  //   'Content-Type': 'application/json',

  // };

  // try {
  //   // Gửi yêu cầu POST
  //   http.Response response = await http.post(
  //     Uri.parse('https://192.168.1.14:7257/api/User/login'),
  //     headers: headers,
  //     body: json.encode(data),
  //   );

  //   // Xác định xem yêu cầu có thành công hay không
  //   if (response.statusCode == 200) {
  //     // Yêu cầu thành công, xử lý dữ liệu phản hồi ở đây
  //     print('Login successful');
  //   } else {
  //     // Yêu cầu không thành công, xử lý lỗi ở đây
  //     print('Login failed with status code: ${response.statusCode}');
  //     print('Error message: ${response.body}');
  //   }
  // } catch (error) {
  //   // Xử lý lỗi nếu có
  //   print('Error while sending POST request: $error');
  // }
    hideKeyboard(context);
    showLoading();
    final  getUserData = await Provider.of<UserProvider>(context, listen: false)
        .getDataUserProfile(username, pass);
        print("test");
        print(getUserData );
   
    if (getUserData == "success" ) {
         SharedPreferences prefs = await SharedPreferences.getInstance();
   String? token = prefs.getString('jwt');
      print(token);
     print(Provider.of<UserProvider>(context, listen: false).loggedInUser.displayName);
      hideLoading();
      Navigator.pushReplacementNamed(
          context, RouteName.create,
          arguments: false);
    } else {
      if (context.mounted) {
        hideLoading();
        AppFuntion.showDialogError(context,getUserData,onPressButton: () {Navigator.of(context, rootNavigator: true).pop();
  
          
        },
            textButton: "Đăng nhập lại", title: "Thông báo lỗi",description: "Vui lòng nhập lại tên và mật khẩu");
      }
    }
  }

  bool _isLoading = false;
  Timer? timerLoading;

  showLoading() {
    if (timerLoading != null) timerLoading?.cancel();
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
    }

    timerLoading = Timer(const Duration(seconds: 30), hideLoading);
  }

  hideLoading() {
    if (timerLoading != null) timerLoading?.cancel();
    if (_isLoading) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  static void hideKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
//   Future<void> login() async {
//       final apiUrl = 'https://192.168.1.14:7257/api/User/login';
//     // 'http://103.226.249.65:8081/api/AppService';
  
//     final requestBody = {
//        "username": "vietphapadmin",
//     "password": "IKQYTX2u\$BGv"
//       // "sid": null,
//       // "cmd": "API_DanhSachKhachHang_Select",
//       // "data": {
//       //   "benhnhan": {
//       //     "TuNgay": "$timeStart",
//       //     "DenNgay": "$timeEnd",
//       //     "MaCoSo": "$place"
//       //   }
//       // }
//     };

//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode(requestBody),
//       );

//       if (response.statusCode == 200) {
//         print(response);}
//   }
//   catch (e) {
//       print('Lỗi kết nối: $e');
//     }
// }
}
  //  SharedPreferences prefs = await SharedPreferences.getInstance();
  //     token = prefs.getString('jwt');