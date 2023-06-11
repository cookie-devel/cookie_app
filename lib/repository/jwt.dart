import 'package:cookie_app/model/jwt_payload.dart';
import 'package:logger/logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';


class JWT {
  static String? token;
  static const String _key = 'access_token';
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // SingleTon Instance
  JWT._internal();
  static final JWT _singleton = JWT._internal();
  factory JWT() {
    return _singleton;
  }

  static Future<String?> read() async {
    JWT.token = await _secureStorage.read(key: _key);
    return JWT.token;
  }

  static Future<JWTPayload?> decode() async {
    try {
      return JWTPayload.fromJson(JwtDecoder.decode((JWT.token)!));
    } catch (error) {
      Logger().e(error);
      return null;
    }
  }

  static Future<void> write(String value) async {
    return await _secureStorage.write(key: _key, value: value);
  }

  static Future<void> delete() async {
    return await _secureStorage.delete(key: _key);
  }

  static Future<bool> isExpired() async {
    return JwtDecoder.isExpired((JWT.token)!);
  }
}
