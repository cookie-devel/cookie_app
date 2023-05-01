import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cookie_app/handler/socket.io/socket.dart';
import 'package:cookie_app/pages/tabs/maps/maps.tab.dart';
import 'package:cookie_app/pages/tabs/friends/friends.tab.dart';
import 'package:cookie_app/pages/tabs/settings/settings.tab.dart';
import 'package:cookie_app/pages/tabs/chatrooms/chatrooms.tab.dart';
import 'package:cookie_app/pages/tabs/club/club.tab.dart';
import 'package:cookie_app/cookie.splash.dart';

void main() async {
  await dotenv.load();
  runApp(const Cookie());
}

class Cookie extends StatelessWidget {
  const Cookie({super.key});

  static const String _title = 'Cookie';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: const CookieSplash(),
      theme: ThemeData(
        
        appBarTheme: const AppBarTheme(
          color: Colors.transparent,
          elevation: 0,
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
            fontSize: 20
          ),
          contentTextStyle: const TextStyle(
            // fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 16
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

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {

  @override
  void initState() {
    super.initState();
    socketHandler.connect();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    FriendsGrid(),
    ChatTabWidget(),
    MapsWidget(),
    ClubGrid(),
    SettingsWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: SizedBox(
        height:
            kBottomNavigationBarHeight + MediaQuery.of(context).padding.bottom,
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
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.people),
                  label: '친구',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat_bubble),
                  label: '채팅',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.cookie),
                  label: '쿠키',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.sports_basketball),
                  label: '클럽',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: '설정',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: const Color.fromARGB(255, 253, 86, 35),
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,
            ),
          ],
        ),
      ),
    );
  }
}
