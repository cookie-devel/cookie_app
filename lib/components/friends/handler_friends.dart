import 'package:cookie_app/chat.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:cookie_app/design.dart';

class FriendProfileWidget extends StatelessWidget {
  final FriendInfo user;

  const FriendProfileWidget({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatWidget(user: user),
          ),
        );
      },
      onLongPress: () {
        Vibration.vibrate(duration: 40);
        profileWindow(context, user);
      },
      child: Column(
        children: [
          Container(
            width: 85,
            height: 85,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(user.image ?? 'assets/images/user.jpg'),
                fit: BoxFit.cover,
              ),
              border: Border.all(
                color: Colors.deepOrangeAccent,
                width: 1.8,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: Text(
              user.name ?? 'Unknown',
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w200,
                color: Color.fromARGB(221, 60, 60, 60),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
