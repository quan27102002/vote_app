import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vote_app/api/api_base/api_response.dart';
import 'package:vote_app/api/api_request.dart';
import 'package:vote_app/model/comment.dart';

class EditCommentScreen extends StatefulWidget {
  const EditCommentScreen({super.key});

  @override
  State<EditCommentScreen> createState() => _EditCommentScreenState();
}

class _EditCommentScreenState extends State<EditCommentScreen> {
  List<ListComment> listComment = [];

  TextEditingController comment1 = TextEditingController();
  TextEditingController comment2 = TextEditingController();
  TextEditingController comment3 = TextEditingController();
  int selectedEmotion = -1;
  bool isTapped0 = false;
  bool isTapped1 = false;
  bool isTapped2 = false;
  bool isTapped3 = false;
  bool isTapped4 = false;
  bool isComment1 = false;
  bool isComment2 = false;
  bool isComment3 = false;
  List<Map> selectedOptions = [];
  List<Map<String, dynamic>> commentData = [];
  String status = "";
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
                                      onTap: () {},
                                      child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(16.0),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 8.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: TextField(
                                          decoration:
                                              new InputDecoration.collapsed(
                                                  hintText: listComment[
                                                              selectedEmotion]
                                                          .comments?[0]
                                                          .content ??
                                                      ""),
                                          controller: comment1,
                                          // autofillHints:
                                          //     listComment[selectedEmotion]
                                          //             .comments![0]
                                          //             .content ??
                                          //         "",
                                          style: TextStyle(
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(16.0),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 8.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: TextField(
                                          decoration:
                                              new InputDecoration.collapsed(
                                                  hintText: listComment[
                                                              selectedEmotion]
                                                          .comments?[1]
                                                          .content ??
                                                      ""),

                                          controller: comment2,

                                          // listComment[selectedEmotion]
                                          //         .comments![1]
                                          //         .content ??
                                          //     "",
                                          style: TextStyle(
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(16.0),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 8.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: TextField(
                                          decoration:
                                              new InputDecoration.collapsed(
                                                  hintText: listComment[
                                                              selectedEmotion]
                                                          .comments?[2]
                                                          .content ??
                                                      ""),

                                          controller: comment3,
                                          // listComment[selectedEmotion]
                                          //         .comments?[2]
                                          //         .content ??
                                          // "",
                                          style: TextStyle(
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        setState(() {
                                          commentData = [
                                            {
                                              "id": listComment[selectedEmotion]
                                                  .comments?[0]
                                                  .id,
                                              "content": comment1.text,
                                            },
                                            {
                                              "id": listComment[selectedEmotion]
                                                  .comments?[1]
                                                  .id,
                                              "content": comment2.text
                                            },
                                            {
                                              "id": listComment[selectedEmotion]
                                                  .comments?[2]
                                                  .id,
                                              "content": comment3.text
                                            }
                                          ];
                                        });

                                        ApiResponse res =
                                            await ApiRequest.editComment(
                                          selectedEmotion,
                                          commentData,
                                        );
                                        if (res.code == 200) {
                                          print("ok");
                                        }
                                      },
                                      child: Text('Edit'),
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
