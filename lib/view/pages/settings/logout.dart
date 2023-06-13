import 'package:cookie_app/viewmodel/auth.viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> handleSignout(BuildContext context) async {
  Provider.of<AuthViewModel>(context, listen: false).signOut();

  // const destination = SignInWidget();

  // // 현재 페이지를 스택에서 제거하고 대상 페이지를 스택에 추가
  // Navigator.pushReplacement(
  //   context,
  //   MaterialPageRoute(builder: (BuildContext context) => destination),
  // );
}

Future<void> _logoutDialog(BuildContext context) async {
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
              handleSignout(context);
              Navigator.of(context).pop();
            },
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
