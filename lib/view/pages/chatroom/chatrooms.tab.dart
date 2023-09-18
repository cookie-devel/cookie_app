import 'package:cookie_app/view/components/chat/chatroom_list_entry.dart';
import 'package:cookie_app/view/components/chat/connection_info.dart';
import 'package:cookie_app/view/pages/chatroom/addChatroom.dart';
import 'package:cookie_app/view/pages/chatroom/chatpage.dart';
import 'package:flutter/material.dart';

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
        leading: const ConnectionInfo(),
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
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return ChatRoomListEntry(
            name: 'name',
            image: const AssetImage('assets/images/cookie_logo.png'),
            message: 'message',
            time: DateTime.now(),
            navigate: const ChatPage(),
            unread: 10,
          );
        },
      ),
      // body: Consumer<ChatViewModel>(
      //   builder: (context, model, child) => ListView.separated(
      //     separatorBuilder: (context, index) => const Divider(
      //       height: 1,
      //     ),
      //     itemCount: model.roomViewModel.length,
      //     itemBuilder: (BuildContext context, int index) {
      //       ChatRoomViewModel chatRoom = model.roomViewModel[index];
      //       return ChatRoomListEntry(
      //         name: chatRoom.name,
      //         image: chatRoom.image,
      //         message: chatRoom.messages.last.content,
      //         time: chatRoom.messages.last.time,
      //         navigate: const ChatPage(),
      //       );
      //     },
      //   ),
      // ),
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
