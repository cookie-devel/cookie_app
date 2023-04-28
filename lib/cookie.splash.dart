import 'package:cookie_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cookie_app/handler/storage.dart';
import 'package:cookie_app/pages/signin.dart';

class CookieSplash extends StatefulWidget {
  const CookieSplash({super.key});

  @override
  State<CookieSplash> createState() => _CookieSplashState();
}

class _CookieSplashState extends State<CookieSplash>{
  
  bool _isStorageExist = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    checkStorage();
  }
  
  Future<void> checkStorage() async {

    final id = await storage.read(key: 'id');
    final pw = await storage.read(key: 'pw');

    await Future.delayed(Duration.zero);

    if (id != null && pw != null) {
      setState(() {
        _isStorageExist = true;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isStorageExist = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.deepOrangeAccent,

      body: _isLoading ? isLoadingScreen()
      :_isStorageExist ? const MyStatefulWidget() : const SignInWidget(),

    );
  }
}

Widget isLoadingScreen(){
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        SizedBox(height: 24.0),
        CupertinoActivityIndicator(
          animating: true,
          color: Colors.white,
          radius: 35,
        ),
        SizedBox(height: 16.0),
        Text(
          "Loading",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}