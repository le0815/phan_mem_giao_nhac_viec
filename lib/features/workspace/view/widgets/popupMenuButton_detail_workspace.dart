// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:phan_mem_giao_nhac_viec/core/widgets/my_alert_dialog.dart';
import 'package:phan_mem_giao_nhac_viec/core/constraint/constraint.dart';
import 'package:phan_mem_giao_nhac_viec/core/theme/theme_config.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/add_space.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/my_textfield.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/view/widgets/my_user_tile_overview.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/model/user_model.dart';
import 'package:phan_mem_giao_nhac_viec/features/workspace/models/model_workspace.dart';
import 'package:phan_mem_giao_nhac_viec/features/workspace/view_model/workspace_viewmodel.dart';

class PopupMenuButtonDetailWorkspace extends StatelessWidget {
  const PopupMenuButtonDetailWorkspace({
    super.key,
    required this.workspaceID,
    required this.currentUserRole,
    required this.modelWorkspace,
    required this.uid,
    required this.modelDetailMembers,
  });

  final String workspaceID;
  final String currentUserRole;
  final ModelWorkspace modelWorkspace;
  final String uid;
  final Map modelDetailMembers;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.menu), // Icon for the button
      onSelected: (value) {
        // Handle selected value
        if (value == 0) {
          addNewMemberDialog(context);
        }
        // delete workspace
        if (value == 1) {
          // show alert
          // if current use is owner -> delete workspace
          // else leave
          if (MyWorkspaceRole.owner.name == currentUserRole) {
            MyAlertDialog(
              msg: AppLocalizations.of(context)!
                  .areYouSureWantToDeleteThisWorkspace,
              onPressed: () async {
                WorkspaceViewModel.instance
                    .deleteWorkspace(workspaceID: workspaceID);
                // close alert dialog
                Navigator.pop(context);
                // close workspace page
                Navigator.pop(context);
              },
            );
          } else {
            MyAlertDialog(
              msg: AppLocalizations.of(context)!
                  .areYouSureWantToLeaveThisWorkspace,
              onPressed: () async {
                WorkspaceViewModel.instance.leaveWorkspace(
                  workspaceID: workspaceID,
                  uid: uid,
                  modelWorkspace: modelWorkspace,
                  membersDetail: modelDetailMembers,
                );
                // close alert dialog
                Navigator.pop(context);
                // close workspace page
                Navigator.pop(context);
                // sync workspace data
                // HiveBoxes.instance
                //     .syncData(syncType: SyncTypes.syncWorkSpace);
              },
            );
          }
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          child: Text(AppLocalizations.of(context)!.addMember),
        ),
        // if user is owner => delete workspace
        // if user is member => leave workspace
        PopupMenuItem(
          value: 1,
          child: Text(
            MyWorkspaceRole.values.first.name == currentUserRole
                ? AppLocalizations.of(context)!.deleteWorkspace
                : AppLocalizations.of(context)!.leaveWorkspace,
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  addNewMemberDialog(BuildContext context) {
    TextEditingController searchPhaseController = TextEditingController();
    final _userTileGlobalKey = GlobalKey<MyUserTileOverviewState>();
    UserModel? modelUserMemberWorkspace;
    return showDialog(
      context: context,
      builder: (context) {
        final workspaceViewModel =
            Provider.of<WorkspaceViewModel>(context, listen: false);
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.addNewChat,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          backgroundColor: ThemeConfig.scaffoldBackgroundColor,
          content: SingleChildScrollView(
            child: Column(
              children: [
                // enter user searchPhase
                MyTextfield(
                  onChanged: (searchPhrase) => workspaceViewModel
                      .searchUserByPhrase(searchPhrase: searchPhrase),
                  textController: searchPhaseController,
                  textFieldHint: AppLocalizations.of(context)!.searchUserToAdd,
                  prefixIcon: const Icon(Icons.search_outlined),
                ),
                AddVerticalSpace(10),
                // query user to add to this chat
                SizedBox(
                  width: double.maxFinite,
                  height: 300,
                  child: Consumer<WorkspaceViewModel>(
                    builder: (context, value, child) {
                      Map searchResult = value.searchResult;
                      return searchResult.isEmpty
                          ? Text(
                              AppLocalizations.of(context)!.trySearchSomething,
                              style: Theme.of(context).textTheme.bodyMedium,
                            )
                          : ListView.builder(
                              itemCount: value.searchResult.length,
                              itemBuilder: (context, index) {
                                modelUserMemberWorkspace = UserModel.fromMap(
                                  searchResult.values.elementAt(index),
                                );
                                return GestureDetector(
                                  onTap: () {
                                    // change color of user tile when tapped
                                    final userTile =
                                        _userTileGlobalKey.currentState!;
                                    userTile.changeState();
                                    // add uid to members of chat
                                  },
                                  child: MyUserTileOverview(
                                    key: _userTileGlobalKey,
                                    userName:
                                        modelUserMemberWorkspace!.userName,
                                    msg: "user",
                                    onRemove: () {},
                                  ),
                                );
                              },
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
          // save or cancel action
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () async {
                var userTile = _userTileGlobalKey.currentState;

                /// if user was not selected -> show alert
                if (userTile == null || userTile.widget.isSelected == false) {
                  MyAlertDialog(
                    msg: AppLocalizations.of(context)!.userMustBeSelected,
                    onPressed: () => Navigator.pop(context),
                  );
                } else {
                  // add user to database to database
                  try {
                    await WorkspaceViewModel.instance.addUserToWorkspace(
                      userModel: modelUserMemberWorkspace!,
                      modelWorkspace: modelWorkspace,
                      workspaceDocID: workspaceID,
                    );
                  } catch (e) {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: ThemeConfig.secondaryColor,
                          title: Text(e.toString()),
                          actions: [
                            TextButton(
                              onPressed: () {},
                              child: const Text("Okay"),
                            )
                          ],
                        );
                      },
                    );
                  }

                  Navigator.pop(context);
                }
              },
              child: Text(AppLocalizations.of(context)!.add),
            ),
          ],
        );
      },
    );
  }
}
