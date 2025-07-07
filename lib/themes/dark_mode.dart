import 'package:flutter/material.dart';

/// === Custom Color Constants for Dark Mode ===
const Color primaryDark = Color(0xFF40916C); // NEW primary
const Color backgroundDark = Color.fromARGB(255, 0, 11, 19);
const Color surfaceDark = Color.fromARGB(255, 0, 18, 30);
const Color secondaryDark = Color(0xFF00253E);
const Color tertiaryDark = Color.fromARGB(255, 0, 32, 54);
const Color inversePrimaryDark = Color.fromARGB(255, 0, 44, 73);
const Color textPrimaryDark = Colors.white;
const Color textSecondaryDark = Colors.grey;

final ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: backgroundDark,

  primaryColor: primaryDark,

  appBarTheme: const AppBarTheme(
    backgroundColor: backgroundDark,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),

  colorScheme: const ColorScheme.dark(
    primary: primaryDark,
    secondary: secondaryDark,
    surface: surfaceDark,
    background: backgroundDark,
    tertiary: tertiaryDark,
    inversePrimary: inversePrimaryDark,
  ),

  cardColor: surfaceDark,

  textTheme: const TextTheme(
    titleLarge: TextStyle(
      color: textPrimaryDark,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: TextStyle(color: textPrimaryDark, fontSize: 16),
    bodySmall: TextStyle(color: textSecondaryDark, fontSize: 14),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryDark,
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: TextStyle(fontWeight: FontWeight.bold),
    ),
  ),

  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.all(primaryDark),
    trackColor: MaterialStateProperty.all(tertiaryDark),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: surfaceDark,
    hintStyle: TextStyle(color: Colors.grey[400]),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  ),
);
