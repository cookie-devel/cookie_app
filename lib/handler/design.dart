import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cookie_app/friends.dart';
import 'package:cookie_app/handler/socket.dart';

// reference:
// https://fonts.google.com/icons


// cookie앱의 기본 Appbar
PreferredSize? cookieAppbar(BuildContext context,String title){

  return PreferredSize(
    preferredSize: const Size.fromHeight(50.0),
    child: AppBar(
      title: Text(title),
      backgroundColor: Colors.orangeAccent,
      elevation: 0,
      actions: [
      ],
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Colors.orangeAccent,
              Colors.deepOrangeAccent,
            ],
          ),
        ),
      ),
    ),
  );
}

// cookie앱의 friends page Appbar
PreferredSize? friendsAppbar(BuildContext context){

  return PreferredSize(
    preferredSize: const Size.fromHeight(50.0),
    child: AppBar(
      title: Text('친구'),
      backgroundColor: Colors.orangeAccent,
      elevation: 0,
      actions: [
        friendsPageIcon(context),
      ],
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Colors.orangeAccent,
              Colors.deepOrangeAccent,
            ],
          ),
        ),
      ),
    ),
  );
}

// cookie앱의 settings page Appbar
PreferredSize? settingsAppbar(BuildContext context){

  return PreferredSize(
    preferredSize: const Size.fromHeight(50.0),
    child: AppBar(
      title: Text('설정'),
      backgroundColor: Colors.orangeAccent,
      elevation: 0,
      actions: [
      ],
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Colors.orangeAccent,
              Colors.deepOrangeAccent,
            ],
          ),
        ),
      ),
    ),
  );
}

// friends page Appbar에서 icon을 눌렀을 때 나오는 bottom sheet
IconButton friendsPageIcon(BuildContext context){
  return IconButton(
    icon: const Icon(Icons.people),
    onPressed: () {
      showModalBottomSheet<void>(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Divider(height: 2),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text('친구관리'),
                        onTap: () {
                          // TODO: Implement settings page
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.notifications),
                        title: Text('알림'),
                        onTap: () {
                          // TODO: Implement notifications page
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.privacy_tip),
                        title: Text('개인정보'),
                        onTap: () {
                          // TODO: Implement privacy page
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.help),
                        title: Text('도움말'),
                        onTap: () {
                          // TODO: Implement help and feedback page
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.help),
                        title: Text('도움말'),
                        onTap: () {
                          // TODO: Implement help and feedback page
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.help),
                        title: Text('도움말'),
                        onTap: () {
                          // TODO: Implement help and feedback page
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}


// 프로필 창 class
class ProfileWindow extends StatelessWidget {
  final FriendInfo user;
  ProfileWindow({required this.user});

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                  image: DecorationImage(
                    image: AssetImage(user.image ?? 'assets/images/cookie_logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Scrollbar(
                  controller: _scrollController,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            'user.status_message',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 7),
                        const Divider(height: 1),
                        ListTile(
                          title: Text("이름"),
                          subtitle: Text(user.name ?? 'Unknown'),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          title: Text("생일"),
                          subtitle: Text('user.birthday'),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          title: Text("거주지"),
                          subtitle: Text('user.address'),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          title: Text("나이"),
                          subtitle: Text('user.age'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(height: 1),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("확인"),
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}

Future profileWindow(BuildContext context,FriendInfo user) => showDialog(
  context: context,
  builder: (BuildContext context) {
    return ProfileWindow(user: user);
  },
);

// 친구 정보 class
class FriendInfo {

  final String? name;
  final String? image;
  final Map? log;

  FriendInfo({this.name = "Unknown", 
              this.image = "assets/images/user.jpg",
              this.log = const {}});

}

// dictionary -> FriendInfo
FriendInfo returnUserInfo(Map<String, dynamic> profile) {
  String name = profile['name'] as String;
  String image = profile['image'] as String;
  
  Map log = {};
  if (profile['log'] != null) {
    Map log = profile['log'] as Map;
  } 
  else {
    Map log = {};
  }
  return FriendInfo(name: name, 
                    image: image,
                    log: log);
}

// text 클립보드에 복사
class LongPressCopyableText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const LongPressCopyableText({
    Key? key,
    required this.text,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: text));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('클립보드에 복사'),
          duration:Duration(milliseconds:300),
          ),
        );
      },
      child: Text(text, style: style),
    );
  }
}

// socket 연결 상태 확인
Widget connectionInfo() => Row(
  mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        socket.connected ? Icons.check_circle : Icons.warning,
        color: socket.connected ? Colors.green : Colors.red,
        size: 16.0,
      ),
      const SizedBox(width: 4.0),
      Text(
        socket.connected ? 'Connected' : 'Disconnected',
        style: const TextStyle(fontSize: 16.0),
      ),
      SizedBox(width: 5,),
    ],
);
