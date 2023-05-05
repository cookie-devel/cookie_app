import 'package:cookie_app/components/auth/signin.form.dart';
import 'package:flutter/material.dart';
import 'package:cookie_app/pages/signup.dart';
import 'package:cookie_app/cookie.appbar.dart';
import 'package:cookie_app/components/NavigatePage.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  final bool _idlengthCheck = false;
  final bool _pwlengthCheck = false;
  final bool _obscureText = true;

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  final String _selectedID = ''; //ID
  final String _selectedPW = ''; //password

  @override
  void initState() {
    super.initState();
    _idController.text = _selectedID;
    _pwController.text = _selectedPW;
  }

  @override
  void dispose() {
    // Dispose the TextEditingController
    _idController.dispose();
    _pwController.dispose();
    super.dispose();
  }

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
                // border: Border.all(
                //   // color: const Color.fromARGB(255, 255, 99, 159),
                // ),
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
