import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  primaryColor:
      Colors.blue, // Màu chính cho AppBar và một số thành phần nổi bật

  scaffoldBackgroundColor: Colors.grey[100], // Màu nền chính của ứng dụng

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white, // Màu nền AppBar
    foregroundColor: Colors.black87, // Màu của icon và tiêu đề AppBar
    elevation: 0, // Độ bóng của AppBar
  ),

  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Colors.blue, // Màu của mục chọn hiện tại
    unselectedItemColor: Colors.grey, // Màu của các mục không được chọn
  ),

  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary:
        const Color(0xffda16d6d6), // Màu chủ đạo cho các nút và icon nổi bật
    secondary:
        const Color(0xFF6200EE), // Màu phụ, sử dụng cho icon hoặc nhấn mạnh
    error: Colors.redAccent, // Màu cảnh báo, cho các phần tử như Overdue
  ),

  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.black, fontSize: 16),
    titleMedium: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold), // Tiêu đề chính
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xffda16d6d6), // Màu nền cho ElevatedButton
      foregroundColor: Colors.white, // Màu chữ của ElevatedButton
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),

  checkboxTheme: const CheckboxThemeData(
    fillColor:
        WidgetStatePropertyAll(Colors.blue), // Màu của Checkbox khi được chọn
  ),
);
