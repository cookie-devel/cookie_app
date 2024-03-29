import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:cookie_app/service/chat.service.dart';
import 'package:cookie_app/view/components/chat/chatroom_list_entry.dart';
import 'package:cookie_app/view/pages/chatroom/add_chatroom.dart';
import 'package:cookie_app/view/pages/chatroom/chatpage.dart';
import 'package:cookie_app/viewmodel/chat/chatroom.viewmodel.dart';

class ChatTabWidget extends StatefulWidget {
  const ChatTabWidget({super.key});
  @override
  State<ChatTabWidget> createState() => _ChatTabWidgetState();
}

class _ChatTabWidgetState extends State<ChatTabWidget> {
  @override
  Widget build(BuildContext context) {
    List<ChatRoomViewModel> chatRooms = context.watch<ChatService>().rooms;
    return ListView.separated(
      separatorBuilder: (context, index) =>
          const Divider(height: 1, thickness: 0.1),
      itemCount: context.watch<ChatService>().rooms.length,
      itemBuilder: (BuildContext context, int index) {
        ChatRoomViewModel chatRoom = chatRooms[index];

        return ChatRoomListEntry(
          name: chatRoom.name,
          image: chatRoom.image,
          message: chatRoom.messages.isNotEmpty
              ? chatRoom.lastMessage
              : "Empty Message",
          time: chatRoom.messages.isNotEmpty
              ? chatRoom.lastActive
              : chatRoom.createdAt,
          navigate: ChatPage(room: chatRoom),
        );
      },
    );
  }
}

class ChatroomAction extends StatelessWidget {
  const ChatroomAction({
    super.key,
  });

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
