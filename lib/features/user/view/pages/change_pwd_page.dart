import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/add_space.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/my_alert_dialog.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/my_textfield.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class ChangePwdPage extends StatelessWidget {
  const ChangePwdPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController currentPwdController = TextEditingController();
    TextEditingController newPwdController = TextEditingController();
    TextEditingController confirmPwdController = TextEditingController();
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
                // current pwd textfield
                MyTextfield(
                  textFieldHint: "Current Password",
                  textController: currentPwdController,
                  isPassword: true,
                ),
                AddVerticalSpace(20),
                // new pwd textfield
                MyTextfield(
                  textFieldHint: "New Password",
                  textController: newPwdController,
                  isPassword: true,
                ),
                AddVerticalSpace(20),
                // re-enter pwd textfield
                MyTextfield(
                  textFieldHint: "Confirm New Password",
                  textController: confirmPwdController,
                  isPassword: true,
                ),
              ],
            ),
            // confirm button
            Row(
              children: [
                Expanded(child: Consumer<UserViewModel>(
                  builder: (context, value, child) {
                    bool isLoading = value.isLoading;
                    return ElevatedButton(
                      onPressed: () async {
                        try {
                          await UserViewModel.instance.validPwd(
                            newPwd: newPwdController.text,
                            confirmPwd: confirmPwdController.text,
                            currentPwd: currentPwdController.text,
                          );

                          MyAlertDialog(
                              context: context,
                              msg: "Your password was successfully changed",
                              onPressed: () {
                                // close the dialog
                                Navigator.pop(context);
                                // switch back to user page
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
                            : const Text("Confirm"),
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
