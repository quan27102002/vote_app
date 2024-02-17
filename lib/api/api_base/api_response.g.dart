// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponse _$ApiResponseFromJson(Map<String, dynamic> json) {
  return ApiResponse(
    code: json['code'],
    data: json['data'],
    message: json['msg'] ?? "",
    result: json['code'] == 1,
    // total: json['totalElements'] ?? 0,
    // totalPage: json['totalPage'],
    // pageSize: json['pageSize'],
    // pageNumber: json['pageNumber'],
  );
}

Map<String, dynamic> _$ApiResponseToJson(ApiResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'msg': instance.message ?? "",
      'result': instance.result,
      // 'total': instance.total,
      // 'pageNumber': instance.pageNumber,
      // 'pageSize': instance.pageSize,
      // 'totalPage': instance.totalPage,
    };
