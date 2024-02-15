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
  static const String billCustomer =
      "https://localhost:7257/api/UserBill/create";
  static const String comment = "http://103.226.249.65:8081/api/Comment/submit";

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
    Map data = {
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
        "amount": serviceName,
        "unitPrice": serviceUnitPrice,
      }
    };
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
      "userBillId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
      "level": 0,
      "commentType": 0,
      "comments": [
        {
          "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
          "content": "string",
        }
      ],
      "otherComment": "string"
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
}
