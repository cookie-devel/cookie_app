import 'package:cookie_app/pages/chatroom/chatroom.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:cookie_app/components/profile/ProfileWindow.dart';
import 'package:cookie_app/schema/FriendInfo.dart';

class FriendProfileWidget extends StatelessWidget {
  final FriendInfo user;

  const FriendProfileWidget({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height -
        kBottomNavigationBarHeight -
        kToolbarHeight -
        122;
    final imageSize = (screenWidth / 4 > screenHeight / 6)
        ? screenWidth / 4
        : screenHeight / 6;

    const fontSize = 14.0;

    return InkResponse(
      onTap: () {
        profileWindow(context, user);
      },
      onLongPress: () {
        Vibration.vibrate(duration: 40);
        // profileWindow(context, user);
      },
      child: Column(
        children: [
          Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(user.image ?? 'assets/images/user.jpg'),
                fit: BoxFit.cover,
              ),
              border: const Border.fromBorderSide(
                BorderSide(
                  style: BorderStyle.solid,
                  color: Colors.deepOrangeAccent,
                  width: 2,
                ),
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
                fontSize: fontSize,
                fontWeight: FontWeight.w300,
                color: Color.fromARGB(221, 60, 60, 60),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
