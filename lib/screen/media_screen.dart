import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vote_app/api/api_request.dart';
import 'package:vote_app/dialog/funtion.dart';
import 'package:vote_app/provider/userProvider.dart';
import 'package:vote_app/router/router_name.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({Key? key}) : super(key: key);

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  ImagePicker imagePicker = ImagePicker();
  List<XFile> images = []; // List chứa các hình ảnh đã chọn

  Future<void> pickImages({ImageSource? source}) async {
    List<XFile>? pickedImages = await imagePicker.pickMultiImage(
        // maxHeight: 480,
        // maxWidth: 640,
        // imageQuality: 80, // Chất lượng ảnh
        // source: source ?? ImageSource.gallery,
        );
    if (pickedImages != null) {
      setState(() {
        images.addAll(pickedImages);
      });
    } else {
      // Xử lý trường hợp không chọn được ảnh
      print("Không chọn được ảnh");
    }
  }

  Future<void> uploadImages() async {
    var res = await ApiRequest.uploadImages(imagePaths: images);
    if (res.data == true) {
      setState(() {
        images.clear(); // Xóa tất cả ảnh
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thông báo'),
            content: Text('Cập nhật thành công.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      print("Upload thành công");
    }  else if(res.code==401 && res.status==1000){
         AppFuntion.showDialogError(context, "", onPressButton: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();

                await Provider.of<UserProvider>(context, listen: false)
                    .logout();
                await prefs.remove('jwt');
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteName.login,
                  (Route<dynamic> route) => false,
                );
        },
            textButton: "Đăng xuất",
            title: "Thông báo lỗi",
            description: "\t\t" +
                   
                    "\nTài khoản vừa đăng nhập trên thiết bị khác,vui lòng đăng xuất" ??
                "Vui lòng nhập lại tên và mật khẩu");
 
  
    } else {
      print("Upload thất bại");
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
                Navigator.pushNamed(context, RouteName.readuser,
                    arguments: false);
              },
            ),
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text('Tạo tài khoản'),
              onTap: () {
                Navigator.pushNamed(context, RouteName.create,
                    arguments: false);
              },
            ),
            ListTile(
              leading: Icon(Icons.insert_chart),
              title: Text('Xem biểu đồ thống kê'),
              onTap: () {
                Navigator.pushNamed(context, RouteName.chart, arguments: false);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Chỉnh sửa comment'),
              onTap: () {
                Navigator.pushNamed(context, RouteName.editComment,
                    arguments: false);
              },
            ),
            ListTile(
              leading: Icon(Icons.file_download),
              title: Text('Xuất file excel'),
              onTap: () {
                Navigator.pushNamed(context, RouteName.excel);
              },
            ),
            ListTile(
              leading: Icon(Icons.image),
              title: Text('Chỉnh sửa file đa phương tiện'),
              onTap: () {
                Navigator.pushNamed(context, RouteName.editMedia,
                    arguments: false);
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Đăng xuất'),
              onTap: () async {
               await   Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteName.login,
                  (Route<dynamic> route) => false,
                );
                Provider.of<UserProvider>(context, listen: false)
                    .logout();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Center(
            child: Text(
          'Thay đổi ảnh',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        )),
      ),
      body: Stack(
        children: [
          // Hiển thị các hình ảnh đã chọn
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Số cột trong grid view
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            itemCount: images.length,
            itemBuilder: (BuildContext context, int index) {
              return Image.file(File(images[index].path));
            },
          ),
          // Nút để chọn hình ảnh từ thiết bị
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                pickImages();
              },
              tooltip: 'Pick Images',
              child: Icon(Icons.photo_library),
            ),
          ),
          // Nút để thực hiện upload hình ảnh
          Positioned(
            bottom: 16,
            left: 16,
            child: FloatingActionButton(
              onPressed: () async {
                uploadImages();
              },
              tooltip: 'Upload Images',
              child: Icon(Icons.cloud_upload),
            ),
          ),
        ],
      ),
    );
  }
}
