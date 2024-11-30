import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final String? textFieldHint;
  final TextEditingController textController;
  final int maxLines;
  final bool readOnly;
  final Function()? onPressed;
  final Widget? prefixIcon;

  const MyTextfield({
    super.key,
    this.prefixIcon,
    this.onPressed,
    this.textFieldHint,
    this.maxLines = 1,
    this.readOnly = false,
    required this.textController,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      readOnly: readOnly,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: prefixIcon != null ? IconButton(onPressed: onPressed, icon: prefixIcon!) : null,
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
