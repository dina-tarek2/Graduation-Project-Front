import 'package:dio/dio.dart';
import 'package:graduation_project_frontend/api_services/api_consumer.dart';
import 'package:graduation_project_frontend/api_services/api_interceptors.dart';
import 'package:graduation_project_frontend/api_services/end_points.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;
  // to add dio in the construactor
  DioConsumer({required this.dio}) {
    dio.options.baseUrl = EndPoints.baseUrl;
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
      return Response.data;
    } on DioException catch (e) {
      // switch (e.type) {
      //   case dio
      // }
      print(e.toString());
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
        data: data,
        queryParameters: queryParameters,
      );
      return Response.data;
    } on DioException catch (e) {
      print(e.toString());
    }
    throw UnimplementedError();
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
      return Response.data;
    } on DioException catch (e) {
      print(e.toString());
    }
    throw UnimplementedError();
  }

  @override
  Future post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFromData = false,
  }) async {
    try {
      final Response = await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return Response.data;
    } on DioException catch (e) {
      print(e.toString());
    }
    throw UnimplementedError();
  }
}
