import 'dart:convert';
import 'package:dio/dio.dart';
// import 'package:http_parser/http_parser.dart';
// import 'package:image_picker/image_picker.dart';
import 'api_base/api_client.dart';
import 'api_base/api_response.dart';

class ApiRequest {
  static const String domain = "http://103.226.249.65:8081/api/AppService";
  static const String data =
      "https://api.mockfly.dev/mocks/f8a8de5b-31b9-4a44-8c1e-843f4be7003e/service";
  //auth
  //login
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

  //register
  // static Future<ApiResponse> userRegister({
  //   required String username,
  //   required String password,
  //   required String email,
  //   required String mobileNumber,
  //   String? affiliateCode,
  //   required String transactionCode,
  // }) async {
  //   Map data = {
  //     "username": username,
  //     "password": password,
  //     "email": email,
  //     "mobileNumber": mobileNumber,
  //     "affiliateCode": affiliateCode,
  //     "transactionCode": transactionCode,
  //   };
  //   return await ApiClient()
  //       .request(url: "$domain/api/v1/auth/user/register", data: json.encode(data), method: ApiClient.post);
  // }

  //send-verify-password
  // static Future<ApiResponse> sendVerifyPassword(String email) async {
  //   Map data = {"email": email};
  //   return await ApiClient().request(
  //       url: "$domain/api/v1/auth/send-verify/reset-password", data: json.encode(data), method: ApiClient.post);
  // }

  //verify-password
  // static Future<ApiResponse> verifyPassword({required String email, required String code}) async {
  //   Map data = {"email": email, "code": code};
  //   return await ApiClient()
  //       .request(url: "$domain/api/v1/auth/verify/reset-password", data: json.encode(data), method: ApiClient.post);
  // }

  //reset-password
  static Future<ApiResponse> getComment() async {
    return await ApiClient().request(
      url: data,
      method: ApiClient.get,
    );
  }

  //profile
  // static Future<ApiResponse> getUserInfo() async {
  //   return await ApiClient().request(url: "$domain/api/v1/user/account", method: ApiClient.get);
  // }

  //media
  //images
  // static Future<ApiResponse> uploadImages({
  //   required List<XFile> imagePaths,
  // }) async {
  //   List<MultipartFile> imageFiles = [];
  //   for (XFile imagePath in imagePaths) {
  //     imageFiles.add(await MultipartFile.fromFile(
  //       imagePath.path,
  //       filename: imagePath.path.split('/').last,
  //       contentType: MediaType('image', 'png'),
  //     ));
  //   }
  //   Map<String, dynamic> data = {
  //     "files": imageFiles,
  //   };
  //   return await ApiClient().request(url: "$domain/api/v1/file/upload", formData: data, method: ApiClient.post);
  // }
}
