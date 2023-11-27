import 'package:flutter/material.dart';

import 'package:cookie_app/theme/components/input.theme.dart';

class DefaultColor {
  static Color color1 = const Color.fromRGBO(242, 191, 94, 1);
  static Color color2 = const Color.fromRGBO(242, 179, 102, 1);
  static Color color3 = const Color.fromRGBO(227, 147, 100, 1);
  static Color color4 = const Color.fromRGBO(254, 243, 231, 1);
  static Color color5 = const Color.fromRGBO(115, 52, 29, 1);
  static Color color6 = const Color.fromRGBO(242, 242, 242, 1);

  static Color color7 = const Color.fromRGBO(242, 201, 204, 1);
  static Color color8 = const Color.fromRGBO(238, 185, 191, 1);
  static Color color9 = const Color.fromRGBO(246, 217, 201, 1);
  static Color color10 = const Color.fromRGBO(226, 199, 172, 1);
  static Color color11 = const Color.fromRGBO(252, 203, 199, 1);
}

ThemeData defaultThemeData = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: DefaultColor.color2,
    secondary: DefaultColor.color3,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: DefaultColor.color3,
    iconTheme: IconThemeData(color: DefaultColor.color6),
    centerTitle: true,
    titleSpacing: 50.0,
  ),
  iconTheme: IconThemeData(color: DefaultColor.color6),
  dialogTheme: DialogTheme(
    backgroundColor: DefaultColor.color6,
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
        side: BorderSide(width: 1, color: DefaultColor.color6),
      ),
    ),
  ),
  scaffoldBackgroundColor: DefaultColor.color6,
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: DefaultColor.color10,
  ),
  bottomSheetTheme: BottomSheetThemeData(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: DefaultColor.color6,
    modalBarrierColor: Colors.transparent,
  ),
  inputDecorationTheme: InputTheme.defaultInputDecorationTheme,
);
