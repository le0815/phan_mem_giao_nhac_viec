import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:phan_mem_giao_nhac_viec/core/theme/theme_config.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/add_space.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/my_textfield.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/view/widgets/my_user_tile_overview.dart';
import 'package:phan_mem_giao_nhac_viec/features/message/view/widgets/chat_box_list.dart';
import 'package:phan_mem_giao_nhac_viec/features/message/view_model/message_view_model.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/model/user_model.dart';

import '../../../../core/widgets/my_alert_dialog.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Stack(
        children: [
          const ChatBoxList(),
          // float add new chat button
          Positioned(
            bottom: 10,
            right: 10,
            child: FloatingActionButton(
              onPressed: () {
                AddNewChatDialog(context);
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> AddNewChatDialog(BuildContext context) {
    TextEditingController searchPhaseController = TextEditingController();
    final _userTileGlobalKey = GlobalKey<MyUserTileOverviewState>();
    UserModel? modelUserMemberChat;
    return showDialog(
      context: context,
      builder: (context) {
        final messageViewModel =
            Provider.of<MessageViewModel>(context, listen: false);
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
                  onChanged: (searchPhrase) => messageViewModel
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
                  child: Consumer<MessageViewModel>(
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
                                modelUserMemberChat = UserModel.fromMap(
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
                                    userName: modelUserMemberChat!.userName,
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
                    context: context,
                    msg: AppLocalizations.of(context)!.userMustBeSelected,
                  );
                } else {
                  // add chat to database
                  try {
                    await MessageViewModel.instance
                        .createNewChat(modelUser: modelUserMemberChat!);
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
