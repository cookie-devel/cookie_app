import 'package:cookie_app/cookie.appbar.dart';
import 'package:cookie_app/handler/signinout.handler.dart';
import 'package:cookie_app/pages/signin.dart';
import 'package:flutter/material.dart';
import 'package:cookie_app/pages/settings/detail/MyProfile.page.dart';
import 'package:cookie_app/components/NavigatePage.dart';

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
                    navigateSlide(context, list[index].destination!);
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
  SettingsListProp(
    text: '프로필 관리',
    icon: Icons.person,
    destination: const MyProfileWidget(),
  ),
  SettingsListProp(
    text: '알림',
    icon: Icons.notifications,
    destination: const MyProfileWidget(),
  ),
  SettingsListProp(
    text: '친구',
    icon: Icons.people,
    destination: const MyProfileWidget(),
  ),
  SettingsListProp(
    text: '언어',
    icon: Icons.language,
    destination: const MyProfileWidget(),
  ),
  SettingsListProp(
    text: '기타',
    icon: Icons.more_horiz,
    destination: const MyProfileWidget(),
  ),
  SettingsListProp(
    text: '로그아웃',
    icon: Icons.logout,
    onTap: _showAlertDialog,
    color: Colors.red,
  ),
];

Future<void> _logout(BuildContext context) async {
  await handleSignOut();
  const destination = SignInWidget();

  // 현재 페이지를 스택에서 제거하고 대상 페이지를 스택에 추가
  await Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (BuildContext context) => destination),
  );
}

Future<void> _showAlertDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: const Text(
          '로그아웃',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          '정말로 로그아웃 하시겠습니까?',
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              '아니오',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            onPressed: () {
              _logout(context);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Text(
              '예',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}
