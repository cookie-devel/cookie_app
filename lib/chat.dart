import 'package:cookie_app/friends.dart';
import 'package:cookie_app/handler/handler_chat.dart';
import 'package:flutter/material.dart';
import 'package:cookie_app/handler/design.dart';
import 'package:cookie_app/handler/socket.dart';

class ChatWidget extends StatefulWidget {

  final FriendInfo? user;

  const ChatWidget({Key? key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {

  List messages = ['안녕하세요','채팅 페이지 테스트입니다','대화를 원할 경우 마침표로 대화를 마무리하세요'];

  final chatFieldController = TextEditingController();
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    socket.on('chat message', (data) {
      if (mounted) {
        setState(() {
          messages.add(data);
        });
      }
    });
  }

  send() {
    if (chatFieldController.text.trim().isNotEmpty) {
      socket.emit("chat message", chatFieldController.text);
      chatFieldController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      
      home: Scaffold(
        
        resizeToAvoidBottomInset: true,
        backgroundColor: Color.fromARGB(255, 240, 240, 240),
        
        appBar: chatAppbar(context, widget.user?.name??'Unknown'),
        
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          child: Column(
            children: [
              // connectionInfo(),
              chat(context, widget.user??FriendInfo(), messages),
              chatField(),
              const SizedBox(height: 10,),
            ],
          ),
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
          borderRadius: BorderRadius.circular(20),
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
                  hintStyle: TextStyle(fontSize: 14,color: Colors.grey),
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
                  Image.asset('assets/images/cookie_logo.png', width: 24, height: 24),
                ],
              ),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            )
          ],
        ),
      );
}