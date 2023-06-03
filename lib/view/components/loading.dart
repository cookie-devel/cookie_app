import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cookie_app/utils/themeProvider.dart';
import 'package:provider/provider.dart';

Widget loadingScreen() {
  return Consumer<ThemeProvider>(
    builder: (context, themeProvider, _) {
      final isDark = themeProvider.isDarkModeEnabled;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 24.0),
            CupertinoActivityIndicator(
              animating: true,
              color: !isDark ? Colors.deepOrangeAccent : Colors.white,
              radius: 35,
            ),
            const SizedBox(height: 16.0),
            Text(
              "Loading",
              style: TextStyle(
                color: !isDark ? Colors.deepOrangeAccent : Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    },
  );
}
