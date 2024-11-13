import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/pages/body_create.dart';
import 'package:phan_mem_giao_nhac_viec/pages/body_home.dart';
import 'package:phan_mem_giao_nhac_viec/pages/body_message.dart';
import 'package:phan_mem_giao_nhac_viec/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(217, 217, 217, 217),
      ),
      home: HomePage(),

      //route for navigation page
      routes: {
        "/body_home": (context) => const BodyHome(),
        "/body_create": (context) => const BodyCreate(),
        "/body_message": (context) => const BodyMessage(),
      },
    );
  }
}
