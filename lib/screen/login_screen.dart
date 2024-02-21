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
import 'package:vote_app/screen/intro_screen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    // _checkToken(); // Gọi hàm để kiểm tra token
  }

  Future<void> _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt');
    if (token != null) {
      // Token tồn tại, chuyển hướng tới màn hình tiếp theo
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => IntroScreen(),
        ),
      );
    }
  }

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
      // backgroundColor: Color.fromRGBO(47, 179, 178, 1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 200),
            alignment: Alignment.center,
            child: Column(children: [
              Container(
                  height: 300,
                  child: Image.asset(
                    "assets/images/logo_uc.png",
                    fit: BoxFit.fill,
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Tên đăng nhập",
                      style: TextStyle(
                        fontFamily: 'SF Pro Rounded',
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(47, 179, 178, 1),
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    // hintText: 'Username',
                    enabled: true,
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 8.0, top: 8.0),
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
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Mật khẩu",
                      style: TextStyle(
                        fontFamily: 'SF Pro Rounded',
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      )),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(47, 179, 178, 1),
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: _isObscure3,
                  decoration: InputDecoration(
                    border: InputBorder.none,
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
                    // hintText: 'Password',
                    enabled: true,
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 8.0, top: 15.0),
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
              ),
              Spacing.h32,
              SizedBox(
                height: 50,
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color.fromRGBO(47, 179, 178, 1) // Màu của nút
                      ),
                  onPressed: () {
                    // login();
                    logIn(usernameController.text, passwordController.text);
                  },
                  child: Text(
                    "Đăng nhập",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }

  Future<void> logIn(String username, String pass) async {
    hideKeyboard(context);
    showLoading();
    final getUserData = await Provider.of<UserProvider>(context, listen: false)
        .getDataUserProfile(username, pass);
    print("test");
    print(getUserData);

    if (getUserData == "success") {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt');
      int? role = prefs.getInt('role');
      print(token);
      print(Provider.of<UserProvider>(context, listen: false)
          .loggedInUser
          .displayName);
      hideLoading();
      if (role == 1) {
        Navigator.pushReplacementNamed(context, RouteName.create,
            arguments: false);
      } else if (role == 2) {
        Navigator.pushReplacementNamed(context, RouteName.chart,
            arguments: false);
      } else {
        Navigator.pushReplacementNamed(context, RouteName.intro,
            arguments: false);
      }
    } else {
      if (context.mounted) {
        hideLoading();
        AppFuntion.showDialogError(context, getUserData, onPressButton: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
            textButton: "Đăng nhập lại",
            title: "Thông báo lỗi",
            description: "Vui lòng nhập lại tên và mật khẩu");
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
}
  //  SharedPreferences prefs = await SharedPreferences.getInstance();
  //     token = prefs.getString('jwt');