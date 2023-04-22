import 'package:flutter/material.dart';
import 'package:cookie_app/pages/tabs/friends/friendsSheet.dart';

// cookie앱의 friends page Appbar
PreferredSize? friendsAppbar(BuildContext context) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(50.0),
    child: AppBar(
      title: const Text('친구'),
      backgroundColor: Colors.orangeAccent,
      elevation: 0,
      actions: [
        friendsPageIcon(context),
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
