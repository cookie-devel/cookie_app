import 'package:cookie_app/repository/api/auth.dart';
import 'package:cookie_app/repository/storage/account.storage.dart';
import 'package:cookie_app/types/api/account/signin.dart';
import 'package:cookie_app/types/form/signin.dart';
import 'package:cookie_app/types/form/signup.dart';
import 'package:cookie_app/viewmodel/base.viewmodel.dart';
import 'package:cookie_app/repository/jwt.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends BaseViewModel {
  bool _isSigned = false;
  bool get isSigned => _isSigned;

  bool validate(GlobalKey<FormState> formKey) {
    return formKey.currentState!.validate();
  }

  // TODO: Implement Signin Properly
  Future<void> signIn({required String id, required String pw}) async {
    setBusy(true);
    // Handle Signin
    try {
      // SignInResponse result = await apiPostSignIn(
      //   SignInFormModel(
      //     id: id,
      //     pw: pw,
      //   ),
      // );
      SignInResponse response = await AuthAPI.postSignIn(
        SignInFormModel(
          id: id,
          pw: pw,
        ),
      );

      await JWT.write(response.access_token);

      // accountStorage.writeData()
      // accountStorage.writeJSON(response.account);

      // InfoResponse(
      //   account: result.account,
      // );

      // my = MyInfo.loadFromAccountInfo(result.account);

      _isSigned = true;
    } catch (e) {
      rethrow;
    } finally {
      setBusy(false);
    }

    // setBusy(false);

    // if (success) {
    //   JWT.write(result.access_token);

    //   Map<String, dynamic> account = (await result)['account'];
    //   my = MyInfoRepository.loadFromJSON(account);
    //   accountStorage.writeJSON(account);

    //   return true;
    // } else {
    //   return false;
    // }
  }

  void signUp(SignUpFormModel signUpForm) async {
    setBusy(true);
    // Handle Signup
    try {
      AuthAPI.postSignUp(signUpForm);
    } catch (e) {
      rethrow;
    }

    setBusy(false);
  }

  void signOut() async {
    setBusy(true);

    try {
      await JWT.delete();
      AccountStorage().deleteData();
      _isSigned = false;
    } catch (e) {
      print('Error signing out: $e');
    }

    setBusy(false);
  }
}
