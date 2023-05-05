import 'package:cookie_app/handler/signinout.handler.dart';
import 'package:cookie_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cookie_app/pages/signin.dart';

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
    var signin = await handleAutoSignIn();

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

Widget loadingScreen() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        SizedBox(height: 24.0),
        CupertinoActivityIndicator(
          animating: true,
          color: Colors.deepOrangeAccent,
          radius: 35,
        ),
        SizedBox(height: 16.0),
        Text(
          "Loading",
          style: TextStyle(
            color: Colors.deepOrangeAccent,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
