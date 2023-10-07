import 'package:flutter/material.dart';

import 'package:cookie_app/view/components/account/profile_window.dart';
import 'package:cookie_app/view/components/rounded_image.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';

class FriendProfileWidget extends StatefulWidget {
  final PublicAccountViewModel account;
  final bool displayName;
  final bool enableOnTap;
  final bool enableOnLongPress;

  const FriendProfileWidget({
    Key? key,
    required this.account,
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
      end: const Offset(0, 0.05),
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
          _startAnimation();
          showModalBottomSheet(
            context: context,
            useSafeArea: false,
            isScrollControlled: true,
            backgroundColor: Colors.deepOrange.withOpacity(0.9),
            builder: (BuildContext context) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: ProfileWindow(user: widget.account),
              );
            },
          );

          Future.delayed(const Duration(milliseconds: 300), () {
            _reverseAnimation();
          });
        }
      },
      child: Column(
        children: [
          SlideTransition(
            position: _animation,
            child: RoundedImage(
              imageSize: imageSize,
              image: widget.account.profile.image,
            ),
          ),
          if (widget.displayName) const SizedBox(height: 8),
          if (widget.displayName)
            Flexible(
              child: Text(
                widget.account.name,
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
