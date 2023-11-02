import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:cookie_app/viewmodel/theme.provider.dart';

class ChatRoomListEntry extends StatelessWidget {
  final String name;
  final String message;
  final ImageProvider image;
  final DateTime time;
  final int unread;
  final Widget navigate;

  const ChatRoomListEntry({
    super.key,
    required this.name,
    required this.message,
    required this.image,
    required this.time,
    this.unread = 0,
    required this.navigate,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => navigate,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: SizedBox(
          height: 68,
          child: Row(
            children: [
              ChatRoomImage(image: image),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChatRoomName(name: name),
                    const SizedBox(height: 8),
                    ChatRoomMessage(message: message),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ChatRoomTime(time: time),
                  const SizedBox(height: 8),
                  unread == 0
                      ? const SizedBox()
                      : ChatRoomUnreadBadge(unread: unread),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatRoomName extends StatelessWidget {
  final String name;

  const ChatRoomName({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return Text(
          name,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        );
      },
    );
  }
}

class ChatRoomMessage extends StatelessWidget {
  final String message;

  const ChatRoomMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return Text(
          message,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: themeProvider.theme.colorScheme.onSecondary,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }
}

class ChatRoomImage extends StatelessWidget {
  final ImageProvider image;

  const ChatRoomImage({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        image: DecorationImage(
          image: image,
          fit: BoxFit.cover,
        ),
        border: Border.all(width: 1, color: Colors.black45),
      ),
    );
  }
}

class ChatRoomTime extends StatelessWidget {
  final DateTime? time;

  const ChatRoomTime({
    super.key,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      time != null ? timeago.format(time!, locale: 'ko') : "",
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w300,
        color: Color.fromARGB(221, 150, 150, 150),
      ),
    );
  }
}

class ChatRoomUnreadBadge extends StatelessWidget {
  final int unread;

  const ChatRoomUnreadBadge({
    super.key,
    required this.unread,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return Badge(
          largeSize: 21,
          label: Text(
            unread.toString().length > 3 ? "999+" : unread.toString(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          backgroundColor: const Color.fromARGB(255, 255, 99, 159),
        );
      },
    );
  }
}
