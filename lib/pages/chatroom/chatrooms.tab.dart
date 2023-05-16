import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cookie_app/cookie.appbar.dart';
import 'package:cookie_app/components/chat/chatroom_list_entry.dart';
import 'package:cookie_app/schema/FriendInfo.dart';
import 'package:flutter/services.dart';
import 'package:cookie_app/pages/chatroom/chatroom.dart';

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
      appBar: CookieAppBar(title: '채팅'),
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
              room: FriendInfo.fromMap(log),
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
