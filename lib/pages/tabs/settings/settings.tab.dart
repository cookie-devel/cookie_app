import 'package:cookie_app/pages/signin.dart';
import 'package:flutter/material.dart';
import 'package:cookie_app/handler/storage.dart';
import 'settings.appbar.dart';
import 'detail/MyProfile.page.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({Key? key}) : super(key: key);

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: settingsAppbar(context),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('프로필 관리'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 150),
                  reverseTransitionDuration: const Duration(milliseconds: 150),
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return const MyProfileWidget();
                  },
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                ),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('알림'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle notification settings onTap
            },
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('친구'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle privacy settings onTap
            },
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('언어'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle language settings onTap
            },
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('기타'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle about onTap
            },
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text(
              '로그아웃',
              style: TextStyle(color: Colors.red),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.red,
            ),
            onTap: () {
              _showAlertDialog(context);
            },
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }
}

Future<void> _logout(BuildContext context) async {
  await storage.delete(key: 'id');
  await storage.delete(key: 'pw');

  const destination = SignInWidget();

  // 현재 페이지를 스택에서 제거하고 대상 페이지를 스택에 추가
  Navigator.pushReplacement(
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
        title: Text(
          '로그아웃',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          '정말로 로그아웃 하시겠습니까?',
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
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
            child: Text(
              '예',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              _logout(context);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ],
      );
    },
  );
}
