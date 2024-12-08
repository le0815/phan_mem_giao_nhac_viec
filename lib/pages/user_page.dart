import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User name"),
      ),
      body: Column(
        children: [
          Text("your user name"),
          Text("your email"),
          Text("forgot password?"),
        ],
      ),
    );
  }
}
