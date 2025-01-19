import 'package:flutter/material.dart';

class ThemeConfig {
  static const Color primaryColor = Color(0xFF04796F); // Greenish teal
  static const Color scaffoldBackgroundColor = Colors.white; // Light teal
  static const Color secondaryColor = Color(0xFFF5F5F5); // Light teal
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      fontFamily: 'Roboto', // Rounded sans-serif font
      textTheme: const TextTheme(
        // user for calendar only
        // --
        bodyLarge: TextStyle(
          fontSize: 14.0,
          color: primaryColor,
          fontWeight: FontWeight.w300,
        ),
        titleLarge: TextStyle(
          fontSize: 16.0,
          color: primaryColor,
          fontWeight: FontWeight.w300,
        ),
        // --
        displayLarge: TextStyle(
          fontSize: 52.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(
          fontSize: 14.0,
          color: Colors.black,
          fontWeight: FontWeight.normal,
        ),
        titleMedium: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        bodySmall: TextStyle(
          fontSize: 13.0,
          color: Colors.black54,
          fontWeight: FontWeight.w200,
        ),
      ),
      appBarTheme: const AppBarTheme(color: scaffoldBackgroundColor),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: secondaryColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
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
      bottomAppBarTheme: const BottomAppBarTheme(
        color: Colors.transparent,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }
}
