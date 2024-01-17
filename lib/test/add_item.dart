// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:pocketbase/pocketbase.dart';

// class AddItem extends StatefulWidget {
//   const AddItem({super.key});

//   @override
//   State<AddItem> createState() => _AddItemState();
// }

// class _AddItemState extends State<AddItem> {
//   final pb =
//       PocketBase('http://127.0.0.1:8090'); // Thay bằng URL PocketBase của bạn
//   XFile? _image;

//   Future<void> _pickImage() async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);

//     setState(() {
//       _image = pickedFile;
//     });
//   }

//   Future<void> _pushImage() async {
//     if (_image != null) {
//       try {
//         final file = File(_image!.path);
//         pb.collection('example').create(
//           body: {
//             'title': 'Hello world!',
//             // ... any other regular field
//           },
//           files: [
//             http.MultipartFile.fromString(
//               'document', // the name of the file field
//               'example content...',
//               filename: 'example_document.txt',
//             ),
//           ],
//         ).then((record) {
//           print(record.id);
//           print(record.getStringValue('title'));
//         });
//         // Sửa đường dẫn ảnh nếu cần
//         // Thêm xử lý thành công tại đây
//       } catch (error) {
//         // Thêm xử lý lỗi tại đây
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Center(
//           child: Text('Nguyễn Đại Hồng Quân'),
//         ),
//       ),
//       body: Center(
//         child: _image != null
//             ? Column(
//                 children: [
//                   Image.file(_image! as File),
//                   TextButton(
//                     onPressed: _pushImage,
//                     child: Text("Đẩy lên PocketBase"),
//                   ),
//                 ],
//               )
//             : Text("Chưa chọn ảnh"),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _pickImage,
//         child: Icon(Icons.add_a_photo),
//       ),
//     );
//   }
// }
