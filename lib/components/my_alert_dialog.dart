import 'package:flutter/material.dart';

MyAlertDialog(BuildContext context,
    {required String msg, required Function()? onOkay}) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(msg),
        actions: [
          TextButton(
            onPressed: onOkay,
            child: const Text("Okay"),
          )
        ],
      );
    },
  );
}
