import 'package:cookie_app/view/components/auth/signup.form.dart';
import 'package:flutter/material.dart';

class SignUpWidget extends StatelessWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('회원가입')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10, 45, 10, 25),
        child: SignUpForm(),
      ),
    );
  }
}
