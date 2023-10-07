import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logging/logging.dart';

import 'package:cookie_app/datasource/storage/jwt.storage.dart';
import 'package:cookie_app/types/jwt_payload.dart';

class JWTRepository {
  static final Logger _log = Logger('JWTRepository');

  static String? _token;
  static JWTPayload? _payload;

  static String? get token => _token;
  static JWTPayload? get payload {
    if (_token == null) {
      throw Exception('JWT token is null');
    }
    return _payload;
  }

  static Future<bool> setToken(String? token) async {
    if (JwtDecoder.isExpired(token!)) {
      _log.warning('JWT token is expired');
      return false;
    }

    _token = token;
    _payload = JWTPayload.fromJWT(token);
    await JWTStorage.write(token);

    return true;
  }

  static bool isExpired() {
    if (_token == null) {
      throw Exception('JWT token is null');
    }
    return JwtDecoder.isExpired(_token!);
  }

  static Future<void> flush() async {
    _token = null;
    _payload = null;
    return await JWTStorage.delete();
  }
}
