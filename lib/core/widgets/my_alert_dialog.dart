import 'package:flutter/material.dart';

MyAlertDialog({
  required BuildContext context,
  required String msg,
  Function()? onPressed,
}) async {
  await showDialog(
    context: context,
    builder: (context) {
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
    },
  );
}
