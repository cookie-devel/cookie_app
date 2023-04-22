import 'package:flutter/material.dart';
import 'package:cookie_app/schema/FriendInfo.dart';

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
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            children: [
              Container(
                height: 120,
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
              const SizedBox(height: 10),
              Expanded(
                child: Scrollbar(
                  controller: _scrollController,
                  child: SingleChildScrollView(
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
                        const SizedBox(height: 7),
                        const Divider(height: 1),
                        ListTile(
                          title: const Text("이름"),
                          subtitle: Text(user.name ?? 'Unknown'),
                        ),
                        const Divider(height: 1),
                        const ListTile(
                          title: Text("생일"),
                          subtitle: Text('user.birthday'),
                        ),
                        const Divider(height: 1),
                        const ListTile(
                          title: Text("거주지"),
                          subtitle: Text('user.address'),
                        ),
                        const Divider(height: 1),
                        const ListTile(
                          title: Text("나이"),
                          subtitle: Text('user.age'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(height: 1),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("확인"),
              ),
              const SizedBox(height: 15),
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
