import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class JWTRepository {
  @protected
  static const String _key = 'access_token';
  @protected
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  Future<String?> read();
}

class JWTRepositoryStorageImpl extends JWTRepository {
  @override
  Future<String?> read() async {
    return await JWTRepository._secureStorage.read(key: JWTRepository._key);
  }

  Future<void> write(String token) async {
    await JWTRepository._secureStorage
        .write(key: JWTRepository._key, value: token);
  }

  Future<void> delete() async {
    await JWTRepository._secureStorage.delete(key: JWTRepository._key);
  }
}
