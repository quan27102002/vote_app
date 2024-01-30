import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:vote_app/theme/spacing.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({super.key});

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final pb = PocketBase('http://127.0.0.1:8090');
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _placeController = new TextEditingController();
  TextEditingController _dobController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "Đăng ký tài khoản ",
              style: TextStyle(
                  color: Color.fromARGB(204, 0, 0, 0),
                  fontWeight: FontWeight.w600,
                  fontSize: 28),
            ),
            Spacing.h32,
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Địa chỉ mail',
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
                  return "Email cannot be empty";
                }
                if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                    .hasMatch(value)) {
                  return ("Please enter a valid email");
                } else {
                  return null;
                }
              },
              onSaved: (value) {
                _emailController.text = value!;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            Spacing.h12,
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Họ và tên',
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
                  return "Name cannot be empty";
                }
                if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                    .hasMatch(value)) {
                  return ("Please enter a valid email");
                } else {
                  return null;
                }
              },
              onSaved: (value) {
                _emailController.text = value!;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            Spacing.h12,
            TextFormField(
              controller: _placeController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Chi nhánh',
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
                  return "place cannot be empty";
                }
                if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                    .hasMatch(value)) {
                  return ("Please enter a valid place");
                } else {
                  return null;
                }
              },
              onSaved: (value) {
                _emailController.text = value!;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            Spacing.h12,

            // Row(children: [
            TextFormField(
              controller: _dobController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Ngày tháng năm sinh',
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
                  return "dob cannot be empty";
                }
                if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                    .hasMatch(value)) {
                  return ("Please enter a valid dob");
                } else {
                  return null;
                }
              },
              onSaved: (value) {
                _emailController.text = value!;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            Spacing.h12,
            TextFormField(
              obscureText: true,
              controller: _passwordController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Mật khẩu',
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
                  return "Password cannot be empty";
                }
                if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                    .hasMatch(value)) {
                  return ("Please enter a valid password");
                } else {
                  return null;
                }
              },
              onSaved: (value) {
                _emailController.text = value!;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            Spacing.h12,
            ElevatedButton(
                onPressed: () => postCreateUser(
                    _nameController.text,
                    _emailController.text,
                    _passwordController.text,
                    _placeController.text,
                    _dobController.text),
                child: Text("Đăng ký"))
          ]),
        ),
      ),
    );
  }

  Future<void> postCreateUser(String name, String email, String password,
      String place, String dob) async {
    final body = <String, dynamic>{
      "username": name,
      "email": email,
      "emailVisibility": true,
      "password": password,
      "passwordConfirm": password,
      "name": name,
      "place": place,
      "dob": dob,
      "role": 2
    };

    final record = await pb.collection('users').create(body: body);
    await pb.collection('users').requestVerification(email);
  }
}
