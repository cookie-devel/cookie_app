// cookie앱의 settings page Appbar
import 'package:flutter/material.dart';

PreferredSize? settingsAppbar(BuildContext context) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(50.0),
    child: AppBar(
      title: const Text('설정'),
      backgroundColor: Colors.orangeAccent,
      elevation: 0,
      actions: const [],
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Colors.orangeAccent,
              Colors.deepOrangeAccent,
            ],
          ),
        ),
      ),
    ),
  );
}
