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
  static const String data = "https://10.0.2.2:7257/api/Comment/getallcomments";
  static const String billCustomer =
      "https://10.0.2.2:7257/api/UserBill/create";
  static const String comment = "https://10.0.2.2:7257/api/Comment/submit";
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
          // "MaCoSo": codeBr,
          "MaCoSo": "ND", // truyền mã cơ sở
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
        url: "https://10.0.2.2:7257/api/Report/filter",
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
        url: "https://10.0.2.2:7257/api/Report/filterlevel",
        data: json.encode(data),
        method: ApiClient.post);
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

  //register
  static Future<ApiResponse> userRegister(String name, String email,
      String place, String brandCode, String pass, int role) async {
    Map data = {
      "username": name,
      "password": pass,
      "role": role,
      "displayName": "STAFF",
      "email": email,
      "code": brandCode,
      "branchAddress": place
    };
    return await ApiClient().request(
      url: "https://10.0.2.2:7257/api/User/register",
      data: json.encode(data),
    );
  }

  //send-verify-password
  // static Future<ApiResponse> sendVerifyPassword(String email) async {
  //   Map data = {"email": email};viet
  //   return await ApiClient().request(
  //       url: "$domain/api/v1/auth/send-verify/reset-password", data: json.encode(data), method: ApiClient.post);
  // }

  //verify-password
  // static Future<ApiResponse> verifyPassword({required String email, required String code}) async {
  //   Map data = {"email": email, "code": code};
  //   return await ApiClient()
  //       .request(url: "$domain/api/v1/auth/verify/reset-password", data: json.encode(data), method: ApiClient.post);
  // }

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

//edit Comment
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

//getListEmotion_Comment
  static Future<ApiResponse> getComment() async {
    return await ApiClient().request(
      url: data,
      method: ApiClient.get,
    );
  }

  static Future<ApiResponse> userLogin(
    String username,
    String passWord,
  ) async {
    final data = {"username": username, "password": passWord};

    return ApiClient().request(
      url: "https://10.0.2.2:7257/api/User/login",
      data: json.encode(data),
    );
  }
}
