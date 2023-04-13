import 'package:cookie_app/chat.dart';
import 'package:cookie_app/maps.dart';
import 'package:flutter/material.dart';
import 'package:cookie_app/signin.dart';
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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  static const String _title = 'Flutter Code Sample';
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          title: _title,
          home: SignInWidget(),
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
    ChatWidget(),
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
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Friends',
              backgroundColor: Colors.orange,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble),
              label: 'Chat',
              backgroundColor: Colors.green,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_searching),
              label: 'Location',
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_basketball),
              label: 'Club',
              backgroundColor: Colors.deepOrange,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
              backgroundColor: Colors.purple,
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}