import 'package:dio/dio.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Api {
  final Dio api = Dio();
  String? accessToken;
  String? refreshToken;

  final _storage = const FlutterSecureStorage();

  Api() {
    api.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      if (!options.path.contains('http')) {
        options.path = 'http://localhost:3000/' + options.path;
      }

      print('path: ${options.path}');
      final accessTokenStorage = await _storage.read(key: 'access_token');

      options.headers['Authorization'] = 'Bearer $accessTokenStorage';
      return handler.next(options);
    }, onError: (error, handler) async {
      if ((error.response?.statusCode == 401 &&
          error.response?.data['message'] == "Invalid JWT")) {
        if (await _storage.containsKey(key: 'refresh_token')) {
          // if (await fetchRefreshToken()) {
          //   return handler.resolve(await _retry(error.requestOptions));
          // }
          await fetchRefreshToken();
        }
      }
      return handler.next(error);
    }));
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    return api.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  Future<bool> fetchRefreshToken() async {
    final refreshTokenStorage = await _storage.read(key: 'refresh_token');
    final response = await api.post('/auth/refresh', data: {
      'refreshToken': refreshTokenStorage,
    });

    if (response.statusCode == 200) {
      accessToken = response.data.accessToken;
      refreshToken = response.data.refreshToken;
      return true;
    } else {
      // refresh token is wrong
      accessToken = null;
      refreshToken = null;
      _storage.deleteAll();
      return false;
    }
  }
}
