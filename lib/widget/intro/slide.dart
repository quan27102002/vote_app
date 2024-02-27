import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vote_app/provider/comment.dart';
import 'package:vote_app/provider/image_provider.dart';
import 'package:vote_app/provider/userProvider.dart';
import 'package:vote_app/router/router_name.dart';

class Slide extends StatefulWidget {
  const Slide({Key? key}) : super(key: key);

  @override
  State<Slide> createState() => _SlideState();
}

class _SlideState extends State<Slide> {
  final PageController _pageController = PageController();
  List<dynamic> _images = [];
  int _currentPage = 0;
  // final List<String> _images = [
  //   'assets/images/1.jpg',
  //   'assets/images/2.jpg',
  //   'assets/images/3.jpg',
  //   'assets/images/4.jpg',
  //   'assets/images/5.jpg',
  //   'assets/images/6.jpg',
  //   'assets/images/7.jpg',
  //   'assets/images/8.jpg',
  // ];

  late Timer _timer;
  initData() async {
    var image = Provider.of<ImagesProvider>(context, listen: false);
    await image.getApi();
    _images = image.listImage;
    setState(() {});
    print(_images);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < _images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  void _navigateToEmotionScreen() {
    Navigator.pushReplacementNamed(
      context,
      '/idbillcustomer',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ImagesProvider>(builder: (context, image, child) {
      return Scaffold(
        drawer: Drawer(
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
                // Add your logic here for Button 4
          
                  SharedPreferences prefs = await SharedPreferences.getInstance();
             await   Provider.of<UserProvider>(context, listen: false).logout();
                 await prefs.remove('jwt'); 
               Navigator.pushNamedAndRemoveUntil(context, RouteName.login,(Route<dynamic> route) => false,);
              },
            ),
          ],
        ),
      ),
        // backgroundColor: const Color.fromRGBO(47, 179, 178, 1),
        body: Stack(
          children: [
            Positioned.fill(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _images.length,
                itemBuilder: (context, index) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        image.listImage[index],
                        fit: BoxFit.cover,
                      ),
                      Container(
                        color: Color.fromARGB(255, 108, 113, 113)
                            .withOpacity(0.3), // Màu mờ (đen với độ mờ 0.5)
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height:
                                    400, // Điều chỉnh kích thước của hình ảnh
                              ),
                              const SizedBox(height: 30),
                              const Text(
                                'Công nghệ đi đầu – Cam kết bền lâu',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Colors.white, // Màu văn bản trên màu mờ
                                ),
                              ),
                              // const SizedBox(height: 20),

                              SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                onPressed: _navigateToEmotionScreen,
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  padding: const EdgeInsets.all(20),
                                  backgroundColor:
                                      const Color.fromRGBO(47, 179, 178, 1),
                                ),
                                child: const Text(
                                  'Bắt đầu đánh giá',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
