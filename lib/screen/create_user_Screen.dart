import 'dart:async';

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
import 'package:vote_app/theme/spacing.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({super.key});

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  String? _selectedOption;

  final Map<int, String> options = {
    2: 'Quản lý cơ sở',
    3: 'Khách hàng',
  };
  bool _isObscure3 = true;

  bool visible = false;

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _branchController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _branchCodeController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Điều khiển',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
              ListTile(
              leading: Icon(Icons.person),
              title: Text('Xem các tài khoản'),
              onTap: () {
                // Add your logic here for Button 1
                Navigator.pushReplacementNamed(context, RouteName.readuser,
                    arguments: false);
              },
            ),
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text('Tạo tài khoản'),
              onTap: () {
                // Add your logic here for Button 1
                Navigator.pushReplacementNamed(context, RouteName.create,
                    arguments: false);
              },
            ),
            ListTile(
              leading: Icon(Icons.insert_chart),
              title: Text('Xem biểu đồ thống kê'),
              onTap: () {
                // Add your logic here for Button 2
                Navigator.pushReplacementNamed(context, RouteName.chart,
                    arguments: false);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Chỉnh sửa comment'),
              onTap: () {
                // Add your logic here for Button 2
                Navigator.pushReplacementNamed(context, RouteName.editComment,
                    arguments: false);
              },
            ),
            ListTile(
              leading: Icon(Icons.file_download),
              title: Text('Xuất file excel'),
              onTap: () {
                // Add your logic here for Button 3
                Navigator.pushNamed(context, RouteName.excel);
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Đăng xuất'),
              onTap: () async {
                // Add your logic here for Button 4
                Navigator.pushNamed(context, RouteName.login);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove("jwt");
                Provider.of<UserProvider>(context, listen: false).logout();
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 150),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 260,
                    child: Image.asset(
                      "assets/images/logovietphap.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                  Container(
                    height: 300,
                    child: Image.asset(
                      "assets/images/logo_uc.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                Text(
                  "Tạo tài khoản ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(47, 179, 178, 1),
                    fontSize: 25,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Tên ",
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
                    controller: _nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                 
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
                      _nameController.text = value!;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Email ",
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
                    controller: _emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                  
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
                        return "Email cannot be empty";
                      }
                      if (!regex.hasMatch(value)) {
                        return ("please enter valid Email min. 6 character");
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _emailController.text = value!;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                 SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Tên cơ sở ",
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
                    controller: _branchController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                   
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
                        return "Email cannot be empty";
                      }
                      if (!regex.hasMatch(value)) {
                        return ("please enter valid Email min. 6 character");
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _branchController.text = value!;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                 SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Mã cơ sở ",
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
                    controller: _branchCodeController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                    
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
                        return "Email cannot be empty";
                      }
                      if (!regex.hasMatch(value)) {
                        return ("please enter valid Email min. 6 character");
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _branchCodeController.text = value!;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                 SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Loại tài khoản",
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
                  child: DropdownButtonFormField<String>(
                    value: _selectedOption,
                    items: options.keys.map((int key) {
                      return DropdownMenuItem<String>(
                        value: key.toString(),
                        child: Text(options[key]!),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedOption = value;
                        print(value);
                      });
                    },
                    decoration: InputDecoration(
                  
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      enabledBorder: InputBorder.none,
                    ),
                    dropdownColor: Colors.white,
                  ),
                ),
                 SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Mật khẩu của người dùng",
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
                    controller: _passwordController,
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
                      _passwordController.text = value!;
                    },
                    keyboardType: TextInputType.visiblePassword,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     CreateUser(
                //         _nameController.text,
                //         _emailController.text,
                //         _branchController.text,
                //         _branchCodeController.text,
                //         _passwordController.text,
                //         int.parse(_selectedOption!));
                //   },
                //   child: Text(
                //     "Tạo tài khoản",
                //     style: TextStyle(
                //       fontSize: 20,
                //     ),
                //   ),
                // ),
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
                    CreateUser(
                        _nameController.text,
                        _emailController.text,
                        _branchController.text,
                        _branchCodeController.text,
                        _passwordController.text,
                        int.parse(_selectedOption!));
                  },
                  child: Text(
                    "Tạo tài khoản",
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
      ),
    );
  }

  Future<void> CreateUser(String name, String email, String place,
      String branchCode, String pass, int role) async {
    // showLoading();
    ApiResponse res = await ApiRequest.userRegister(
        name, email, place, branchCode, pass, role);
    print(res);
    if (res.data == true) {
      AppFuntion.showDialogError(context, "", onPressButton: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
          textButton: "OK",
          title: "Thông báo",
          description: "Tạo tài khoản thành công");
    } else {
      AppFuntion.showDialogError(context, "", onPressButton: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
          textButton: "Nhập lại thông tin",
          title: "Thông báo lỗi",
          description: "Tạo tài khoản thất bại,nhập lại các thông tin");
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
}
