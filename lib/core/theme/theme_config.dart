import 'package:flutter/material.dart';

class ThemeConfig {
  static const Color primaryColor = Color(0xFF04796F); // Greenish teal
  static const Color scaffoldBackgroundColor = Color(0xFFF5F5F5); // Light teal

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      fontFamily: 'Roboto', // Rounded sans-serif font
      textTheme: TextTheme(
        displayLarge: const TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        bodyLarge: const TextStyle(
          fontSize: 20.0,
          color: primaryColor,
          fontWeight: FontWeight.w800,
        ),
        bodyMedium: TextStyle(
          fontSize: 14.0,
          color: Colors.grey[600],
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(26.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(26.0),
          borderSide: const BorderSide(color: primaryColor),
        ),
        hintStyle: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
          color: Colors.grey[400],
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontWeight: FontWeight.normal),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26.0),
          ),
        ),
      ),
    );
  }
}
