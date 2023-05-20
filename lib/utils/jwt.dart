import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

FlutterSecureStorage secureStorage = const FlutterSecureStorage();

class JWT {
  static Future<String?> token = secureStorage.read(key: 'access_token');

  static Future<String?> read() async {
    JWT.token = secureStorage.read(key: 'access_token');
    return JWT.token;
  }

  static Future<Map<String, dynamic>> decode() async {
    return JwtDecoder.decode((await JWT.token)!);
  }

  static Future<void> write(String value) async {
    return await secureStorage.write(key: 'access_token', value: value);
  }

  static Future<void> delete() async {
    return await secureStorage.delete(key: 'access_token');
  }
}
