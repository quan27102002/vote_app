import 'package:flutter/material.dart';
import 'package:vote_app/api/api_base/api_response.dart';
import 'package:vote_app/api/api_request.dart';

class MyListViewScreen extends StatefulWidget {
  final String timeCreate;
  final String timeEnd;
  final String selectedOption;
  final int index;

  const MyListViewScreen(
      {super.key,
      required this.timeCreate,
      required this.timeEnd,
      required this.selectedOption,
      required this.index});
  @override
  State<MyListViewScreen> createState() => _MyListViewScreenState();
}

class _MyListViewScreenState extends State<MyListViewScreen> {
  List<dynamic> userComments = [];
  List<dynamic> otherComments = [];

  @override
  Widget build(BuildContext context) {
    // Lấy tham số từ route arguments

    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết các đánh giá'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Gọi hàm exportToChart khi người dùng nhấn nút refresh
              exportToChart(widget.timeCreate, widget.timeEnd,
                  widget.selectedOption, widget.index);
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          for (var comment in userComments)
            ListTile(
              title: Text(comment['content']),
              subtitle: Text('Count: ${comment['count']}'),
            ),
          for (var comment in otherComments)
            ListTile(
              title: Text(comment['content']),
              subtitle: Text('Count: ${comment['count']}'),
            ),
        ],
      ),
    );
  }

  Future<void> exportToChart(
      String createTime, String timend, String place, int level) async {
    ApiResponse res = await ApiRequest.getfilterTotalComment(
        createTime, timend, place, level);
    if (res.code == 200) {
      List<dynamic> userData = res.data['userComments'];
      List<dynamic> otherData = res.data['otherComments'];

      // Thêm dữ liệu vào userComments và otherComments
      setState(() {
        userComments.clear();
        otherComments.clear();
        userComments.addAll(userData);
        otherComments.addAll(otherData);
      });
    }
  }
}
