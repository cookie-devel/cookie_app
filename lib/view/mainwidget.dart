import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:cookie_app/view/components/badge.dart';
import 'package:cookie_app/view/pages/chatroom/chatrooms.tab.dart';
import 'package:cookie_app/view/pages/friends/friends.tab.dart';
import 'package:cookie_app/view/pages/friends/friends_sheet.dart';
import 'package:cookie_app/view/pages/maps/maps.tab.dart';
import 'package:cookie_app/view/pages/settings/settings.tab.dart';
import 'package:cookie_app/viewmodel/chat.viewmodel.dart';
import 'package:cookie_app/viewmodel/friends.viewmodel.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class Page {
  final String title;
  final IconData icon;
  final IconData iconOutline;
  final Widget page;
  final List<Widget>? actions;
  final String? badge;

  const Page({
    required this.title,
    required this.icon,
    required this.iconOutline,
    required this.page,
    this.badge,
    this.actions,
  });
}

class _MainWidgetState extends State<MainWidget> {
  final List<Page> _pages = [
    const Page(
      title: '친구',
      icon: Icons.people,
      iconOutline: Icons.people_outline,
      page: FriendsTab(),
      actions: [FriendsAction()],
    ),
    const Page(
      title: '채팅',
      icon: Icons.chat_bubble,
      iconOutline: Icons.chat_bubble_outline,
      page: ChatTabWidget(),
      actions: [ChatroomAction()],
    ),
    const Page(
      title: 'C🍪🍪KIE',
      icon: Icons.cookie,
      iconOutline: Icons.cookie_outlined,
      page: MapsWidget(),
    ),
    Page(
      title: '설정',
      icon: Icons.settings,
      iconOutline: Icons.settings_outlined,
      page: SettingsWidget(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    context.read<ChatViewModel>().connect();
    context.read<FriendsViewModel>().updateFriends();
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DoubleBackToCloseApp(
      snackBar: const SnackBar(content: Text('뒤로 버튼을 한번 더 누르면 종료됩니다.')),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(_pages[_selectedIndex].title),
          actions: _pages[_selectedIndex].actions,
        ),
        body: _pages[_selectedIndex].page,
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (i) => setState(() => _selectedIndex = i),
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: _pages.map((e) {
            return NavigationDestination(
              selectedIcon: BadgedIcon(
                icon: e.icon,
                // label: '',
              ),
              icon: BadgedIcon(
                icon: e.iconOutline,
                label: '',
              ),
              label: e.title,
            );
          }).toList(),
          selectedIndex: _selectedIndex,
        ),
      ),
    );
  }
}
