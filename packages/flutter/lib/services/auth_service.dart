import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:first_project/exceptions/form_exceptions.dart';
import 'package:first_project/exceptions/secure_storage_exceptions.dart';
import 'package:first_project/models/user_model.dart';
import 'package:first_project/services/helper_service.dart';

import 'package:first_project/services/secure_storage_service.dart';
import 'package:first_project/services/api_service.dart';
import 'package:first_project/models/token_model.dart';

class AuthService {
  static const String loginPath = 'token/';
  static const String registerPath = 'users/';
  static const String refreshPath = 'token/refresh/';
  static const String verifyPath = 'token/verify/';

  static Future<User> loadUser() async {
    try {
      final user = await Api().api.get('auth/user');
      final json = jsonDecode(user.toString());
      print(json);
      return User.fromJson(json);
    } catch (err) {
      print('error: $err.toString()');
      throw Exception(err);
    }
  }

  static void saveTokens(Map<String, String> tokens) async {
    print('saveTokens: ${tokens.toString()}');
    await SecureStorageService.storage.write(
      key: SecureStorageService.accessTokenKey,
      value: tokens['accessToken'].toString(),
    );

    await SecureStorageService.storage.write(
      key: SecureStorageService.refreshTokenKey,
      value: tokens['refreshToken'].toString(),
    );
  }

  static void saveStorage(String key, String value) async {
    try {
      await SecureStorageService.storage.write(
        key: key,
        value: value,
      );
    } catch (err) {
      throw Exception(err);
    }
  }

  static void saveUser(int userId) async {
    await SecureStorageService.storage.write(
      key: SecureStorageService.userKey,
      value: userId.toString(),
    );
  }

  // static Future<void> refreshToken(User user) async {
  //   final response = await http.post(
  //     HelperService.buildUri(refreshPath),
  //     headers: HelperService.buildHeaders(),
  //     body: jsonEncode(
  //       {
  //         'refreshToken': user.tokens['refreshToken'],
  //       },
  //     ),
  //   );

  //   final statusType = (response.statusCode / 100).floor() * 100;
  //   switch (statusType) {
  //     case 200:
  //       final json = jsonDecode(response.body);
  //       user.tokens['accessToken'] = json['access'];
  //       saveUser(user);
  //       break;
  //     case 400:
  //     case 300:
  //     case 500:
  //     default:
  //       throw Exception('Error contacting the server!');
  //   }
  // }

  static Future<User> register({
    required String email,
    required String password,
    required String cellphone,
    required String firstName,
    required String lastName,
  }) async {
    final response = await http.post(
      HelperService.buildUri(loginPath),
      headers: HelperService.buildHeaders(),
      body: jsonEncode(
        {
          'email': email,
          'password': password,
          'cellphone': cellphone,
          'first_name': firstName,
          'last_name': lastName
        },
      ),
    );

    final statusType = (response.statusCode / 100).floor() * 100;
    switch (statusType) {
      case 200:
        final json = jsonDecode(response.body);
        final user = User.fromJson(json);

        // saveUser(user);

        return user;
      case 400:
        final json = jsonDecode(response.body);
        throw handleFormErrors(json);
      case 300:
      case 500:
      default:
        throw FormGeneralException(message: 'Error contacting the server!');
    }
  }

  static Future<void> logout() async {
    await SecureStorageService.storage.delete(
      key: SecureStorageService.userKey,
    );

    await SecureStorageService.storage.delete(
      key: SecureStorageService.accessTokenKey,
    );

    await SecureStorageService.storage.delete(
      key: SecureStorageService.refreshTokenKey,
    );
  }

  static Future<User> login({
    required String username,
    required String password,
  }) async {
    print('login');
    try {
      final response = await Api().api.post(
        'auth/signin',
        data: {
          'username': username,
          'password': password,
        },
      );

      // print('response: ' + response.toString());
      final json = jsonDecode(response.toString());
      final user = User.fromJson(json);

      saveUser(user.id);
      return user;
    } catch (err) {
      throw Exception(err);
    }
  }
}
