import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:phan_mem_giao_nhac_viec/pages/home_page.dart';
import 'package:phan_mem_giao_nhac_viec/services/auth/login_or_register.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          log("connecting: - ${DateTime.now()}");
          // show loading indicator
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData) {
          log("redirect to home page: - ${DateTime.now()}");
          return const HomePage();
        } else {
          return const LoginOrRegisterPage();
        }
      },
    );
  }
}
