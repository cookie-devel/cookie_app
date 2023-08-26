import 'package:cookie_app/model/account/account_info.dart';
import 'package:cookie_app/repository/jwt.repo.dart';
import 'package:flutter/material.dart';
import 'package:cookie_app/types/api/auth/signin.dart';
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

  bool validate(GlobalKey<FormState> formKey) {
    return formKey.currentState!.validate();
  }

  Future<bool> jwtSignIn({
    required String token,
    required PrivateAccountViewModel privateAccountViewModel,
  }) async {
    _isSigned = await JWTRepository.setToken(token);
    PrivateAccountModel? model =
        await PrivateAccountModel.fromStorage(storage: AccountStorage());
    if (model == null) return false;

    assert(model.userid == JWTRepository.payload!.userid);

    privateAccountViewModel.updateMyInfo(
      model: model,
    );

    return true;
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

      privateAccountViewModel.updateMyInfo(
        model: response.account.toPrivateAccount(),
      );

      _isSigned = await JWTRepository.setToken(response.access_token);
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
      await JWTRepository.flush();
      AccountStorage().deleteData();
      _isSigned = false;
    } catch (e) {
      logger.warning('Error signing out: $e');
    }

    setBusy(false);
  }
}
