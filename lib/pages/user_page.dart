import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_user.dart';

class UserPage extends StatelessWidget {
  final ModelUser modelUser;
  const UserPage({super.key, required this.modelUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My profile"),
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
                  const Text(
                    "User name: ",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    modelUser.userName,
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              const Divider(
                thickness: 1,
              ),
              Row(
                children: [
                  const Text(
                    "Email: ",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    modelUser.email,
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              const Divider(
                thickness: 1,
              ),
              GestureDetector(
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Change your password ",
                      style: TextStyle(fontSize: 18),
                    ),
                    Icon(Icons.arrow_forward_ios_outlined)
                  ],
                ),
              ),
              const Divider(
                thickness: 1,
              ),
              GestureDetector(
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Delete account?",
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),
                    Icon(Icons.arrow_forward_ios_outlined)
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
