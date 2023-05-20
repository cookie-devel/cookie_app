import 'package:flutter/material.dart';
import 'package:cookie_app/schema/User.dart';

// 프로필 창 class
class ProfileWindow extends StatelessWidget {
  final User user;
  const ProfileWindow({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    double pivotSize = MediaQuery.of(context).size.height * 0.19;
    Widget divider = const Divider(thickness: 2);
    return SizedBox.expand(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: pivotSize * 0.13),
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
                  width: pivotSize,
                  height: pivotSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(width: 1, color: Colors.white),
                  ),
                ),
                Container(
                  width: pivotSize * 0.942,
                  height: pivotSize * 0.942,
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
          SizedBox(height: pivotSize * 0.087),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              scrollDirection: Axis.vertical,
              children: [
                Container(
                  height: pivotSize,
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
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
                        user.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user.profileMessage,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
                  height: pivotSize * 0.45,
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
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
                          // TODO: ChatRoom room
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => ChatRoom(room: user),
                          //   ),
                          // );
                        },
                        icon: Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.white,
                          size: pivotSize * 0.22,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.favorite_border_outlined,
                          color: Colors.white,
                          size: pivotSize * 0.22,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.cookie_outlined,
                          color: Colors.white,
                          size: pivotSize * 0.22,
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
      decoration: BoxDecoration(
        color: Colors.orangeAccent,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
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

Future<void> profileBottomSheet(BuildContext context, User user) {
  return showModalBottomSheet(
    context: context,
    useSafeArea: true,
    backgroundColor: const Color.fromARGB(255, 83, 56, 63),
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
