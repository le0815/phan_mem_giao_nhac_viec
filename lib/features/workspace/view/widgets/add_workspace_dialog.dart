import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phan_mem_giao_nhac_viec/core/theme/theme_config.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/my_textfield.dart';
import 'package:phan_mem_giao_nhac_viec/features/workspace/view_model/workspace_viewmodel.dart';

class AddWorkspaceDialog extends StatelessWidget {
  const AddWorkspaceDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController workspaceNameController = TextEditingController();
    return AlertDialog(
      backgroundColor: ThemeConfig.scaffoldBackgroundColor,
      title: Text(
        AppLocalizations.of(context)!.createNewWorkspace,
        style: Theme.of(context).textTheme.titleMedium,
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
            await WorkspaceViewModel.instance
                .createWorkspace(workspaceName: workspaceNameController.text);

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
