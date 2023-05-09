import 'package:cookie_app/components/chat/connectionInfo.dart';
import 'package:cookie_app/cookie.appbar.dart';
import 'package:flutter/material.dart';
import 'package:cookie_app/handler/socket.io/socket.dart';
import 'package:cookie_app/components/chat/chatListView.dart';
import 'package:cookie_app/schema/FriendInfo.dart';

class ChatRoom extends StatefulWidget {
  final FriendInfo? room;

  const ChatRoom({Key? key, this.room}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  List messages = ['안녕하세요', '채팅 페이지 테스트입니다', '대화를 원할 경우 마침표로 대화를 마무리하세요'];

  final chatFieldController = TextEditingController();
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    socketHandler.registerSendMessageEvent((data) {
      if (mounted) {
        setState(() {
          messages.add(data);
        });
      }
    });
  }

  send() {
    if (chatFieldController.text.trim().isNotEmpty) {
      socketHandler.sendMessage(chatFieldController.text);
      chatFieldController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(247, 253, 253, 253),
      appBar: CookieAppBar(
        title: widget.room?.username ?? 'Unknown',
        actions: [connectionInfo()],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
        child: Column(
          children: [
            chat(context, widget.room ?? FriendInfo(), messages),
            const SizedBox(height: 6),
            SafeArea(
              bottom: true,
              child: chatField(),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 6)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    chatFieldController.dispose();
    super.dispose();
  }

  Widget chatField() => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: chatFieldController,
                onSubmitted: (text) {
                  if (text.isNotEmpty) {
                    send();
                  }
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: ' Type your message...',
                  hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(Icons.message),
                  ),
                ),
              ),
            ),
            IconButton(
              iconSize: 0,
              onPressed: send,
              icon: Stack(
                children: [
                  const Icon(Icons.send),
                  Image.asset(
                    'assets/images/cookie_logo.png',
                    width: 24,
                    height: 24,
                  ),
                ],
              ),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            )
          ],
        ),
      );
}
