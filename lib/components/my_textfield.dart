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
        border: const UnderlineInputBorder(borderSide: BorderSide.none),
        // icon: Icon(Icons.remove_red_eye_outlined),
      ),
    );
  }
}
