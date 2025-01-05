import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
          msg: AppLocalizations.of(context)!.pwdMustMatch,
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
                  Text(
                    AppLocalizations.of(context)!.register,
                    style: const TextStyle(fontSize: 24),
                  ),
                  AddVerticalSpace(40),
                  // User Name
                  MyTextfield(
                    textFieldHint: AppLocalizations.of(context)!.userName,
                    textController: userNameTextController,
                  ),
                  AddVerticalSpace(20),
                  // Email Address
                  MyTextfield(
                    textFieldHint: AppLocalizations.of(context)!.emailAddress,
                    textController: emailTextController,
                  ),
                  AddVerticalSpace(20),
                  // pwd
                  MyTextfield(
                    textFieldHint: AppLocalizations.of(context)!.password,
                    textController: pwdTextController,
                  ),
                  AddVerticalSpace(20),
                  // confirm
                  MyTextfield(
                    textFieldHint:
                        AppLocalizations.of(context)!.confirmPassword,
                    textController: confirmTextController,
                  ),
                  // register btn
                  AddVerticalSpace(20),
                  RegisterButton(
                      emailTextController: emailTextController,
                      pwdTextController: pwdTextController,
                      confirmTextController: confirmTextController,
                      OnRegister: OnRegister),
                  AddVerticalSpace(20),
                  // Have an account? Login now.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: onTap,
                        child: Text(
                          AppLocalizations.of(context)!.haveAnAccountLoginNow,
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

class RegisterButton extends StatelessWidget {
  const RegisterButton({
    super.key,
    required this.emailTextController,
    required this.pwdTextController,
    required this.confirmTextController,
    required this.OnRegister,
  });

  final TextEditingController emailTextController;
  final TextEditingController pwdTextController;
  final TextEditingController confirmTextController;
  final Future<Null> Function() OnRegister;

  @override
  Widget build(BuildContext context) {
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
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Text(
                AppLocalizations.of(context)!.register,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
