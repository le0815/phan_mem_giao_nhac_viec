import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/pages/add_task.dart';
import 'package:phan_mem_giao_nhac_viec/services/auth/auth_gate.dart';
import 'package:phan_mem_giao_nhac_viec/pages/body_task.dart';
import 'package:phan_mem_giao_nhac_viec/pages/body_home.dart';
import 'package:phan_mem_giao_nhac_viec/pages/body_message.dart';
import 'package:firebase_core/firebase_core.dart';
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
      // theme: ThemeData(
      //     scaffoldBackgroundColor: const Color.fromARGB(217, 217, 217, 217),
      //     colorScheme: ColorScheme.light(
      //       // primary: Colors.white,
      //       surface: Colors.white,
      //     )),
      home: const AuthPage(),
      //route for navigation page
      routes: {
        "/body_home": (context) => const BodyHome(),
        "/body_task": (context) => const BodyTask(),
        "/body_message": (context) => const BodyMessage(),
        "/add_task": (context) => const AddTask(),
      },
    );
  }
}
