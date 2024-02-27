import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vote_app/provider/userProvider.dart';
import 'package:vote_app/router/router_name.dart';
import 'package:vote_app/screen/logout_screen.dart';

class EndScreen extends StatelessWidget {
  const EndScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
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
                  Text(
                    "Đã tham gia đánh giá trải nghiệm dịch vụ của chúng tôi!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
          ),
          Image.asset("assets/images/end.jpg"),
          SizedBox(
            width: width * 0.3,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color.fromRGBO(47, 179, 178, 1) // Màu của nút
                  ),
              onPressed: () async {
                Navigator.pushNamed(context, RouteName.intro);
              },
              child: Text(
                "Thoát",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            width: width * 0.3,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color.fromRGBO(47, 179, 178, 1) // Màu của nút
                  ),
              onPressed: () async {
               SharedPreferences prefs = await SharedPreferences.getInstance();
                 await Provider.of<UserProvider>(context, listen: false).logout();
                 await prefs.remove('jwt'); 
               Navigator.pushNamedAndRemoveUntil(context, RouteName.login,(Route<dynamic> route) => false,);
              },
              child: Text(
                "Đăng xuất",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
