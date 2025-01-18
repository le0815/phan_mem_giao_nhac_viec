import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:phan_mem_giao_nhac_viec/core/theme/theme_config.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/view/widgets/my_user_tile_overview.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/model/user_model.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/repository/user_local_repo.dart';
import 'package:phan_mem_giao_nhac_viec/features/workspace/models/model_workspace.dart';
import 'package:phan_mem_giao_nhac_viec/features/workspace/repositories/workspace_local_repo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phan_mem_giao_nhac_viec/features/workspace/view_model/workspace_viewmodel.dart';

class MemberWorkspaceList extends StatelessWidget {
  const MemberWorkspaceList({
    super.key,
    required this.workspaceID,
    required this.modelWorkspace,
    required this.membersDetail,
  });
  final String workspaceID;
  final ModelWorkspace modelWorkspace;
  final Map membersDetail;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              AppLocalizations.of(context)!.members,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        SingleChildScrollView(
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: ThemeConfig.secondaryColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ValueListenableBuilder(
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
                Map modelDetailMembers =
                    modelsWorkspaceData[workspaceID]["membersDetail"];
                return ListView.builder(
                  itemCount: modelDetailMembers.length,
                  itemBuilder: (context, index) {
                    var userData = UserLocalRepo.instance.getModelUser(
                        uid: modelDetailMembers.keys.elementAt(index));
                    UserModel userModel = UserModel.fromMap(userData);
                    return MyUserTileOverview(
                      userName: userModel.userName,
                      msg: modelDetailMembers.values.elementAt(index)['role'],
                      onRemove: () {
                        WorkspaceViewModel.instance.removeUser(
                          modelWorkspace: modelWorkspace,
                          workspaceID: workspaceID,
                          membersDetail: modelDetailMembers,
                          uid: userModel.uid,
                          userModel: userModel,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
