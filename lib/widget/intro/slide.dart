import 'dart:async';
import 'package:flutter/material.dart';

class Slide extends StatefulWidget {
  const Slide({Key? key}) : super(key: key);

  @override
  State<Slide> createState() => _SlideState();
}

class _SlideState extends State<Slide> {
  int _currentPage = 0;
  final List<String> _images = [
    'assets/images/anh1.jpg',
    'assets/images/anh2.jpg',
    'assets/images/anh3.JPG',
    'assets/images/anh4.jpg',
    'assets/images/anh5.JPG',
  ];

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        if (_currentPage < _images.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
      });
    });
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  void _stopTimer() {
    _timer.cancel();
  }

  void _navigateToEmotionScreen() {
    Navigator.pushReplacementNamed(
      context,
      '/idbillcustomer',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromRGBO(47, 179, 178, 1),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              _images[_currentPage],
              fit: BoxFit.cover,
            ),
          ),
          // Positioned(
          //   top: 0,
          //   left: 0,
          //   child: Image.asset("assets/images/logo_uc.png"),
          // ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Color.fromARGB(255, 39, 40, 40)
                  .withOpacity(0.3), // Màu mờ (đen với độ mờ 0.5)
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 400, // Điều chỉnh kích thước của hình ảnh
                    ),
                    const SizedBox(height: 30),

                    Text(
                      "Công nghệ đi đầu",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Cam kết bền lâu",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // const SizedBox(height: 20),

                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: _navigateToEmotionScreen,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: const EdgeInsets.all(5),
                          backgroundColor:
                              const Color.fromRGBO(47, 179, 178, 1),
                        ),
                        child: Text("Bắt đầu",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
