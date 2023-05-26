import 'dart:convert';
import 'package:cookie_app/schema/Room.dart';
import 'package:flutter/material.dart';
import 'package:cookie_app/cookie.appbar.dart';
import 'package:cookie_app/components/chat/chatroom_list_entry.dart';
import 'package:flutter/services.dart';
import 'package:cookie_app/pages/chatroom/chatroom.dart';
import 'package:cookie_app/utils/myinfo.dart';
import 'package:cookie_app/pages/chatroom/addChatroom.dart';

class ChatTabWidget extends StatefulWidget {
  const ChatTabWidget({super.key});
  @override
  State<ChatTabWidget> createState() => _ChatTabWidgetState();
}

class _ChatTabWidgetState extends State<ChatTabWidget> {
  @override
  void initState() {
    super.initState();
    getSampleData();
  }

  List<dynamic> chatLog = [];

  void getSampleData() async {
    print(my.id);
    final String res = await rootBundle.loadString('assets/data/chat.json');
    final data = await json.decode(res);

    setState(() {
      chatLog = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int chatLength = chatLog.length;
    return Scaffold(
      appBar: CookieAppBar(
        title: '채팅',
        actions: const [ChatroomAction()],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 0, 10, 0),
        itemCount: chatLength,
        itemBuilder: (BuildContext context, int index) {
          final Map<String, dynamic> log = chatLog[index];
          final String name = log['username'];

          final Map messages = log['log'];
          final Map lastdata = _lastData(messages);
          final String lastkey = lastdata['lastkey'];
          final String lastmessage = lastdata['lastmessage'];

          return ChatRoomListEntry(
            name: name,
            image: log['profile']['image'],
            message: lastmessage,
            time: DateTime.tryParse(lastkey),
            unread: 1000,
            navigate: ChatRoom(
              // room: User.fromMap(log),
              room: Room(
                id: '',
                name: name,
                messages: [],
                users: [],
              ),
            ),
          );
        },
      ),
    );
  }

  Map _lastData(Map log) {
    if (log.isEmpty) {
      return {};
    }

    final List keys = log.keys.toList();
    final String lastKey = keys.last;
    final List list = log[lastKey];

    if (list.isEmpty) {
      return {};
    }

    final int lastIndex = list.length - 1;
    final String lastMessage = list[lastIndex]['message'];

    return {'lastkey': lastKey, 'lastmessage': lastMessage};
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
