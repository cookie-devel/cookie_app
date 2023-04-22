import 'package:flutter/material.dart';
import 'package:cookie_app/chat.dart';
// import 'package:cookie_app/design.dart';
import 'package:cookie_app/design.dart';

// 각각의 프로필 객체 생성
Widget returnChatTabWidget({
  required BuildContext context,
  required FriendInfo user,
}) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatWidget(user: user),
        ),
      );
    },
    child: SizedBox(
      height: 82,
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              // shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(user.image ?? 'assets/images/user.jpg'),
                fit: BoxFit.cover,
              ),
              border: Border.all(
                color: Colors.white,
                // color: const Color.fromARGB(255, 255, 99, 159),
                width: 0,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.name ?? 'Unknown',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(221, 42, 42, 42),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "채팅탭에서 보이는 메시지입니다.",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color.fromARGB(221, 100, 100, 100),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerRight,
                child: const Text(
                  "19:23 PM",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: Color.fromARGB(221, 150, 150, 150),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 27,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 99, 159),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white,
                        width: 0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          "48".length > 3 ? "999+" : "48",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
