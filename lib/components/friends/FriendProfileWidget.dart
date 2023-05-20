import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:cookie_app/components/profile/ProfileWindow.dart';
import 'package:cookie_app/schema/User.dart';

class FriendProfileWidget extends StatefulWidget {
  final User user;
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
  State<FriendProfileWidget> createState() => _FriendProfileWidgetState();
}

class _FriendProfileWidgetState extends State<FriendProfileWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, 0.03),
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startAnimation() {
    _animationController.reset();
    _animationController.forward();
  }

  void _reverseAnimation() {
    _animationController.reverse();
  }

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

    return GestureDetector(
      onTap: () {
        if (widget.enableOnTap) {
          if (widget.enableOnTap) {
            _startAnimation();
            profileBottomSheet(context, widget.user);
            Future.delayed(const Duration(milliseconds: 300), () {
              _reverseAnimation();
            });
          }
        }
      },
      onLongPress: () {
        if (widget.enableOnLongPress) {
          Vibration.vibrate(duration: 40);
        }
      },
      child: Column(
        children: [
          SlideTransition(
            position: _animation,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.orangeAccent,
                      width: 2.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: imageSize - 14,
                  height: imageSize - 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: widget.user.profileImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (widget.displayName) const SizedBox(height: 8),
          if (widget.displayName)
            Flexible(
              child: Text(
                widget.user.name,
                maxLines: 1,
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
