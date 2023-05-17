import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:cookie_app/components/profile/ProfileWindow.dart';
import 'package:cookie_app/schema/FriendInfo.dart';

class FriendProfileWidget extends StatelessWidget {
  final FriendInfo user;
  final bool displayName;
  final bool enableOnTap;
  final bool enableOnLongPress;

  const FriendProfileWidget({
    Key? key,
    required this.user,
    this.displayName = true,
    this.enableOnTap = true,
    this.enableOnLongPress = true,
  }) : super(key: key);

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
        if (!enableOnTap) return;
        profileBottomSheet(context, user);
        // profileWindow(context, user);
      },
      onLongPress: () {
        if (!enableOnLongPress) return;
        Vibration.vibrate(duration: 40);
      },
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: imageSize,
                height: imageSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.deepOrangeAccent,
                    width: 1.0,
                  ),
                ),
              ),
              Container(
                width: imageSize - 12,
                height: imageSize - 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: user.profileImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          if (displayName) const SizedBox(height: 8),
          if (displayName)
            Flexible(
              child: Text(
                user.username,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(221, 60, 60, 60),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
