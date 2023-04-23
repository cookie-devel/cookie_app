import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cookie_app/components/friends/FriendProfileWidget.dart';
import 'package:cookie_app/schema/FriendInfo.dart';
import 'package:flutter/services.dart';
import 'package:cookie_app/pages/tabs/friends/friends.appbar.dart';

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
    getSampleData();
  }

  void getSampleData() async {
    final String res = await rootBundle.loadString('assets/data/friends.json');
    final data = await json.decode(res);

    setState(() {
      profiles = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: friendsAppbar(context),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 8),
        child: GridView.builder(
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
        ),
      ),
    );
  }
}

// Reference:
// https://eunoia3jy.tistory.com/106
// https://memostack.tistory.com/329
