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
  late File image;
  ImagePicker picker = ImagePicker();

// Hãy đảm bảo rằng bạn đã import ImagePicker từ thư viện image_picker
  static final imagePicker = ImagePicker();
  Future pickImage({ImageSource? source}) async {
    XFile? image = await imagePicker.pickImage(
      maxHeight: 480,
      maxWidth: 640,
      source: source ?? ImageSource.gallery,
    );
    if (image != null) {
      var res = await ApiRequest.upload(imagePaths: image);
      if (res.code == 200) {
        return "ok";
      }
    }
    return null;
  }

  Future<void> _getImage() async {
    try {
      // Chọn ảnh từ thư viện của thiết bị
      final XFile? pickedImage =
          await picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        // Nếu ảnh đã được chọn thành công, ta tạo một File từ đường dẫn của ảnh
        setState(() {
          image = File(pickedImage.path);
        });
      } else {
        print('No image selected');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
      ),
      body: Stack(
        children: [
          // Hiển thị hình ảnh được chọn (nếu có).
          // if (_image != null) Image.file(File(_image!.path)),
          // // Nút để chọn hình ảnh từ thiết bị.
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: pickImage,
              tooltip: 'Pick Image',
              child: Icon(Icons.photo_library),
            ),
          ),
          // Nút để thực hiện upload hình ảnh.
          Positioned(
            bottom: 16,
            left: 16,
            child: FloatingActionButton(
              onPressed: () async {
                // var res = await ApiRequest.upload(image: image);
              },
              tooltip: 'Upload Image',
              child: Icon(Icons.cloud_upload),
            ),
          ),
        ],
      ),
    );
  }
}
