import 'package:cookie_app/schema/FriendInfo.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:typed_data';

Widget bottomSheetInside(BuildContext context, FriendInfo user) {
  return SafeArea(
    child: Container(
      height: MediaQuery.of(context).size.height * 0.225,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 249, 253, 255),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
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
        padding: const EdgeInsets.fromLTRB(16, 10, 13, 10),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.height * 0.15,
                  height: MediaQuery.of(context).size.height * 0.15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(width: 1, color: Colors.deepOrangeAccent),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.height * 0.15 - 6,
                  height: MediaQuery.of(context).size.height * 0.15 - 6,
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
                          user.username ?? "Unknown",
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
                        "33",
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
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 10),
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
                          '채팅하기',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {},
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
                          '친구신청',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Future<void> _markerBottomSheet(BuildContext context, FriendInfo user) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.transparent,
    isDismissible: true, // 배경 터치 시 닫힐지 말지 설정
    enableDrag: true, // 드래그로 닫힐지 말지 설정
    builder: (BuildContext context) {
      return bottomSheetInside(context, user);
    },
  );
}

Marker addMarker(
  BuildContext context,
  FriendInfo user,
  LatLng location,
  Uint8List markIcons,
) {
  return Marker(
    draggable: false,
    markerId: MarkerId(user.username.toString()),
    position: location,
    icon: BitmapDescriptor.fromBytes(markIcons),
    onTap: () {
      _markerBottomSheet(context, user);
    },
  );
}
