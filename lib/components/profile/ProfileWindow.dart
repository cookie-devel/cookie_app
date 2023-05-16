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
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImage(
                        image: user.profileImage,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: user.profileImage,
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(
                      color: Colors.orangeAccent,
                      width: 3.0,
                    ),
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
                        ListTile(
                          title: Text(
                            user.profileMessage ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        const Divider(),
                        userProfileListTile("이름", user.username),
                        const Divider(),
                        userProfileListTile("생일", 'user.birthday'),
                        const Divider(),
                        userProfileListTile("거주지", 'user.address'),
                        const Divider(),
                        userProfileListTile("나이", 'user.age'),
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
                  const SizedBox(width: 22),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(width: 1, color: Colors.black45),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatRoom(room: user),
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
        return AnimatedProfileWindow(user: user);
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

class AnimatedProfileWindow extends StatefulWidget {
  final FriendInfo user;
  const AnimatedProfileWindow({super.key, required this.user});

  @override
  State<AnimatedProfileWindow> createState() => _AnimatedProfileWindowState();
}

class _AnimatedProfileWindowState extends State<AnimatedProfileWindow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 225),
    );
    _scaleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: ProfileWindow(user: widget.user),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  // final String imageUrl;
  final ImageProvider image;

  const FullScreenImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          InteractiveViewer(
            child: GestureDetector(
              onTap: () {
                // Navigator.pop(context);
              },
              child: Center(
                child: Image(image: image),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 16,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
