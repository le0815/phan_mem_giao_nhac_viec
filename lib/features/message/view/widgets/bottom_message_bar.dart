// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:phan_mem_giao_nhac_viec/core/widgets/my_textfield.dart';
import 'package:phan_mem_giao_nhac_viec/features/message/view/pages/chat_box_page.dart';

class BottomMessageBar extends StatelessWidget {
  final bool isSending;
  final ChatBoxPage chatBoxPageWidget;
  final Function() onPressed;
  const BottomMessageBar({
    super.key,
    required this.isSending,
    required this.chatBoxPageWidget,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: MyTextfield(
              textController: chatBoxPageWidget.messageTextController,
              textFieldHint: AppLocalizations.of(context)!.enterMessageHere,
            ),
          ),
          // send message button
          // if message is sending -> the send button will be replaced by loading indicator
          isSending
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                )
              : IconButton(
                  onPressed: onPressed,
                  icon: const Icon(Icons.send_outlined),
                ),
        ],
      ),
    );
  }
}
