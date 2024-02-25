import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

@JsonSerializable()
class ApiResponse {
  dynamic code;
  dynamic data;
  String? message;
  bool? result;
  Map<String, List<String>>? headers;
  // int? total;
  // int? totalPage;
  // int? pageSize;
  // int? pageNumber;

  @JsonKey(includeFromJson: false, includeToJson: false)
  Response? dioResponse;

  ApiResponse({
    this.code,
    this.data,
    this.message,
    this.result,
    this.headers,
    // this.total,
    // this.totalPage,
    // this.pageSize,
    // this.pageNumber,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) => _$ApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApiResponseToJson(this);
}
