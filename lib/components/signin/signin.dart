import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

Scaffold isLoadingScreen() {
  return Scaffold(
    backgroundColor: Colors.deepOrangeAccent,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SizedBox(height: 24.0),
          CupertinoActivityIndicator(
            animating: true,
            color: Colors.white,
            radius: 35,
          ),
          SizedBox(height: 16.0),
          Text(
            "Loading",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
    bottomNavigationBar: const SizedBox(
      height: 72.0,
      child: Center(
        child: Text(
          "C🍪🍪KIE",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 2.0,
                color: Colors.grey,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
