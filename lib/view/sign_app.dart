import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:cookie_app/utils/navigation_service.dart';
import 'package:cookie_app/view/pages/signin.dart';
import 'package:cookie_app/viewmodel/theme.provider.dart';

class SignApp extends StatelessWidget {
  const SignApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cookie Login',
      theme: context.watch<ThemeProvider>().theme,
      navigatorKey: SignAppNavigationService.navigatorKey,
      home: const SignInWidget(),
    );
  }
}
