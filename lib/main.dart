import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:cookie_app/datasource/storage/jwt.storage.dart';
import 'package:cookie_app/firebase_options.dart';
import 'package:cookie_app/view/mainwidget.dart';
import 'package:cookie_app/view/navigation_service.dart';
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

  // Load Data
  await dotenv.load();
  initializeDateFormatting().then(
    (_) => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>(
            create: (_) => ThemeProvider(),
          ),
          ChangeNotifierProvider<MapProvider>(
            create: (_) => MapProvider(),
          ),
          ChangeNotifierProvider<PrivateAccountViewModel>(
            create: (_) => PrivateAccountViewModel(),
          ),
          ChangeNotifierProvider<AuthViewModel>(
            create: (_) => AuthViewModel(),
          ),
          ChangeNotifierProvider<FriendsViewModel>(
            create: (_) => FriendsViewModel(),
          ),
          ChangeNotifierProvider<ChatViewModel>(
            create: (_) => ChatViewModel(),
          ),
        ],
        child: const Cookie(),
      ),
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
  @override
  void initState() {
    super.initState();

    JWTStorage.read().then((value) {
      if (value != null) {
        context.read<AuthViewModel>().jwtSignIn(
              token: value,
              privateAccountViewModel: context.read<PrivateAccountViewModel>(),
            );
      }
      FlutterNativeSplash.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Cookie._title,
      navigatorKey: NavigationService.navigatorKey,
      home: context.watch<AuthViewModel>().isSigned
          ? const MainWidget()
          : const SignInWidget(),
      theme: context.watch<ThemeProvider>().theme,
    );
  }
}

// reference
// https://pub.dev/packages/badges [badges widget]
