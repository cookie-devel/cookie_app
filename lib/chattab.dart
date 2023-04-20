import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cookie_app/handler/design.dart';
import 'package:cookie_app/handler/socket.dart';
import 'package:cookie_app/handler/handler_chattab.dart';

const String jsonChatLog = '''[
  {
    "name": "박종범",
    "image": "assets/images/user2.jpg",
    "log": {
      "2021-08-01": [
        {
          "sender": "박종범",
          "message": "안녕하세요"
        },
        {
          "sender": "박종범",
          "message": "반갑습니다"
        }
      ]
    }
  },
  {
    "name": "김채원",
    "image": "assets/images/cw1.png",
    "log": {
      "2021-08-09": [
        {
          "sender": "김채원",
          "message": "안녕하세요"
        },
        {
          "sender": "김채원",
          "message": "반갑습니다"
        }
      ]
    }
  },  
  {
    "name": "백승헌",
    "image": "assets/images/user.jpg",
    "log": {
      "2021-08-02": [
        {
          "sender": "백승헌",
          "message": "안녕하세요"
        },
        {
          "sender": "백승헌",
          "message": "반갑습니다"
        }
      ]
    }
  },
  {
    "name": "홍은채",
    "image": "assets/images/ec1.png",
    "log": {
      "2021-08-09": [
        {
          "sender": "김채원",
          "message": "안녕하세요"
        },
        {
          "sender": "김채원",
          "message": "반갑습니다"
        }
      ]
    }
  },
  {
    "name": "카즈하",
    "image": "assets/images/kz1.png",
    "log": {
      "2021-08-09": [
        {
          "sender": "김채원",
          "message": "안녕하세요"
        },
        {
          "sender": "김채원",
          "message": "반갑습니다"
        }
      ]
    }
  },  
  {
    "name": "사쿠라",
    "image": "assets/images/sk1.png",
    "log": {
      "2021-08-09": [
        {
          "sender": "김채원",
          "message": "안녕하세요"
        },
        {
          "sender": "김채원",
          "message": "반갑습니다"
        }
      ]
    }
  },  
  {
    "name": "허윤진",
    "image": "assets/images/yj1.png",
    "log": {
      "2021-08-09": [
        {
          "sender": "김채원",
          "message": "안녕하세요"
        },
        {
          "sender": "김채원",
          "message": "반갑습니다"
        }
      ]
    }
  },  
  {
    "name": "김채원",
    "image": "assets/images/cw2.png",
    "log": {
      "2021-08-09": [
        {
          "sender": "김채원",
          "message": "안녕하세요"
        },
        {
          "sender": "김채원",
          "message": "반갑습니다"
        }
      ]
    }
  },  
  {
    "name": "김채원",
    "image": "assets/images/cw3.png",
    "log": {
      "2021-08-09": [
        {
          "sender": "김채원",
          "message": "안녕하세요"
        },
        {
          "sender": "김채원",
          "message": "반갑습니다"
        }
      ]
    }
  }
]
''';

class ChatTabWidget extends StatefulWidget {
  const ChatTabWidget({super.key});

  @override
  _ChatTabWidgetState createState() => _ChatTabWidgetState();
}

class _ChatTabWidgetState extends State<ChatTabWidget> {
  
  // late List<dynamic> chatLog;
  // late int chatLength;
  
  // @override
  // void initState() {
  //   super.initState();
  //   chatLog = jsonDecode(jsonChatLog);
  //   chatLength = chatLog.length;
  // }



  @override
  Widget build(BuildContext context) {

    final List<dynamic> chatLog = jsonDecode(jsonChatLog);
    final int chatLength = chatLog.length;

    return Scaffold(
      appBar: cookieAppbar(context,'채팅'),
      body:Padding(
        padding: const EdgeInsets.fromLTRB(10, 16, 10, 8),
        child:ListView.builder(
          itemCount: chatLength,
          itemBuilder: (BuildContext context, int index) {
            final Map<String, dynamic> log = chatLog[index];

            return Container(
              child: returnChatTabWidget(
                  context: context,
                  user: returnUserInfo(log)
              ),
            );
          },
        )
      ),
    );
  }


  // @override
  // void dispose() {
  //   super.dispose();
  // }

}