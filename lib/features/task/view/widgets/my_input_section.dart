import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/my_textfield.dart';

class MyInputSection extends StatelessWidget {
  const MyInputSection({
    super.key,
    this.textStyle,
    required this.textEditingController,
    required this.maxLine,
    required this.sectionName,
  });
  final TextEditingController textEditingController;
  final int maxLine;
  final String sectionName;
  final TextStyle? textStyle;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sectionName,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        MyTextfield(
          textController: textEditingController,
          maxLines: maxLine,
          textStyle: textStyle,
        ),
      ],
    );
  }
}
