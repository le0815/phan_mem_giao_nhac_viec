import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final String textFieldHint;
  final TextEditingController textController;

  const MyTextfield({
    super.key,
    required this.textFieldHint,
    required this.textController,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: textFieldHint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        // icon: Icon(Icons.remove_red_eye_outlined),
      ),
    );
  }
}
