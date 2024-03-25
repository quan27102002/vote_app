import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vote_app/provider/userProvider.dart';
import 'package:vote_app/router/router_name.dart';


class EndScreen extends StatefulWidget {
  const EndScreen({super.key});

  @override
  State<EndScreen> createState() => _EndScreenState();
}

class _EndScreenState extends State<EndScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
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
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: const Center(
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
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Đăng xuất'),
              onTap: ()  {
               Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteName.login,
                  (Route<dynamic> route) => false,
                );
                Provider.of<UserProvider>(context, listen: false)
                    .logout();
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 100,
            color: const Color.fromRGBO(244, 244, 244, 1),
          ),
          Container(
            padding: const EdgeInsets.only(top: 20),
            color: const Color.fromRGBO(244, 244, 244, 1),
            child: const Center(
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
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Đã tham gia đánh giá trải nghiệm dịch vụ của chúng tôi!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),textAlign:TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ),
          Image.asset("assets/images/end.jpg"),
          const SizedBox(height: 20,),
            SizedBox(
                        height: 50,
                        width: 200,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(47, 179, 178, 1) // Màu của nút
                              ),
                          onPressed: () {
                           
                  Navigator.pushNamedAndRemoveUntil(context, RouteName.intro,(Route<dynamic> route) => false,);
                          },
                          child: const Text(
                            "Quay về",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
        ],
      ),
    );
  }
}
