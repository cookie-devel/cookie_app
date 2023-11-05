import 'package:flutter/material.dart';

import 'package:dio/dio.dart';

import 'package:cookie_app/datasource/api/auth.dart';
import 'package:cookie_app/service/auth.service.dart';

class AuthViewModel {
  late AuthService _authService;
  AuthViewModel(AuthService authService) {
    this._authService = authService;
  }

  Future<void> handleSignIn(
    String id,
    String pw,
  ) async {
    try {
      await _authService.signIn(id: id, pw: pw);
    } on DioException catch (e) {
      if (e.response != null)
        throw Exception('로그인에 실패하였습니다: ${e.response!.statusMessage!}');
      else
        throw Exception('로그인에 실패하였습니다: 서버와 연결할 수 없습니다.');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> handleSignUp(
    FormState formState,
    SignUpRequest signUpForm,
  ) async {
    try {
      await _authService.signUp(signUpForm);
    } on DioException catch (e) {
      if (e.response != null)
        throw Exception('로그인에 실패하였습니다: ${e.response!.statusMessage!}');
      else
        throw Exception('로그인에 실패하였습니다: 서버와 연결할 수 없습니다.');
    } catch (e) {
      rethrow;
    }
  }
}
