import 'package:flutter/material.dart';

class InputTheme {
  static InputDecorationTheme defaultInputDecorationTheme =
      InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(90.0),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
    filled: true,
    fillColor: Colors.white,
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
      borderSide: const BorderSide(color: Colors.orangeAccent),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(90.0),
      borderSide: const BorderSide(color: Colors.grey),
    ),
  );
}
