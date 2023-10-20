import 'package:flutter/material.dart';

import 'package:retrofit/retrofit.dart';

import 'package:cookie_app/datasource/retrofit/account.dart';
import 'package:cookie_app/datasource/retrofit/auth.dart';
import 'package:cookie_app/datasource/retrofit/client.dart';
import 'package:cookie_app/datasource/storage/jwt.storage.dart';
import 'package:cookie_app/utils/logger.dart';
import 'package:cookie_app/viewmodel/base.viewmodel.dart';

class AuthProvider extends BaseChangeNotifier {
  final AuthRestClient _api = AuthApiClient().client;
  String? token;

  void setToken(String token) {
    JWTStorage.write(token);
    this.token = token;
    notifyListeners();
  }

  Future<InfoResponse> jwtSignIn({
    required String token,
  }) async {
    try {
      setConnectionState(ConnectionState.waiting);
      HttpResponse<SignInResponse> res = await _api.getSignIn(token);
      String? newToken =
          res.response.headers.value('Authorization')?.split(' ').elementAt(1);

      if (newToken != null)
        setToken(newToken);
      else
        setToken(token);

      setConnectionState(ConnectionState.done);
      return res.data.account;
    } catch (e) {
      rethrow;
    } finally {
      setConnectionState(ConnectionState.done);
    }
  }

  Future<void> signIn({
    required String id,
    required String pw,
  }) async {
    setConnectionState(ConnectionState.waiting);
    // Handle Signin
    try {
      HttpResponse<SignInResponse> res =
          await _api.postSignIn(SignInRequest(id: id, pw: pw));
      String? newToken =
          res.response.headers.value('Authorization')?.split(' ').elementAt(1);
      setToken(newToken!);
    } catch (e) {
      rethrow;
    } finally {
      setConnectionState(ConnectionState.done);
    }
  }

  Future<void> signUp(SignUpRequest signUpForm) async {
    setConnectionState(ConnectionState.waiting);
    // Handle Signup
    try {
      await _api.postSignUp(signUpForm);
    } catch (e) {
      rethrow;
    } finally {
      setConnectionState(ConnectionState.done);
    }
  }

  void signOut() async {
    try {
      JWTStorage.delete();
      token = null;
      notifyListeners();
    } catch (e) {
      logger.w('Error signing out: $e');
      rethrow;
    }
  }
}
