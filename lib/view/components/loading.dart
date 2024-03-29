import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 24.0),
          CupertinoActivityIndicator(
            animating: true,
            color: Colors.deepOrangeAccent,
            radius: 35,
          ),
          SizedBox(height: 16.0),
          Text(
            "Loading",
            style: TextStyle(
              color: Colors.deepOrangeAccent,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
