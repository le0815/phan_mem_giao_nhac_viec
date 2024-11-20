import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_elevated_button_long.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_textfield.dart';
import 'package:phan_mem_giao_nhac_viec/ultis/add_space.dart';

class AddTask extends StatelessWidget {
  const AddTask({super.key});

  @override
  Widget build(BuildContext context) {
    var taskTitleController = TextEditingController();
    var taskDescriptionController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Add New Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              // title
              MyTextfield(
                  textFieldHint: "Title", textController: taskTitleController),
              AddVerticalSpace(12),
              // description
              MyTextfield(
                  textFieldHint: "Description",
                  textController: taskDescriptionController),

              Row(
                children: [
                  Expanded(
                    child: MyElevatedButtonLong(
                      onPress: () {},
                      title: "Submit",
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
