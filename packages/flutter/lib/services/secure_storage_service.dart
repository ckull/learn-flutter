import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const storage = FlutterSecureStorage();

  static const String userKey = 'user';
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
}
