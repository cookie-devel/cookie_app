import 'package:flutter/material.dart';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';

import 'package:cookie_app/service/account.service.dart';
import 'package:cookie_app/service/chat.service.dart';
import 'package:cookie_app/service/map.service.dart';
import 'package:cookie_app/utils/logger.dart';
import 'package:cookie_app/view/components/badge.dart';
import 'package:cookie_app/view/components/snackbar.dart';
import 'package:cookie_app/view/pages/chatroom/chatrooms.tab.dart';
import 'package:cookie_app/view/pages/friends/friends.tab.dart';
import 'package:cookie_app/view/pages/friends/friends_sheet.dart';
import 'package:cookie_app/view/pages/maps/maps.tab.dart';
import 'package:cookie_app/view/pages/settings/settings.tab.dart';
import 'package:cookie_app/viewmodel/map/map.viewmodel.dart';

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
    // Initial Data Loading After Login At Here
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountService>().update().catchError((error) {
        showErrorSnackBar(context, error.message);
      });
      context.read<ChatService>().connect();
      context.read<MapService>().connect();
    });
    initializeFirebaseMessaging();
  }

  void initializeFirebaseMessaging() async {
    // Request Permission
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await FirebaseMessaging.instance.getToken().then((token) {
      if (token != null) {
        context.read<AccountService>().registerDeviceToken(token);
      }
    });

    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      context.read<AccountService>().registerDeviceToken(token);
    }).onError((error) {
      logger.e(error.message);
    });

    await FirebaseMessaging.instance
        .subscribeToTopic("cookie-server")
        .then((value) => logger.d("subscribed to cookie-server"))
        .onError(
          (error, stackTrace) => logger.e("error subscribing to cookie-server"),
        );
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
      Page(
        title: 'C🍪🍪KIE',
        icon: Icons.cookie,
        iconOutline: Icons.cookie_outlined,
        page: const MapsWidget(),
        badge: context.watch<MapViewModel>().mapLog.length.toString(),
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
              label: e.badge != null && e.badge != "0" ? e.badge : null,
            ),
            icon: BadgedIcon(
              icon: e.iconOutline,
              label: e.badge != null && e.badge != "0" ? e.badge : null,
            ),
            label: e.title,
          );
        }).toList(),
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
