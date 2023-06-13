import 'package:cookie_app/view/components/cookie.appbar.dart';
import 'package:flutter/material.dart';

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CookieAppBar(title: '설정'),
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
                trailing: const Icon(Icons.arrow_forward_ios),
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
              const Divider(
                height: 1,
              )
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

  SettingsListProp({
    required this.text,
    required this.icon,
    this.destination,
    this.onTap,
    this.color,
  });
}

List<SettingsListProp> list = [
  // SettingsListProp(
  //   text: '프로필 관리',
  //   icon: Icons.person,
  //   destination: const MyProfileWidget(),
  // ),
  // SettingsListProp(
  //   text: '알림',
  //   icon: Icons.notifications,
  //   destination: const MyProfileWidget(),
  // ),
  // SettingsListProp(
  //   text: '친구',
  //   icon: Icons.people,
  //   destination: const MyProfileWidget(),
  // ),
  // SettingsListProp(
  //   text: '언어',
  //   icon: Icons.language,
  //   destination: const MyProfileWidget(),
  // ),
  // SettingsListProp(
  //   text: '테마',
  //   icon: Icons.color_lens,
  //   destination: const ThemeSettingsPage(),
  // ),
  // SettingsListProp(
  //   text: '기타',
  //   icon: Icons.more_horiz,
  //   destination: const MyProfileWidget(),
  // ),
  // SettingsListProp(
  //   text: '로그아웃',
  //   icon: Icons.logout,
  //   // onTap: handleSignOut,
  //   onTap: () => Provider.of<AuthViewModel>(context, listen: false).signOut(),
  //   color: Colors.red,
  // ),
];
