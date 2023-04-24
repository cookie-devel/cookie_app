import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cookie_app/pages/chatroom/chatroom.dart';
import '../../handler/chatroom.handler.dart';
import 'package:cookie_app/schema/FriendInfo.dart';

class ChatTab extends StatefulWidget {

  final FriendInfo user;

  const ChatTab({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatTab> createState() => _ChatTabState();

}

class _ChatTabState extends State<ChatTab> {

  // 추후 사용
  // String? FriendId;
  // Map<String,dynamic> chatRoomLog = {};

  @override
  void initState() {
    super.initState();
  }

  // 추후 사용
  // Future<void> _handleChatTabTap() async {
  //   Map<String, dynamic> data = await chatRoomHandler(FriendId!);
  //   setState(() {
  //     chatRoomLog = data;
  //   });

  //   NavigatorState navigatorState = Navigator.of(context);
  //   navigatorState.push(MaterialPageRoute(builder: (context) => ChatWidget(user: widget.user)));
  // }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:(){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatWidget(user: widget.user),
          ),
        );
      },
      // 추후 사용
      // onTap: () async{
      //   _handleChatTabTap();
      // },
      child: SizedBox(
        height: 82,
        child: Row(
          children: [
            SizedBox(width: 1,),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                image: DecorationImage(
                  image:
                      AssetImage(widget.user.image ?? 'assets/images/user.jpg'),
                  fit: BoxFit.cover,
                ),
                border: Border.all(
                  width: 1,
                  color: Colors.black45
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
                    widget.user.name ?? 'Unknown',
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
            const SizedBox(width: 9),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
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

  @override
  void dispose() {
    super.dispose();
  }
}


