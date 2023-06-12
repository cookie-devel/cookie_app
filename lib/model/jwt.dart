import 'package:cookie_app/repository/jwt.repo.dart';
import 'package:cookie_app/types/jwt_payload.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class JWTModel {
  String? token;
  JWTPayload? payload;

  final JWTRepositoryStorageImpl _jwtStorage = JWTRepositoryStorageImpl();

  JWTModel({this.token}) {
    if (token != null) {
      payload = JWTPayload.fromJWT(token!);
    }
  }

  Future<void> loadFromStorage() async {
    token = await _jwtStorage.read();
    if (token != null) {
      payload = JWTPayload.fromJWT(token!);
    }
  }

  Future<void> save(String token) async {
    await _jwtStorage.write(token);
  }

  Future<void> delete() async {
    await _jwtStorage.delete();
  }

  JWTPayload getPayload() {
    if (token == null) {
      throw Exception('JWT token is null');
    }
    return JWTPayload.fromJWT(token!);
  }

  bool isExpired() {
    if (token == null) {
      throw Exception('JWT token is null');
    }
    return JwtDecoder.isExpired(token!);
  }
}
