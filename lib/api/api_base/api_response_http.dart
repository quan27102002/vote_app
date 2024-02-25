import 'dart:convert';

class ApiResponseHttp {
  dynamic code;
  dynamic data;
  String? message;
  bool? result;

  ApiResponseHttp({
    this.code,
    this.data,
    this.message,
    this.result,
  });

  factory ApiResponseHttp.fromJson(Map<String, dynamic> json) {
    return ApiResponseHttp(
      code: json['code'],
      data: json['data'],
      message: json['message'],
      result: json['result'],
    );
  }

  static ApiResponseHttp error(String message) {
    return ApiResponseHttp(message: message);
  }
}
