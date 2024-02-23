import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vote_app/api/api_request.dart';

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
      maxHeight: 480,
      maxWidth: 640,
      imageQuality: 80, // Chất lượng ảnh
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
    if (res.result == true) {
      print("Upload thành công");
    } else {
      print("Upload thất bại");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Images'),
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
