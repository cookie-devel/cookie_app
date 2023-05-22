import 'package:cookie_app/pages/signin.dart';
import 'package:cookie_app/utils/myinfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cookie_app/handler/socket.io/socket.dart';
import 'package:cookie_app/pages/maps/maps.tab.dart';
import 'package:cookie_app/pages/friends/friends.tab.dart';
import 'package:cookie_app/pages/settings/settings.tab.dart';
import 'package:cookie_app/pages/chatroom/chatrooms.tab.dart';
import 'package:cookie_app/pages/club/club.tab.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:cookie_app/handler/signinout.handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cookie_app/components/ThemeData.dart';
import 'package:provider/provider.dart';
import 'package:cookie_app/utils/themeProvider.dart';
import 'package:cookie_app/utils/mapProvider.dart';

void main() async {
  // Preserve Splash Screen
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  timeago.setLocaleMessages('ko', timeago.KoMessages());

  // Load Data
  await dotenv.load();
  bool autoSignIn = await checkJWT();

  if (autoSignIn) {
    await my.loadFromStorage();
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
      ],
      child: Cookie(signin: autoSignIn),
    ),
  );
}

class Cookie extends StatelessWidget {
  final bool signin;
  Cookie({super.key, required this.signin});

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
          home: signin ? const MainWidget() : const SignInWidget(),
          theme: isDarkModeEnabled ? darkThemeData() : defaultThemeData(),
        );
      },
    );
  }
}

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  DateTime? currentBackPressTime;
  Future<bool> _onWillPop() async {
    final currentTime = DateTime.now();
    final backButtonInterval = currentBackPressTime == null
        ? const Duration(milliseconds: 1500)
        : currentTime.difference(currentBackPressTime!);

    if (backButtonInterval >= const Duration(milliseconds: 1500)) {
      currentBackPressTime = currentTime;
      Fluttertoast.showToast(
        msg: '\'뒤로\' 버튼을 다시 누르면 종료됩니다.',
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black.withOpacity(0.2),
        textColor: Colors.white,
      );
      return false;
    }
    return true;
  }

  static const List<Widget> _widgetOptions = <Widget>[
    FriendsGrid(),
    ChatTabWidget(),
    MapsWidget(),
    ClubGrid(),
    SettingsWidget(),
  ];

  BottomNavigationBarItem iconItem(
    String text,
    IconData iconName,
    String label, [
    Color color = const Color(0xFF66BB6A),
  ]) {
    if (text.isEmpty) {
      return BottomNavigationBarItem(
        icon: Icon(iconName),
        label: label,
      );
    } else {
      return BottomNavigationBarItem(
        icon: badges.Badge(
          position: badges.BadgePosition.topEnd(top: -8, end: -8),
          badgeStyle: badges.BadgeStyle(
            borderSide: const BorderSide(color: Colors.white, width: 1),
            shape: badges.BadgeShape.circle,
            badgeColor: color,
          ),
          badgeContent: SizedBox(
            width: 8,
            height: 8,
            child: FittedBox(
              fit: BoxFit.cover,
              child: Text(
                text.length > 3 ? '999+' : text,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          child: Icon(iconName),
        ),
        label: label,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: SizedBox(
          height: kBottomNavigationBarHeight +
              MediaQuery.of(context).padding.bottom,
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 15,
                        spreadRadius: 5,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                ),
              ),
              BottomNavigationBar(
                items: [
                  iconItem(
                    '1111',
                    Icons.people,
                    '친구',
                  ),
                  iconItem(
                    '2',
                    Icons.chat_bubble,
                    '채팅',
                  ),
                  iconItem(
                    '',
                    Icons.cookie,
                    '쿠키',
                  ),
                  iconItem(
                    '3',
                    Icons.sports_basketball,
                    '클럽',
                  ),
                  iconItem(
                    '4',
                    Icons.settings,
                    '설정',
                  ),
                ],
                currentIndex: _selectedIndex,
                onTap: (i) => setState(() => _selectedIndex = i),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// reference
// https://pub.dev/packages/badges [badges widget]
