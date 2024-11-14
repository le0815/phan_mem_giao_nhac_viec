import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/pages/auth_page.dart';
import 'package:phan_mem_giao_nhac_viec/pages/body_create.dart';
import 'package:phan_mem_giao_nhac_viec/pages/body_home.dart';
import 'package:phan_mem_giao_nhac_viec/pages/body_message.dart';
import 'package:phan_mem_giao_nhac_viec/pages/home_page.dart';
import 'package:phan_mem_giao_nhac_viec/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:phan_mem_giao_nhac_viec/pages/register_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
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
      home: const AuthPage(),
      //route for navigation page
      routes: {
        "/body_home": (context) => const BodyHome(),
        "/body_create": (context) => const BodyCreate(),
        "/body_message": (context) => const BodyMessage(),
      },
    );
  }
}
