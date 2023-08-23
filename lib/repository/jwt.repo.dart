import 'package:cookie_app/datasource/storage/jwt.storage.dart';
import 'package:cookie_app/types/jwt_payload.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class JWTRepository {
  // Singleton Instance
  static final JWTRepository _jwtRepo = JWTRepository._internal();
  factory JWTRepository() {
    return _jwtRepo;
  }
  JWTRepository._internal();

  String? _token;
  JWTPayload? _payload;

  get token => _token;
  get payload {
    if (_token == null) {
      throw Exception('JWT token is null');
    } else if (isExpired()) {
      throw Exception('JWT token is expired');
    }
    return _payload;
  }

  final JWTStorage _jwtStorage = JWTStorage();

  void setToken(String? token) async {
    _token = token;
    _payload = token != null ? JWTPayload.fromJWT(token) : null;
    await _jwtStorage.write(token);
  }

  bool isExpired() {
    if (_token == null) {
      throw Exception('JWT token is null');
    }
    return JwtDecoder.isExpired(_token!);
  }

  Future<void> flush() async {
    _token = null;
    _payload = null;
    return await _jwtStorage.delete();
  }
}
