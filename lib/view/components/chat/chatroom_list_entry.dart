import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cookie_app/viewmodel/theme.viewmodel.dart';
import 'package:provider/provider.dart';

class ChatRoomListEntry extends StatelessWidget {
  final String name;
  final String message;
  final ImageProvider image;
  final DateTime time;
  final int unread;
  final Widget navigate;

  const ChatRoomListEntry({
    Key? key,
    required this.name,
    required this.message,
    required this.image,
    required this.time,
    this.unread = 0,
    required this.navigate,
  }) : super(key: key);

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
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // // TODO: implement build
    // throw UnimplementedError();
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final isDark = themeProvider.isDarkModeEnabled;
        return Text(
          name,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color:
                !isDark ? const Color.fromARGB(221, 42, 42, 42) : Colors.white,
          ),
        );
      },
    );
  }
}

class ChatRoomMessage extends StatelessWidget {
  final String message;

  const ChatRoomMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final isDark = themeProvider.isDarkModeEnabled;
        return Text(
          message,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: !isDark
                ? const Color.fromARGB(221, 100, 100, 100)
                : Colors.white60,
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
    Key? key,
    required this.image,
  }) : super(key: key);

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
    Key? key,
    required this.time,
  }) : super(key: key);

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
    Key? key,
    required this.unread,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final isDark = themeProvider.isDarkModeEnabled;
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color:
                !isDark ? const Color.fromARGB(255, 255, 99, 159) : Colors.grey,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white,
              width: 0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                unread.toString().length > 3 ? "999+" : unread.toString(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
