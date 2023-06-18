import 'package:cookie_app/view/components/fullscreen_image.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';
import 'package:flutter/material.dart';

// 프로필 창 class
class ProfileWindow extends StatelessWidget {
  final PublicAccountViewModel user;
  const ProfileWindow({
    super.key,
    required this.user,
  });

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
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image(
                    image: user.profileImage,
                    fit: BoxFit.cover,
                    errorBuilder: (
                      BuildContext context,
                      Object error,
                      StackTrace? stackTrace,
                    ) {
                      return const Icon(Icons.person);
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: pivotSize * 0.087),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              scrollDirection: Axis.vertical,
              children: [
                SizedBox(
                  height: pivotSize * 1.5,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 100,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
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
                                user.profileMessage ?? '',
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
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Expanded(
                        flex: 45,
                        child: Container(
                          height: pivotSize * 0.45,
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
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
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                divider,
                const UserProfileTile(mainTitle: "생일", subTitle: '2000-01-01'),
                divider,
                const UserProfileTile(mainTitle: "거주지", subTitle: '경기 수원'),
                divider,
                const UserProfileTile(mainTitle: "나이", subTitle: '24'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserProfileTile extends StatelessWidget {
  const UserProfileTile({
    super.key,
    required this.mainTitle,
    required this.subTitle,
  });

  final String mainTitle;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orangeAccent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
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