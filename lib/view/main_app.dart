import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:cookie_app/service/account.service.dart';
import 'package:cookie_app/service/auth.service.dart';
import 'package:cookie_app/service/chat.service.dart';
import 'package:cookie_app/theme/theme.provider.dart';
import 'package:cookie_app/utils/navigation_service.dart';
import 'package:cookie_app/view/main_widget.dart';
import 'package:cookie_app/viewmodel/map.viewmodel.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService authService = context.read<AuthService>();

    assert(authService.accessToken != null);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AccountService>(
          create: (_) => AccountService(authService),
        ),
        ChangeNotifierProvider<ChatService>(
          create: (_) => ChatService(authService.accessToken!),
        ),
        ChangeNotifierProvider<MapViewModel>(
          create: (_) => MapViewModel(authService.accessToken!),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cookie',
        theme: context.watch<ThemeProvider>().theme,
        navigatorKey: NavigationService.navigatorKey,
        home: const MainWidget(),
      ),
    );
  }
}
