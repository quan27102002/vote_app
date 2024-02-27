import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vote_app/api/api_base/api_response.dart';
import 'package:vote_app/api/api_request.dart';
import 'package:vote_app/model/readUser.dart';
import 'package:vote_app/provider/userProvider.dart';
import 'package:vote_app/router/router_name.dart';

class ReadUser extends StatefulWidget {
  const ReadUser({Key? key}) : super(key: key);

  @override
  State<ReadUser> createState() => _ReadUserState();
}

class _ReadUserState extends State<ReadUser> {
  List<dynamic> _users = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    ApiResponse res = await ApiRequest.getUser();
    if (res.code == 200) {
      List<dynamic> usersData = res.data;
      List<ReadUsers> users =
          usersData.map((data) => ReadUsers.fromJson(data)).toList();
      setState(() {
        _users.addAll(users);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              leading: Icon(Icons.person),
              title: Text('Xem các tài khoản'),
              onTap: () {
                Navigator.pushReplacementNamed(context, RouteName.readuser,
                    arguments: false);
              },
            ),
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text('Tạo tài khoản'),
              onTap: () {
                Navigator.pushReplacementNamed(context, RouteName.create,
                    arguments: false);
              },
            ),
            ListTile(
              leading: Icon(Icons.insert_chart),
              title: Text('Xem biểu đồ thống kê'),
              onTap: () {
                Navigator.pushReplacementNamed(context, RouteName.chart,
                    arguments: false);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Chỉnh sửa comment'),
              onTap: () {
                Navigator.pushReplacementNamed(context, RouteName.editComment,
                    arguments: false);
              },
            ),
            ListTile(
              leading: Icon(Icons.file_download),
              title: Text('Xuất file excel'),
              onTap: () {
                Navigator.pushReplacementNamed(context, RouteName.excel);
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Đăng xuất'),
              onTap: () async {
               
                SharedPreferences prefs = await SharedPreferences.getInstance();
           
             await   Provider.of<UserProvider>(context, listen: false).logout();
                 await prefs.remove('jwt'); 
                 Navigator.pushReplacementNamed(context, RouteName.login);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(backgroundColor: Color.fromRGBO(47, 179, 178, 1) ,title: Center(child: Text("Danh mục các tài khoản trên hệ thống", style: TextStyle(
                        fontFamily: 'SF Pro Rounded',
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ))),),
      body: _users != null
          ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32,vertical: 30),
            child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return GestureDetector(
                    onTap: () {
                    showDialog(
  context: context,
  builder: (context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(20),
      title: Text(
        'Thông tin người dùng',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildBoldText('Tên người dùng: ', user.userName),
          _buildBoldText('Email: ', user.email),
          _buildBoldText('Mã cơ sở: ', user.code),
          _buildBoldText('Địa chỉ chi nhánh: ', user.branchAddress),
          _buildBoldText('Vai trò: ', user.userRole),
          _buildBoldText('Trạng thái: ', user.userStatus),
          _buildBoldText('Ngày tạo: ', user.createdOn.toString()),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Đóng',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  },
);

                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.person, color: Colors.blue),
                          SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.userName,
                                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                user.branchAddress,
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
  Widget _buildBoldText(String title, String content) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 20, color: Colors.black),
        children: [
          TextSpan(
            text: title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: content),
        ],
      ),
    ),
  );
}
}
