import 'dart:developer';

import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_alert_dialog.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_textfield.dart';
import 'package:phan_mem_giao_nhac_viec/services/auth/auth_service.dart';
import 'package:phan_mem_giao_nhac_viec/ultis/add_space.dart';

class RegisterPage extends StatelessWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    var userNameTextController = TextEditingController();
    var emailTextController = TextEditingController();
    var pwdTextController = TextEditingController();
    var confirmTextController = TextEditingController();

    OnRegister() async {
      if (pwdTextController.text != confirmTextController.text) {
        log("pwd must match");
        MyAlertDialog(
          context,
          msg: "Password must match!",
          onOkay: () => Navigator.pop(context),
        );
        return;
      }

      // loading indicator
      // MyLoadingIndicator(context);

      final authService = AuthService();
      var fcmToken = await FirebaseMessaging.instance.getToken();
      try {
        // create account
        await authService.RegisterWithEmailAndPassword(
          emailTextController.text,
          pwdTextController.text,
          userNameTextController.text,
          [fcmToken!],
        );
      } catch (e) {
        // show error
        if (context.mounted) {
          MyAlertDialog(
            context,
            msg: e.toString(),
            onOkay: () => Navigator.pop(context),
          );
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
                  // User Name
                  MyTextfield(
                    textFieldHint: "User Name",
                    textController: userNameTextController,
                  ),
                  AddVerticalSpace(20),
                  // Email Address
                  MyTextfield(
                    textFieldHint: "Email Address",
                    textController: emailTextController,
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
                  RegisterButton(emailTextController, pwdTextController,
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
      TextEditingController emailTextController,
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
              log("usrname: ${emailTextController.text}");
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
