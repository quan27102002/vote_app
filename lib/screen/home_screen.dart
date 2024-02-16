import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vote_app/api/api_base/api_response.dart';
import 'package:vote_app/api/api_request.dart';
import 'package:vote_app/model/comment.dart';
import 'package:vote_app/widget/emotion/comment.dart';
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
                      isTapped0 = !isTapped0;
                      resetCommentSelections();
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
                    onTap: () {
                      isTapped1 = !isTapped1;
                      resetCommentSelections();
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
                    onTap: () {
                      isTapped2 = !isTapped2;
                      resetCommentSelections();
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
                    onTap: () {
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
                    onTap: () {
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
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                                          var id1 = listComment[selectedEmotion]
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
                                        padding: EdgeInsets.all(16.0),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 8.0),
                                        decoration: BoxDecoration(
                                          color: isComment1
                                              ? Colors.blue
                                              : Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(8.0),
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
                                          var id2 = listComment[selectedEmotion]
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
                                        padding: EdgeInsets.all(16.0),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 8.0),
                                        decoration: BoxDecoration(
                                          color: isComment2
                                              ? Colors.blue
                                              : Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(8.0),
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
                                          var id3 = listComment[selectedEmotion]
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
                                        padding: EdgeInsets.all(16.0),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 8.0),
                                        decoration: BoxDecoration(
                                          color: isComment3
                                              ? Colors.blue
                                              : Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(8.0),
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
                                    TextField(
                                      controller: commentDifferen,
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        print(selectedOptions);
                                        print(status);
                                        print(commentDifferen.text);
                                        setState(() {
                                          if (selectedOptions.isNotEmpty ==
                                                  true &&
                                              commentDifferen.text.isEmpty ==
                                                  true) {
                                            commentType = 0;
                                          }
                                          if (selectedOptions.isEmpty == true &&
                                              commentDifferen.text.isNotEmpty ==
                                                  true) {
                                            commentType = 1;
                                          }
                                          if (selectedOptions.isNotEmpty ==
                                                  true &&
                                              commentDifferen.text.isNotEmpty ==
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
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) => EndScreen(),
                                            ),
                                          );
                                          print("ok");
                                        }
                                      },
                                      child: Text('Hoàn thành đánh giá'),
                                    )
                                  ],
                                ),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
