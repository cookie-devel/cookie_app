import 'package:flutter/material.dart';

import 'package:cookie_app/datasource/api/auth.dart';
import 'package:cookie_app/service/auth.service.dart';

class AuthViewModel {
  late AuthService _authService;
  AuthViewModel(AuthService authService) {
    this._authService = authService;
  }

  Future<void> handleSignIn(
    FormState formState,
    String id,
    String pw,
  ) async {
    if (!formState.validate()) return;
    formState.save();
    await _authService.signIn(id: id, pw: pw);
    return;
  }

  Future<void> handleSignUp(
    FormState formState,
    SignUpRequest signUpForm,
  ) async {
    if (!formState.validate()) return;
    formState.save();

    try {
      await _authService.signUp(signUpForm);
    } catch (e) {
      rethrow;
    }
  }
}
