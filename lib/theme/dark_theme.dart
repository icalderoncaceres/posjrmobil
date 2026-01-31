import 'package:flutter/material.dart';
import 'package:six_pos/theme/custom_theme_colors.dart';

ThemeData dark = ThemeData(
  fontFamily: 'Roboto',
  primaryColor: const Color(0xFF003473),
  secondaryHeaderColor: const Color(0xFFCC003F),
  disabledColor: const Color(0xffa2a7ad),
  brightness: Brightness.dark,
  hintColor: const Color(0xFFbebebe),
  cardColor: Colors.black,

  extensions: <ThemeExtension<CustomThemeColors>>[
    CustomThemeColors.dark(),
  ],


  colorScheme: const ColorScheme.dark(
      surface: Color(0xFF343636),
    error: Color(0xFFbd0a00),
  ),
);
