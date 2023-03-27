import 'package:flutter/material.dart';

const double iconWidth = 85;
const double iconHeight = 85;

final friendItems = {
  'user1': {
    'name': 'user1',
    'profile': 'assets/profile1.png',
    'status': 'online',
  },
  'user2': {
    'name': 'user2',
    'profile': 'assets/profile2.png',
    'status': 'offline',
  },
  'user3': {
    'name': 'user3',
    'profile': 'assets/profile3.png',
    'status': 'offline',
  },
  'user4': {
    'name': 'user4',
    'profile': 'assets/profile4.png',
    'status': 'offline',
  },
  'user5': {
    'name': 'user5',
    'profile': 'assets/profile5.png',
    'status': 'offline',
  },
  'user6': {
    'name': 'user6',
    'profile': 'assets/profile6.png',
    'status': 'offline',
  },
};

// FriendList? friendList;
class FriendsGrid extends StatefulWidget {
  const FriendsGrid({Key? key}) : super(key: key);

  @override
  _FriendsGridState createState() => _FriendsGridState();
}

class _FriendsGridState extends State<FriendsGrid> {
  @override
  Widget build(BuildContext context) {
    // friendList = friendItems.
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      child: GridView.builder(
        itemCount: 30,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Container(
              child: returnProfile(width: iconWidth, height: iconHeight));
        },
      ),
    );
  }
}

Widget returnProfile({required double width, required double height}) {
  return InkWell(
    onTap: () {
      print("Clicked!!!");
    },
    child: Column(children: [
      Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: const DecorationImage(
              image: AssetImage('assets/newjeans.jpg'), fit: BoxFit.contain),
          border: Border.all(
            color: const Color.fromARGB(255, 255, 99, 159),
          ),
        ),
      ),
      const Text(
        'name',
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w200,
            color: Color.fromARGB(221, 70, 70, 70)),
      )
    ]),
  );
}

// https://memostack.tistory.com/329
// Reference: https://eunoia3jy.tistory.com/106