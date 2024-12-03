import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_textfield.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_workspace_overview_tile.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_workspace.dart';
import 'package:phan_mem_giao_nhac_viec/services/workspace/workspace_service.dart';
import 'package:phan_mem_giao_nhac_viec/ultis/add_space.dart';

class BodyWorkspace extends StatelessWidget {
  const BodyWorkspace({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Stack(
        children: [
          addFloatingButton(context),
        ],
      ),
    );
  }

  Positioned addFloatingButton(BuildContext context) {
    return Positioned(
      bottom: 10,
      right: 10,
      child: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              var workspaceNameController = TextEditingController();
              return popUpDialog(workspaceNameController, context);
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  AlertDialog popUpDialog(
      TextEditingController workspaceNameController, BuildContext context) {
    String currentUID = FirebaseAuth.instance.currentUser!.uid;
    return AlertDialog(
      title: const Text(
        "Create new workspace",
        style: TextStyle(fontSize: 16),
      ),
      // workspace name text field
      content: MyTextfield(
        textController: workspaceNameController,
        textFieldHint: "Enter workspace name",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            WorkspaceService.createWorkspace(
              currentUID: currentUID,
              modelWorkspace: ModelWorkspace(
                workspaceName: workspaceNameController.text,
                createAt: Timestamp.now(),
              ),
            );
            Navigator.pop(context);
          },
          child: const Text("Add"),
        ),
      ],
    );
  }
}
