
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vote_app/router/router_name.dart';
import 'package:vote_app/theme/spacing.dart';





class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _check=false;
    late bool rememberToken=false;
  bool _isObscure3 = true;
  bool visible = false;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
final pb = PocketBase('http://127.0.0.1:8090');
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          
          children: <Widget>[
          //  Container(
          //   width:MediaQuery.of(context).size.width,
          //   color:Color.fromRGBO(47, 179, 178, 0.5),
          //   child: Image.asset('assets/images/logovietphap.png')
          //   ),
            Container(

              color: Color.fromRGBO(47, 179, 178, 0.5),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*1,
              child: Center(
                child: Container(
                  margin: EdgeInsets.all(12),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Đăng nhập",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 40,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(child:Text("Email của người dùng",style:TextStyle(fontFamily: 'SF Pro Rounded',color: Color(0xFF848496),
      fontSize: 14,fontWeight: FontWeight.w400,))),
                        Spacing.h12,
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Email',
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
                              return "Email cannot be empty";
                            }
                            if (!RegExp(
                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(value)) {
                              return ("Please enter a valid email");
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            emailController.text = value!;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                           SizedBox(child:Text("Mật khẩu của người dùng",style:TextStyle(fontFamily: 'SF Pro Rounded',color: Color(0xFF848496),
      fontSize: 14,fontWeight: FontWeight.w400,))),
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
                       
           Row(
           mainAxisAlignment: MainAxisAlignment.end,
             children: [Text("Nhớ đăng nhập",style:TextStyle(fontWeight:FontWeight.w600,color:const Color.fromARGB(255, 255, 255, 255))),
               IconButton(
                icon: Icon(
                  _check ? Icons.check_box : Icons.check_box_outline_blank,
                  size: 30.0,
                  color: const Color.fromARGB(255, 248, 250, 248),
                ),
                onPressed: () {
                  setState(() {
                    _check = !_check;
                    if (_check) {
                       rememberToken=true;
                    
                      
                    } else {
               
                      
                     
                      rememberToken=false;
                    }
                  });
                 }),
             ],
           ),
                       
                        SizedBox(
                          height: 20,
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          elevation: 5.0,
                          height: 40,
                          onPressed: () async {                          final authData = await pb.collection('users').authWithPassword(
  emailController.text,passwordController.text
,
); 
                           Navigator.pushNamed(context,'/emotion');
                         

 saveToken(pb.authStore.token);
print(pb.authStore.isValid);
print(pb.authStore.token);
print(pb.authStore.model.id);
checkTokenIsExpired(pb.authStore.model.id);
//  createEmail(emailController.text, passwordController.text);
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            visible: visible,
                            child: Container(
                                child: CircularProgressIndicator(
                              color: Colors.white,
                            ))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void showErrorDialog(String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Login Error"),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OK"),
          ),
        ],
      );
    },
  );
}



Future<void> createEmail(String email,String password) async {

  final body = <String, dynamic>{

  "email": email,
  "password": password,
  "username": "test_username",
  "emailVisibility": true,
  "passwordConfirm": "12345678",
  "name": "test"
};  
final record = await pb.collection('users').create(body: body);
await pb.collection('users').requestVerification(email);
}
Future<void> saveToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('userToken', token);
  print("lưu thành công"+ token);
}
Future<void> deleteToken() async {
 SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('userToken');
 
}
Future<bool?> checkTokenIsExpired(String id)async{
final record = await pb.collection('users').getOne(id,
  
);

 print(record.data['role']);
 if(record==1){
  Navigator.pushNamed(context, RouteName.admin);
 }
}

}

