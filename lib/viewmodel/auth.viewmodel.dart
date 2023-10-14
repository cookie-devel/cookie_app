import 'package:flutter/material.dart';

import 'package:logging/logging.dart';

import 'package:cookie_app/datasource/api/auth.dart';
import 'package:cookie_app/datasource/storage/account.storage.dart';
import 'package:cookie_app/repository/jwt.repo.dart';
import 'package:cookie_app/types/api/auth/signin.dart';
import 'package:cookie_app/types/api/auth/signup.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';

class AuthViewModel extends ChangeNotifier {
  Logger log = Logger('AuthViewModel');

  bool _isSigned = false;
  bool get isSigned => _isSigned;

  bool validate(GlobalKey<FormState> formKey) {
    return formKey.currentState!.validate();
  }

  Future<bool> jwtSignIn({
    required String token,
    required PrivateAccountViewModel privateAccountViewModel,
  }) async {
    _isSigned = await JWTRepository.setToken(token);
    notifyListeners();
    if (!_isSigned) return false;

    SignInResponse response = await AuthAPI.getSignIn();
    privateAccountViewModel.model = response.account.toPrivateAccount();

    return true;
  }

  Future<void> signIn({
    required String id,
    required String pw,
    required PrivateAccountViewModel privateAccountViewModel,
  }) async {
    // Handle Signin
    try {
      SignInResponse response = await AuthAPI.postSignIn(
        SignInRequest(
          id: id,
          pw: pw,
        ),
      );

      privateAccountViewModel.model = response.account.toPrivateAccount();

      _isSigned = await JWTRepository.setToken(response.access_token);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUp(SignUpRequest signUpForm) async {
    // Handle Signup
    try {
      await AuthAPI.postSignUp(signUpForm);
    } catch (e) {
      rethrow;
    }
  }

  void signOut() async {
    try {
      await JWTRepository.flush();
      AccountStorage().deleteData();
      _isSigned = false;
    } catch (e) {
      log.warning('Error signing out: $e');
      rethrow;
    }
  }
}
