import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:cookie_app/view/components/dialog.dart';
import 'package:cookie_app/viewmodel/auth.provider.dart';
import 'package:cookie_app/viewmodel/chat.viewmodel.dart';
import 'package:cookie_app/viewmodel/theme.provider.dart';

class SettingsWidget extends StatelessWidget {
  SettingsWidget({Key? key}) : super(key: key);

  final List<ListTile Function(BuildContext)> itemBuilders = [
    (context) => const ListTile(
          title: Text('프로필 관리'),
          leading: Icon(Icons.person),
        ),
    (context) => ListTile(
          title: const Text('다크 모드'),
          leading: const Icon(Icons.color_lens),
          trailing: Switch(
            onChanged: context.read<ThemeProvider>().setDarkMode,
            value: context.watch<ThemeProvider>().isDarkMode,
          ),
        ),
    (context) => ListTile(
          title: const Text(
            '로그아웃',
            style: TextStyle(color: Colors.red),
          ),
          leading: const Icon(Icons.logout, color: Colors.red),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => Alert(
                title: "로그아웃",
                content: "로그아웃 하시겠습니까?",
                onConfirm: () {
                  context.read<ChatViewModel>().disconnect();
                  context.read<AuthProvider>().signOut();
                  Navigator.of(context).pop();
                },
              ),
            );
          },
        ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: itemBuilders.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 1, thickness: 0.1),
      itemBuilder: (context, index) => itemBuilders[index](context),
    );
  }
}
