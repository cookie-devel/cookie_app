import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class JWTStorage {
  static const String _key = 'access_token';
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static Future<String?> read() async {
    return await _secureStorage.read(key: _key);
  }

  static Future<void> write(String? token) async {
    await _secureStorage.write(key: _key, value: token);
  }

  static Future<void> delete() async {
    await _secureStorage.delete(key: _key);
  }
}
