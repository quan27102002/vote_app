import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:vote_app/api/api_base/api_response.dart';
import 'package:vote_app/api/api_base/api_response_http.dart';
// import 'package:image_picker/image_picker.dart';
import 'api_base/api_client.dart';
import 'api_base/api_response.dart';
import 'package:http/http.dart' as http;

class ApiRequest {
  static const String domain = "http://103.226.249.65:8081/api/AppService";

  //auth
  //login
  static Future<ApiResponse> getData() async {
    Map data = {
      "sid": null,
      "cmd": "API_DanhSachKhachHang_Select",
      "data": {
        "benhnhan": {
          "TuNgay": "20240101", //truyền date time now
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

  static Future<ApiResponse> getTokenByRefreshtoken(
      String accessToken, String refreshToken) async {
    Map data = {
      "accessToken": accessToken,
      "refreshToken": refreshToken,
    };
    return await ApiClient().request(
        url: "$domain/api/v1/auth/user/register",
        data: json.encode(data),
        method: ApiClient.post);
  }

  static Future<ApiResponse> getTotalComment(
      String createTime, String timend, String place) async {
    Map data = {
      "startTime": createTime,
      "endTime": timend,
      "branchCode": place
    };
    return await ApiClient().request(
        url: "$domain/api/v1/auth/user/register",
        data: json.encode(data),
        method: ApiClient.post);
  }

  static Future<ApiResponse> getfilterTotalComment(
      String createTime, String timend, String place, int level) async {
    Map data = {
      "startTime": createTime,
      "endTime": timend,
      "branchCode": place,
      "level": level
    };
    return await ApiClient().request(
        url: "$domain/api/v1/auth/user/register",
        data: json.encode(data),
        method: ApiClient.post);
  }

  //register
  static Future<ApiResponse> userRegister(
      String name, String email, String place, String pass, role) async {
    Map data = {
      "username": name,
      "password": pass,
      "role": role,
      "displayName": "",
      "email": email,
      "code": "",
      "branchAddress": place
    };
    return await ApiClient().request(
        url: "https://10.0.2.2:7257/api/User/register",
        data: json.encode(data),
        method: ApiClient.post);
  }

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
  static Future<ApiResponse> resetPass(
      {required String password,
      required String confirmPassword,
      required String token}) async {
    Map data = {"password": password, "confirmPassword": confirmPassword};
    return await ApiClient()
        .request(url: domain, data: json.encode(data), method: ApiClient.post);
  }

  static Future<ApiResponse> userLogin(
    String username,
    String passWord,
  ) async {
    final data = {"username": username, "password": passWord};
    //   try {
    //   http.Response response = await http.post(
    //     Uri.parse('https://localhost:7257/api/User/login'),
    //     headers: {'Content-Type': 'application/json'},
    //     body: json.encode(data),
    //   );

    //   // Kiểm tra mã trạng thái của response
    //   if (response.statusCode == 200) {
    //     // Xử lý dữ liệu response và trả về ApiResponseHttp
    //     return ApiResponseHttp.fromJson(json.decode(response.body));
    //   } else {
    //     // Xử lý trường hợp response không thành công
    //     return ApiResponseHttp.error('Failed to login. Status code: ${response.statusCode}');
    //   }
    // } catch (e) {
    //   // Xử lý các trường hợp ngoại lệ và trả về ApiResponseHttp phù hợp
    //   return ApiResponseHttp.error(e.toString());
    // }

    return ApiClient().request(
      url: "https://10.0.2.2:7257/api/User/login",
      data: json.encode(data),
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
