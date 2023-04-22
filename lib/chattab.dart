import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cookie_app/ect/test_data.dart';
import 'package:cookie_app/handler/design.dart';
import 'package:cookie_app/handler/handler_chattab.dart';

class ChatTabWidget extends StatefulWidget {
  const ChatTabWidget({super.key});
  @override
  State<ChatTabWidget> createState() => _ChatTabWidgetState();
}

class _ChatTabWidgetState extends State<ChatTabWidget> {
  
  // late List<dynamic> chatLog;
  // late int chatLength;
  
  // @override
  // void initState() {
  //   super.initState();
  //   chatLog = jsonDecode(jsonChatLog);
  //   chatLength = chatLog.length;
  // }



  @override
  Widget build(BuildContext context) {

    final List<dynamic> chatLog = jsonDecode(jsonChatLog);
    final int chatLength = chatLog.length;

    return Scaffold(
      appBar: cookieAppbar(context,'채팅'),
      body:Padding(
        padding: const EdgeInsets.fromLTRB(10, 16, 10, 8),
        child:ListView.builder(
          itemCount: chatLength,
          itemBuilder: (BuildContext context, int index) {
            final Map<String, dynamic> log = chatLog[index];

            return Container(
              child: returnChatTabWidget(
                  context: context,
                  user: returnUserInfo(log)
              ),
            );
          },
        )
      ),
    );
  }


  // @override
  // void dispose() {
  //   super.dispose();
  // }

}