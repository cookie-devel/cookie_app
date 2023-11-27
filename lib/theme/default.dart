import 'package:flutter/material.dart';

import 'package:cookie_app/theme/components/input.theme.dart';

class DefaultColor {
  static Color color1 = const Color.fromRGBO(242, 191, 94, 1);
  static Color color2 = const Color.fromRGBO(242, 179, 102, 1);
  static Color colorMainOrange = const Color.fromRGBO(252, 147, 49, 1);
  static Color colorMainWhite = const Color.fromRGBO(254, 243, 231, 1);
  static Color colorMainYellow = const Color.fromRGBO(248, 234, 179, 1);
  static Color colorMainBrown = const Color.fromRGBO(115, 52, 29, 1);
}

ThemeData defaultThemeData = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: DefaultColor.color2,
    secondary: DefaultColor.colorMainOrange,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: DefaultColor.colorMainOrange,
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.w600,
      color: DefaultColor.colorMainWhite,
      fontSize: 22.0,
    ),
    iconTheme: IconThemeData(color: DefaultColor.colorMainWhite),
    centerTitle: false,
    titleSpacing: 24.0,
  ),
  iconTheme: IconThemeData(color: DefaultColor.colorMainWhite),
  dialogTheme: DialogTheme(
    backgroundColor: DefaultColor.colorMainWhite,
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
        side: BorderSide(width: 1, color: DefaultColor.colorMainWhite),
      ),
    ),
  ),
  scaffoldBackgroundColor: DefaultColor.colorMainWhite,
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: DefaultColor.colorMainYellow,
  ),
  bottomSheetTheme: BottomSheetThemeData(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: DefaultColor.colorMainYellow,
    modalBarrierColor: Colors.transparent,
  ),
  inputDecorationTheme: InputTheme.defaultInputDecorationTheme,
);
