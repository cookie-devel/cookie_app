import 'package:flutter/material.dart';
import 'package:cookie_app/schema/FriendInfo.dart';

import 'package:cookie_app/components/chat/bubbles/myBubble.dart';
import 'package:cookie_app/components/chat/bubbles/otherBubble.dart';

Widget chat(BuildContext context, FriendInfo user, messages) {
  return Expanded(
    child: SingleChildScrollView(
      reverse: true,
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: messages.length,
            itemBuilder: (BuildContext context, int index) {
              final message = messages[index];
              return message.endsWith('.')
                  ? myBubble(context, user, message)
                  : otherBubble(context, user, message);
            },
          ),
        ],
      ),
    ),
  );
}
