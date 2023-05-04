import 'package:flutter/material.dart';

// reference:
// https://fonts.google.com/icons

// cookie앱의 기본 Appbar

class CookieAppBar extends AppBar {
  CookieAppBar({Key? key, required String title, List<Widget>? actions})
      : super(
          key: key,
          title: Text(title),
          actions: actions,
          centerTitle: true,
          backgroundColor: Colors.orangeAccent,
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
        );
}
