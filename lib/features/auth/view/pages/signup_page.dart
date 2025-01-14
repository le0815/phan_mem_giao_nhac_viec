import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_alert_dialog.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/my_textfield.dart';
import 'package:phan_mem_giao_nhac_viec/features/auth/view/pages/signin_page.dart';
import 'package:phan_mem_giao_nhac_viec/features/auth/view_model/auth_view_model.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/add_space.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

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

      final authService = AuthViewModel();
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
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            flex: 3,
            child: SectionOneBody(),
          ),
          Expanded(
            flex: 7,
            child: SectionTwoBody(
              usrNameTextController: userNameTextController,
              pwdTextController: pwdTextController,
              confirmPwdTextController: confirmTextController,
            ),
          ),
        ],
      ),
    );
  }
}

class SectionOneBody extends StatelessWidget {
  const SectionOneBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Welcome!",
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ],
      ),
    );
  }
}

class SectionTwoBody extends StatelessWidget {
  const SectionTwoBody({
    super.key,
    required this.usrNameTextController,
    required this.pwdTextController,
    required this.confirmPwdTextController,
    // required this.widget,
  });

  final TextEditingController usrNameTextController;
  final TextEditingController pwdTextController;
  final TextEditingController confirmPwdTextController;
  // final LogInPage widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          )),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sign Up",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            AddVerticalSpace(20),
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
              isPassword: true,
            ),
            AddVerticalSpace(20),
            // re-enter pwd
            MyTextfield(
              textFieldHint: "Confirm Password",
              textController: confirmPwdTextController,
              isPassword: true,
            ),
            // sign in btn
            AddVerticalSpace(20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // OnSignIn();
                    },
                    child: Text("Sign Up"),
                  ),
                ),
              ],
            ),
            AddVerticalSpace(20),
            // not have an account yet? register now.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have account? "),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SigninPage()),
                    );
                  },
                  child: const Text(
                    "Sign In!",
                    style: TextStyle(
                      color: Colors.blue,
                      // decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
