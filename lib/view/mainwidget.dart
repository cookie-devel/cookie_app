import 'package:cookie_app/viewmodel/friends.viewmodel.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:cookie_app/view/pages/chatroom/chatrooms.tab.dart';
import 'package:cookie_app/view/pages/friends/friends.tab.dart';
import 'package:cookie_app/view/pages/maps/maps.tab.dart';
import 'package:cookie_app/view/pages/settings/settings.tab.dart';
import 'package:cookie_app/viewmodel/chat.viewmodel.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  final List<Widget> widgetOptions = <Widget>[
    const FriendsTab(),
    const ChatTabWidget(),
    const MapsWidget(),
    // const ClubGrid(),
    SettingsWidget(),
  ];

  @override
  void initState() {
    super.initState();
    context.read<ChatViewModel>().connect();
    context.read<FriendsViewModel>().updateFriends();
  }

  int _selectedIndex = 0;

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

  Widget badgedIcon({required Icon icon, String? label}) {
    if (label == null) {
      return icon;
    } else if (label.isEmpty) {
      return Badge(child: icon);
    } else {
      return Badge(label: Text(label), child: icon);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: widgetOptions[_selectedIndex],
        bottomNavigationBar: NavigationBar(
          shadowColor: Colors.grey.withOpacity(0.1),
          onDestinationSelected: (i) => setState(() => _selectedIndex = i),
          destinations: [
            NavigationDestination(
              selectedIcon:
                  badgedIcon(icon: const Icon(Icons.people), label: '12'),
              icon: badgedIcon(icon: const Icon(Icons.people_outline)),
              label: '친구',
            ),
            NavigationDestination(
              icon: badgedIcon(icon: const Icon(Icons.chat_bubble), label: ''),
              label: '채팅',
            ),
            const NavigationDestination(
              icon: Icon(Icons.cookie),
              label: '쿠키',
            ),
            // const NavigationDestination(
            //   icon: Icon(Icons.sports_basketball),
            //   label: '클럽',
            // ),
            const NavigationDestination(
              icon: Badge(
                child: Icon(Icons.settings),
              ),
              label: '설정',
            ),
          ],
          selectedIndex: _selectedIndex,
        ),
      ),
    );
  }
}
