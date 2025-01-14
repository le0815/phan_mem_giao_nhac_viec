import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/core/view/pages/app_ui.dart';
import 'package:phan_mem_giao_nhac_viec/features/auth/view/pages/signin_page.dart';
import 'package:phan_mem_giao_nhac_viec/main.dart';

class AuthGateViewModel extends StatelessWidget {
  const AuthGateViewModel({super.key});

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
          return AppUi(
            key: appUIGlobalKey,
          );
        } else {
          return const SigninPage();
        }
      },
    );
  }
}
