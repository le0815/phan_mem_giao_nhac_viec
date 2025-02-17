// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomTextfield extends StatefulWidget {
  final TextEditingController textController;
  final String textFieldHint;
  const CustomTextfield({
    super.key,
    required this.textController,
    required this.textFieldHint,
  });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.textController,
      textAlignVertical: TextAlignVertical.center,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        suffixIcon: TextButton(
          onPressed: () {},
          child: Text("Send OTP"),
        ),

        // filled: true,
        // fillColor: Colors.white,
        hintText: widget.textFieldHint,
        // hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        // border: OutlineInputBorder(
        //   borderSide: const BorderSide(width: 1, color: Colors.grey),
        //   borderRadius: BorderRadius.circular(8),
        // ),
        // icon: Icon(Icons.remove_red_eye_outlined),
      ),
    );
  }
}
