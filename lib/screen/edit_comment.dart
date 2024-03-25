import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vote_app/api/api_base/api_response.dart';
import 'package:vote_app/api/api_request.dart';
import 'package:vote_app/dialog/funtion.dart';
import 'package:vote_app/model/comment.dart';
import 'package:vote_app/provider/comment.dart';
import 'package:vote_app/provider/userProvider.dart';
import 'package:vote_app/router/router_name.dart';

import 'package:vote_app/screen/end_screen.dart';
import 'package:vote_app/utils/app_functions.dart';

class EditCommentScreen extends StatefulWidget {
  const EditCommentScreen({Key? key}) : super(key: key);

  @override
  _EditCommentScreenState createState() => _EditCommentScreenState();
}

class _EditCommentScreenState extends State<EditCommentScreen> {
  TextEditingController comment1 = TextEditingController();
  TextEditingController comment2 = TextEditingController();
  TextEditingController comment3 = TextEditingController();
  TextEditingController comment4 = TextEditingController();
  void reset() {
    comment1.clear();
    comment2.clear();
    comment3.clear();
    comment4.clear();
  }

  List<Map<String, dynamic>> commentData = [];

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
  bool isComment4 = false;
  TextEditingController commentDifferen = TextEditingController();
  int? level;
  int? commentType;

  int selectedEmotion = -1;
  String status = "";
  String selectedComment = '';
  int selectedOption = 0;
  List<Map> selectedOptions = []; // Đổi sang kiểu List<String>
  List<ListComment> listComment = [];

  initData() async {
    var comment = Provider.of<CommentProvider>(context, listen: false);
    await comment.getApi().whenComplete(() => null);
  }

