import 'package:flutter/material.dart';
import 'package:cookie_app/socket.io/socket.dart';

// socket 연결 상태 확인
Widget connectionInfo() => Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(
          socket.connected ? Icons.check_circle : Icons.warning,
          color: socket.connected ? Colors.green : Colors.red,
          size: 16.0,
        ),
        const SizedBox(width: 4.0),
        Text(
          socket.connected ? '연결' : '연결 안됨',
          style: const TextStyle(fontSize: 16.0),
        ),
        const SizedBox(
          width: 8,
        ),
      ],
    );
