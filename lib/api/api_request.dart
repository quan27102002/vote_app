import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'api_base/api_client.dart';
import 'api_base/api_response.dart';

class ApiRequest {
  static const String domain = "http://103.226.249.65:8081/api/AppService";
  static const String data = "https://10.0.2.2:7257/api/Comment/getallcomments";
  static const String billCustomer =
      "https://10.0.2.2:7257/api/UserBill/create";
  static const String comment = "https://10.0.2.2:7257/api/Comment/submit";
  static const String uploadImage =
      "https://10.0.2.2:7257/api/Image/bulkupload";
  static const String edit = "https://10.0.2.2:7257/api/Comment/edit";

  //getBillCustomer
  static Future<ApiResponse> getData() async {
    Map data = {
      "sid": null,
      "cmd": "API_DanhSachKhachHang_Select",
      "data": {
        "benhnhan": {
          "TuNgay": "20240123", //truyền date time now
          "DenNgay": "20240123", // truyền date time now
          "MaCoSo": "TH", // truyền mã cơ sở
        }
      }
    };
    return await ApiClient().request(
      url: domain,
      data: json.encode(data),
      method: ApiClient.post,
    );
  }

//uploadBillCustomer
  static Future<ApiResponse> uploadBillCustomer(
    int billCode,
    String customerName,
    String customerCode,
    String phone,
    String startTime,
    String branchCode,
    String branchAddress,
    String doctor,
    String serviceName,
    int serviceAmount,
    int serviceUnitPrice,
  ) async {
    List<Map<String, dynamic>> data = [
      {
        "billCode": billCode,
        "customerName": customerName,
        "customerCode": customerCode,
        "phone": phone,
        "startTime": startTime,
        "branchCode": branchCode,
        "branchAddress": branchAddress,
        "doctor": doctor,
        "service": {
          "name": serviceName,
          "amount": serviceAmount,
          "unitPrice": serviceUnitPrice,
        }
      }
    ];
    return await ApiClient().request(
      url: billCustomer,
      data: json.encode(data),
      method: ApiClient.post,
    );
  }

//uploadComment
  static Future<ApiResponse> uploadComment(
    String userBillId,
    int level,
    int commentType,
    List comments,
    String otherComment,
  ) async {
    Map data = {
      "userBillId": userBillId,
      "level": level,
      "commentType": commentType,
      "comments": comments,
      "otherComment": otherComment,
    };
    return await ApiClient().request(
      url: comment,
      data: json.encode(data),
      method: ApiClient.post,
    );
  }

//getListEmotion_Comment
  static Future<ApiResponse> getComment() async {
    return await ApiClient().request(
      url: data,
      method: ApiClient.get,
    );
  }

  //upload image
  // static Future<ApiResponse> upload({
  //   required XFile image,
  // }) async {
  //   MultipartFile imageFiles;
  //   imageFiles = (await MultipartFile.fromFile(image.path,
  //       filename: image.path.split('/').last,
  //       contentType: MediaType('image', 'png')));

  //   return await ApiClient().request(
  //     url: uploadImage,
  //     image: imageFiles,
  //     method: ApiClient.post,
  //   );
  // }
  static Future<ApiResponse> upload({
    required XFile imagePaths,
  }) async {
    MultipartFile imageFiles;
    imageFiles = (await MultipartFile.fromFile(
      imagePaths.path,
      filename: imagePaths.path.split('/').last,
      contentType: MediaType('image', 'png'),
    ));
    Map<String, dynamic> data = {"file": imageFiles};
    return await ApiClient().request(
      url: uploadImage,
      formData: data,
      method: ApiClient.post,
    );
  }

  //edit ccomment
  static Future<ApiResponse> editComment(
    int level,
    List comments,
  ) async {
    Map data = {
      "level": level,
      "comments": comments,
    };
    return await ApiClient().request(
      url: edit,
      data: json.encode(data),
      method: ApiClient.post,
    );
  }
}
