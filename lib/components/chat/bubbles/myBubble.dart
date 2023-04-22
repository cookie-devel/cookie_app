import 'package:flutter/material.dart';
import 'package:cookie_app/schema/FriendInfo.dart';
import 'package:cookie_app/components/LongPressCopyableText.dart';

Widget myBubble(BuildContext context, FriendInfo user, String text) {
  return Column(
    children: [
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
              color: const Color.fromARGB(255, 167, 194, 249),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.zero,
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
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ],
      ),
      const SizedBox(height: 15), // 수직 간격 조정
    ],
  );
}
