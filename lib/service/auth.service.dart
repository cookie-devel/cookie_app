import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:retrofit/retrofit.dart';

import 'package:cookie_app/datasource/api/account.dart';
import 'package:cookie_app/datasource/api/auth.dart';
import 'package:cookie_app/datasource/storage/jwt.storage.dart';
import 'package:cookie_app/utils/logger.dart';

class AuthService extends ChangeNotifier {
  final Dio _dio = Dio();
  late AuthRestClient _api;
  String? _token;
  ConnectionState _connectionState = ConnectionState.none;
  ConnectionState get connectionState => _connectionState;

  AuthService({String? token}) {
    this._token = token;
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (e, handler) {
          logger.e('Error: $e');
          logger.t('Body: ${e.response?.data}');
          return handler.next(e);
        },
      ),
    );
    _dio.options.baseUrl = dotenv.env['BASE_URI']!;
    _api = AuthRestClient(_dio);
  }

  String? get token => _token;
  set token(String? token) {
    JWTStorage.write(token);
    this._token = token;
    _dio.options.headers['Authorization'] = 'Bearer $token';
    _api = AuthRestClient(_dio);
    notifyListeners();
  }

  Future<InfoResponse> jwtSignIn({
    required String token,
  }) async {
    try {
      _connectionState = ConnectionState.waiting;
      notifyListeners();
      logger.t('JWT Signin with token: $token');
      HttpResponse<SignInResponse> res = await _api.getSignIn(token);
      String? newToken =
          res.response.headers.value('Authorization')?.split(' ').elementAt(1);

      this.token = newToken ?? token;

      return res.data.account;
    } catch (e) {
      rethrow;
    } finally {
      _connectionState = ConnectionState.done;
      notifyListeners();
    }
  }

  Future<void> signIn({
    required String id,
    required String pw,
  }) async {
    _connectionState = ConnectionState.waiting;
    notifyListeners();
    // Handle Signin
    try {
      HttpResponse<SignInResponse> res =
          await _api.postSignIn(userid: id, password: pw);
      logger.t('Signin res: ${res.response.headers}');
      String? newToken =
          res.response.headers.value('Authorization')?.split(' ').elementAt(0);
      this.token = newToken!;
    } catch (e) {
      rethrow;
    } finally {
      _connectionState = ConnectionState.done;
      notifyListeners();
    }
  }

  Future<void> signUp(SignUpRequest signUpForm) async {
    _connectionState = ConnectionState.waiting;
    notifyListeners();
    // Handle Signup
    try {
      await _api.postSignUp(signUpForm);
    } catch (e) {
      rethrow;
    } finally {
      _connectionState = ConnectionState.done;
      notifyListeners();
    }
  }

  void signOut() async {
    try {
      JWTStorage.delete();
      this.token = null;
    } catch (e) {
      logger.w('Error signing out: $e');
      rethrow;
    } finally {
      notifyListeners();
    }
  }
}
