import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatWidget extends StatefulWidget {
  const ChatWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  late IO.Socket socket;
  late List messages = [];

  final chatFieldController = TextEditingController();

  bool _connected = false;

  @override
  void initState() {
    super.initState();

    socket = IO.io('http://test.parkjb.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.connect();
    socket.onConnect((_) {
      print('connect');
      setState(() {
        _connected = true;
      });
    });
    socket.on('chat message', (data) {
              setState(() {messages.add(data);});
              // print(messages.toString());
            });

    socket.on('disconnect', (_) {
      setState(() {
        _connected = false;
      });
      print('disconnect');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        children: [
          _connected ? const Text('Connected') : const Text('Not Connected'),
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                return Text(messages[index]);
              },
            ),
          ),
          Container(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: chatFieldController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Message',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    socket.emit("chat message", chatFieldController.text);
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    socket.dispose();
    chatFieldController.dispose();
    super.dispose();
  }
}
