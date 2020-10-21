import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  primaryColor: primaryColor,
  primaryColorLight: Color(0xFFFFE7E7),
  primaryColorDark: Color(0xFFC88585),
  unselectedWidgetColor: Colors.grey[300],
  primarySwatch: primaryColor,
  fontFamily: 'Nunito',
);

final MaterialColor primaryColor = MaterialColor(
  0xFFFCB5B5,
  const<int, Color> {
    50: const Color(0xFFFFF6F6),
    100: const Color(0xFFFEE9E9),
    200: const Color(0xFFFEDADA),
    300: const Color(0xFFFDCBCB),
    400: const Color(0xFFFCC0C0),
    500: const Color(0xFFFCB5B5),
    600: const Color(0xFFFCAEAE),
    700: const Color(0xFFFBA5A5),
    800: const Color(0xFFFB9D9D),
    900: const Color(0xFFFA8D8D),
  }
);