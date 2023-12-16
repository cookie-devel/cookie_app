import 'package:flutter/material.dart';
import 'package:cookie_app/view/pages/friends/friends.search.page.dart';

class FriendsAction extends StatelessWidget {
  const FriendsAction({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.person_add_rounded),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FriendSearchScreen(),
          ),
        );
      },
    );
  }
}
