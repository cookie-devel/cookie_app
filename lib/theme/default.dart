import 'package:flutter/material.dart';

import 'package:cookie_app/theme/components/input.theme.dart';

ThemeData defaultThemeData = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: InputTheme.color2,
    secondary: InputTheme.color3,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: InputTheme.color3,
    iconTheme: IconThemeData(color: InputTheme.color6),
    centerTitle: true,
    titleSpacing: 50.0,
  ),
  iconTheme: IconThemeData(color: InputTheme.color6),
  dialogTheme: DialogTheme(
    backgroundColor: InputTheme.color6,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
    ),
    titleTextStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black87,
      fontSize: 20,
    ),
    contentTextStyle: const TextStyle(
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
        side: BorderSide(width: 1, color: InputTheme.color6),
      ),
    ),
  ),
  scaffoldBackgroundColor: InputTheme.color6,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: InputTheme.color1,
    selectedItemColor: const Color.fromARGB(255, 253, 86, 35),
    selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
    unselectedItemColor: Colors.grey,
    showSelectedLabels: true,
    showUnselectedLabels: false,
    type: BottomNavigationBarType.fixed,
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: InputTheme.color4,
  ),
  bottomSheetTheme: BottomSheetThemeData(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: InputTheme.color6,
    modalBarrierColor: Colors.transparent,
  ),
  inputDecorationTheme: InputTheme.defaultInputDecorationTheme,
);
