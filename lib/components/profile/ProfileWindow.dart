import 'package:flutter/material.dart';
import 'package:cookie_app/schema/FriendInfo.dart';
import 'package:cookie_app/pages/chatroom/chatroom.dart';

// 프로필 창 class
class ProfileWindow extends StatelessWidget {
  final FriendInfo user;
  ProfileWindow({super.key, required this.user});

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
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.74,
          child: Column(
            children: [
              Container(
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                  image: DecorationImage(
                    image: AssetImage(
                      user.image ?? 'assets/images/cookie_logo.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Scrollbar(
                  controller: _scrollController,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        const ListTile(
                          title: Text(
                            'user.status_message',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Divider(height: 1),
                        userProfileListTile("이름", user.name ?? 'Unknown'),
                        const Divider(height: 1),
                        userProfileListTile("생일", 'user.birthday' ?? 'Unknown'),
                        const Divider(height: 1),
                        userProfileListTile("거주지", 'user.address' ?? 'Unknown'),
                        const Divider(height: 1),
                        userProfileListTile("나이", 'user.age' ?? 'Unknown'),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(width: 1, color: Colors.black45),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("뒤로가기"),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(width: 1, color: Colors.black45),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatWidget(user: user),
                        ),
                      );
                    },
                    child: const Text("채팅하기"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

Future profileWindow(BuildContext context, FriendInfo user) => showDialog(
      context: context,
      builder: (BuildContext context) {
        return ProfileWindow(user: user);
      },
    );

Widget userProfileListTile(String mainTitle, String subTitle) {
  return ListTile(
    title: Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        mainTitle,
        style: const TextStyle(fontSize: 14),
      ),
    ),
    subtitle: Text(
      subTitle,
      style: const TextStyle(fontSize: 18),
    ),
  );
}
