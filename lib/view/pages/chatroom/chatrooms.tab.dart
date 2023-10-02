import 'package:cookie_app/view/components/chat/chatroom_list_entry.dart';
import 'package:cookie_app/view/components/chat/connection_info.dart';
import 'package:cookie_app/view/pages/chatroom/add_chatroom.dart';
import 'package:cookie_app/view/pages/chatroom/chatpage.dart';
import 'package:cookie_app/viewmodel/chat.viewmodel.dart';
import 'package:cookie_app/viewmodel/chat/room.viewmodel.dart';
import 'package:flutter/material.dart';
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
        leading: Consumer<ChatViewModel>(
          builder: (context, model, child) => ConnectionInfo(
            connected: model.connected,
          ),
        ),
        actions: const [
          SizedBox(
            width: 56.0,
            child: ChatroomAction(),
          ),
        ],
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => const Divider(
          height: 1,
        ),
        itemCount: context.watch<ChatViewModel>().roomViewModel.length,
        itemBuilder: (BuildContext context, int index) {
          ChatRoomViewModel chatRoom =
              context.watch<ChatViewModel>().roomViewModel[index];

          return ChatRoomListEntry(
            name: chatRoom.name,
            image: chatRoom.image,
            message: chatRoom.messages.isNotEmpty
                ? chatRoom.messages.last.content
                : "Empty Message",
            time: chatRoom.messages.isNotEmpty
                ? chatRoom.messages.last.time
                : chatRoom.createdAt,
            navigate: const ChatPage(),
          );
        },
      ),
    );
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
