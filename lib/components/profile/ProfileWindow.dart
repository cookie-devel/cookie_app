import 'package:flutter/material.dart';
import 'package:cookie_app/schema/FriendInfo.dart';
import 'package:cookie_app/pages/chatroom/chatroom.dart';

// 프로필 창 class
class ProfileWindow extends StatelessWidget {
  final FriendInfo user;
  const ProfileWindow({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    double imageSize = MediaQuery.of(context).size.height * 0.19;
    Widget divider = const Divider(thickness: 2);
    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(width: 1, color: Colors.white),
                  ),
                ),
                Container(
                  width: imageSize - 8,
                  height: imageSize - 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: user.profileImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Flexible(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
              scrollDirection: Axis.vertical,
              children: [
                Container(
                  height: imageSize,
                  decoration: const BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.5, 0.5),
                      ),
                    ],
                  ),
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user.profileMessage ?? "",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Container(
                  height: imageSize * 0.4,
                  decoration: const BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.5, 0.5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatRoom(room: user),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.favorite_border_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.cookie_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                divider,
                userProfiletile("생일", 'user.birthday'),
                divider,
                userProfiletile("거주지", 'user.address'),
                divider,
                userProfiletile("나이", 'user.age'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget userProfiletile(String mainTitle, String subTitle) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.orangeAccent,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            spreadRadius: 0.5,
            offset: Offset(0.5, 0.5),
          ),
        ],
      ),
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mainTitle,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subTitle,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 26.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
Future<void> profileBottomSheet(BuildContext context, FriendInfo user) {
  return showModalBottomSheet(
    context: context,
    useSafeArea: true,
    backgroundColor: const Color.fromARGB(255, 254, 218, 230),
    builder: (BuildContext context) {
      return ProfileWindow(user: user);
    },
  );
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
