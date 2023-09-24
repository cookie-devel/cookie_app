import 'package:flutter/material.dart';

class ConnectionInfo extends StatelessWidget {
  final bool connected;

  const ConnectionInfo({
    super.key,
    required this.connected,
  });

  @override
  Widget build(BuildContext context) {
    return connected
        ? Container()
        : const Tooltip(
            message: 'Server Socket Not Connected',
            child: Icon(
              Icons.sync_problem,
              color: Colors.red,
            ),
          );
  }
}
