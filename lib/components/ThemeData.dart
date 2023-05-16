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
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrangeAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(width: 1, color: Colors.black45),
        ),
      ),
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
    bottomSheetTheme: const BottomSheetThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      modalBarrierColor: Colors.transparent,
    ),
  );
}
