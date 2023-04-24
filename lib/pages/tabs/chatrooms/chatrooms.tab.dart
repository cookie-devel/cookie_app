import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cookie_app/cookie.appbar.dart';
import 'package:cookie_app/components/chat/chatTabWidget.dart';
import 'package:cookie_app/schema/FriendInfo.dart';
import 'package:flutter/services.dart';

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
      appBar: cookieAppbar(context, '채팅'),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 16, 10, 8),
        child: ListView.builder(
          itemCount: chatLength,
          itemBuilder: (BuildContext context, int index) {
            final Map<String, dynamic> log = chatLog[index];

            return ChatTab(user: returnUserInfo(log));
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
