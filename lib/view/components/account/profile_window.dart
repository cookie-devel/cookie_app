import 'package:cookie_app/theme/components/input.theme.dart';
import 'package:flutter/material.dart';

import 'package:cookie_app/view/components/box_decoration.dart';
import 'package:cookie_app/view/components/fullscreen_image.dart';
import 'package:cookie_app/view/components/rounded_image.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';

// 프로필 창 class
class ProfileWindow extends StatelessWidget {
  final AccountViewModel user;
  const ProfileWindow({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 4),
          // Profile Image
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FullScreenImage(image: user.profile.image),
                ),
              );
            },
            child: RoundedImage(
              image: user.profile.image,
            ),
          ),
          CookieDecoratedContainer(
            child: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                      color: InputTheme.color6,
                    ),
                  ),
                  Text(
                    user.profile.message ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19.0,
                      color: InputTheme.color6,
                    ),
                  ),
                ],
              ),
            ],
          ),
          CookieDecoratedContainer(
            child: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      // TODO: ChatRoom room
                    },
                    icon: Icon(
                      Icons.chat_bubble_outline,
                      color: InputTheme.color6,
                      // size: pivotSize * 0.22,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.favorite_border_outlined,
                      color: InputTheme.color6,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.cookie_outlined,
                      color: InputTheme.color6,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const UserProfileTile(title: 'title', content: 'content'),
        ].map((e) => wrapped(e)).toList(),
      ),
    );
  }
}

class UserProfileTile extends StatelessWidget {
  const UserProfileTile({
    super.key,
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return CookieDecoratedContainer(
      child: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            color: InputTheme.color6,
          ),
        ),
        Text(
          content,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26.0,
            color: InputTheme.color6,
          ),
        ),
      ],
    );
  }
}

Container wrapped(child) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    child: child,
  );
}
