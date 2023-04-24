import 'package:flutter/material.dart';

// cookie앱의 club page Appbar
PreferredSize? clubAppbar(BuildContext context) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(50.0),
    child: AppBar(
      title: const Text('클럽'),
      backgroundColor: Colors.orangeAccent,
      elevation: 0,
      actions: [
      ],
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
