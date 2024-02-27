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

  Future<ApiResponse> request({
    required String url,
    String method = post,
    String? data,
    String? deviceId,
    String? token,
    FormData? formData,
    Map<String, dynamic>? queryParameters,
    bool getFullResponse = false,
  }) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return ApiResponse(
        data: null,
        message: 'Không có kết nối mạng.',
        code: 2106,
      );
    }
    if (url.isEmpty) {
      print('!!!!!!EMPTY URL!!!!!! - data: $data');
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('jwt');
    Map<String, dynamic> headerMap = (token != null && token.isNotEmpty)
        ? {'Authorization': 'Bearer $token', 'deviceId': deviceId}
        : {'deviceId': deviceId};
    headerMap.putIfAbsent("accept", () => "*/*");
    print(headerMap);
    try {
      Response response = await _dio.request(
        url,
        data: formData ?? data ?? jsonEncode({}),
        options: Options(
          method: method,
          sendTimeout: const Duration(milliseconds: 60000),
          receiveTimeout: const Duration(milliseconds: 60000),
          headers: headerMap,
          contentType:
              formData != null ? 'multipart/form-data' : contentTypeJson,
        ),
        queryParameters: queryParameters,
      );
      if (_isSuccessful(response.statusCode)) {
        var apiResponse = ApiResponse.fromJson(response.data);
        apiResponse.message =
            '${apiResponse.message ?? ''} (Code: ${apiResponse.code != null ? apiResponse.code.toString() : 'Unknown'})';

        if (getFullResponse) apiResponse.dioResponse = response;
        return apiResponse;
      } else {
        return ApiResponse(
          data: null,
          message: 'Request was not successful',
          code: response.statusCode,
        );
      }
    } on DioError catch (e) {
      String errorMessage;
      if (e.response != null) {
        errorMessage = e.response!.data != null &&
                e.response!.data.runtimeType.toString().contains('Map') &&
                e.response!.data['message'] != null
            ? e.response!.data['message']
            : e.response!.statusMessage ?? 'Unknown error occurred';
        if (e.response?.statusCode == 401) {
          await _refreshToken();
          // Retry the request after refreshing the token
          return await request(
              url: url,
              method: method,
              data: data,
              deviceId: deviceId,
              token: token,
              formData: formData,
              queryParameters: queryParameters,
              getFullResponse: getFullResponse);
        }
        return ApiResponse(
          data: null,
          message: errorMessage,
          code: e.response?.statusCode,
        );
      } else if (e.error is SocketException) {
        SocketException socketException = e.error as SocketException;
        errorMessage = socketException.osError?.message ?? "Socket Exception";
      } else {
        errorMessage = e.error.toString();
      }
      return ApiResponse(
        data: null,
        message: errorMessage,
        code: -9999,
      );
    } catch (e) {
      return ApiResponse(
        data: null,
        message: e.toString(),
        code: -9999,
      );
    }
  }

  bool _isSuccessful(int? i) {
    if (i == null) {
      return false;
    } else {
      return i >= 200 && i <= 299;
    }
  }

  Future<void> _refreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt');
    String? refreshToken = prefs.getString('jwtrefresh');
    if (token != null && refreshToken != null) {
      ApiResponse res =
          await ApiRequest.getTokenByRefreshtoken(token, refreshToken);
      if (res.code == 200) {
        String newToken = res.data["accessToken"];
        String newRefreshToken = res.data["refreshToken"];
        print(newToken);
        await prefs.setString('jwt', newToken);
        await prefs.setString('jwtrefresh', newRefreshToken);
      }
    }
  }
}