  void resetCommentSelections() {
    isComment1 = false;
    isComment2 = false;
    isComment3 = false;
    isComment4 = false;
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
    initData();
    // getApi();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Consumer<CommentProvider>(builder: (context, comment, child) {
      return Scaffold(
        drawer: Drawer(
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
                leading: const Icon(Icons.person),
                title: const Text('Xem các tài khoản'),
                onTap: () {
                  // Add your logic here for Button 1
                  Navigator.pushNamed(context, RouteName.readuser,
                      arguments: false);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_add),
                title: const Text('Tạo tài khoản'),
                onTap: () {
                  // Add your logic here for Button 1
                  Navigator.pushNamed(context, RouteName.create,
                      arguments: false);
                },
              ),
              ListTile(
                leading: const Icon(Icons.insert_chart),
                title: const Text('Xem biểu đồ thống kê'),
                onTap: () {
                  // Add your logic here for Button 2
                  Navigator.pushNamed(context, RouteName.chart,
                      arguments: false);
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Chỉnh sửa comment'),
                onTap: () {
                  // Add your logic here for Button 2
                  Navigator.pushNamed(context, RouteName.editComment,
                      arguments: false);
                },
              ),
              ListTile(
                leading: const Icon(Icons.file_download),
                title: const Text('Xuất file excel'),
                onTap: () {
                  // Add your logic here for Button 3
                  Navigator.pushNamed(context, RouteName.excel);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Chỉnh sửa file đa phương tiện'),
                onTap: () {
                  Navigator.pushNamed(context, RouteName.editMedia,
                      arguments: false);
                },
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Đăng xuất'),
                onTap: () {
                  try {
                    Provider.of<UserProvider>(context, listen: false).logout();
                  } catch (e) {
                  } finally {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RouteName.login,
                      (Route<dynamic> route) => false,
                    );
                  }
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: const Center(
            child: Text(
              "Chỉnh sửa ý kiến đánh giá",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 50, bottom: 100),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          resetEmotionSelections();
                          reset();
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
                              width: 120,
                              decoration: BoxDecoration(
                                  color: isTapped0 == true
                                      ? const Color.fromRGBO(255, 214, 214, 1)
                                      : Colors.white,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  )),
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Image.asset(
                                "assets/images/icon1.png",
                                width: 100,
                              ),
                            ),
                            // Khoảng cách giữa Icon và Text
                            Container(
                              padding: const EdgeInsets.only(bottom: 5),
                              width: 120,
                              decoration: BoxDecoration(
                                  color: isTapped0 == true
                                      ? const Color.fromRGBO(255, 214, 214, 1)
                                      : Colors.white,
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  )),
                              child: const Center(
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
                          reset();
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
                              width: 120,
                              decoration: BoxDecoration(
                                  color: isTapped1 == true
                                      ? const Color.fromRGBO(255, 233, 217, 1)
                                      : Colors.white,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  )),
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Image.asset(
                                "assets/images/icon2.png",
                                width: 100,
                              ),
                            ),
                            // Khoảng cách giữa Icon và Text
                            Container(
                              padding: const EdgeInsets.only(bottom: 5),
                              width: 120,
                              decoration: BoxDecoration(
                                  color: isTapped1 == true
                                      ? const Color.fromRGBO(255, 233, 217, 1)
                                      : Colors.white,
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  )),
                              child: const Center(
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
                          reset();
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
                              width: 120,
                              decoration: BoxDecoration(
                                  color: isTapped2 == true
                                      ? const Color.fromRGBO(255, 243, 181, 1)
                                      : Colors.white,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  )),
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Image.asset(
                                "assets/images/icon3.png",
                                width: 100,
                              ),
                            ),
                            // Khoảng cách giữa Icon và Text
                            Container(
                              padding: const EdgeInsets.only(bottom: 5),
                              width: 120,
                              decoration: BoxDecoration(
                                  color: isTapped2 == true
                                      ? const Color.fromRGBO(255, 243, 181, 1)
                                      : Colors.white,
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  )),
                              child: const Center(
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
                          reset();
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
                              width: 120,
                              decoration: BoxDecoration(
                                  color: isTapped3 == true
                                      ? const Color.fromRGBO(224, 242, 255, 1)
                                      : Colors.white,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  )),
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Image.asset(
                                "assets/images/icon4.png",
                                width: 100,
                              ),
                            ),
                            // Khoảng cách giữa Icon và Text
                            Container(
                              padding: const EdgeInsets.only(bottom: 5),
                              width: 120,
                              decoration: BoxDecoration(
                                  color: isTapped3 == true
                                      ? const Color.fromRGBO(224, 242, 255, 1)
                                      : Colors.white,
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  )),
                              child: const Center(
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
                          reset();
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
                              width: 120,
                              decoration: BoxDecoration(
                                  color: isTapped4 == true
                                      ? const Color.fromRGBO(203, 255, 227, 1)
                                      : Colors.white,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  )),
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Image.asset(
                                "assets/images/icon5.png",
                                width: 100,
                              ),
                            ),
                            // Khoảng cách giữa Icon và Text
                            Container(
                              padding: const EdgeInsets.only(bottom: 5),
                              width: 120,
                              decoration: BoxDecoration(
                                  color: isTapped4 == true
                                      ? const Color.fromRGBO(203, 255, 227, 1)
                                      : Colors.white,
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  )),
                              child: const Center(
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
              Container(
                padding: const EdgeInsets.only(right: 30, left: 30),
                width: width,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    selectedEmotion == -1
                        ? Container()
                        : Column(
                            children: [
                              comment.listComment[selectedEmotion].comments!
                                          .length ==
                                      2
                                  ? Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(8.0),
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: const Color.fromRGBO(
                                                      47, 179, 178, 1)),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                            child: TextField(
                                              controller: comment1,
                                              decoration:
                                                  new InputDecoration.collapsed(
                                                hintText: comment
                                                        .listComment[
                                                            selectedEmotion]
                                                        .comments![0]
                                                        .content ??
                                                    "",
                                              ),
                                              style: const TextStyle(
                                                fontSize: 18.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(8.0),
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: const Color.fromRGBO(
                                                      47, 179, 178, 1)),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                            child: TextField(
                                              controller: comment2,
                                              decoration:
                                                  new InputDecoration.collapsed(
                                                hintText: comment
                                                        .listComment[
                                                            selectedEmotion]
                                                        .comments![1]
                                                        .content ??
                                                    "",
                                              ),
                                              style: const TextStyle(
                                                fontSize: 18.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 50,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromRGBO(
                                                        47,
                                                        179,
                                                        178,
                                                        1) // Màu của nút
                                                ),
                                            onPressed: () async {
                                              AppFunctions.showLoading(context);
                                              setState(() {
                                                commentData = [
                                                  {
                                                    "id": comment
                                                        .listComment[
                                                            selectedEmotion]
                                                        .comments?[0]
                                                        .id,
                                                    "content": comment1.text,
                                                  },
                                                  {
                                                    "id": comment
                                                        .listComment[
                                                            selectedEmotion]
                                                        .comments?[1]
                                                        .id,
                                                    "content": comment2.text
                                                  },
                                                ];
                                              });

                                              ApiResponse res =
                                                  await ApiRequest.editComment(
                                                selectedEmotion,
                                                commentData,
                                              );
                                              if (res.data == true) {
                                                AppFunctions.hideLoading(
                                                    context);
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text('Thông báo'),
                                                      content: const Text(
                                                          'Cập nhật thành công.'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text('OK'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                                comment.listComment.clear();
                                                await comment.getApi();
                                              } else if (res.data == false) {
                                                AppFunctions.hideLoading(
                                                    context);
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text('Thông báo'),
                                                      content: const Text(
                                                          'Bình luận không được để trống.'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text('OK'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                              AppFunctions.hideKeyboard(
                                                  context);
                                            },
                                            child: const Text(
                                              'Cập nhật thông tin',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(8.0),
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: const Color.fromRGBO(
                                                      47, 179, 178, 1)),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                            child: TextField(
                                              decoration: new InputDecoration
                                                  .collapsed(
                                                  hintText: comment
                                                          .listComment[
                                                              selectedEmotion]
                                                          .comments?[0]
                                                          .content ??
                                                      ""),
                                              controller: comment1,
                                              style: const TextStyle(
                                                fontSize: 18.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(8.0),
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: const Color.fromRGBO(
                                                      47, 179, 178, 1)),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: TextField(
                                              decoration: new InputDecoration
                                                  .collapsed(
                                                  hintText: comment
                                                          .listComment[
                                                              selectedEmotion]
                                                          .comments?[1]
                                                          .content ??
                                                      ""),
                                              controller: comment2,
                                              style: const TextStyle(
                                                fontSize: 18.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(8.0),
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: const Color.fromRGBO(
                                                      47, 179, 178, 1)),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                            child: TextField(
                                              decoration: new InputDecoration
                                                  .collapsed(
                                                  hintText: comment
                                                          .listComment[
                                                              selectedEmotion]
                                                          .comments?[2]
                                                          .content ??
                                                      ""),
                                              controller: comment3,
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                color: isComment3
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                        comment.listComment[selectedEmotion]
                                                    .comments!.length ==
                                                4
                                            ? GestureDetector(
                                                onTap: () {},
                                                child: Container(
                                                  width: double.infinity,
                                                  padding: const EdgeInsets.all(8.0),
                                                  margin: const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: const Color.fromRGBO(
                                                            47, 179, 178, 1)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.0),
                                                  ),
                                                  child: TextField(
                                                    controller: comment4,
                                                    decoration:
                                                        new InputDecoration
                                                            .collapsed(
                                                      hintText: comment
                                                              .listComment[
                                                                  selectedEmotion]
                                                              .comments![3]
                                                              .content ??
                                                          "",
                                                    ),
                                                    style: const TextStyle(
                                                      fontSize: 18.0,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          height: 50,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color.fromRGBO(
                                                    47,
                                                    179,
                                                    178,
                                                    1) // Màu của nút
                                                ),
                                            onPressed: () async {
                                              AppFunctions.showLoading(context);
                                              if (comment
                                                      .listComment[
                                                          selectedEmotion]
                                                      .comments!
                                                      .length ==
                                                  4) {
                                                setState(() {
                                                  commentData = [
                                                    {
                                                      "id": comment
                                                          .listComment[
                                                              selectedEmotion]
                                                          .comments?[0]
                                                          .id,
                                                      "content": comment1.text,
                                                    },
                                                    {
                                                      "id": comment
                                                          .listComment[
                                                              selectedEmotion]
                                                          .comments?[1]
                                                          .id,
                                                      "content": comment2.text
                                                    },
                                                    {
                                                      "id": comment
                                                          .listComment[
                                                              selectedEmotion]
                                                          .comments?[2]
                                                          .id,
                                                      "content": comment3.text
                                                    },
                                                    {
                                                      "id": comment
                                                          .listComment[
                                                              selectedEmotion]
                                                          .comments?[3]
                                                          .id,
                                                      "content": comment4.text
                                                    }
                                                  ];
                                                });
                                              }
                                              if (comment
                                                      .listComment[
                                                          selectedEmotion]
                                                      .comments!
                                                      .length ==
                                                  3) {
                                                setState(() {
                                                  commentData = [
                                                    {
                                                      "id": comment
                                                          .listComment[
                                                              selectedEmotion]
                                                          .comments?[0]
                                                          .id,
                                                      "content": comment1.text,
                                                    },
                                                    {
                                                      "id": comment
                                                          .listComment[
                                                              selectedEmotion]
                                                          .comments?[1]
                                                          .id,
                                                      "content": comment2.text
                                                    },
                                                    {
                                                      "id": comment
                                                          .listComment[
                                                              selectedEmotion]
                                                          .comments?[2]
                                                          .id,
                                                      "content": comment3.text
                                                    },
                                                  ];
                                                });
                                              }

                                              ApiResponse res =
                                                  await ApiRequest.editComment(
                                                selectedEmotion,
                                                commentData,
                                              );
                                              if (res.data == true) {
                                                AppFunctions.hideLoading(
                                                    context);
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text('Thông báo'),
                                                      content: const Text(
                                                          'Cập nhật thành công.'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text('OK'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                                comment.listComment.clear();
                                                await comment.getApi();
                                              } else if (res.code == 401 &&
                                                  res.status == 1000) {
                                                AppFunctions.hideLoading(
                                                    context);
                                                AppFuntion.showDialogError(
                                                    context, "",
                                                    onPressButton: () async {
                                                  SharedPreferences prefs =
                                                      await SharedPreferences
                                                          .getInstance();

                                                  await Provider.of<
                                                              UserProvider>(
                                                          context,
                                                          listen: false)
                                                      .logout();
                                                  await prefs.remove('jwt');
                                                  Navigator
                                                      .pushNamedAndRemoveUntil(
                                                    context,
                                                    RouteName.login,
                                                    (Route<dynamic> route) =>
                                                        false,
                                                  );
                                                },
                                                    textButton: "Đăng xuất",
                                                    title: "Thông báo lỗi",
                                                    description: "\t\t" +
                                                            "\nTài khoản vừa đăng nhập trên thiết bị khác,vui lòng đăng xuất" ??
                                                        "Vui lòng nhập lại tên và mật khẩu");
                                              } else if (res.data == false) {
                                                AppFunctions.hideLoading(
                                                    context);
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text('Thông báo'),
                                                      content: const Text(
                                                          'Bình luận không được để trống.'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text('OK'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                              AppFunctions.hideKeyboard(
                                                  context);
                                            },
                                            child: const Text(
                                              'Cập nhật thông tin',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
