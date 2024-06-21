import 'package:dio/dio.dart';
import 'package:flutter_dio_sample/utils/network/dio/dio_client.dart';
import 'package:flutter_dio_sample/utils/network/helper/token_manager.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await TokenManager().getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
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
        String newAccesToken = await getRefreshToken();
        // store locally
        TokenManager().setRefreshToken(newAccesToken);
        // add new token to the request header
        final reqOption = err.requestOptions;
        reqOption.headers['Authentication'] = 'Bearer $newAccesToken';

        // retry the failed request simply by cloning it
        return handler.resolve(await DioClient().client.request(reqOption.path,
            options:
                Options(method: reqOption.method, headers: reqOption.headers),
            data: reqOption.data,
            queryParameters: reqOption.queryParameters));
      } catch (e) {
        return handler.next(err);
      }
    }
    super.onError(err, handler);
  }
}

Future<String> getRefreshToken() async {
  final response = await DioClient().client.post('account/token/refresh');

  return response.data as String;
}
