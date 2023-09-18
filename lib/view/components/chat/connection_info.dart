import 'package:cookie_app/socket.io/socket.handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConnectionInfo extends StatelessWidget {
  const ConnectionInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SocketHandler>(
      builder: (context, socket, child) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              socket.connected ? Icons.check_circle : Icons.warning,
              color: socket.connected ? Colors.green : Colors.red,
              size: 16.0,
            ),
            Text(
              socket.connected ? '연결' : '연결 안됨',
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
