import 'dart:convert';
import 'package:cookie_app/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class Friends extends StatelessWidget {
  const Friends({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ko', 'KR'),
      ],
      home: FriendsGrid(),
    );
  }
}

const String jsonString = '''[
  {
    "name": "박종범",
    "image": "assets/images/user2.jpg"
  },
  {
    "name": "백승헌",
    "image": "assets/images/user.jpg"
  },
  {
    "name": "Jane",
    "image": "assets/images/cookies.jpg"
  },
  {
    "name": "JB",
    "image": "assets/images/cookie_logo.png"
  },
  {
    "name": "cw1",
    "image": "assets/images/cw1.png"
  },
  {
    "name": "cw2",
    "image": "assets/images/cw2.png"
  },
  {
    "name": "cw3",
    "image": "assets/images/cw3.png"
  },
  {
    "name": "cw4",
    "image": "assets/images/cw4.png"
  },
  {
    "name": "cw5",
    "image": "assets/images/cw5.png"
  },
  {
    "name": "cw4",
    "image": "assets/images/cw4.png"
  },
  {
    "name": "cw5",
    "image": "assets/images/cw5.png"
  },
  {
    "name": "cw4",
    "image": "assets/images/cw4.png"
  },
  {
    "name": "cw5",
    "image": "assets/images/cw5.png"
  }
]
''';

// FriendList? friendList;
class FriendsGrid extends StatefulWidget {
  const FriendsGrid({Key? key}) : super(key: key);

  @override
  _FriendsGridState createState() => _FriendsGridState();
}

class _FriendsGridState extends State<FriendsGrid> {
  @override
  Widget build(BuildContext context) {
    final List<dynamic> profiles = jsonDecode(jsonString);
    final int listLength = profiles.length;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, kToolbarHeight - 32, 8, 8),
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

            return Container(
              child: returnProfile(
                  context: context,
                  user: returnUserInfo(profile)
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget returnProfile({
  required BuildContext context,
  required FriendInfo user
  }) {
  return InkWell(

    onTap: () {

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatWidget(name:user.name,image:user.image),
        ),
      );
      // print("=" * 30);
      // print("${user.name} Clicked!!!");
      // print("${user.image}");

    },

    child: Column(
      
      children: [

        Expanded(
          child: Container(
            width: 85,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image:
                  DecorationImage(image: AssetImage(user.image), fit: BoxFit.contain),
              border: Border.all(
                  color: const Color.fromARGB(255, 255, 99, 159), width: 1.8),
            ),
          ),
        ),

        const SizedBox(height: 5),

        Text(
          user.name,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w200,
              color: Color.fromARGB(221, 60, 60, 60)),
        )
      ]
    ),
  );
}

class FriendInfo {

  final String name;
  final String image;

  FriendInfo({required this.name, required this.image});

}

FriendInfo returnUserInfo(Map<String, dynamic> profile) {

  String name = profile['name'] as String;
  String image = profile['image'] as String;

  return FriendInfo(name: name, 
                    image: image);

}

// Reference: https://eunoia3jy.tistory.com/106
//            https://memostack.tistory.com/329


