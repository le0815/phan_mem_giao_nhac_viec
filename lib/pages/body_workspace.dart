import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/my_textfield.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_workspace_overview_tile.dart';
import 'package:phan_mem_giao_nhac_viec/core/constraint/constraint.dart';
import 'package:phan_mem_giao_nhac_viec/core/repositories/local_repo.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_workspace.dart';
import 'package:phan_mem_giao_nhac_viec/pages/workspace_page.dart';
import 'package:phan_mem_giao_nhac_viec/services/workspace/workspace_service.dart';

final hiveWorkspaceStreamKey = GlobalKey<HiveWorkspaceStreamState>();

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
          HiveWorkspaceStream(
              key: hiveWorkspaceStreamKey,
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
      title: Text(
        AppLocalizations.of(context)!.createNewWorkspace,
        style: const TextStyle(fontSize: 16),
      ),
      // workspace name text field
      content: MyTextfield(
        textController: workspaceNameController,
        textFieldHint: AppLocalizations.of(context)!.enterWorkspaceName,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: () async {
            // create new workspace
            await WorkspaceService.instance.createWorkspace(
              currentUID: currentUID,
              modelWorkspace: ModelWorkspace(
                workspaceName: workspaceNameController.text,
                createAt: DateTime.now().millisecondsSinceEpoch,
                members: [currentUID],
              ),
            );

            Navigator.pop(context);
            // sync workspace data
            // HiveBoxes.instance.syncData(syncType: SyncTypes.syncWorkSpace);
          },
          child: Text(AppLocalizations.of(context)!.add),
        ),
      ],
    );
  }
}

class HiveWorkspaceStream extends StatefulWidget {
  const HiveWorkspaceStream({
    super.key,
    required this.currentUID,
    required this.workspaceDetailGlobalKey,
  });

  final String currentUID;
  final GlobalKey<WorkspacePageState> workspaceDetailGlobalKey;

  @override
  State<HiveWorkspaceStream> createState() => HiveWorkspaceStreamState();
}

class HiveWorkspaceStreamState extends State<HiveWorkspaceStream> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: LocalRepo.instance.workspaceHiveBox.listenable(),
      builder: (context, value, child) {
        if (value.isEmpty) {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.noWorkspaceHere,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black54,
              ),
            ),
          );
        }
        final modelsWorkspaceData = value.toMap();
        return ListView.builder(
          itemCount: modelsWorkspaceData.length,
          itemBuilder: (context, index) {
            ModelWorkspace modelWorkspace = ModelWorkspace.fromMap(
                modelsWorkspaceData.values.elementAt(index)['modelWorkspace']);
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
                workspaceName: modelWorkspace.workspaceName,
              ),
            );
          },
        );
      },
    );
  }
}
