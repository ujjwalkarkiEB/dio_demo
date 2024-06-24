import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'auth_interceptor.dart';

class DioClient {
  // Static instance of DioClient
  static final DioClient _instance = DioClient._();

  // Dio instance
  final Dio _client;

  // Private constructor
  DioClient._()
      : _client = Dio(BaseOptions(
            baseUrl: 'http://10.0.2.2:8000/api/',
            connectTimeout: const Duration(seconds: 6000),
            receiveTimeout: const Duration(seconds: 6000),
            contentType: 'application/json',
            responseType: ResponseType.json));

  // Factory constructor to return the same DioClient instance
  factory DioClient() {
    return _instance;
  }

  // Getter to access the Dio client
  Dio get client => _client;
  void setupInterceptors(BuildContext context) {
    _client.interceptors.add(AuthInterceptor(context: context));
  }
}
