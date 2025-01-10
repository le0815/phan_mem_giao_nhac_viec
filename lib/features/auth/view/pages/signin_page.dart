import 'dart:developer';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_alert_dialog.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_textfield.dart';
import 'package:phan_mem_giao_nhac_viec/features/auth/view/pages/signup_page.dart';
import 'package:phan_mem_giao_nhac_viec/features/auth/view/widgets/my_loading_indicator.dart';
import 'package:phan_mem_giao_nhac_viec/features/auth/view_model/auth_view_model.dart';
import 'package:phan_mem_giao_nhac_viec/ultis/add_space.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            flex: 4,
            child: SectionOneBody(),
          ),
          Expanded(
            flex: 6,
            child: SectionTwoBody(),
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
            "Hello!",
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ],
      ),
    );
  }
}

class SectionTwoBody extends StatelessWidget {
  SectionTwoBody({
    super.key,
  });

  var emailTextController = TextEditingController();
  var pwdTextController = TextEditingController();
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
              AppLocalizations.of(context)!.login,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            AddVerticalSpace(20),
            // usr name
            MyTextfield(
              textFieldHint: AppLocalizations.of(context)!.userName,
              textController: emailTextController,
            ),
            AddVerticalSpace(20),
            // pwd
            MyTextfield(
              textFieldHint: AppLocalizations.of(context)!.password,
              textController: pwdTextController,
              isPassword: true,
            ),
            // sign in btn
            AddVerticalSpace(20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      FutureBuilder(
                        future: AuthViewModel().SignInWithEmailAndPassword(
                            email: emailTextController.text,
                            password: pwdTextController.text),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("sddsf"),
                                  margin: EdgeInsets.only(bottom: 500.0),
                                  behavior: SnackBarBehavior.floating,
                                  dismissDirection: DismissDirection.none),
                            );
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const MyLoadingIndicator();
                          }
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: Text("Logged in"),
                            actions: [
                              TextButton(
                                onPressed: () {},
                                child: const Text("Okay"),
                              )
                            ],
                          );
                        },
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.signIn),
                  ),
                ),
              ],
            ),
            AddVerticalSpace(20),
            // not have an account yet? register now.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have account? "),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignupPage()),
                    );
                  },
                  child: const Text(
                    "Register!",
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
