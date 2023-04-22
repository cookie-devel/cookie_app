import 'package:flutter/material.dart';

// friends page Appbar에서 icon을 눌렀을 때 나오는 bottom sheet
IconButton friendsPageIcon(BuildContext context) {
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
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text('친구관리'),
                        onTap: () {
                          // TODO: Implement settings page
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.notifications),
                        title: const Text('알림'),
                        onTap: () {
                          // TODO: Implement notifications page
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.privacy_tip),
                        title: const Text('개인정보'),
                        onTap: () {
                          // TODO: Implement privacy page
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.help),
                        title: const Text('도움말'),
                        onTap: () {
                          // TODO: Implement help and feedback page
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.help),
                        title: const Text('도움말'),
                        onTap: () {
                          // TODO: Implement help and feedback page
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.help),
                        title: const Text('도움말'),
                        onTap: () {
                          // TODO: Implement help and feedback page
                          Navigator.pop(context);
                        },
                      ),
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
