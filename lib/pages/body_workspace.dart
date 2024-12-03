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
    String currentUID = FirebaseAuth.instance.currentUser!.uid;
    return Padding(
      padding: EdgeInsets.all(8),
      child: Stack(
        children: [
          StreamBuilder(
            stream: WorkspaceService.workspaceStream(currentUID),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // show loading indicator
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData) {
                return const Center(
                  child: Text(
                    'No workspace here!',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black54,
                    ),
                  ),
                );
              }
              final docs = snapshot.data!.docs;
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  return docs.isEmpty
                      ? const Center(
                          child: Text(
                            'No workspace here!',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black54,
                            ),
                          ),
                        )
                      : MyWorkspaceOverviewTile(
                          workspaceName:
                              (docs[index].data() as Map?)?["workspaceName"],
                        );
                },
              );
            },
          ),
          addFloatingButton(context, currentUID),
        ],
      ),
    );
  }

  Positioned addFloatingButton(BuildContext context, String currentUID) {
    return Positioned(
      bottom: 10,
      right: 10,
      child: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              var workspaceNameController = TextEditingController();
              return popUpDialog(workspaceNameController, context, currentUID);
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  AlertDialog popUpDialog(TextEditingController workspaceNameController,
      BuildContext context, String currentUID) {
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
          onPressed: () async {
            WorkspaceService.createWorkspace(
              currentUID: currentUID,
              modelWorkspace: ModelWorkspace(
                workspaceName: workspaceNameController.text,
                createAt: Timestamp.now(),
                members: [currentUID],
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
