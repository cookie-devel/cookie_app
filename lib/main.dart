import 'package:cookie_app/pages/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cookie_app/handler/socket.io/socket.dart';
import 'package:cookie_app/pages/tabs/maps/maps.tab.dart';
import 'package:cookie_app/pages/tabs/friends/friends.tab.dart';
import 'package:cookie_app/pages/tabs/settings/settings.tab.dart';
import 'package:cookie_app/pages/tabs/chatrooms/chatrooms.tab.dart';
import 'package:cookie_app/pages/tabs/club/club.tab.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:cookie_app/handler/signinout.handler.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() async {
  // Preserve Splash Screen
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Load Data
  await dotenv.load();
  bool autoSignIn = await handleAutoSignIn();
  socketHandler.connect();

  runApp(
    Cookie(
      success: autoSignIn,
    ),
  );
}

class Cookie extends StatelessWidget {
  final bool success;
  const Cookie({super.key, required bool success}) : success = success;

  static const String _title = 'Cookie';

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: success ? const MainWidget() : const SignInWidget(),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.orangeAccent,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          titleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 20,
          ),
          contentTextStyle: const TextStyle(
            // fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 16,
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          alignment: Alignment.center,
        ),
        scaffoldBackgroundColor: Colors.grey[100],
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color.fromARGB(255, 253, 86, 35),
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  DateTime? currentBackPressTime;
  Future<bool> _onWillPop() async {
    final currentTime = DateTime.now();
    final backButtonInterval = currentBackPressTime == null
        ? const Duration(milliseconds: 2000)
        : currentTime.difference(currentBackPressTime!);

    if (backButtonInterval >= const Duration(milliseconds: 2000)) {
      currentBackPressTime = currentTime;
      Fluttertoast.showToast(
        msg: '\'뒤로\' 버튼을 또 누르시면 종료됩니다.',
        backgroundColor: Colors.black.withOpacity(0.2),
        textColor: Colors.white,
      );
      return false;
    }
    return true;
  }

  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    FriendsGrid(),
    ChatTabWidget(),
    MapsWidget(),
    ClubGrid(),
    SettingsWidget(),
  ];

  static const Color greenShade400 = Color(0xFF66BB6A);
  BottomNavigationBarItem iconItem(
    Text text,
    Icon icon,
    String label, {
    Color color = greenShade400,
  }) {
    if (text.data == null || text.data!.isEmpty) {
      return BottomNavigationBarItem(
        icon: icon,
        label: label,
      );
    } else {
      return BottomNavigationBarItem(
        icon: badges.Badge(
          position: badges.BadgePosition.topEnd(top: -10, end: -10),
          badgeStyle: badges.BadgeStyle(
            padding: const EdgeInsets.all(5),
            borderRadius: BorderRadius.circular(10),
            badgeColor: color,
          ),
          badgeContent: text,
          child: icon,
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
                    const Text('1', style: TextStyle(color: Colors.white)),
                    const Icon(Icons.people),
                    '친구',
                  ),
                  iconItem(
                    const Text('2', style: TextStyle(color: Colors.white)),
                    const Icon(Icons.chat_bubble),
                    '채팅',
                  ),
                  iconItem(
                    const Text(''),
                    const Icon(Icons.cookie),
                    '쿠키',
                  ),
                  iconItem(
                    const Text('3', style: TextStyle(color: Colors.white)),
                    const Icon(Icons.sports_basketball),
                    '클럽',
                  ),
                  iconItem(
                    const Text('4', style: TextStyle(color: Colors.white)),
                    const Icon(Icons.settings),
                    '설정',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: const Color.fromARGB(255, 253, 86, 35),
                selectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.bold),
                onTap: _onItemTapped,
                type: BottomNavigationBarType.fixed,
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
