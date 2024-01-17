// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:database/database.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:vote_app/widget/emotion/Comment.dart';

class EmotionScreen extends StatefulWidget {
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
          backgroundColor: Color.fromRGBO(73, 227, 227, 0.8),
          title: const Center(
            child: Text(
              'Mời bạn đánh giá chất lượng dịch vụ',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Column(children: [
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                  onTap: () {
                    setState(() {
                      isTapped1 = !isTapped1;
                      isTapped2 = false;
                      isTapped3 = false;
                      isTapped4 = false;
                      isTapped5 = false;
                      if (isTapped1) {
                        selectedEmotion = 0;
                        selectCmt = [false, false, false, false];
                        cmt = [];
                      } else {
                        selectedEmotion = -1;
                      }
                      print(selectedComment);
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(
                            0.0), // Loại bỏ khoảng trắng xung quanh Icon
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isTapped1
                              ? Color.fromARGB(255, 202, 55,
                                  19) // Màu đỏ đậm khi được chạm vào
                              : Colors.grey, // Màu xám khi không được chạm vào
                        ),
                        child: Icon(
                          FontAwesomeIcons.faceAngry,
                          size: 80, // Độ lớn của Icon
                          color: Colors.white, // Màu trắng cho Icon
                        ),
                      ),
                      Text(
                        "Rất tệ",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      )
                    ],
                  )),
              InkWell(
                  onTap: () {
                    setState(() {
                      isTapped2 = !isTapped2;
                      isTapped1 = false;
                      isTapped3 = false;
                      isTapped4 = false;
                      isTapped5 = false;
                      if (isTapped2) {
                        selectedEmotion = 1;
                        selectCmt = [false, false, false, false];
                        cmt = [];
                      }
                      if (!isTapped2) {
                        selectedEmotion = -1;
                      }
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(
                            0.0), // Loại bỏ khoảng trắng xung quanh Icon
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isTapped2
                              ? const Color.fromARGB(255, 241, 244,
                                  54) // Màu vàng đậm khi được chạm vào
                              : Colors.grey, // Màu xám khi không được chạm vào
                        ),
                        child: Icon(
                          FontAwesomeIcons.faceFrown,
                          size: 80, // Độ lớn của Icon
                          color: Colors.white, // Màu trắng cho Icon
                        ),
                      ),
                      Text(
                        "Tệ",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      )
                    ],
                  )),
              InkWell(
                  onTap: () {
                    setState(() {
                      isTapped3 = !isTapped3;
                      isTapped2 = false;
                      isTapped1 = false;
                      isTapped4 = false;
                      isTapped5 = false;
                      if (isTapped3) {
                        selectedEmotion = 2;
                        selectCmt = [false, false, false, false];
                        cmt = [];
                      } else {
                        selectedEmotion = -1;
                      }
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(
                            0.0), // Loại bỏ khoảng trắng xung quanh Icon
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isTapped3
                              ? Color.fromARGB(255, 108, 221,
                                  80) // Màu xanh lá cây đậm khi được chạm vào
                              : Colors.grey, // Màu xám khi không được chạm vào
                        ),
                        child: Icon(
                          FontAwesomeIcons.faceFrownOpen,
                          size: 80, // Độ lớn của Icon
                          color: Colors.white, // Màu trắng cho Icon
                        ),
                      ),
                      Text(
                        "Bình thường",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      )
                    ],
                  )),
              InkWell(
                  onTap: () {
                    setState(() {
                      isTapped4 = !isTapped4;
                      isTapped2 = false;
                      isTapped3 = false;
                      isTapped1 = false;
                      isTapped5 = false;
                      if (isTapped4) {
                        selectedEmotion = 3;
                        cmt = [];
                        selectCmt = [false, false, false, false];
                      } else {
                        selectedEmotion = -1;
                      }
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(
                            0.0), // Loại bỏ khoảng trắng xung quanh Icon
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isTapped4
                              ? Color.fromARGB(255, 13, 172,
                                  13) // Màu xanh lá cây đậm khi được chạm vào
                              : Colors.grey, // Màu xám khi không được chạm vào
                        ),
                        child: Icon(
                          FontAwesomeIcons.faceGrinSquint,
                          size: 80, // Độ lớn của Icon
                          color: Colors.white, // Màu trắng cho Icon
                        ),
                      ),
                      Text(
                        "Tốt",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      )
                    ],
                  )),
              InkWell(
                  onTap: () {
                    setState(() {
                      isTapped5 = !isTapped5;
                      isTapped2 = false;
                      isTapped3 = false;
                      isTapped4 = false;
                      isTapped1 = false;
                      if (isTapped5) {
                        selectedEmotion = 4;
                        selectCmt = [false, false, false, false];
                        cmt = [];
                      } else {
                        selectedEmotion = -1;
                      }
                      print(selectedComment);
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(
                            0.0), // Loại bỏ khoảng trắng xung quanh Icon
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isTapped5
                              ? Color.fromARGB(207, 228, 8,
                                  99) // Màu đỏ đậm khi được chạm vào
                              : Colors.grey, // Màu xám khi không được chạm vào
                        ),
                        child: Icon(
                          FontAwesomeIcons.faceGrinHearts,
                          size: 80, // Độ lớn của Icon
                          color: Colors.white, // Màu trắng cho Icon
                        ),
                      ),
                      Text(
                        "Hoàn hảo",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      )
                    ],
                  )),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Comment(
            selectedEmotion: selectedEmotion,
            selec: selectCmt,
            resetCmt: cmt,
          ),
        ]),
      ),
    );
  }
}
