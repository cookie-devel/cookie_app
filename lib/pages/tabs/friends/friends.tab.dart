import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cookie_app/components/friends/FriendProfileWidget.dart';
import 'package:cookie_app/schema/FriendInfo.dart';
import 'package:flutter/services.dart';
import 'package:cookie_app/pages/tabs/friends/friends.appbar.dart';
import 'package:cookie_app/handler/data.dart';

class FriendsGrid extends StatefulWidget {
  const FriendsGrid({Key? key}) : super(key: key);

  @override
  State<FriendsGrid> createState() => _FriendsGridState();
}

class _FriendsGridState extends State<FriendsGrid> {
  List<dynamic> profiles = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
    setState(() {
      profiles = account['friendList'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: friendsAppbar(context),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 8),
        child: profiles.isNotEmpty
            ? GridView.builder(
                itemCount: profiles.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.8,
                  mainAxisSpacing: 15.0,
                  crossAxisSpacing: 10.0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  final Map<String, dynamic> profile = profiles[index];

                  return FriendProfileWidget(
                    user: returnUserInfo(profile),
                  );
                },
              )
            : const Center(
                child: Text(
                  '친구를 추가해보세요!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      ),
    );
  }
}

// Reference:
// https://eunoia3jy.tistory.com/106
// https://memostack.tistory.com/329
