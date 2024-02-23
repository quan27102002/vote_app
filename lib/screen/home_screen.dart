import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vote_app/api/api_base/api_response.dart';
import 'package:vote_app/api/api_request.dart';
import 'package:vote_app/model/comment.dart';

import 'package:vote_app/screen/end_screen.dart';

class EmotionScreen extends StatefulWidget {
  final String userBillId;
  // const EmotionScreen({super.key, required this.userBillId});
  const EmotionScreen({Key? key, required this.userBillId}) : super(key: key);

  @override
  _EmotionScreenState createState() => _EmotionScreenState();
}

class _EmotionScreenState extends State<EmotionScreen> {
  List selectCmt = [false, false, false, false];
  List cmt = [];
  bool isTapped0 = false;
  bool isTapped1 = false;
  bool isTapped2 = false;
  bool isTapped3 = false;
  bool isTapped4 = false;
  bool isComment1 = false;
  bool isComment2 = false;
  bool isComment3 = false;
  TextEditingController commentDifferen = TextEditingController();
  int? level;
  int? commentType;

  int selectedEmotion = -1;
  String status = "";
  String selectedComment = '';
  int selectedOption = 0;
  List<Map> selectedOptions = []; // Đổi sang kiểu List<String>
  List<ListComment> listComment = [];

  Future<void> getApi() async {
    listComment.clear();
    ApiResponse res = await ApiRequest.getComment();

    if (res.code == 200) {
      setState(() {
        for (var e in res.data) {
          listComment.add(ListComment.fromJson(e));
        }
      });
      print(listComment);
    } else {
      print(res.message ?? "Lỗi");
    }
  }

  void resetCommentSelections() {
    isComment1 = false;
    isComment2 = false;
    isComment3 = false;
    selectedOptions.clear();
  }

  void resetEmotionSelections() {
    isTapped0 = false;
    isTapped1 = false;
    isTapped2 = false;
    isTapped3 = false;
    isTapped4 = false;
  }

