import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EmotionScreen extends StatefulWidget {
  const EmotionScreen({super.key});

  @override
  _EmotionScreenState createState() => _EmotionScreenState();
}

class _EmotionScreenState extends State<EmotionScreen> {
  List selectCmt = [false, false, false, false];
  List cmt = [];
  bool isTapped1 = false;
  bool isTapped2 = false;
  bool isTapped3 = false;
  bool isTapped4 = false;
  bool isTapped5 = false;
  int selectedEmotion = -1;
  String selectedComment = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(47, 179, 178, 1),
          title: const Center(
            child: Text(
              'Mời bạn đánh giá chất lượng dịch vụ',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(top: 50),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isSelected = !isSelected;
                      });
                    },
                    child: Column(
                      children: [
                        Icon(
                          FontAwesomeIcons.faceAngry,
                          size:
                              50, // Đặt kích thước của biểu tượng theo mong muốn
                        ),
                        SizedBox(height: 8), // Khoảng cách giữa Icon và Text
                        Text(
                          'Rất Tệ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {},
                    child: Column(
                      children: [
                        Icon(
                          FontAwesomeIcons.faceFrown,
                          size:
                              50, // Đặt kích thước của biểu tượng theo mong muốn
                        ),
                        SizedBox(height: 8), // Khoảng cách giữa Icon và Text
                        Text(
                          'Tệ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {},
                    child: Column(
                      children: [
                        Icon(
                          FontAwesomeIcons.faceFrownOpen,
                          size:
                              50, // Đặt kích thước của biểu tượng theo mong muốn
                        ),
                        SizedBox(height: 8), // Khoảng cách giữa Icon và Text
                        Text(
                          'Bình thường',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {},
                    child: Column(
                      children: [
                        Icon(
                          FontAwesomeIcons.faceGrinSquint,
                          size:
                              50, // Đặt kích thước của biểu tượng theo mong muốn
                        ),
                        SizedBox(height: 8), // Khoảng cách giữa Icon và Text
                        Text(
                          'Tốt',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {},
                    child: Column(
                      children: [
                        Icon(
                          FontAwesomeIcons.faceGrinHearts,
                          size:
                              50, // Đặt kích thước của biểu tượng theo mong muốn
                        ),
                        SizedBox(height: 8), // Khoảng cách giữa Icon và Text
                        Text(
                          'Hoàn hảo',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (selectedEmotion != -1)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.grey, // Màu của Container
                padding: EdgeInsets.all(16),
                child: Text(
                  'Bạn đã chọn: $selectedComment',
                  style: TextStyle(
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
