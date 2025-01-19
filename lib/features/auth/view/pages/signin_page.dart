import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/core/theme/theme_config.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/my_textfield.dart';
import 'package:phan_mem_giao_nhac_viec/features/auth/view/pages/signup_page.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/my_alert_dialog.dart';
import 'package:phan_mem_giao_nhac_viec/features/auth/view_model/auth_view_model.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/add_space.dart';

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
        mainAxisSize: MainAxisSize.max,
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

class SectionTwoBody extends StatefulWidget {
  SectionTwoBody({
    super.key,
  });

  @override
  State<SectionTwoBody> createState() => _SectionTwoBodyState();
}

class _SectionTwoBodyState extends State<SectionTwoBody> {
  var emailTextController = TextEditingController();

  var pwdTextController = TextEditingController();

  Route _createRoute(Widget destinationPage) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => destinationPage,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.login,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: ThemeConfig.primaryColor,
                    ),
              ),
              AddVerticalSpace(20),
              // usr name
              MyTextfield(
                textFieldHint: "Email",
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
                        try {
                          AuthViewModel.instance.signInWithEmailAndPassword(
                              email: emailTextController.text,
                              password: pwdTextController.text);
                        } on Exception catch (e) {
                          MyAlertDialog(msg: e.toString(), context: context);
                        }
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
                      Navigator.push(context, _createRoute(const SignupPage()));
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
      ),
    );
  }
}
