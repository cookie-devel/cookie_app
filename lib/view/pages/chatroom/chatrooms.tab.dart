import 'dart:math';
import 'package:cookie_app/view/pages/chatroom/addChatroom.dart';
import 'package:cookie_app/view/pages/chatroom/chatroom.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';
import 'package:cookie_app/viewmodel/chat/room.viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:cookie_app/view/components/chat/chatroom_list_entry.dart';
import 'package:provider/provider.dart';

class ChatTabWidget extends StatefulWidget {
  const ChatTabWidget({super.key});
  @override
  State<ChatTabWidget> createState() => _ChatTabWidgetState();
}

class _ChatTabWidgetState extends State<ChatTabWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('채팅'),
        actions: const [ChatroomAction()],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 0, 10, 0),
        itemCount:
            Provider.of<PrivateAccountViewModel>(context).chatRooms.length,
        itemBuilder: (BuildContext context, int index) {
          ChatRoomViewModel chatRoom =
              Provider.of<PrivateAccountViewModel>(context).chatRooms[index];
          return ChatRoomListEntry(
            name: chatRoom.name,
            image: chatRoom.image,
            message: chatRoom.messages.last.content,
            time: chatRoom.messages.last.time,
            unread: Random().nextInt(1000),
            navigate: ChatRoom(
              room: chatRoom,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class ChatroomAction extends StatelessWidget {
  const ChatroomAction({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add_box_outlined),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FriendSelectionScreen(),
          ),
        );
      },
    );
  }
}
