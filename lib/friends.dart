import 'dart:convert';
import 'chat.dart';
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
    "name": "Jane",
    "image": "assets/images/newjeans.jpg"
  },  
  {
    "name": "Jane",
    "image": "assets/images/newjeans.jpg"
  },
  {
    "name": "JB",
    "image": "assets/images/newjeans.jpg"
  },
  {
    "name": "Jane",
    "image": "assets/images/newjeans.jpg"
  },  
  {
    "name": "Jane",
    "image": "assets/images/newjeans.jpg"
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

    // JSON 데이터를 파싱하여 List<Map<String, dynamic>> 형태로 변환합니다.
    final List<dynamic> profiles = jsonDecode(jsonString);
    final int listLength = profiles.length;


    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('친구'),
      // ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, kToolbarHeight-16, 8, 8),
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
              child: returnProfile(context: context,
                                  width: iconWidth, 
                                  height: iconHeight,
                                  image: profile['image'] as String,
                                  name: profile['name'] as String),
            );
          },
        ),
      ),
    );
  }
}

Widget returnProfile({required context, required double width, required double height,  
                      required String image, required String name,}) {

  return InkWell(

    onTap: () {
      print("="*30);
      print("${name} Clicked!!!");
      print("${image}");
      Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChatWidget()),
      );
    },
    
    child: Column(
      children: [

        Expanded(
          child: Container(
            width: width,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: AssetImage(image), fit: BoxFit.contain),
              border: Border.all(
                color: const Color.fromARGB(255, 255, 99, 159),
                width: 1.5
              ),
            ),
          ),
        ),

        const SizedBox(height: 5),

        Text(
          name,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w200,
              color: Color.fromARGB(221, 60, 60, 60)
          ),
        )

      ]
    ),
  );
}



// https://memostack.tistory.com/329
// Reference: https://eunoia3jy.tistory.com/106