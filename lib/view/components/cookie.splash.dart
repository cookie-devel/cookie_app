import 'package:cookie_app/main.dart';
import 'package:cookie_app/repository/jwt.dart';
import 'package:flutter/material.dart';
import 'package:cookie_app/view/pages/signin.dart';
import 'loading.dart';

class CookieSplash extends StatefulWidget {
  const CookieSplash({super.key});

  @override
  State<CookieSplash> createState() => _CookieSplashState();
}

class _CookieSplashState extends State<CookieSplash> {
  bool _isStorageExist = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    checkStorage();
  }

  Future<void> checkStorage() async {
    var signin = !(await JWT.isExpired());

    if (signin) {
      setState(() {
        _isStorageExist = false;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isStorageExist = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? loadingScreen()
          : _isStorageExist
              ? const SignInWidget()
              : const MainWidget(),
      // :_isStorageExist ? const MyStatefulWidget() : const SignInWidget(),
    );
  }
}
