import 'package:cookie_app/view/components/auth/signup.form.dart';
import 'package:cookie_app/view/components/cookie.appbar.dart';
import 'package:flutter/material.dart';

class SignUpWidget extends StatelessWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CookieAppBar(title: '회원가입'),
      body: const SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10, 45, 10, 25),
        child: SignUpForm(),
      ),
    );
  }
}
