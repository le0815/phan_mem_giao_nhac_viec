import 'package:flutter/material.dart';

MySnackBar(context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        content: Text(msg),
        margin: EdgeInsets.only(bottom: 500.0),
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.none),
  );
}
