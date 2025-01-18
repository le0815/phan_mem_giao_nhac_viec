import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:phan_mem_giao_nhac_viec/features/workspace/view/widgets/my_workspace_overview_tile.dart';
import 'package:phan_mem_giao_nhac_viec/features/workspace/models/model_workspace.dart';
import 'package:phan_mem_giao_nhac_viec/features/workspace/repositories/workspace_local_repo.dart';
import 'package:phan_mem_giao_nhac_viec/features/workspace/view/pages/detail_workspace_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phan_mem_giao_nhac_viec/features/workspace/view_model/workspace_viewmodel.dart';
import 'package:phan_mem_giao_nhac_viec/main.dart';

class WorkspaceList extends StatefulWidget {
  const WorkspaceList({
    super.key,
    required this.currentUID,
  });

  final String currentUID;

  @override
  State<WorkspaceList> createState() => WorkspaceListState();
}

class WorkspaceListState extends State<WorkspaceList> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable:
          WorkspaceLocalRepo.instance.workspaceHiveBox.listenable(),
      builder: (context, value, child) {
        if (value.isEmpty) {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.noWorkspaceHere,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          );
        }
        final modelsWorkspaceData = value.toMap();
        return ListView.builder(
          itemCount: modelsWorkspaceData.length,
          itemBuilder: (context, index) {
            ModelWorkspace modelWorkspace = ModelWorkspace.fromMap(
                modelsWorkspaceData.values.elementAt(index)['modelWorkspace']);
            Map modelDetailMembers =
                modelsWorkspaceData.values.elementAt(index)['membersDetail'];
            return GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailWorkspacePage(
                      key: detailWorkspacePageGlobalKey,
                      workspaceID: modelsWorkspaceData.keys.elementAt(index),
                      modelWorkspace: modelWorkspace,
                      modelDetailMembers: modelDetailMembers,
                    ),
                  ),
                ).then(
                  (value) {
                    // clear task overview after switch back
                    WorkspaceViewModel.instance.clearAllPreviousEvents();
                  },
                );
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
