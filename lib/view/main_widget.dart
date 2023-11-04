import 'package:flutter/material.dart';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:provider/provider.dart';

import 'package:cookie_app/service/account.service.dart';
import 'package:cookie_app/service/chat.service.dart';
import 'package:cookie_app/view/components/badge.dart';
import 'package:cookie_app/view/pages/chatroom/chatrooms.tab.dart';
import 'package:cookie_app/view/pages/friends/friends.tab.dart';
import 'package:cookie_app/view/pages/friends/friends_sheet.dart';
import 'package:cookie_app/view/pages/maps/maps.tab.dart';
import 'package:cookie_app/view/pages/settings/settings.tab.dart';
import 'package:cookie_app/viewmodel/map.viewmodel.dart';

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

class MainWidget extends StatefulWidget {
  const MainWidget({
    super.key,
  });

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountService>().updateFriends();
      context.read<ChatService>().connect();
      context.read<MapViewModel>().connect();
    });
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Page> pages = [
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(pages[_selectedIndex].title),
        actions: pages[_selectedIndex].actions,
      ),
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(content: Text('뒤로 버튼을 한번 더 누르면 종료됩니다.')),
        child: pages[_selectedIndex].page,
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: pages.map((e) {
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
    );
  }
}
