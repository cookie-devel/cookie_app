import 'package:flutter/material.dart';

ThemeData defaultThemeData() {
  return ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.orangeAccent,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      titleTextStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black87,
        fontSize: 20,
      ),
      contentTextStyle: const TextStyle(
        // fontWeight: FontWeight.bold,
        color: Colors.black,
        fontSize: 16,
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      alignment: Alignment.center,
    ),
    scaffoldBackgroundColor: Colors.grey[100],
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color.fromARGB(255, 253, 86, 35),
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
