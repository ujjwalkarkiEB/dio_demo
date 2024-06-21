import 'package:flutter_dio_sample/utils/network/dio/auth_interceptor.dart';
import 'package:flutter_dio_sample/utils/network/dio/dio_client.dart';
import 'package:flutter_dio_sample/utils/network/helper/token_manager.dart';

import '../../model/user.dart';

class ApiService {
  ApiService._() {
    dioClient.addInterceptor(AuthInterceptor());
  }
  static final ApiService _instance = ApiService._();

  factory ApiService() => _instance;

  final dioClient = DioClient();

  Future<void> login(User user) async {
    try {
      final response = await dioClient.client.post('account/login',
          data: {'email': user.email, 'password': user.password});

      final accesstoken = response.data['accessToken'];
      TokenManager().setAccessToken(accesstoken);
    } catch (e) {
      print('login error: ${e.toString()}');
    }
  }

  Future<void> register(User user) async {
    try {
      await dioClient.client.post('account/register', data: {
        'userName': user.userName!,
        'email': user.email,
        'password': user.password,
        'repeat_password': user.password
      });
    } catch (e) {
      print('Register Error: ${e.toString()}');
    }
  }
}
