import 'package:flutter/material.dart';
import 'package:cookie_app/schema/FriendInfo.dart';
import 'package:cookie_app/components/LongPressCopyableText.dart';

Widget myBubble(BuildContext context, FriendInfo user, String text) {
  return Column(
    children: [
      const SizedBox(height: 7.5),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Chat bubble
          Container(
            constraints: const BoxConstraints(
              maxWidth: 200,
            ),
            decoration: ShapeDecoration(
              color: Colors.green.shade300,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(2),
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              shadows: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 7,
            ),
            child: LongPressCopyableText(
              text: text,
              style: const TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
          const SizedBox(width: 2),
        ],
      ),
      const SizedBox(height: 7.5), // 수직 간격 조정
    ],
  );
}
