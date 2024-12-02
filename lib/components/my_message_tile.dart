import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

class MyMessageTile extends StatelessWidget {
  final String text;
  final BubbleType bubbleType;
  const MyMessageTile({
    super.key,
    required this.text,
    required this.bubbleType,
  });

  @override
  Widget build(BuildContext context) {
    return ChatBubble(
      clipper: ChatBubbleClipper5(type: bubbleType),
      // if the message is sender -> display in the right side of the screen
      alignment:
          bubbleType == BubbleType.sendBubble ? Alignment.topRight : null,
      margin: const EdgeInsets.only(top: 10),
      backGroundColor:
          bubbleType == BubbleType.sendBubble ? Colors.blue : Color(0xffE7E7ED),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Text(
          text,
          style: TextStyle(
              color: bubbleType == BubbleType.sendBubble
                  ? Colors.white
                  : Colors.black),
        ),
      ),
    );
  }
}
