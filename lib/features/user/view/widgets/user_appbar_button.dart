import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/model/user_model.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/repository/user_local_repo.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/view/pages/user_page.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/view_model/user_view_model.dart';

class UserAppbarButton extends StatefulWidget {
  const UserAppbarButton({super.key});

  @override
  State<UserAppbarButton> createState() => _UserAppbarButtonState();
}

class _UserAppbarButtonState extends State<UserAppbarButton> {
  final currentUID = FirebaseAuth.instance.currentUser!.uid;
  late final UserModel modelUser;

  @override
  void initState() {
    super.initState();
    modelUser = UserModel.fromMap(
      UserLocalRepo.instance.getModelUser(uid: currentUID) ??
          {
            "email": "sample@email.com",
            "userName": "sample@email.com",
            "uid": "sampleUID",
            "fcm": ["sampleFCM"],
          },
    );
  }

  @override
  Widget build(BuildContext context) {
    String firstCharacterOfUserName =
        UserViewModel.instance.getIconText(userName: modelUser.userName);

    return Tooltip(
      triggerMode: TooltipTriggerMode.longPress,
      message: currentUID,
      child: GestureDetector(
        onTap: () async {
          // get user info

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserPage(
                modelUser: modelUser,
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
  }
}
