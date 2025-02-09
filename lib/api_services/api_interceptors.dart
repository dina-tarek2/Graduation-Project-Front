import 'package:dio/dio.dart';

class ApiInterceptors  extends Interceptor{
  @override
  //write here code you need to be done every time you send a request
  //headers are sent with request
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
      options.headers['token']='token';
    super.onRequest(options, handler);
  }
}