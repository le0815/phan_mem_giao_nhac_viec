import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_alert_dialog.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_loading_indicator.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_textfield.dart';
import 'package:phan_mem_giao_nhac_viec/services/auth/auth_service.dart';
import 'package:phan_mem_giao_nhac_viec/ultis/add_space.dart';

class RegisterPage extends StatelessWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    var usrNameTextController = TextEditingController();
    var pwdTextController = TextEditingController();
    var confirmTextController = TextEditingController();

    OnRegister() async {
      if (pwdTextController.text != confirmTextController.text) {
        log("pwd must match");
        MyAlertDialog(context, "Password must match!");
        return;
      }

      // loading indicator
      // MyLoadingIndicator(context);

      final authService = AuthService();

      try {
        // create account
        await authService.RegisterWithEmailAndPassword(
          usrNameTextController.text,
          pwdTextController.text,
        );
      } catch (e) {
        // show error
        if(context.mounted)
        {
          MyAlertDialog(context, e.toString());
        }
        log('error while register: ${e.toString()}.');
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Register Page",
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
                  AddVerticalSpace(20),
                  // confirm
                  MyTextfield(
                    textFieldHint: "Confirm Password",
                    textController: confirmTextController,
                  ),
                  // register btn
                  AddVerticalSpace(20),
                  RegisterButton(usrNameTextController, pwdTextController,
                      confirmTextController, OnRegister),
                  AddVerticalSpace(20),
                  // Have an account? Login now.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: onTap,
                        child: const Text(
                          "Have an account? Login now.",
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
      ),
    );
  }

  Row RegisterButton(
      TextEditingController usrNameTextController,
      TextEditingController pwdTextController,
      TextEditingController confirmTextController,
      Future<Null> OnRegister()) {
    return Row(
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
              log("confirm: ${confirmTextController.text}");
              OnRegister();
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text(
                "Register",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