  @override
  void initState() {
    selectedEmotion = -1;
    resetCommentSelections();
    super.initState();
    getApi();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      // appBar: AppBar(
      //     backgroundColor: Color.fromRGBO(47, 179, 178, 1),
      //     title: const Center(
      //       child: Text(
      //         'Mời bạn đánh giá chất lượng dịch vụ',
      //         style: TextStyle(
      //           fontSize: 24,
      //           fontWeight: FontWeight.bold,
      //         ),
      //       ),
      //     )),
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
                      resetEmotionSelections();
                      resetCommentSelections();
                      isTapped0 = !isTapped0;

                      if (isTapped0) {
                        setState(() {
                          selectedEmotion = 0;
                          status = "Rất tệ";
                        });
                      } else {
                        setState(() {
                          selectedEmotion = -1;
                        });
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          decoration: BoxDecoration(
                              color: isTapped0 == true
                                  ? Color.fromRGBO(255, 214, 214, 1)
                                  : Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              )),
                          padding: EdgeInsets.only(bottom: 5),
                          child: Image.asset(
                            "assets/images/icon1.png",
                            width: 100,
                          ),
                        ),
                        // Khoảng cách giữa Icon và Text
                        Container(
                          padding: EdgeInsets.only(bottom: 5),
                          width: 100,
                          decoration: BoxDecoration(
                              color: isTapped0 == true
                                  ? Color.fromRGBO(255, 214, 214, 1)
                                  : Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                          child: Center(
                            child: Text(
                              'Rất Tệ',
                              style: TextStyle(
                                color: Color.fromRGBO(255, 121, 121, 1),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      resetEmotionSelections();
                      resetCommentSelections();
                      isTapped1 = !isTapped1;

                      if (isTapped1) {
                        setState(() {
                          selectedEmotion = 1;
                          status = "Tệ";
                        });
                      } else {
                        setState(() {
                          selectedEmotion = -1;
                        });
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          decoration: BoxDecoration(
                              color: isTapped1 == true
                                  ? Color.fromRGBO(255, 233, 217, 1)
                                  : Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              )),
                          padding: EdgeInsets.only(bottom: 5),
                          child: Image.asset(
                            "assets/images/icon2.png",
                            width: 100,
                          ),
                        ),
                        // Khoảng cách giữa Icon và Text
                        Container(
                          padding: EdgeInsets.only(bottom: 5),
                          width: 100,
                          decoration: BoxDecoration(
                              color: isTapped1 == true
                                  ? Color.fromRGBO(255, 233, 217, 1)
                                  : Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                          child: Center(
                            child: Text(
                              'Tệ',
                              style: TextStyle(
                                color: Color.fromRGBO(252, 149, 74, 1),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      resetEmotionSelections();
                      resetCommentSelections();
                      isTapped2 = !isTapped2;

                      if (isTapped2) {
                        setState(() {
                          selectedEmotion = 2;
                          status = "Bình thường";
                        });
                      } else {
                        setState(() {
                          selectedEmotion = -1;
                        });
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          decoration: BoxDecoration(
                              color: isTapped2 == true
                                  ? Color.fromRGBO(255, 243, 181, 1)
                                  : Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              )),
                          padding: EdgeInsets.only(bottom: 5),
                          child: Image.asset(
                            "assets/images/icon3.png",
                            width: 100,
                          ),
                        ),
                        // Khoảng cách giữa Icon và Text
                        Container(
                          padding: EdgeInsets.only(bottom: 5),
                          width: 100,
                          decoration: BoxDecoration(
                              color: isTapped2 == true
                                  ? Color.fromRGBO(255, 243, 181, 1)
                                  : Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                          child: Center(
                            child: Text(
                              'Bình thường',
                              style: TextStyle(
                                color: Color.fromRGBO(147, 146, 136, 1),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      resetEmotionSelections();
                      resetCommentSelections();
                      isTapped3 = !isTapped3;
                      if (isTapped3) {
                        setState(() {
                          selectedEmotion = 3;
                          status = "Tốt";
                        });
                      } else {
                        setState(() {
                          selectedEmotion = -1;
                        });
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          decoration: BoxDecoration(
                              color: isTapped3 == true
                                  ? Color.fromRGBO(224, 242, 255, 1)
                                  : Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              )),
                          padding: EdgeInsets.only(bottom: 5),
                          child: Image.asset(
                            "assets/images/icon4.png",
                            width: 100,
                          ),
                        ),
                        // Khoảng cách giữa Icon và Text
                        Container(
                          padding: EdgeInsets.only(bottom: 5),
                          width: 100,
                          decoration: BoxDecoration(
                              color: isTapped3 == true
                                  ? Color.fromRGBO(224, 242, 255, 1)
                                  : Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                          child: Center(
                            child: Text(
                              'Tốt',
                              style: TextStyle(
                                color: Color.fromRGBO(98, 189, 255, 1),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      resetEmotionSelections();
                      resetCommentSelections();
                      isTapped4 = !isTapped4;
                      if (isTapped4) {
                        setState(() {
                          selectedEmotion = 4;
                          status = "Hoàn hảo";
                        });
                      } else {
                        setState(() {
                          selectedEmotion = -1;
                        });
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          decoration: BoxDecoration(
                              color: isTapped4 == true
                                  ? Color.fromRGBO(203, 255, 227, 1)
                                  : Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              )),
                          padding: EdgeInsets.only(bottom: 5),
                          child: Image.asset(
                            "assets/images/icon1.png",
                            width: 100,
                          ),
                        ),
                        // Khoảng cách giữa Icon và Text
                        Container(
                          padding: EdgeInsets.only(bottom: 5),
                          width: 100,
                          decoration: BoxDecoration(
                              color: isTapped4 == true
                                  ? Color.fromRGBO(203, 255, 227, 1)
                                  : Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                          child: Center(
                            child: Text(
                              'Hoàn hảo',
                              style: TextStyle(
                                color: Color.fromRGBO(39, 203, 114, 1),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(right: 30, left: 30),
              width: width,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  selectedEmotion == -1
                      ? Container()
                      : Column(
                          children: [
                            listComment[selectedEmotion].comments![0].content ==
                                    ""
                                ? Container()
                                : Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            var value1 =
                                                listComment[selectedEmotion]
                                                    .comments![0]
                                                    .content;
                                            var id1 =
                                                listComment[selectedEmotion]
                                                        .comments?[0]
                                                        .id ??
                                                    "";
                                            isComment1 = !isComment1;
                                            Map map = {
                                              "id": id1,
                                              "content": value1,
                                            };
                                            if (isComment1) {
                                              if (!selectedOptions
                                                  .contains(map)) {
                                                selectedOptions.add(map);
                                              }
                                            } else {
                                              selectedOptions.remove(
                                                  map); // Remove the value if it exists
                                            }
                                          });
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(8.0),
                                          margin: EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color.fromRGBO(
                                                    47, 179, 178, 1)),
                                            color: isComment1
                                                ? Colors.blue
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                          child: Text(
                                            listComment[selectedEmotion]
                                                    .comments![0]
                                                    .content ??
                                                "",
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              color: isComment1
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            var value2 =
                                                listComment[selectedEmotion]
                                                        .comments?[1]
                                                        .content ??
                                                    "";
                                            var id2 =
                                                listComment[selectedEmotion]
                                                        .comments?[1]
                                                        .id ??
                                                    "";
                                            isComment2 = !isComment2;
                                            Map map = {
                                              "id": id2,
                                              "content": value2,
                                            };
                                            if (isComment2) {
                                              if (!selectedOptions
                                                  .contains(map)) {
                                                selectedOptions.add(map);
                                              }
                                            } else {
                                              selectedOptions.remove(
                                                  map); // Remove the value if it exists
                                            }
                                          });
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(8.0),
                                          margin: EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color.fromRGBO(
                                                    47, 179, 178, 1)),
                                            color: isComment2
                                                ? Colors.blue
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Text(
                                            listComment[selectedEmotion]
                                                    .comments![1]
                                                    .content ??
                                                "",
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              color: isComment2
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            var value3 =
                                                listComment[selectedEmotion]
                                                        .comments![2]
                                                        .content ??
                                                    "";
                                            var id3 =
                                                listComment[selectedEmotion]
                                                        .comments?[2]
                                                        .id ??
                                                    "";
                                            isComment3 = !isComment3;
                                            Map map = {
                                              "id": id3,
                                              "content": value3,
                                            };
                                            if (isComment3) {
                                              if (!selectedOptions
                                                  .contains(map)) {
                                                selectedOptions.add(map);
                                              }
                                            } else {
                                              selectedOptions.remove(
                                                  map); // Remove the value if it exists
                                            }
                                          });
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(8.0),
                                          margin: EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color.fromRGBO(
                                                    47, 179, 178, 1)),
                                            color: isComment3
                                                ? Colors.blue
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                          child: Text(
                                            listComment[selectedEmotion]
                                                    .comments?[2]
                                                    .content ??
                                                "",
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              color: isComment3
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.only(left: 8.0),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 8.0),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color.fromRGBO(
                                                  47, 179, 178, 1)),
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                        child: TextField(
                                          controller: commentDifferen,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'Ý kiến khác...',
                                              hintStyle: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.black,
                                              )),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        height: 50,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Color.fromRGBO(
                                                  47,
                                                  179,
                                                  178,
                                                  1) // Màu của nút
                                              ),
                                          onPressed: () async {
                                            setState(() {
                                              if (selectedOptions.isNotEmpty ==
                                                      true &&
                                                  commentDifferen
                                                          .text.isEmpty ==
                                                      true) {
                                                commentType = 0;
                                              }
                                              if (selectedOptions.isEmpty ==
                                                      true &&
                                                  commentDifferen
                                                          .text.isNotEmpty ==
                                                      true) {
                                                commentType = 1;
                                              }
                                              if (selectedOptions.isNotEmpty ==
                                                      true &&
                                                  commentDifferen
                                                          .text.isNotEmpty ==
                                                      true) {
                                                commentType = 2;
                                              }
                                              level = selectedEmotion;
                                            });
                                            final res =
                                                await ApiRequest.uploadComment(
                                              widget.userBillId,
                                              level ?? 0,
                                              commentType ?? 0,
                                              selectedOptions,
                                              commentDifferen.text,
                                            );
                                            if (res.code == 200) {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EndScreen(),
                                                ),
                                              );
                                              print("ok");
                                            }
                                          },
                                          child: Text(
                                            'Hoàn thành đánh giá',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
