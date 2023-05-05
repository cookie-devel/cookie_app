// cookie앱의 chat page Appbar
import 'package:flutter/material.dart';
import 'package:cookie_app/components/chat/connectionInfo.dart';

PreferredSize? chatAppbar(BuildContext context, String name) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(50.0),
    child: AppBar(
      // automaticallyImplyLeading: true,
      titleSpacing: 2,
      title: Row(
        children: [
          // IconButton(
          //   padding: const EdgeInsets.only(left: 8),
          //   icon: const Icon(Icons.arrow_back),
          //   onPressed: () => Navigator.pop(context),
          // ),
          Text(name),
        ],
      ),
      backgroundColor: Colors.orangeAccent,
      // elevation: 0,
      actions: [connectionInfo()],
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
