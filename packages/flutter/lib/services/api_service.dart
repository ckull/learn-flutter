import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:first_project/services/auth_service.dart';
import 'package:first_project/services/secure_storage_service.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:first_project/models/token_model.dart';
import 'package:http/http.dart' as http;
import 'package:first_project/services/secure_storage_service.dart';

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

      final accessTokenStorage = await _storage.read(key: 'access_token');

      options.headers['Authorization'] = 'Bearer $accessTokenStorage';
      return handler.next(options);
    }, onError: (DioException error, handler) async {
      if ((error.response?.statusCode == 401)) {
        if (await fetchRefreshToken()) {
          return handler.resolve(await _retry(error.requestOptions));
        } else {
          await AuthService.logout();
          return handler.next(error);
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

  Future<dynamic> fetchRefreshToken() async {
    // final userIdStorage = await _storage.read(key: 'user_id');
    // print('userIdStorage: $userIdStorage');

    try {
      final refreshTokenStorage = await _storage.read(key: 'refresh_token');
      print('refreshTokenStorage: $refreshTokenStorage');
      final String url = 'http://localhost:3000/auth/refresh';
      Dio _api = new Dio();
      final response = await _api.post(
        'http://localhost:3000/auth/refresh',
        options: Options(
          headers: {
            'authorization':
                'Bearer $refreshTokenStorage', // Set the content type if needed
          },
        ),
      );

      final json = jsonDecode(response.toString());

      // final tokens = Token.fromJson(json);
      final tokens = response.toString();
      print('tokens: ${json.toString()}');

      AuthService.saveStorage(
          SecureStorageService.accessTokenKey, json['access_token'].toString());
      AuthService.saveStorage(SecureStorageService.refreshTokenKey,
          json['refresh_token'].toString());
      return true;
    } catch (err) {
      print('error: $err');
      return false;
      throw Exception(err);
    }
  }
}
