import 'package:flutter/material.dart';

import 'package:logging/logging.dart';

import 'package:cookie_app/datasource/api/auth.dart';
import 'package:cookie_app/datasource/storage/account.storage.dart';
import 'package:cookie_app/types/api/account/info.dart';
import 'package:cookie_app/types/api/auth/signin.dart';
import 'package:cookie_app/types/api/auth/signup.dart';
import 'package:cookie_app/viewmodel/base.viewmodel.dart';

class AuthProvider extends BaseChangeNotifier {
  Logger log = Logger('AuthProvider');

  String? token;

  bool validate(GlobalKey<FormState> formKey) {
    return formKey.currentState!.validate();
  }

  Future<InfoResponse> jwtSignIn({
    required String token,
  }) async {
    try {
      setConnectionState(ConnectionState.waiting);
      SignInResponse res = await AuthAPI.getSignIn(token);
      this.token = res.access_token;
      setConnectionState(ConnectionState.done);
      return res.account;
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
      SignInResponse response = await AuthAPI.postSignIn(
        SignInRequest(
          id: id,
          pw: pw,
        ),
      );
      token = response.access_token;
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
      await AuthAPI.postSignUp(signUpForm);
    } catch (e) {
      rethrow;
    } finally {
      setConnectionState(ConnectionState.done);
    }
  }

  void signOut() async {
    try {
      AccountStorage().deleteData();
      token = null;
      notifyListeners();
    } catch (e) {
      log.warning('Error signing out: $e');
      rethrow;
    }
  }
}
