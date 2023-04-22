import 'package:flutter/material.dart';
import 'package:cookie_app/handler/socket.io/socket.dart';

// socket 연결 상태 확인
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
        const SizedBox(
          width: 5,
        ),
      ],
    );
