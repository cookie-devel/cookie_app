import 'package:cookie_app/view/components/RoundedImage.dart';
import 'package:flutter/material.dart';

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
        appBar: AppBar(title: const Text('테스트')),
        body: const Center(
          child: RoundedImage(
            // image: AssetImage('assets/images/kz1.png'),
            image: NetworkImage(
                "http://localhost:3000/uploads/minji57/minji57.profile.1687232627486.jpg",),
          ),
        ),
      ),
    );
  }
}
// Run via `flutter run -t lib/test/main.dart`
