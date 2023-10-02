import 'package:cookie_app/datasource/storage/jwt.storage.dart';
import 'package:cookie_app/firebase_options.dart';
import 'package:cookie_app/view/mainwidget.dart';
import 'package:cookie_app/view/pages/signin.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';
import 'package:cookie_app/viewmodel/auth.viewmodel.dart';
import 'package:cookie_app/viewmodel/chat.viewmodel.dart';
import 'package:cookie_app/viewmodel/friendlist.viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:logging/logging.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:provider/provider.dart';
import 'package:cookie_app/viewmodel/theme.viewmodel.dart';
import 'package:cookie_app/viewmodel/map.viewmodel.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  Logger.root.level = Level.INFO; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
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
          ChangeNotifierProvider<FriendsListViewModel>(
            create: (_) => FriendsListViewModel(),
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

class Cookie extends StatelessWidget {
  const Cookie({super.key});

  static const String _title = 'Cookie';

  @override
  Widget build(BuildContext context) {
    // FIXME: Maybe we should make something like CacheManager
    JWTStorage.read().then((value) {
      if (value != null) {
        context.read<AuthViewModel>().jwtSignIn(
              token: value,
              privateAccountViewModel: context.read<PrivateAccountViewModel>(),
            );
      }
      FlutterNativeSplash.remove();
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: context.watch<AuthViewModel>().isSigned
          ? const MainWidget()
          : const SignInWidget(),
      theme: context.watch<ThemeProvider>().theme,
    );
  }
}

// reference
// https://pub.dev/packages/badges [badges widget]
