import 'package:flutter/material.dart';

// friends page Appbar에서 icon을 눌렀을 때 나오는 bottom sheet
IconButton friendsAction(BuildContext context) {
  return IconButton(
    icon: const Icon(Icons.people),
    onPressed: () {
      showModalBottomSheet<void>(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Divider(height: 2),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      listTile(const Icon(Icons.person), '친구관리', () {}),
                      listTile(const Icon(Icons.notifications), '알림', () {}),
                      listTile(const Icon(Icons.sort), '정렬', () {
                        sortFriendsList(context);
                      }),
                      listTile(const Icon(Icons.privacy_tip), '개인정보', () {}),
                      listTile(const Icon(Icons.help), '도움말', () {}),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

ListTile listTile(Icon icon, String title, Function onTap) {
  return ListTile(
    leading: icon,
    title: Text(title),
    onTap: () {
      onTap();
    },
  );
}

Future<void> sortFriendsList(context) {
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
