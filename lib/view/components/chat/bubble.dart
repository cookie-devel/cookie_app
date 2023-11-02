import 'package:flutter/material.dart';

import 'package:cookie_app/view/components/long_press_copyable_text.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';

class MyBubble extends StatelessWidget {
  final String content;

  const MyBubble({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
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
                text: content,
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
}

class OtherBubble extends StatelessWidget {
  final AccountViewModel user;
  final String content;

  const OtherBubble({
    super.key,
    required this.user,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 7.5),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image
            InkWell(
              onTap: () {
                // profileWindow(context, user);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: user.profile.image,
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(width: 0.5, color: Colors.black45),
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
                  user.name,
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
                    color: const Color.fromARGB(213, 244, 143, 177),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(2),
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
                    text: content,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 7.5), // 수직 간격 조정
      ],
    );
  }
}
