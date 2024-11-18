import 'package:flutter/material.dart';

MyLoadingIndicator(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}
