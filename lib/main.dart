import 'package:cookie_app/view/mainwidget.dart';
import 'package:cookie_app/view/pages/signin.dart';
import 'package:cookie_app/repository/jwt.dart';
import 'package:cookie_app/viewmodel/auth.viewmodel.dart';
import 'package:cookie_app/viewmodel/myinfo.viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cookie_app/socket.io/socket.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cookie_app/view/components/ThemeData.dart';
import 'package:provider/provider.dart';
import 'package:cookie_app/viewmodel/theme.viewmodel.dart';
import 'package:cookie_app/viewmodel/map.viewmodel.dart';

void main() async {
  // Preserve Splash Screen
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  timeago.setLocaleMessages('ko', timeago.KoMessages());

  // Load Data
  await dotenv.load();
  bool autoSignIn = !(await JWT.isExpired());

  if (autoSignIn) {
    // await my.loadFromStorage();
    socketHandler.connect();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider<MapProvider>(
          create: (_) => MapProvider(),
        ),
        ChangeNotifierProvider<MyInfoViewModel>(
          create: (_) => MyInfoViewModel(),
        ),
        ChangeNotifierProvider<AuthViewModel>(
          create: (_) => AuthViewModel(),
        )
      ],
      child: const Cookie(),
    ),
  );
}

class Cookie extends StatelessWidget {
  const Cookie({super.key});

  static const String _title = 'Cookie';

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final isDarkModeEnabled = themeProvider.isDarkModeEnabled;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: _title,
          home: Provider.of<AuthViewModel>(context, listen: true).isSigned
              ? const MainWidget()
              : const SignInWidget(),
          theme: isDarkModeEnabled ? darkThemeData() : defaultThemeData(),
        );
      },
    );
  }
}

// reference
// https://pub.dev/packages/badges [badges widget]
