import 'package:dio/dio.dart';
import 'package:flutter_dio_sample/features/authentication/bloc/auth_bloc.dart';
import 'package:flutter_dio_sample/utils/network/dio/dio_client.dart';
import 'package:flutter_dio_sample/utils/network/helper/token_manager.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await TokenManager().getAccessToken();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401 -> unauthorized access error
    if (err.response?.statusCode == 401) {
      try {
        // get new accesstoken
        String? newAccesToken = await getRefreshToken();
        if (newAccesToken != null) {}

        err.requestOptions.headers['Authentication'] = 'Bearer $newAccesToken';

        // retry the failed request with new access token attached to request header
        return handler
            .resolve(await DioClient().client.fetch(err.requestOptions));
      } catch (e) {
        return handler.next(err);
      }
    }
    super.onError(err, handler);
  }
}

Future<String?> getRefreshToken() async {
  try {
    final refreshToken = TokenManager().getRefreshToken();
    final response = await DioClient()
        .client
        .post('account/token/refresh', data: {'refreshToken': refreshToken});
    final newAccessToken = response.data['accessToken'];
    TokenManager().setAccessToken(newAccessToken);
    return newAccessToken;
  } catch (e) {
    TokenManager().clearTokens();
    AuthBloc().add(AuthLogoutRequested());
  }
  return null;
}
