import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_textfield.dart';
import 'package:phan_mem_giao_nhac_viec/ultis/add_space.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    var usrNameTextController = TextEditingController();
    var pwdTextController = TextEditingController();
    var confirmTextController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
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
                          log("confirm: ${confirmTextController.text}");
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
