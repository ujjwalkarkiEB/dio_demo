import 'package:dio/dio.dart';
import 'package:flutter_dio_sample/utils/network/dio/auth_interceptor.dart';

class DioClient {
  final Dio _client;

  // Constructor to initialize DioClient with optional baseUrl
  DioClient({String baseUrl = 'http://10.0.2.2:8000/api/'})
      : _client = Dio(BaseOptions(baseUrl: baseUrl)) {
    _client.interceptors.add(AuthInterceptor());
  }

  // Public getter to access the Dio client
  Dio get client => _client;

  // Method to add interceptors
  void addInterceptor(Interceptor interceptor) {
    _client.interceptors.add(interceptor);
  }
}
