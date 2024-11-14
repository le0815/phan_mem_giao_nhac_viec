import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_textfield.dart';
import 'package:phan_mem_giao_nhac_viec/ultis/add_space.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var usrNameTextController = TextEditingController();
  var pwdTextController = TextEditingController();

  OnSignIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: usrNameTextController.text, password: pwdTextController.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
