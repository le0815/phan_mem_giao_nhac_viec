import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_textfield.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_workspace_overview_tile.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_workspace.dart';
import 'package:phan_mem_giao_nhac_viec/pages/workspace_page.dart';
import 'package:phan_mem_giao_nhac_viec/services/workspace/workspace_service.dart';

final futureWorkspaceKey = GlobalKey<FutureWorkSpaceState>();

class BodyWorkspace extends StatelessWidget {
  BodyWorkspace({super.key});
  final workspaceDetailGlobalKey = GlobalKey<WorkspacePageState>();

  @override
  Widget build(BuildContext context) {
    String currentUID = FirebaseAuth.instance.currentUser!.uid;
    return Padding(
      padding: EdgeInsets.all(8),
      child: Stack(
        children: [
          FutureWorkSpace(
              key: futureWorkspaceKey,
              currentUID: currentUID,
              workspaceDetailGlobalKey: workspaceDetailGlobalKey),
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
              return PopupDialog(
                  workspaceNameController: workspaceNameController,
                  context: context,
                  currentUID: currentUID);
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PopupDialog extends StatelessWidget {
  const PopupDialog({
    super.key,
    required this.workspaceNameController,
    required this.context,
    required this.currentUID,
  });

  final TextEditingController workspaceNameController;
  final BuildContext context;
  final String currentUID;

  @override
  Widget build(BuildContext context) {
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
            await WorkspaceService.instance.createWorkspace(
              currentUID: currentUID,
              modelWorkspace: ModelWorkspace(
                workspaceName: workspaceNameController.text,
                createAt: DateTime.now().millisecondsSinceEpoch,
                members: [currentUID],
              ),
            );

            Navigator.pop(context);
            // refresh data of futureWorkspace
            futureWorkspaceKey.currentState!.refreshData();
          },
          child: const Text("Add"),
        ),
      ],
    );
  }
}

class FutureWorkSpace extends StatefulWidget {
  const FutureWorkSpace({
    super.key,
    required this.currentUID,
    required this.workspaceDetailGlobalKey,
  });

  final String currentUID;
  final GlobalKey<WorkspacePageState> workspaceDetailGlobalKey;

  @override
  State<FutureWorkSpace> createState() => FutureWorkSpaceState();
}

class FutureWorkSpaceState extends State<FutureWorkSpace> {
  refreshData() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: WorkspaceService.instance
          .workspaceFuture(currentUID: widget.currentUID),
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
        final modelsWorkspaceData = snapshot.data!;
        return ListView.builder(
          itemCount: modelsWorkspaceData.length,
          itemBuilder: (context, index) {
            if (modelsWorkspaceData.isEmpty) {
              const Center(
                child: Text(
                  'No workspace here!',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black54,
                  ),
                ),
              );
            }

            return GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkspacePage(
                      key: widget.workspaceDetailGlobalKey,
                      workspaceID: modelsWorkspaceData.keys.elementAt(index),
                      workspaceData:
                          modelsWorkspaceData.values.elementAt(index),
                    ),
                  ),
                ).then(
                  (value) {
                    // clear task overview after switch back
                    widget.workspaceDetailGlobalKey.currentState!
                        .clearTaskResult();
                  },
                );
                // refresh data of futureWorkspace
                setState(() {});
              },
              child: MyWorkspaceOverviewTile(
                workspaceName: modelsWorkspaceData.values
                    .elementAt(index)['modelWorkspace']
                    .workspaceName,
              ),
            );
          },
        );
      },
    );
  }
}
