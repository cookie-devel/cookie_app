import 'package:flutter/material.dart';
import 'package:cookie_app/model/jwt.dart';
import 'package:cookie_app/types/api/auth/signin.dart';
import 'package:cookie_app/types/jwt_payload.dart';
import 'package:cookie_app/repository/api/auth.dart';
import 'package:cookie_app/repository/storage/account.storage.dart';
import 'package:cookie_app/types/form/signin.dart';
import 'package:cookie_app/types/form/signup.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';
import 'package:cookie_app/viewmodel/base.viewmodel.dart';

class AuthViewModel extends BaseViewModel {
  bool _isSigned = false;
  bool get isSigned => _isSigned;

  final JWTModel _jwtModel = JWTModel();
  JWTPayload get jwtPayload => _jwtModel.getPayload();

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

      _jwtModel.save(response.access_token);
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
      await _jwtModel.delete();
      AccountStorage().deleteData();
      _isSigned = false;
    } catch (e) {
      print('Error signing out: $e');
    }

    setBusy(false);
  }
}
