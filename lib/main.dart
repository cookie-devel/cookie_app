import 'package:flutter/material.dart';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:cookie_app/firebase_options.dart';
import 'package:cookie_app/model/account/account.dart';
import 'package:cookie_app/service/auth.service.dart';
import 'package:cookie_app/view/main_app.dart';
iimport 'package:cookie_app/viewmodel/theme.provider.dart';

void main() async {
  // Preserve Splash Screen
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  timeago.setLocaleMessages('ko', timeago.KoMessages());

  AwesomeNotifications().initialize(
    'resource://drawable/res_app_icon',
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
      ),
      NotificationChannel(
        channelKey: 'chat_channel',
        channelName: '채팅',
        channelDescription: '채팅 알림',
      ),
    ],
  );

  // Load Data
  await dotenv.load();
  await initializeDateFormatting();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const Cookie(),
    ),
  );
}

class Cookie extends StatefulWidget {
  const Cookie({super.key});

  @override
  State<Cookie> createState() => _CookieState();
}

class _CookieState extends State<Cookie> {
  AccountModel? model;

  @override
  void initState() {
    super.initState();

    // Request Notification Permission
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed)
        AwesomeNotifications().requestPermissionToSendNotifications();
    });

    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return context.watch<AuthService>().isLoggedIn
        ? const MainApp()
        : const SignApp();
  }
}
