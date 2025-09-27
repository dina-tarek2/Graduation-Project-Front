import 'package:dio/dio.dart';
import 'package:radintel/api_services/api_consumer.dart';
import 'package:radintel/api_services/api_interceptors.dart';
import 'package:radintel/api_services/end_points.dart';

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
    
    // Configure Dio to handle 500 errors gracefully
    dio.options.validateStatus = (status) {
      return status != null && status < 500; // Don't throw for 4xx errors, only 5xx
    };
    
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

  // Helper method to handle DioException errors consistently
  String _handleDioException(DioException e) {
    print("DioException: ${e.message}");
    
    if (e.response != null) {
      // Server responded with error status
      String errorMessage;
      
      // Check for the specific rate limiting error format
      if (e.response?.data != null && e.response?.data['error'] != null) {
        errorMessage = e.response?.data['error'];
        
        // If it's a rate limiting error, add retry information
        if (e.response?.data['retryAfter'] != null) {
          int retryAfter = e.response?.data['retryAfter'];
          int minutes = (retryAfter / 60).round();
          errorMessage += " Please try again in $minutes minutes.";
        }
      } else {
        errorMessage = e.response?.data?['message'] ?? 
                      e.response?.data?['error'] ?? 
                      'Server error: ${e.response?.statusCode}';
      }
      
      return errorMessage;
    } else if (e.type == DioExceptionType.connectionTimeout || 
               e.type == DioExceptionType.receiveTimeout) {
      return 'Connection timeout. Please check your internet connection.';
    } else if (e.type == DioExceptionType.connectionError) {
      return 'Network error. Please check your internet connection.';
    } else {
      return e.message ?? 'An unexpected error occurred.';
    }
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
      throw _handleDioException(e);
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
      throw _handleDioException(e);
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
      throw _handleDioException(e);
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
      throw _handleDioException(e);
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
      throw _handleDioException(e);
    }
  }
}
