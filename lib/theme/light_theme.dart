import 'package:flutter/material.dart';
import 'package:six_pos/theme/custom_theme_colors.dart';

ThemeData light = ThemeData(
  fontFamily: 'Roboto',
  primaryColor: const Color(0xFF003473),
  secondaryHeaderColor: const Color(0xFFCC003F),
  disabledColor: const Color(0xFFBABFC4),
  brightness: Brightness.light,
  hintColor: const Color(0xFF9F9F9F),
  cardColor: Colors.white,

  extensions: <ThemeExtension<CustomThemeColors>>[
    CustomThemeColors.light(),
  ],

  appBarTheme:  const AppBarTheme(
    surfaceTintColor: Colors.white,
    elevation: 10,
    shadowColor: Color(0xFFC2CAD9),
  ),
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: const Color(0xFFEEBD8D),
    onPrimary: const Color(0xFF003473),
    secondary: const Color(0xFFCC003F),
    onSecondary: const Color(0xFFCC003F),
    error: const Color(0xFFFF4848),
    onError: Colors.redAccent,
    surface: Colors.white,
    onSurface:  const Color(0xFF002349),
    shadow: Colors.grey[300],
    tertiaryContainer: const Color(0xFFD4F4D4),
    onTertiary: const Color(0xFFDAEBFF),


    // buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),


  ),
);