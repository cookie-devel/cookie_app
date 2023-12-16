import 'package:cookie_app/view/pages/friends/friends.search.page.dart';
import 'package:flutter/material.dart';

class FriendsAction extends StatelessWidget {
  const FriendsAction({super.key});

  Future<void> _sortFriendsList(context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        title: const Text('정렬'),
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.sort_by_alpha),
            title: const Text('오름차순'),
            onTap: () => Navigator.pop(context, '오름차순'),
          ),
          ListTile(
            leading: const Icon(Icons.sort_by_alpha),
            title: const Text('내림차순'),
            onTap: () => Navigator.pop(context, '내림차순'),
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('친밀도순'),
            onTap: () => Navigator.pop(context, '친밀도순'),
          ),
        ],
      ),
    ).then((returnVal) {
      if (returnVal != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$returnVal으로 정렬되었습니다.'),
            duration: const Duration(milliseconds: 750),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.people),
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext context) => Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    title: const Text('친구찾기'),
                    leading: const Icon(Icons.person),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FriendSearchScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('알림'),
                    leading: const Icon(Icons.notifications),
                    onTap: () {},
                  ),
                  ListTile(
                    title: const Text('정렬'),
                    leading: const Icon(Icons.sort),
                    onTap: () {
                      _sortFriendsList(context);
                    },
                  ),
                  ListTile(
                    title: const Text('개인정보'),
                    leading: const Icon(Icons.privacy_tip),
                    onTap: () {},
                  ),
                  ListTile(
                    title: const Text('도움말'),
                    leading: const Icon(Icons.help),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
