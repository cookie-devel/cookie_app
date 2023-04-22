import 'package:flutter/material.dart';

// reference:
// https://fonts.google.com/icons

// cookie앱의 기본 Appbar
PreferredSize? cookieAppbar(BuildContext context, String title) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(50.0),
    child: AppBar(
      title: Text(title),
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


PreferredSize? cookieAppbar2(BuildContext context, String name) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(50.0),
    child: AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 2,
      title: Row(
        children: [
          IconButton(
            padding: const EdgeInsets.only(left: 8),
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          Text(name),
        ],
      ),
      backgroundColor: Colors.orangeAccent,
      elevation: 0,
      actions: [],
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
