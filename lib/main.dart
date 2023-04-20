import 'package:cookie_app/maps.dart';
import 'package:flutter/material.dart';
import 'package:cookie_app/signin.dart';
import 'package:cookie_app/chattab.dart';
import 'package:cookie_app/friends.dart';
import 'package:cookie_app/settings.dart';
import 'package:cookie_app/handler/socket.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {

  await dotenv.load();
  socket.onConnect((data) {
    print('socket connected');
    print(socket.id);
  });
  socket.onDisconnect((data) => print('socket disconnected: ${data}'));

  runApp(Cookie());

}

class Cookie extends StatelessWidget {
  const Cookie({super.key});

  static const String _title = 'Cookie';
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: _title,
      
      home: const SignInWidget(),
      
      theme: ThemeData(

        appBarTheme: const AppBarTheme(
          color: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.indigo,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
        ),
      )
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
    socket.connect();
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    FriendsGrid(),
    ChatTabWidget(),
    MapsWidget(),
    Text(
      'Index 2: Club',
      style: optionStyle,
    ),
    SettingsWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),

      bottomNavigationBar: SizedBox(

        height: kBottomNavigationBarHeight + MediaQuery.of(context).padding.bottom,
        
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
              selectedItemColor: const Color.fromARGB(255, 15, 135, 255),
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,
            ),
          ],
        ),
      )
    );
  }
}