import 'package:dio/dio.dart';
import 'package:flutter_dio_sample/utils/network/dio/auth_interceptor.dart';
import 'package:flutter_dio_sample/utils/network/dio/dio_client.dart';
import 'package:flutter_dio_sample/utils/network/helper/token_manager.dart';

import '../../model/user.dart';

class ApiService {
  ApiService._();

  static final ApiService _instance = ApiService._();
  factory ApiService() => _instance;

  final Dio dioClient = DioClient().client;

  Future<void> login(User user) async {
    try {
      final response = await dioClient.post(
        'account/login',
        data: {'email': user.email, 'password': user.password},
      );

      final accessToken = response.data['accessToken'];
      final refreshToken = response.data['refreshToken'];
      await TokenManager().setAccessToken(accessToken);
      await TokenManager().setRefreshToken(refreshToken);
    } on DioException catch (e) {
      if (e.response != null) {
        print(
            'Login Error: ${e.response!.statusCode} - ${e.response!.statusMessage}');
        throw 'Login failed: ${e.response!.data['message']}'; // Adjust error message based on API response
      } else {
        print('Network error: $e');
        throw 'Network error occurred'; // Handle network errors
      }
    } catch (e) {
      print('Generic Error: $e');
      throw 'Login failed'; // Catch any other unhandled exceptions
    }
  }

  Future<void> register(User user) async {
    try {
      await dioClient.post(
        'account/register',
        data: {
          'userName': user.userName!,
          'email': user.email,
          'password': user.password,
          'repeat_password': user.password
        },
      );
    } on DioException catch (e) {
      if (e.response != null) {
        print(
            'Register Error: ${e.response!.statusCode} - ${e.response!.statusMessage}');
        throw 'Registration failed: ${e.response!.data['message']}'; // Adjust error message based on API response
      } else {
        print('Network error: $e');
        throw 'Network error occurred'; // Handle network errors
      }
    } catch (e) {
      print('Generic Error: $e');
      throw 'Registration failed'; // Catch any other unhandled exceptions
    }
  }
}
