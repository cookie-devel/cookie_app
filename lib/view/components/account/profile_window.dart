import 'package:cookie_app/service/map.service.dart';
import 'package:cookie_app/view/components/dialog.dart';
import 'package:cookie_app/view/components/snackbar.dart';
import 'package:flutter/material.dart';

import 'package:cookie_app/view/components/box_decoration.dart';
import 'package:cookie_app/view/components/fullscreen_image.dart';
import 'package:cookie_app/view/components/rounded_image.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';
import 'package:provider/provider.dart';

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
          const SizedBox(height: 1),
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    user.profile.message ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19.0,
                      color: Colors.white,
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
                    icon: const Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.white,
                      // size: pivotSize * 0.22,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.favorite_border_outlined,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => Alert(
                          title: "위치 공유",
                          content: "${user.name}님에게 위치 공유를 요청할래요?",
                          onCancel: () {
                            Navigator.of(context).pop();
                          },
                          onConfirm: () {
                            context.read<MapService>().requestShare(
                                  user.id,
                                );
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            showSnackBar(
                              context,
                              "${user.name}님에게 위치 공유를 요청했어요!",
                              icon: const Icon(
                                Icons.cookie_outlined,
                              ),
                            );
                          },
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.cookie_outlined,
                      color: Colors.white,
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
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            color: Colors.white,
          ),
        ),
        Text(
          content,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26.0,
            color: Colors.white,
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
