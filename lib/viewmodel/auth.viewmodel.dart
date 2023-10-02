import 'package:cookie_app/repository/jwt.repo.dart';
import 'package:cookie_app/types/api/auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:cookie_app/types/api/auth/signin.dart';
import 'package:cookie_app/datasource/api/auth.dart';
import 'package:cookie_app/datasource/storage/account.storage.dart';
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
    if (!_isSigned) return false;
    notifyListeners();

    // FIXME: Load PrivateAccountViewModel from cache

    // PrivateAccountModel? model =
    //     await PrivateAccountModel.fromStorage(storage: AccountStorage());
    // logger.shout('model: $model');
    // if (model == null) return false;
    // notifyListeners();

    // assert(model.id == JWTRepository.payload!.userid);

    // await privateAccountViewModel.updateMyInfo(
    //   model: model,
    // );

    return true;
  }

  Future<void> signIn({
    required String id,
    required String pw,
    required PrivateAccountViewModel privateAccountViewModel,
  }) async {
    setLoadState(busy: true, loaded: false);
    // Handle Signin
    try {
      SignInResponse response = await AuthAPI.postSignIn(
        SignInRequest(
          id: id,
          pw: pw,
        ),
      );

      privateAccountViewModel.updateMyInfo(
        model: response.account.toPrivateAccount(),
      );

      _isSigned = await JWTRepository.setToken(response.access_token);
      setLoadState(busy: false, loaded: true);
    } catch (e) {
      setLoadState(busy: false, loaded: false);
      rethrow;
    }
  }

  Future<void> signUp(SignUpRequest signUpForm) async {
    setLoadState(busy: true, loaded: false);
    // Handle Signup
    try {
      await AuthAPI.postSignUp(signUpForm);
      setLoadState(busy: false, loaded: true);
    } catch (e) {
      setLoadState(busy: false, loaded: false);
      rethrow;
    }
  }

  void signOut() async {
    setLoadState(busy: true, loaded: false);

    try {
      await JWTRepository.flush();
      AccountStorage().deleteData();
      _isSigned = false;
      setLoadState(busy: false, loaded: true);
    } catch (e) {
      setLoadState(busy: false, loaded: false);
      logger.warning('Error signing out: $e');
      rethrow;
    }
  }
}
