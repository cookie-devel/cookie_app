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
  const ChatWidget({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(socket.connected ? Icons.check_circle : Icons.warning,
                  color: socket.connected ? Colors.green : Colors.red,
                  size: 16.0),
              const SizedBox(width: 4.0),
              Text(socket.connected ? 'Connected' : 'Disconnected',
                  style: const TextStyle(fontSize: 16.0)),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                      "assets/images/cw5.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("김채원",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 5),
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth: 200,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 189, 252, 138),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Text(messages[index]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 15), // 수직 간격 조정
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
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
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: ' Type your message...',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(Icons.message),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (chatFieldController.text.trim().isNotEmpty) {
                      socket.emit("chat message", chatFieldController.text);
                      chatFieldController.text = '';
                    }
                  },
                  icon: const Icon(Icons.send),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    chatFieldController.dispose();
    super.dispose();
  }
}
