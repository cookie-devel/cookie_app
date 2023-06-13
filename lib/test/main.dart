import 'package:cookie_app/view/components/RoundedImage.dart';
import 'package:flutter/material.dart';
import 'package:cookie_app/view/components/cookie.appbar.dart';

void main() {
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      home: Scaffold(
        appBar: CookieAppBar(title: '테스트'),
        body: const Center(
          child: RoundedImage(
            image: AssetImage('assets/images/kz1.png'),
          ),
        ),
      ),
    );
  }
}
// Run via `flutter run -t lib/test/main.dart`