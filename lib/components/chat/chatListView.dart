import 'package:flutter/material.dart';
import 'package:cookie_app/schema/FriendInfo.dart';

import 'bubbles/myBubble.dart';
import 'bubbles/otherBubble.dart';

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
              return messages[index][messages[index].length - 1] == '.'
                  ? myBubble(context, user, messages[index])
                  : otherBubble(context, user, messages[index]);
            },
          ),
        ],
      ),
    ),
  );
}