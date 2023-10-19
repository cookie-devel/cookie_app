import 'package:flutter/material.dart';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:cookie_app/datasource/storage/jwt.storage.dart';
import 'package:cookie_app/firebase_options.dart';
import 'package:cookie_app/model/account/account_info.dart';
import 'package:cookie_app/types/api/account/info.dart';
import 'package:cookie_app/utils/navigation_service.dart';
import 'package:cookie_app/view/mainwidget.dart';
import 'package:cookie_app/view/pages/signin.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';
import 'package:cookie_app/viewmodel/auth.viewmodel.dart';
import 'package:cookie_app/viewmodel/chat.viewmodel.dart';
import 'package:cookie_app/viewmodel/friends.viewmodel.dart';
import 'package:cookie_app/viewmodel/map.viewmodel.dart';
import 'package:cookie_app/viewmodel/theme.viewmodel.dart';

void main() async {
  Logger.root.level = Level.INFO; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

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
        ChangeNotifierProvider(create: (context) => AuthProvider()),
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
  PrivateAccountModel? model;
  @override
  void initState() {
    super.initState();

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    loadJWT().then((_) {
      FlutterNativeSplash.remove();
    });
  }

  Future<void> loadJWT() async {
    String? token = await JWTStorage.read();
    if (context.mounted && token != null) {
      InfoResponse res =
          await context.read<AuthProvider>().jwtSignIn(token: token);
      setState(() {
        model = res.toPrivateAccount();
      });
    }
  }

  @override
  Widget build(BuildContext context) =>
      context.watch<AuthProvider>().token == null
          ? MaterialApp(
              debugShowCheckedModeBanner: false,
              title: Cookie._title,
              theme: context.watch<ThemeProvider>().theme,
              navigatorKey: SignAppNavigationService.navigatorKey,
              home: const SignInWidget(),
            )
          : MultiProvider(
              providers: [
                ChangeNotifierProvider<PrivateAccountViewModel>(
                  create: (_) => PrivateAccountViewModel(model: model),
                ),
                ChangeNotifierProvider<FriendsViewModel>(
                  create: (_) => FriendsViewModel(),
                ),
                ChangeNotifierProvider<ChatViewModel>(
                  create: (_) => ChatViewModel(),
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
