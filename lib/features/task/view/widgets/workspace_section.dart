import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:phan_mem_giao_nhac_viec/core/theme/theme_config.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/add_space.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/my_textfield.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/view_model/task_view_model.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/model/user_model.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/view/widgets/my_user_tile_overview.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WorkspaceSection extends StatefulWidget {
  const WorkspaceSection({
    super.key,
    this.isAddTaskMode = true,
    this.workspaceName,
    this.assignerUID,
    this.assigneeUID,
    required this.onSelectedUserUID,
    required this.memberList,
  });
  final List<UserModel> memberList;
  final ValueChanged<String?> onSelectedUserUID;
  final bool isAddTaskMode;
  final String? workspaceName;
  final String? assignerUID;
  final String? assigneeUID;
  @override
  State<WorkspaceSection> createState() => WorkspaceSectionState();
}

class WorkspaceSectionState extends State<WorkspaceSection> {
  final TextEditingController textController = TextEditingController();
  List<bool> memberSelectedState = [];

  @override
  void initState() {
    super.initState();
    memberSelectedState = List.generate(
      widget.memberList.length,
      (index) => false,
    );
    // return assignee result
    widget.onSelectedUserUID(widget.assigneeUID);
    // init selected user when in detail task page
    if (!widget.isAddTaskMode) {
      for (var i = 0; i < widget.memberList.length; i++) {
        if (widget.memberList[i].uid == widget.assigneeUID) {
          TaskViewModel.instance.changeSelectedMemberState(currentIndex: i);
          // setState(() {});
          break;
        }
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ensure the widget is fully initialized
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // load workspace member list
      TaskViewModel.instance.searchMember(searchPhrase: '');
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // show only when in detail task page
        widget.isAddTaskMode == false
            ? DetailTaskMode(
                workspaceName: widget.workspaceName!,
                assignerUserModel: widget.memberList
                    .where(
                      (element) => element.uid == widget.assignerUID,
                    )
                    .first,
              )
            : AddVerticalSpace(1),

        Text(
          AppLocalizations.of(context)!.assignTo,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Container(
          height: 180,
          decoration: BoxDecoration(
            color: ThemeConfig.secondaryColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              // search bar
              MyTextfield(
                textController: textController,
                textFieldHint: AppLocalizations.of(context)!.searchMember,
                // display users are match with search phrase
                onChanged: (value) {
                  taskViewModel.searchMember(searchPhrase: value);
                },
              ),
              AddVerticalSpace(10),
              Expanded(
                child: Consumer<TaskViewModel>(
                  builder: (context, value, child) {
                    return ListView.builder(
                      itemCount: value.searchMemberResult.length,
                      itemBuilder: (context, index) {
                        UserModel userModel = value.searchMemberResult[index];
                        // get index of userModel in memberList
                        var currentOriginalMemberIndex =
                            widget.memberList.indexWhere(
                          (element) => element.uid == userModel.uid,
                        );
                        return GestureDetector(
                          onTap: () {
                            taskViewModel.changeSelectedMemberState(
                                currentIndex: currentOriginalMemberIndex);
                            setState(() {});
                            // return the uid of selected user
                            if (memberSelectedState[
                                currentOriginalMemberIndex]) {
                              widget.onSelectedUserUID(widget
                                  .memberList[currentOriginalMemberIndex].uid);
                            } else {
                              widget.onSelectedUserUID(null);
                            }
                          },
                          child: MyUserTileOverview(
                            userName: userModel.userName,
                            msg: "sdfsd",
                            isSelected:
                                memberSelectedState[currentOriginalMemberIndex],
                            onRemove: () {},
                          ),
                        );
                      },
                    );
                  },
                ),
              )
              // user list
            ],
          ),
        )
      ],
    );
  }
}

class DetailTaskMode extends StatelessWidget {
  const DetailTaskMode({
    super.key,
    required this.workspaceName,
    required this.assignerUserModel,
  });
  final String workspaceName;
  final UserModel assignerUserModel;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.workspace,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              workspaceName,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        // Assigner name
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.assigner,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              assignerUserModel.userName,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ],
    );
  }
}
