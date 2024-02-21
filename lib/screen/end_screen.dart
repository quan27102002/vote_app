import 'package:flutter/material.dart';
import 'package:vote_app/screen/logout_screen.dart';

class EndScreen extends StatelessWidget {
  const EndScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Chi tiết các đánh giá'),
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.arrow_right),
      //       onPressed: () {
      //         // Gọi hàm exportToChart khi người dùng nhấn nút refresh
      //         Navigator.of(context).pushReplacement(
      //           MaterialPageRoute(
      //             builder: (context) => LogoutScreen(),
      //           ),
      //         );
      //       },
      //     ),
      //   ],
      // ),
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
          Image.asset("assets/images/end.jpg")
        ],
      ),
    );
  }
}
