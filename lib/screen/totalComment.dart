import 'package:flutter/material.dart';
import 'package:vote_app/api/api_base/api_response.dart';
import 'package:vote_app/api/api_request.dart';

class MyListViewScreen extends StatefulWidget {
  @override
  State<MyListViewScreen> createState() => _MyListViewScreenState();
}

class _MyListViewScreenState extends State<MyListViewScreen> {
  List<dynamic> userComments = [];

  List<dynamic> otherComments = [];

  late int index;
  late String timeCreate;
  late String timeEnd;
  late dynamic selectedOption;

  @override
  void initState() {
    super.initState();

    // Lấy tham số từ route arguments
    Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      index = args['index'] as int;
      timeCreate = args['timeCreate'] as String;
      timeEnd = args['timeEnd'] as String;
      selectedOption = args['_selectedOption']; // Kiểu dữ liệu tùy ý
    }

    // Gọi hàm exportToChart với các tham số đã lấy
    exportToChart(timeCreate, timeEnd, selectedOption, index);
  }

  Future<void> exportToChart(
      String createTime, String timend, String place, int level) async {
    ApiResponse res = await ApiRequest.getfilterTotalComment(
        createTime, timend, place, level);
    if (res.code == 200) {
    List<dynamic> userData = res.data['userComments'];
  List<dynamic> otherData = res.data['otherComments'];

  // Thêm dữ liệu vào userComments và otherComments
  userComments.addAll(userData);
  otherComments.addAll(otherData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết các đánh giá'),
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
}
