import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_alert_dialog.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_loading_indicator.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_textfield.dart';
import 'package:phan_mem_giao_nhac_viec/services/auth/auth_service.dart';
import 'package:phan_mem_giao_nhac_viec/ultis/add_space.dart';

class LoginPage extends StatefulWidget {
  final Function() onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var usrNameTextController = TextEditingController();
  var pwdTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    OnSignIn() async {
      // show loading indicator
      MyLoadingIndicator(context);

      final authService = AuthService();

      try {
        await authService.SignInWithEmailAndPassword(
            usrNameTextController.text, pwdTextController.text);

        // close loading indicator
        if (context.mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        // close loading indicator
        if (context.mounted) {
          Navigator.pop(context);
          MyAlertDialog(context, e.toString());
        }
        log('error while sign in: $e.');
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Login Page",
                  style: TextStyle(fontSize: 24),
                ),
                AddVerticalSpace(40),
                // usr name
                MyTextfield(
                  textFieldHint: "User Name",
                  textController: usrNameTextController,
                ),
                AddVerticalSpace(20),
                // pwd
                MyTextfield(
                  textFieldHint: "Password",
                  textController: pwdTextController,
                ),

                // sign in btn
                AddVerticalSpace(20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          log("usrname: ${usrNameTextController.text}");
                          log("pwd: ${pwdTextController.text}");
                          OnSignIn();
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Text(
                            "Sign In",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                AddVerticalSpace(20),
                // not have an account yet? register now.
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Not have an account yet? Register now.",
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
