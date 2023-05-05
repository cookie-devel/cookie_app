import 'dart:io';
import 'package:cookie_app/components/auth/signup.form.dart';
import 'package:cookie_app/components/friends/FriendProfileWidget.dart';
import 'package:flutter/material.dart';
import 'package:cookie_app/cookie.appbar.dart';
import 'package:cookie_app/components/ImageSelection.dart';
import 'package:cookie_app/schema/FriendInfo.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  File? _imageFile;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CookieAppBar(title: '회원가입'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(10, 45, 10, 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Profile Image
            FriendProfileWidget(
              user: _imageFile == null
                  ? FriendInfo()
                  : FriendInfo(image: _imageFile!.path),
              enableOnLongPress: false,
              enableOnTap: false,
              displayName: false,
            ),

            const SizedBox(height: 10),

            // select image button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black45, width: 1),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('이미지 불러오기'),
              onPressed: () async {
                final imageSelectionDialog = ImageSelectionDialog();
                final imageFile = await imageSelectionDialog.show(context);
                setState(() {
                  if (imageFile != null) {
                    _imageFile = File(imageFile.path);
                  }
                });
              },
            ),

            SignUpForm(),
          ],
        ),
      ),
    );
  }
}
