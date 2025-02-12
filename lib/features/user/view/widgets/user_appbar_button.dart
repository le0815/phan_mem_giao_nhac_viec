import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/core/theme/theme_config.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/model/user_model.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/repository/user_local_repo.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/view/pages/user_page.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class UserAppbarButton extends StatefulWidget {
  const UserAppbarButton({super.key});

  @override
  State<UserAppbarButton> createState() => _UserAppbarButtonState();
}

class _UserAppbarButtonState extends State<UserAppbarButton> {
  UserModel userModel = UserModel.fromMap(
    {
      "email": "sample@email.com",
      "userName": "sample@email.com",
      "uid": "sampleUID",
      "fcm": ["sampleFCM"],
    },
  );

  getUserModel() async {
    userModel = await UserViewModel.instance.getUserModel();
  }

  @override
  void initState() {
    super.initState();
    getUserModel();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, value, child) {
        String firstCharacterOfUserName =
            UserViewModel.instance.getIconText(userName: userModel.userName);
        // show loading indicator when fetching user data from firebase
        return value.isLoading
            ? Container(
                width: 30,
                height: 30,
                child: const CircularProgressIndicator(
                  color: ThemeConfig.primaryColor,
                ),
              )
            : Tooltip(
                triggerMode: TooltipTriggerMode.longPress,
                message: userModel.uid,
                child: GestureDetector(
                  onTap: () async {
                    // get user info

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserPage(
                          modelUser: userModel,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    // padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(217, 217, 217, 217),
                        borderRadius: BorderRadius.circular(16)),
                    child: Center(child: Text(firstCharacterOfUserName)),
                  ),
                ),
              );
      },
    );
  }
}
