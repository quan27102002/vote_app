import 'package:flutter/material.dart';
import 'package:vote_app/screen/logout_screen.dart';

class EndScreen extends StatelessWidget {
  const EndScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết các đánh giá'),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_right),
            onPressed: () {
              // Gọi hàm exportToChart khi người dùng nhấn nút refresh
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LogoutScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Text("cám ơn"),
    );
  }
}
