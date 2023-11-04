import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:retrofit/retrofit.dart';

import 'package:cookie_app/datasource/api/auth.dart';
import 'package:cookie_app/datasource/storage/token.storage.dart';
import 'package:cookie_app/service/error.dart';
import 'package:cookie_app/utils/logger.dart';

class AuthService extends ChangeNotifier {
  // ignore: non_constant_identifier_names
  final ACCESS_TOKEN_HEADER = 'Authorization';
  // ignore: non_constant_identifier_names
  final REFRESH_TOKEN_HEADER = 'RefreshToken';

  final Dio _dio = Dio();
  get dio => _dio;

  TokenStorage tokenStorage = TokenStorage();

  late AuthRestClient _api;
  String? _accessToken;
  String? get accessToken => _accessToken;
  String? _refreshToken;
  String? get refreshToken => _refreshToken;

  ConnectionState _connectionState = ConnectionState.none;
  ConnectionState get connectionState => _connectionState;

  bool get isLoggedIn => _accessToken != null;

  AuthService() {
    tokenStorage.accessToken.then((token) {
      if (token != null) this._accessToken = token;
      notifyListeners();
    });
    tokenStorage.refreshToken.then((token) {
      if (token != null) this._refreshToken = token;
      notifyListeners();
    });

    _dio.interceptors.addAll([
      ErrorInterceptor(),
      accessTokenInterceptor,
      refreshTokenInterceptor,
      updateAccessTokenInterceptor,
      updateRefreshTokenInterceptor,
    ]);
    _dio.options.baseUrl = dotenv.env['BASE_URI']!;
    _api = AuthRestClient(_dio);
  }

  InterceptorsWrapper get accessTokenInterceptor {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        if (this._accessToken != null) {
          options.headers[ACCESS_TOKEN_HEADER] = this._accessToken;
          logger.i(
            'Interceptor injects "AccessToken" header: ${this._accessToken}',
          );
        }
        return handler.next(options);
      },
    );
  }

  InterceptorsWrapper get refreshTokenInterceptor {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        if (this._refreshToken != null) {
          options.headers[REFRESH_TOKEN_HEADER] = this._refreshToken;
          logger.i(
            'Interceptor injects "RefreshToken" header: ${this._refreshToken}',
          );
        }
        return handler.next(options);
      },
    );
  }

  InterceptorsWrapper get updateAccessTokenInterceptor {
    return InterceptorsWrapper(
      onResponse: (response, handler) async {
        if (response.headers[ACCESS_TOKEN_HEADER] != null) {
          String prevToken = this._accessToken.toString();
          setAccessToken(response.headers[ACCESS_TOKEN_HEADER]![0]);
          logger.i(
            'Interceptor updates "AccessToken" from $prevToken to ${this._accessToken}',
          );
        }

        return handler.next(response);
      },
    );
  }

  InterceptorsWrapper get updateRefreshTokenInterceptor {
    return InterceptorsWrapper(
      onResponse: (response, handler) async {
        if (response.headers[REFRESH_TOKEN_HEADER] != null) {
          String prevToken = this._refreshToken.toString();
          setRefreshToken(response.headers[REFRESH_TOKEN_HEADER]![0]);
          logger.i(
            'Interceptor updates "RefreshToken" from $prevToken to ${this._refreshToken}',
          );
        }

        return handler.next(response);
      },
    );
  }

  void setAccessToken(String token) async {
    this._accessToken = token;
    await tokenStorage.setAccessToken(token);
    notifyListeners();
  }

  void setRefreshToken(String token) async {
    this._refreshToken = token;
    await tokenStorage.setRefreshToken(token);
    notifyListeners();
  }

  Future<void> signIn({
    required String id,
    required String pw,
  }) async {
    _connectionState = ConnectionState.waiting;
    notifyListeners();
    // Handle Signin
    try {
      HttpResponse<void> res = await _api.postSignIn(userid: id, password: pw);
      logger.t('Signin res: ${res.response.headers}');
    } catch (e) {
      logger.e('Error signing in: $e');
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
      logger.e('Error signing up: $e');
      rethrow;
    } finally {
      _connectionState = ConnectionState.done;
      notifyListeners();
    }
  }

  void signOut() async {
    try {
      tokenStorage.deleteAccessToken();
      tokenStorage.deleteRefreshToken();
      this._accessToken = null;
      this._refreshToken = null;
    } catch (e) {
      logger.w('Error signing out: $e');
      rethrow;
    } finally {
      notifyListeners();
    }
  }
}
