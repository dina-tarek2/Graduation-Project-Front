import 'package:dio/dio.dart';
import 'package:graduation_project_frontend/api_services/api_consumer.dart';
import 'package:graduation_project_frontend/api_services/api_interceptors.dart';
import 'package:graduation_project_frontend/api_services/end_points.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;
  final bool? isdicom;
  // to add dio in the construactor
  DioConsumer({required this.dio, this.isdicom = false}) {
    if (isdicom == true) {
      dio.options.baseUrl = EndPoints.DicomBaseUrl;
    } else {
      dio.options.baseUrl = EndPoints.baseUrl;
    }
    //tosent header with request
    dio.interceptors.add(ApiInterceptors());
    // to print info about request
    dio.interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true));
  }

  @override
  Future delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFromData = false,
  }) async {
    try {
      final Response = await dio.delete(
        path,
        data: isFromData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
      );
      return Response;
    } on DioException catch (e) {
      print("DioException: ${e.message}");
      throw (" ${e.response?.data['message'] ?? e.message}");
    }
  }

  @override
  Future get(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFromData = false,
  }) async {
    try {
      final Response = await dio.get(
        path,
        // data: data,
        queryParameters: queryParameters,
      );
      return Response;
    } on DioException catch (e) {
      print("DioException: ${e.message}");
      throw (" ${e.response?.data['message'] ?? e.message}");
    }
  }

  @override
  Future patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFromData = false,
  }) async {
    try {
      final Response = await dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return Response;
    } on DioException catch (e) {
      print("DioException: ${e.message}");
      throw (" ${e.response?.data['message'] ?? e.message}");
    }
  }

@override
  Future post(
    String path, {
    dynamic data,
    CancelToken? cancelToken,
    Map<String, dynamic>? queryParameters,
    bool isFromData = false,
        ProgressCallback? onSendProgress,

  }) async {
    try {
      final response = await dio.post(
        path,
        data: data,
        cancelToken: cancelToken,
        queryParameters: queryParameters,
        onSendProgress: onSendProgress,
      );
      return response;
    } on DioException catch (e) {
      print("DioException: ${e.message}");
      throw (" ${e.response?.data['message'] ?? e.message}");
    }
  }
  @override
  Future put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFromData = false,
  }) async {
    try {
      final response = await dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      print("DioException: ${e.message}");
      throw (" ${e.response?.data['message'] ?? e.message}");
    }
  }
}
