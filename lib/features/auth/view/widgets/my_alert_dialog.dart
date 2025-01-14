import 'package:flutter/material.dart';

class MyAlertDialog extends StatelessWidget {
  final String msg;
  final Function()? onPressed;
  const MyAlertDialog({super.key, required this.msg, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(msg),
      actions: [
        TextButton(
          onPressed: onPressed ??
              () {
                Navigator.pop(context);
              },
          child: const Text("Okay"),
        )
      ],
    );
  }
}
