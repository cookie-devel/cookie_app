import 'package:cookie_app/theme/dark.dart';
import 'package:cookie_app/theme/default.dart';
import 'package:cookie_app/view/mainwidget.dart';
import 'package:cookie_app/view/pages/signin.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';
import 'package:cookie_app/viewmodel/auth.viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:timeago/timeago.dart' as timeago;
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
  Future.delayed(const Duration(milliseconds: 1000));
  // bool autoSignIn = !(await JWT.isExpired());
  // bool autoSignIn = !JWTModel.fromJWT((await JWTRepositoryStorageImpl().read())!).isExpired();

  // if (autoSignIn) {
  //   // await my.loadFromStorage();
  //   await socketHandler.connect();
  // }

  runApp(
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
          theme: isDarkModeEnabled ? darkThemeData : defaultThemeData,
        );
      },
    );
  }
}

// reference
// https://pub.dev/packages/badges [badges widget]
