import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:first_project/exceptions/user_exceptions.dart';
import 'package:first_project/services/auth_service.dart';

typedef Token = Map<String, String>;

class User {
  final int id;
  String username;
  String created_at;
  String updated_at;
  Map<String, String>? tokens;

  User({
    required this.id,
    required this.username,
    required this.created_at,
    required this.updated_at,
    this.tokens,
  }) {}

  factory User.fromJson(Map<String, dynamic> json) {
    final user = User(
      id: json['id'],
      username: json['username'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
      tokens: json['tokens'] != null
          ? {
              'accessToken': json['tokens']['access_token'],
              'refreshToken': json['tokens']['refresh_token'],
            }
          : null,
    );

    return user;
  }

  String toJson() {
    return jsonEncode(
      {
        'userId': id,
        'userEmail': username,
        'userFirstName': created_at,
        'userLastName': updated_at,
      },
    );
  }
}
