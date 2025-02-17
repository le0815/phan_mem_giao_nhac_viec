import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/add_space.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/my_alert_dialog.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/my_textfield.dart';
import 'package:phan_mem_giao_nhac_viec/features/auth/view/widgets/custom_textfield.dart';
import 'package:phan_mem_giao_nhac_viec/features/auth/view_model/auth_view_model.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Change Password",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                // AddVerticalSpace(20),
                // new pwd textfield
                MyTextfield(
                  textFieldHint: "Email",
                  textController: emailController,
                ),
                AddVerticalSpace(20),
              ],
            ),
            // confirm button
            Row(
              children: [
                Expanded(child: Consumer<AuthViewModel>(
                  builder: (context, value, child) {
                    bool isLoading = value.isLoading;
                    return ElevatedButton(
                      onPressed: () async {
                        try {
                          await AuthViewModel.instance.sendResetPasswordLink(
                              email: emailController.text);

                          MyAlertDialog(
                              context: context,
                              msg:
                                  "Your password reset link was successfully sent!\nCheck your email",
                              onPressed: () {
                                // close the dialog
                                Navigator.pop(context);
                                // switch back to login page
                                Navigator.pop(context);
                              });
                        } catch (e) {
                          MyAlertDialog(context: context, msg: e.toString());
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text("Send Reset Link"),
                      ),
                    );
                  },
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
