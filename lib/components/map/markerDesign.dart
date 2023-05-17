import 'package:flutter/material.dart';
import 'package:cookie_app/schema/FriendInfo.dart';
import 'package:cookie_app/pages/chatroom/chatroom.dart';
import 'package:cookie_app/components/map/ImageProcess.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:typed_data';

class BottomSheetInside extends StatelessWidget {
  final FriendInfo user;
  const BottomSheetInside({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final imageSize = mediaQuery.size.height * 0.165;
    return Container(
      height: mediaQuery.size.height * 0.2,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 249, 253, 255),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(21),
          topRight: Radius.circular(21),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            spreadRadius: 0.5,
            offset: Offset(0.7, 0.7),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 10, 10, 8),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(width: 1, color: Colors.deepOrangeAccent),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.height * 0.158 - 2,
                  height: MediaQuery.of(context).size.height * 0.158 - 2,
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
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          user.username,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.person,
                        size: 16,
                        color: Colors.black54,
                      ),
                      const SizedBox(width: 1),
                      const Text(
                        "777",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: Text(
                      '${user.profileMessage!}\n',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrangeAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                              color: Colors.black45,
                              width: 1,
                            ),
                          ),
                        ),
                        child: const Text(
                          'COOKIE!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Fluttertoast.showToast(
                            msg: 'COOKIE!!!',
                            toastLength: Toast.LENGTH_SHORT,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black.withOpacity(0.2),
                            textColor: Colors.white,
                          );
                        },
                      ),
                      const SizedBox(width: 18),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrangeAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                              color: Colors.black45,
                              width: 1,
                            ),
                          ),
                        ),
                        child: const Text(
                          '채팅하기',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
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
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> markerBottomSheet(BuildContext context, FriendInfo user) {
  return showModalBottomSheet(
    context: context,
    useSafeArea: true,
    builder: (BuildContext context) {
      return BottomSheetInside(user: user);
    },
  );
}

Future<Marker> addMarker(
  BuildContext context,
  FriendInfo user,
  LatLng location, {
  int size = 100,
  Color color = Colors.deepOrangeAccent,
  double width = 4,
}) async {
  Uint8List markIcons = await getRoundedImage(
    user.profileImage,
    width: size,
    borderColor: color,
    borderWidth: width,
  );
  return Marker(
    markerId: MarkerId(user.username.toString()),
    icon: BitmapDescriptor.fromBytes(markIcons),
    position: location,
    onTap: () {
      markerBottomSheet(context, user);
    },
  );
}
