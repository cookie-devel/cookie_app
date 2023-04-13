import 'package:flutter/material.dart';

PreferredSize? cookieAppbar(String title){
  return PreferredSize(
    preferredSize: const Size.fromHeight(50.0),
    child: AppBar(
      title: Text(title),
      backgroundColor: Colors.orangeAccent,
      elevation: 0,
      actions: [
        // IconButton(
        //   icon: const Icon(Icons.settings),
        //   onPressed: () {
        //   },
        // ),
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