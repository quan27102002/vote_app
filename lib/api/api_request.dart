import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:vote_app/api/api_base/api_response.dart';
import 'package:http_parser/http_parser.dart';
import 'api_base/api_client.dart';
import 'package:image_picker/image_picker.dart';

class ApiRequest {
  static const String dataBill = "http://103.226.249.65:8081/api/AppService";
  // static const String domain = "http://103.72.99.63/api";
 static const String domain = "http://103.226.249.65/api";
  // static const String domain = "https://10.0.2.2:7257/api";

  //getBillCustomer
  static Future<ApiResponse> getData(String? codeBr) async {
    DateTime now = DateTime.now();
    String time = DateFormat('yyyy-MM-dd').format(now);
    Map data = {
      "sid": null,
      "cmd": "API_DanhSachKhachHang_Select",
      "data": {
        "benhnhan": {
          "TuNgay": time, //truyền date time now
          "DenNgay": time, // truyền date time now
          "MaCoSo": codeBr,
          // truyền mã cơ sở
        }
      }
    };
    return await ApiClient().request(
      url: dataBill,
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
        url: "$domain/User/refreshtoken",
        data: json.encode(data),
        method: ApiClient.post);
  }

  static Future<ApiResponse> getImage() async {
    return await ApiClient().request(
      url: "$domain/Image/get",
      method: ApiClient.get,
    );
  }

  static Future<ApiResponse> getTotalComment(
      String createTime, String timend, String place) async {
    Map data = {
      "startTime": createTime,
      "endTime": timend,
      "branchCode": place
    };
    return await ApiClient().request(
        url: "$domain/Report/filter",
        data: json.encode(data),
        method: ApiClient.post);
  }

  static Future<ApiResponse> exportExcel(
      String createTime, String timend, String place) async {
    Map data = {
      "startTime": createTime,
      "endTime": timend,
      "branchCode": place
    };
    return await ApiClient().request(
        url: "$domain/Report/export",
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
        url: "$domain/Report/filterlevel",
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
      url: "$domain/UserBill/create",
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
      url: "$domain/User/register",
      data: json.encode(data),
    );
  }

//Upload image
  static Future<ApiResponse> uploadImages({
    required List<XFile> imagePaths,
  }) async {
    FormData formData = FormData();

    for (int i = 0; i < imagePaths.length; i++) {
      String fileName = imagePaths[i].path.split('/').last;
      MultipartFile file = await MultipartFile.fromFile(
        imagePaths[i].path,
        filename: fileName,
        contentType: MediaType('image', 'jpg'),
      );
      formData.files.add(MapEntry('formFiles', file));
    }

    return await ApiClient().request(
      url: "$domain/Image/bulkupload",
      formData: formData,
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
      url: "$domain/Comment/submit",
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
      url: "$domain/Comment/edit",
      data: json.encode(data),
      method: ApiClient.post,
    );
  }

//getListEmotion_Comment
  static Future<ApiResponse> getComment() async {
    return await ApiClient().request(
      url: "$domain/Comment/getallcomments",
      method: ApiClient.get,
    );
  }

  static Future<ApiResponse> getUser() async {
    return await ApiClient().request(
      url: "$domain/User/get",
    );
  }

  static Future<ApiResponse> logOut() async {
    return await ApiClient().request(
      url: "$domain/User/signout",
    );
  }

  static Future<ApiResponse> userLogin(
    String username,
    String passWord,
  ) async {
    final data = {"username": username, "password": passWord};

    return ApiClient().request(
      url: "$domain/User/login",
      data: json.encode(data),
    );
  }
}
