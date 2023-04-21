import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cookie_app/handler/design.dart';
import 'package:cookie_app/handler/handler_friends.dart';
import 'package:cookie_app/ect/test_data.dart';

class FriendsGrid extends StatefulWidget {
  const FriendsGrid({Key? key}) : super(key: key);

  @override
  State<FriendsGrid> createState() => _FriendsGridState();
}

class _FriendsGridState extends State<FriendsGrid> {

  @override
  Widget build(BuildContext context) {
    final List<dynamic> profiles = jsonDecode(jsonString);
    final int listLength = profiles.length;

    return Scaffold(
      appBar: friendsAppbar(context),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 24, 10, 8),
        child: GridView.builder(
          itemCount: listLength,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            mainAxisSpacing: 40.0,
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