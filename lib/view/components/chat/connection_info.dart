import 'package:cookie_app/socket.io/socket.handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConnectionInfo extends StatelessWidget {
  const ConnectionInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SocketHandler>(
      builder: (context, socket, child) => socket.connected
          ? Container()
          : const Tooltip(
              message: 'Server Socket Not Connected',
              child: Icon(
                Icons.sync_problem,
                color: Colors.red,
              ),
            ),
    );
  }
}
