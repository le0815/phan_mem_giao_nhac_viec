import 'dart:developer';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_alert_dialog.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_elevated_button_long.dart';
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
      final authService = AuthService();

      try {
        await authService.SignInWithEmailAndPassword(
            usrNameTextController.text, pwdTextController.text);
      } catch (e) {
        // show error
        if (context.mounted) {
          MyAlertDialog(
            context,
            msg: e.toString(),
            onOkay: () => Navigator.pop(context),
          );
        }
        log('error while sign in: $e.');
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
                  Text(
                    AppLocalizations.of(context)!.login,
                    style: TextStyle(fontSize: 24),
                  ),
                  AddVerticalSpace(40),
                  // usr name
                  MyTextfield(
                    textFieldHint: AppLocalizations.of(context)!.userName,
                    textController: usrNameTextController,
                  ),
                  AddVerticalSpace(20),
                  // pwd
                  MyTextfield(
                    textFieldHint: AppLocalizations.of(context)!.password,
                    textController: pwdTextController,
                  ),

                  // sign in btn
                  AddVerticalSpace(20),
                  Row(
                    children: [
                      Expanded(
                        child: MyElevatedButtonLong(
                          onPress: () {
                            OnSignIn();
                          },
                          title: AppLocalizations.of(context)!.signIn,
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
                        child: Text(
                          AppLocalizations.of(context)!.notHaveAnAccountYet,
                          style: const TextStyle(
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
}
