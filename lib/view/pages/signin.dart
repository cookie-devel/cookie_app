import 'package:cookie_app/view/components/auth/signin.form.dart';
import 'package:cookie_app/view/components/cookie.appbar.dart';
import 'package:flutter/material.dart';
import 'package:cookie_app/view/pages/signup.dart';
import 'package:cookie_app/view/components/NavigatePage.dart';

class SignInWidget extends StatelessWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CookieAppBar(title: 'C🍪🍪KIE'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(10, 55, 10, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Logo
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/images/cookie_logo.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 30),
            SignInForm(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: const Text(
                    '> 아이디/비밀번호 찾기',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                  onPressed: () {
                    // navigateSlide(context, const FindIdPwWidget());
                  },
                ),
                const SizedBox(width: 10),
                TextButton(
                  child: const Text(
                    '> 회원가입',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                  onPressed: () {
                    navigateSlide(context, const SignUpWidget());
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
