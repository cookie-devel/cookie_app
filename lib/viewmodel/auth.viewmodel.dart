import 'package:cookie_app/repository/jwt.repo.dart';
import 'package:flutter/material.dart';
import 'package:cookie_app/types/api/auth/signin.dart';
import 'package:cookie_app/types/jwt_payload.dart';
import 'package:cookie_app/datasource/api/auth.dart';
import 'package:cookie_app/datasource/storage/account.storage.dart';
import 'package:cookie_app/types/form/signin.dart';
import 'package:cookie_app/types/form/signup.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';
import 'package:cookie_app/viewmodel/base.viewmodel.dart';
import 'package:logging/logging.dart';

class AuthViewModel extends BaseViewModel {
  final logger = Logger('AuthViewModel');
  bool _isSigned = false;
  bool get isSigned => _isSigned;

  final JWTRepository _jwtRepository = JWTRepository();
  JWTPayload get jwtPayload => _jwtRepository.payload;

  bool validate(GlobalKey<FormState> formKey) {
    return formKey.currentState!.validate();
  }

  Future<void> signIn({
    required String id,
    required String pw,
    required PrivateAccountViewModel privateAccountViewModel,
  }) async {
    setBusy(true);
    // Handle Signin
    try {
      SignInResponse response = await AuthAPI.postSignIn(
        SignInFormModel(
          id: id,
          pw: pw,
        ),
      );

      _jwtRepository.setToken(response.access_token);
      privateAccountViewModel.updateMyInfo(
        model: response.account.toPrivateAccount(),
      );

      _isSigned = true;
    } catch (e) {
      rethrow;
    } finally {
      setBusy(false);
    }
  }

  Future<void> signUp(SignUpFormModel signUpForm) async {
    setBusy(true);
    // Handle Signup
    try {
      await AuthAPI.postSignUp(signUpForm);
    } catch (e) {
      rethrow;
    } finally {
      setBusy(false);
    }
  }

  void signOut() async {
    setBusy(true);

    try {
      await _jwtRepository.flush();
      AccountStorage().deleteData();
      _isSigned = false;
    } catch (e) {
      logger.warning('Error signing out: $e');
    }

    setBusy(false);
  }
}
