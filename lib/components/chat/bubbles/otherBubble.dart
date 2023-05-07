import 'package:flutter/material.dart';
import 'package:cookie_app/schema/FriendInfo.dart';
import 'package:cookie_app/components/LongPressCopyableText.dart';

Widget otherBubble(BuildContext context, FriendInfo user, String text) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Image
          InkWell(
            onTap: () {
              // profileWindow(context, user);
            },
            child: Material(
              elevation: 5,
              shape: const CircleBorder(
                side: BorderSide(
                  color: Color.fromARGB(255, 255, 99, 159),
                  width: 1.5,
                ),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.grey[300],
                child: ClipOval(
                  child: Image.asset(
                    user.image ?? 'assets/images/user.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          // Margin between profile image and chat bubble
          const SizedBox(width: 10),
          // Chat bubble
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.username ?? 'Unknown',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color.fromARGB(255, 55, 55, 55),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 200,
                ),
                decoration: ShapeDecoration(
                  color: const Color.fromARGB(255, 189, 252, 138),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.circular(10),
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
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
      const SizedBox(height: 15), // 수직 간격 조정
    ],
  );
}
