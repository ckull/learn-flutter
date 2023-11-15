import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:first_project/exceptions/user_exceptions.dart';
import 'package:first_project/services/auth_service.dart';

class Token {
  String accessToken;
  String refreshToken;

  Token({
    required this.accessToken,
    required this.refreshToken,
  }) {}

  factory Token.fromJson(Map<String, dynamic> json) {
    final token = Token(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );

    return token;
  }
}
