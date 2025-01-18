import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:phan_mem_giao_nhac_viec/features/workspace/view/widgets/add_workspace_dialog.dart';
import 'package:phan_mem_giao_nhac_viec/features/workspace/view/widgets/workspace_list.dart';

class WorkspacePage extends StatelessWidget {
  WorkspacePage({super.key});

  @override
  Widget build(BuildContext context) {
    String currentUID = FirebaseAuth.instance.currentUser!.uid;
    return Padding(
      padding: EdgeInsets.all(8),
      child: Stack(
        children: [
          WorkspaceList(
            currentUID: currentUID,
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
              return const AddWorkspaceDialog();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
