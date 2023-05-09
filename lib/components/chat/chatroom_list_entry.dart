import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatRoomListEntry extends StatelessWidget {
  final String name;
  final String message;
  final String? image;
  final DateTime? time;
  final int unread;
  final Widget navigate;

  const ChatRoomListEntry({
    Key? key,
    this.name = "새 채팅방",
    this.message = "채팅방 메시지",
    this.image,
    this.time,
    this.unread = 48,
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: SizedBox(
          height: 82,
          child: Row(
            children: [
              const SizedBox(
                width: 1,
              ),
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
              const SizedBox(width: 9),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChatRoomTime(time: time),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 27),
                      ChatRoomUnreadBadge(unread: unread),
                    ],
                  ),
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
    return Text(
      name,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Color.fromARGB(221, 42, 42, 42),
      ),
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
    return Text(
      message,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color.fromARGB(221, 100, 100, 100),
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}

class ChatRoomImage extends StatelessWidget {
  final String? image;

  const ChatRoomImage({
    Key? key,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        image: DecorationImage(
          image: image == null
              ? const AssetImage("assets/images/cookie_logo.png")
                  as ImageProvider
              : NetworkImage(image!),
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
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 99, 159),
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
            unread == 0
                ? ""
                : unread.toString().length > 3
                    ? "999+"
                    : unread.toString(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
