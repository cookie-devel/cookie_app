import 'package:flutter/material.dart';

// reference:
// https://fonts.google.com/icons

// cookie앱의 기본 Appbar

class CookieAppBar extends AppBar {
  CookieAppBar({
    Key? key,
    String? title,
    List<Widget>? actions,
  }) : super(
          key: key,
          title: title == null ? null : Text(title),
          actions: actions,
        );
}
