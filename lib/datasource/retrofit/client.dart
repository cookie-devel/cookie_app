import 'package:dio/dio.dart';

import 'package:cookie_app/datasource/retrofit/account.dart';
import 'package:cookie_app/datasource/retrofit/auth.dart';

class ApiClient {
  late RestClient _client;

  get client => _client;

  ApiClient(String token) {
    Dio dio = Dio(
      BaseOptions(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
    _client = RestClient(dio);
  }

  set accessToken(String token) {
    Dio dio = Dio(BaseOptions(headers: {'Authorization': 'Bearer $token'}));
    _client = RestClient(dio);
  }
}

class AuthApiClient {
  late Dio dio;
  late AuthRestClient _client;

  AuthRestClient get client => _client;

  AuthApiClient() {
    dio = Dio();
    _client = AuthRestClient(dio);
  }

  set accessToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }
}
