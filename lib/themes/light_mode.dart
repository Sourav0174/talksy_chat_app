import 'package:flutter/material.dart';

/// === Custom Color Constants ===
const Color primaryLight = Color(0xFF40916C);
const Color backgroundLight = Colors.white;
const Color surfaceLight = Color(0xFFF0F0F0);
const Color secondaryLight = Color(0xFF081C15);
const Color tertiaryLight = Color(0xFFEFEBE3);
const Color inversePrimaryLight = Color(0xFF40916C);
const Color textPrimary = Color(0xFF52B788);
const Color textSecondary = Color(0xFF081C15);
const Color textTertiary = Colors.grey;

/// === ThemeData for Light Mode ===
final ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: backgroundLight,
  primaryColor: primaryLight,

  appBarTheme: const AppBarTheme(
    backgroundColor: backgroundLight,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: textPrimary,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    iconTheme: IconThemeData(color: Colors.black),
  ),

  colorScheme: const ColorScheme.light(
    primary: primaryLight,
    secondary: secondaryLight,
    surface: surfaceLight,
    background: backgroundLight,
    tertiary: tertiaryLight,
    inversePrimary: inversePrimaryLight,
  ),

  cardColor: surfaceLight,

  textTheme: const TextTheme(
    titleLarge: TextStyle(
      color: textPrimary,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: TextStyle(color: textSecondary, fontSize: 16),
    bodySmall: TextStyle(color: textTertiary, fontSize: 14),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryLight,
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: TextStyle(fontWeight: FontWeight.bold),
    ),
  ),

  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.all(primaryLight),
    trackColor: MaterialStateProperty.all(tertiaryLight),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: surfaceLight,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: Colors.grey[500]),
  ),
);
