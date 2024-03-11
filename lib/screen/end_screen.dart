import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vote_app/provider/userProvider.dart';
import 'package:vote_app/router/router_name.dart';
import 'package:vote_app/screen/logout_screen.dart';

class EndScreen extends StatefulWidget {
  const EndScreen({super.key});

  @override
  State<EndScreen> createState() => _EndScreenState();
}

class _EndScreenState extends State<EndScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, RouteName.intro);
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(
                child: Text(
                  'Điều khiển',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Đăng xuất'),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await Provider.of<UserProvider>(context, listen: false)
                    .logout();
                await prefs.remove('jwt');
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteName.login,
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 100,
            color: Color.fromRGBO(244, 244, 244, 1),
          ),
          Container(
            padding: EdgeInsets.only(top: 20),
            color: Color.fromRGBO(244, 244, 244, 1),
            child: Center(
              child: Column(
                children: [
                  Text(
                    "CẢM ƠN QUÝ KHÁCH",
                    style: TextStyle(
                        fontSize: 40,
                        color: Color.fromRGBO(47, 179, 178, 1),
                        fontWeight: FontWeight.bold // Màu của nút
                        ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Đã tham gia đánh giá trải nghiệm dịch vụ của chúng tôi!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Image.asset("assets/images/end.jpg"),
        ],
      ),
    );
  }
}
