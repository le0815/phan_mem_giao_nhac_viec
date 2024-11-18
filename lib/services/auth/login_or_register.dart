import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/pages/login_page.dart';
import 'package:phan_mem_giao_nhac_viec/pages/register_page.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  bool isLoginPage = true;

  TogglePage() {
    setState(() {
      isLoginPage = !isLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoginPage
        ? LoginPage(
            onTap: TogglePage,
          )
        : RegisterPage(
            onTap: TogglePage,
          );
  }
}
