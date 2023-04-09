import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const Friends());
}

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

const double iconWidth = 85;
const double iconHeight = 85;

const JsonDecoder decoder = JsonDecoder();

const String jsonString = '''{
    "user1": {
      "name": "user1",
      "profile": "assets/images/profile1.png",
      "status": "online"
    },
    "user2": {
      "name": "user2",
      "profile": "assets/images/profile2.png",
      "status": "offline"
    },
    "user3": {
      "name": "user3",
      "profile": "assets/images/profile3.png",
      "status": "offline"
    },
    "user4": {
      "name": "user4",
      "profile": "assets/images/profile4.png",
      "status": "offline"
    },
    "user5": {
      "name": "user5",
      "profile": "assets/images/profile5.png",
      "status": "offline"
    },
    "user6": {
      "name": "user6",
      "profile": "assets/images/profile6.png",
      "status": "offline"
    }
  }
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
    // friendList = friendItems.
  
    final Map<String, dynamic> object = decoder.convert(jsonString);

    final item = object['user1'];
    print(item['name']);
    print(item['profile']);
    print(item['status']);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('My App'),
      // ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, kToolbarHeight-16, 8, 8),
        child: GridView.builder(
          itemCount: 30,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            mainAxisSpacing: 40.0,
            crossAxisSpacing: 10.0,
          ),
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: returnProfile(width: iconWidth, height: iconHeight),
            );
          },
        ),
      ),
    );
  }
}

Widget returnProfile({required double width, required double height}) {
  return InkWell(
    onTap: () {
      print("Clicked!!!");
    },
    child: Column(
      children: [

        Expanded(
          child: Container(
            width: width,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: const DecorationImage(
                  image: AssetImage('assets/images/newjeans.jpg'), fit: BoxFit.contain),
              border: Border.all(
                color: const Color.fromARGB(255, 255, 99, 159),
              ),
            ),
          ),
        ),

        const SizedBox(height: 5),

        const Text(
          'name',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w200,
              color: Color.fromARGB(221, 70, 70, 70)),
        )
      ]
    ),
  );
}



// https://memostack.tistory.com/329
// Reference: https://eunoia3jy.tistory.com/106