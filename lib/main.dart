import 'package:flutter/material.dart';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:cookie_app/datasource/api/account.dart';
import 'package:cookie_app/datasource/storage/jwt.storage.dart';
import 'package:cookie_app/firebase_options.dart';
import 'package:cookie_app/model/account/account.dart';
import 'package:cookie_app/service/account.service.dart';
import 'package:cookie_app/service/auth.service.dart';
import 'package:cookie_app/service/chat.service.dart';
import 'package:cookie_app/utils/logger.dart';
import 'package:cookie_app/utils/navigation_service.dart';
import 'package:cookie_app/view/mainwidget.dart';
import 'package:cookie_app/view/pages/signin.dart';
import 'package:cookie_app/viewmodel/auth.viewmodel.dart';
import 'package:cookie_app/viewmodel/map.viewmodel.dart';
import 'package:cookie_app/viewmodel/theme.provider.dart';

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

  static const String _title = 'Cookie';

  @override
  State<Cookie> createState() => _CookieState();
}

class _CookieState extends State<Cookie> {
  AccountModel? model;

  @override
  void initState() {
    super.initState();

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    loadJWT().onError((error, stackTrace) {
      logger.w(error.toString());
    }).whenComplete(() => FlutterNativeSplash.remove());
  }

  Future<void> loadJWT() async {
    String? token = await JWTStorage.read();
    if (token == null) return;
    if (context.mounted) {
      InfoResponse res;
      try {
        res = await context.read<AuthService>().jwtSignIn(token: token);
        setState(() {
          model = res.toPrivateAccount();
        });
      } catch (e) {
        logger.w(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String? token = context.watch<AuthService>().token;
    return token == null
        ? Provider<AuthViewModel>(
            create: (_) => AuthViewModel(context.read<AuthService>()),
            builder: (context, child) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: Cookie._title,
              theme: context.watch<ThemeProvider>().theme,
              navigatorKey: SignAppNavigationService.navigatorKey,
              home: const SignInWidget(),
            ),
          )
        : MultiProvider(
            providers: [
              ChangeNotifierProvider<AccountService>(
                create: (_) => AccountService(token),
              ),
              ChangeNotifierProvider<ChatService>(
                create: (_) => ChatService(token),
              ),
              ChangeNotifierProvider<MapViewModel>(
                create: (_) => MapViewModel(),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: Cookie._title,
              theme: context.watch<ThemeProvider>().theme,
              navigatorKey: NavigationService.navigatorKey,
              home: const MainWidget(),
            ),
          );
  }
}
