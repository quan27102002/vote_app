// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vote_app/api/api_request.dart';
import 'package:vote_app/utils/app_functions.dart';
import 'api_response.dart';

class ApiClient {
  static const String get = 'GET';
  static const String post = 'POST';
  static const String delete = 'DELETE';
  static const String patch = 'PATCH';
  static const String put = 'PUT';

  static const contentType = 'Content-Type';
  static const contentTypeJson = 'application/json; charset=utf-8';
  static final BaseOptions defaultOptions = BaseOptions(
      connectTimeout: const Duration(seconds: 50),
      receiveTimeout: const Duration(seconds: 5),
      responseType: ResponseType.json);

  Dio _dio = Dio();

  static final Map<BaseOptions, ApiClient> _instanceMap = {};

  factory ApiClient({BaseOptions? options}) {
    options ??= defaultOptions;
    final ApiClient apiClient = ApiClient._create(options: options);
    _instanceMap[options] = apiClient;
    return apiClient;
  }

  ApiClient._create({BaseOptions? options}) {
    options ??= defaultOptions;
    _dio = Dio(options);
    _dio.interceptors.add(PrettyDioLogger(
        requestHeader: false,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
  }

  static ApiClient get instance => ApiClient();
  void printResponseHeaders(Response response) {
    print('Headers of the response:');
    response.headers.forEach((key, values) {
      // print('$key: $values');
    });
  }
  Future<ApiResponse> request(
      {required String url,
      String method = post,
      String? data,
      String? deviceId,
      String? token,
      Map<String, dynamic>? formData,
      Map<String, dynamic>? queryParameters,
      bool getFullResponse = false}) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return ApiResponse(
        data: null,
        message: 'Không có kết nối mạng.',
        code: 2106,
      );
    }
    if (url == "") {
      AppFunctions.log('!!!!!!EMPTY URL!!!!!! - data: $data');
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('jwt');
    Map<String, dynamic> headerMap = (token != null && token != '')
        ? {'Authorization': "Bearer $token", 'deviceId': deviceId}
        : {'deviceId': deviceId};
    headerMap.putIfAbsent("accept", () => "*/*");
    // print(headerMap);
    Response response;
    try {
      response = await _dio.request(url,
          data: formData != null
              ? FormData.fromMap(formData)
              : data ?? jsonEncode({}),
          options: Options(
              method: method,
              sendTimeout: const Duration(milliseconds: 60000),
              receiveTimeout: const Duration(milliseconds: 60000),
              headers: headerMap,
              contentType: formData != null ? 'multipart/form-data' : null),
          queryParameters: queryParameters);
      print(response);
      if (_isSuccessful(response.statusCode)) {
        var apiResponse = ApiResponse.fromJson(response.data);
        apiResponse.message =
            '${apiResponse.message ?? ''} (Code: ${apiResponse.code != null ? apiResponse.code.toString() : 'Unknown'})';
        apiResponse.headers = response.headers.map.map((key, value) {
          return MapEntry(key, value.toList());
        });print(apiResponse.headers);
        printResponseHeaders(response);
        if (getFullResponse) apiResponse.dioResponse = response;
        return apiResponse;
      }
    } on DioException catch (e) {
      // Sentry.captureException(e);
      if (e.response != null) {
        // e.response.data có thể trả về _InternalLinkedHashMap hoặc 1 kiểu nào đó (String), tạm thời check thủ công theo runtimeType
        String? errorMessage = e.response?.data != null &&
                e.response!.data.runtimeType.toString().contains('Map') &&
                !AppFunctions.isNullEmpty(e.response?.data['message'] ??
                    "Lỗi ${e.response?.statusCode}")
            ? e.response?.data['message']
            : !AppFunctions.isNullEmpty(e.response?.statusMessage as Object)
                ? e.response?.statusMessage
                : e.message;
                 Headers? headers = e.response!.headers;

    // Kiểm tra xem header có tồn tại và chứa trường 'is-token-expired' không
    if (headers != null && headers.value('is-token-expired') == '[true]') {
      // Gọi hàm refreshToken ở đây
      print("test4");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt');
      String? refreshToken = prefs.getString('jwtrefresh');
      if (token != null && refreshToken != null) {
        ApiResponse res = await ApiRequest.getTokenByRefreshtoken(token, refreshToken);
        if (res.result == true) {
          String newToken = res.data["accessToken"];
          String newRefreshToken = res.data["refreshToken"];
          print(newToken);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt', newToken);
          await prefs.setString('jwtrefresh', newRefreshToken);
        }
      }
      // print("test 2");
      // Sau khi refreshToken hoàn tất, thực hiện lại yêu cầu ban đầu
      // Lưu ý: Đây là một ví dụ đơn giản, cách xử lý này có thể cần điều chỉnh tùy thuộc vào logic cụ thể của ứng dụng bạn
      return request(url: url, method: method, data: data, deviceId: deviceId, token: token, formData: formData, queryParameters: queryParameters, getFullResponse: getFullResponse);
    }
        return ApiResponse(
          data: null,
          message: errorMessage,
          code: e.response?.statusCode,
        );
      }
      if (e.error is SocketException) {
        SocketException socketException = e.error as SocketException;
        return ApiResponse(
          data: null,
          message: socketException.osError?.message ?? "",
          code: socketException.osError?.errorCode ?? 0,
        );
      }
      return ApiResponse(
        data: null,
        message: e.error != null ? e.error.toString() : "",
        code: -9999,
      );
    }
    throw ('Request NOT successful');
  }

  bool _isSuccessful(int? i) {
    if (i == null) {
      return false;
    } else {
      return i >= 200 && i <= 299;
    }
  }
}
