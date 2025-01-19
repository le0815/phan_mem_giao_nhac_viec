import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:phan_mem_giao_nhac_viec/core/view/pages/app_ui.dart';
import 'package:phan_mem_giao_nhac_viec/features/auth/view/pages/signin_page.dart';
import 'package:phan_mem_giao_nhac_viec/features/auth/view_model/auth_view_model.dart';
import 'package:phan_mem_giao_nhac_viec/main.dart';
import 'package:provider/provider.dart';

class AuthGateViewModel extends StatefulWidget {
  const AuthGateViewModel({super.key});

  @override
  State<AuthGateViewModel> createState() => _AuthGateViewModelState();
}

class _AuthGateViewModelState extends State<AuthGateViewModel> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ensure the widget is fully initialized
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // Defer showing the dialog until after the current frame
      // check login state
      AuthViewModel.instance.checkLoginState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, value, child) {
        if (value.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (value.isLogin) {
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
