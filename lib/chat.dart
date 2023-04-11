import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:cookie_app/handler/socket.dart';

class Chat extends StatelessWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ko', 'KR'),
      ],
      home: ChatWidget(),
    );
  }
}

class ChatWidget extends StatefulWidget {

  final String? name;

  const ChatWidget({Key? key, this.name}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {

  List messages = [];

  final chatFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();

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
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: AppBar(
            title: Text(widget.name??''),
            backgroundColor: Colors.orangeAccent,
            elevation: 0,
            actions: [
              connectionInfo()
            ],
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Colors.orangeAccent,
                    Colors.deepOrangeAccent,
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Column(
            children: [
              // connectionInfo(),
              chat("assets/images/cw5.png", widget.name??'', messages),
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
    chatFieldController.dispose();
    super.dispose();
  }

  Widget connectionInfo() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            socket.connected ? Icons.check_circle : Icons.warning,
            color: socket.connected ? Colors.green : Colors.red,
            size: 16.0,
          ),
          const SizedBox(width: 4.0),
          Text(
            socket.connected ? 'Connected' : 'Disconnected',
            style: const TextStyle(fontSize: 16.0),
          ),
          SizedBox(width: 5,),
        ],
      );

  Widget chatBubble(image, String name, text) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image
              Material(
                elevation: 5,
                shape: const CircleBorder(
                  side: BorderSide(
                    color: Color.fromARGB(255, 255, 99, 159),
                    width: 1.5,
                  ),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: ClipOval(
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // Margin between profile image and chat bubble
              const SizedBox(width: 10),
              // Chat bubble
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 200,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 189, 252, 138),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Text(text),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15), // 수직 간격 조정
        ],
      );

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
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: ' Type your message...',
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(Icons.message),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: send,
              icon: const Icon(Icons.send),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
          ],
        ),
      );

  Widget chat(image, String name, messages) => Expanded(
    child: SingleChildScrollView(
      reverse: true,
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: messages.length,
            itemBuilder: (BuildContext context, int index) {
              return chatBubble(
                  image, name, messages[index]);
            },
          ),
        ],
      ),
    ),
  );

}