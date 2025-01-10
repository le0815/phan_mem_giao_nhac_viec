import 'package:flutter/material.dart';

class MyTextfield extends StatefulWidget {
  final String? textFieldHint;
  final TextEditingController textController;
  final int maxLines;
  final bool readOnly;
  final Function()? onPrefixIconPressed;
  final Widget? prefixIcon;
  final bool isPassword;
  bool obscureText = true;

  MyTextfield({
    super.key,
    this.prefixIcon,
    this.onPrefixIconPressed,
    this.isPassword = false,
    this.textFieldHint,
    this.maxLines = 1,
    this.readOnly = false,
    required this.textController,
  });

  @override
  State<MyTextfield> createState() => _MyTextfieldState();
}

class _MyTextfieldState extends State<MyTextfield> {
  hideText() {
    setState(() {
      widget.obscureText = !widget.obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.textController,
      readOnly: widget.readOnly,
      maxLines: widget.maxLines,
      textAlignVertical: TextAlignVertical.center,
      obscureText: widget.isPassword ? widget.obscureText : false,
      decoration: InputDecoration(
        suffixIcon: widget.isPassword == true
            ? IconButton(
                onPressed: hideText,
                // if text filed is obscure -> eye open icon
                icon: widget.obscureText
                    ? const ImageIcon(AssetImage("assets/icons/eye_closed.png"))
                    : const ImageIcon(
                        AssetImage("assets/icons/eye_opened.png")),
              )
            : null,
        prefixIcon: widget.prefixIcon != null
            ? IconButton(
                onPressed: widget.onPrefixIconPressed, icon: widget.prefixIcon!)
            : null,
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
