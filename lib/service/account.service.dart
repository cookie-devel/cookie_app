import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:cookie_app/datasource/api/account.dart';
import 'package:cookie_app/utils/logger.dart';

class AccountService {
  final Dio _dio = Dio();
  late RestClient _api;

  AccountService(String token) {
    _dio.options.baseUrl = dotenv.env['BASE_URI']!;
    _dio.options.headers['Authorization'] = 'Bearer $token';
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (e, handler) {
          logger.e('Error: $e');
          logger.t('Body: ${e.response?.data}');
          return handler.next(e);
        },
      ),
    );
    _api = RestClient(_dio);
  }

  Future<InfoResponse> getInfo() async {
    try {
      InfoResponse res = await _api.getInfo();
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
