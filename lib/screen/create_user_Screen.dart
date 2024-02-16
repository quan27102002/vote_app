import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:vote_app/api/api_base/api_response.dart';
import 'package:vote_app/api/api_request.dart';
import 'package:vote_app/dialog/funtion.dart';
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
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(47, 179, 178, 1),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(children: [
            Text(
              "Tạo tài khoản ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
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
                      color: Color(0xFF848496),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    )),
              ],
            ),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Tên ',
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
                _nameController.text = value!;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Email ",
                    style: TextStyle(
                      fontFamily: 'SF Pro Rounded',
                      color: Color(0xFF848496),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    )),
              ],
            ),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Email ',
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
                  return "Email cannot be empty";
                }
                if (!regex.hasMatch(value)) {
                  return ("please enter valid Email min. 6 character");
                } else {
                  return null;
                }
              },
              onSaved: (value) {
                _nameController.text = value!;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Mã cơ sở ",
                    style: TextStyle(
                      fontFamily: 'SF Pro Rounded',
                      color: Color(0xFF848496),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    )),
              ],
            ),
            TextFormField(
              controller: _branchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Mã cơ sở ',
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
                  return "Email cannot be empty";
                }
                if (!regex.hasMatch(value)) {
                  return ("please enter valid Email min. 6 character");
                } else {
                  return null;
                }
              },
              onSaved: (value) {
                _nameController.text = value!;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Loại tài khoản",
                    style: TextStyle(
                      fontFamily: 'SF Pro Rounded',
                      color: Color(0xFF848496),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    )),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
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
                  hintText: "Chọn loại tài khoản",
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  enabledBorder: InputBorder.none,
                ),
                dropdownColor: Colors.white,
              ),
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
              controller: _passwordController,
              obscureText: _isObscure3,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: Icon(
                        _isObscure3 ? Icons.visibility : Icons.visibility_off),
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
                _passwordController.text = value!;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                CreateUser(
                    _nameController.text,
                    _emailController.text,
                    _branchController.text,
                    _passwordController.text,
                    int.parse(_selectedOption!));
              },
              child: Text(
                "Tạo tài khoản",
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

  Future<void> CreateUser(
      String name, String email, String place, String pass, int role) async {
    // showLoading();
    ApiResponse res =
        await ApiRequest.userRegister(name, email, place, pass, role);
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
