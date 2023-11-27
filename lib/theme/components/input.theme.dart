import 'package:flutter/material.dart';

class InputTheme {
  static Color color1 = const Color.fromRGBO(242, 191, 94, 1);
  static Color color2 = const Color.fromRGBO(242, 179, 102, 1);
  static Color color3 = const Color.fromRGBO(217, 140, 95, 1);
  static Color color4 = const Color.fromARGB(255, 236, 219, 199);
  static Color color5 = const Color.fromRGBO(115, 52, 29, 1);
  static Color color6 = const Color.fromRGBO(242, 242, 242, 1);
  static InputDecorationTheme defaultInputDecorationTheme =
      InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(90.0),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
    filled: true,
    fillColor: color6,
    hintStyle: const TextStyle(color: Colors.grey),
    errorStyle: const TextStyle(color: Colors.red),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(90.0),
      borderSide: const BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(90.0),
      borderSide: const BorderSide(color: Colors.red),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(90.0),
      borderSide: BorderSide(color: color2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(90.0),
      borderSide: const BorderSide(color: Colors.grey),
    ),
  );
}
