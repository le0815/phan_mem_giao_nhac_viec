import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/model/user_model.dart';

class UserPage extends StatelessWidget {
  final UserModel modelUser;
  const UserPage({super.key, required this.modelUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.myProfile),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    "${AppLocalizations.of(context)!.userName}: ",
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    modelUser.userName,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              const Divider(
                thickness: 1,
              ),
              Row(
                children: [
                  Text(
                    "${AppLocalizations.of(context)!.emailAddress}: ",
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    modelUser.email,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              const Divider(
                thickness: 1,
              ),
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.changeYourPassword,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const Icon(Icons.arrow_forward_ios_outlined)
                  ],
                ),
              ),
              const Divider(
                thickness: 1,
              ),
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.deleteAccount,
                      style: const TextStyle(fontSize: 18, color: Colors.red),
                    ),
                    const Icon(Icons.arrow_forward_ios_outlined)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
