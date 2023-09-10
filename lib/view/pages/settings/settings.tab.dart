import 'package:cookie_app/view/components/dialog.dart';
import 'package:cookie_app/view/pages/settings/detail/MyProfile.page.dart';
// import 'package:cookie_app/view/pages/settings/detail/appTheme.page.dart';
import 'package:cookie_app/viewmodel/auth.viewmodel.dart';
import 'package:cookie_app/viewmodel/theme.viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsWidget extends StatelessWidget {
  SettingsWidget({Key? key}) : super(key: key);
  final List<SettingsListProp> list = [
    SettingsListProp(
      text: '프로필 관리',
      icon: Icons.person,
      destination: const MyProfileWidget(),
    ),
    // SettingsListProp(
    //   text: '알림',
    //   icon: Icons.notifications,
    //   destination: MyProfileWidget(),
    // ),
    // SettingsListProp(
    //   text: '친구',
    //   icon: Icons.people,
    //   destination: MyProfileWidget(),
    // ),
    // SettingsListProp(
    //   text: '언어',
    //   icon: Icons.language,
    //   destination: MyProfileWidget(),
    // ),

    SettingsListProp(
      text: '테마',
      icon: Icons.color_lens,
      // destination: const ThemeSettingsPage(),
      trailing: Switch(
        onChanged: (value) {
          // Provider.of<ThemeProvider>(, listen: false).isDarkModeEnabled = value;
        },
        value: false,
      ),
      onTap: (context) {
        Provider.of<ThemeProvider>(context).toggleDarkMode();
      },
    ),
    // SettingsListProp(
    //   text: '기타',
    //   icon: Icons.more_horiz,
    //   destination: MyProfileWidget(),
    // ),
    SettingsListProp(
      text: '로그아웃',
      icon: Icons.logout,
      onTap: (context) {
        showDialog(
          context: context,
          builder: (context) => Alert(
            title: "로그아웃",
            content: "로그아웃 하시겠습니까?",
            onConfirm:
                Provider.of<AuthViewModel>(context, listen: false).signOut,
            onCancel: () => {},
          ),
        );
      },
      color: Colors.red,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              ListTile(
                title: Text(
                  list[index].text,
                  style: TextStyle(color: list[index].color),
                ),
                leading: Icon(
                  list[index].icon,
                  color: list[index].color,
                ),
                trailing: list[index].trailing,
                onTap: () {
                  if (list[index].onTap != null) {
                    list[index].onTap!(context);
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => list[index].destination!,
                      ),
                    );
                  }
                },
              ),
              const Divider(height: 1),
            ],
          );
        },
      ),
    );
  }
}

class SettingsListProp {
  final String text;
  final IconData icon;
  final Widget? destination;
  final Function? onTap;
  final Color? color;
  final Widget? trailing;

  SettingsListProp({
    required this.text,
    required this.icon,
    this.destination,
    this.onTap,
    this.color,
    this.trailing = const Icon(Icons.arrow_forward_ios),
  });
}
