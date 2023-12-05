import 'dart:io';

import 'package:cookie_app/view/components/map/image_process.dart';
import 'package:flutter/material.dart';
import 'package:custom_marker/marker_icon.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:cookie_app/viewmodel/map/marker.viewmodel.dart';

class BottomSheetInside extends StatelessWidget {
  final MarkerViewModel user;
  final File imageFile;

  const BottomSheetInside({
    super.key,
    required this.user,
    required this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SizedBox(
      height: mediaQuery.size.height * 0.2,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Row(
          children: [
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 2.0,
                    color: Colors.white,
                  ),
                  image: DecorationImage(
                    image: FileImage(
                      imageFile,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Flexible(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.fromLTRB(12, 14, 12, 0),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
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
                            user.name.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Flexible(
                      child: Text(
                        '${user.account.profile.message ?? 'null'}\n',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          icon: const Icon(
                            Icons.chat_bubble_outline,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.favorite_border_outlined,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.cookie_outlined,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> markerBottomSheet(
  BuildContext context,
  MarkerViewModel user,
) async {
  String imageUrl =
      await getNetworkImage(user.account.profile.imageURL.toString());
  File imageFile = await getCachedImage(imageUrl);

  if (!context.mounted) return;
  return showModalBottomSheet(
    context: context,
    useSafeArea: true,
    backgroundColor: Colors.white,
    builder: (BuildContext context) {
      return BottomSheetInside(
        user: user,
        imageFile: imageFile,
      );
    },
  );
}

Future<Marker> addMarker(
  BuildContext context,
  MarkerViewModel user, {
  int size = 135,
  Color color = Colors.deepOrangeAccent,
  double width = 13,
}) async {
  String imageUrl =
      await getNetworkImage(user.account.profile.imageURL.toString());
  return Marker(
    markerId: MarkerId(user.id),
    position: user.position,
    icon: await MarkerIcon.downloadResizePictureCircle(
      imageUrl,
      size: size,
      addBorder: true,
      borderColor: color,
      borderSize: width,
    ),
    onTap: () {
      markerBottomSheet(context, user);
    },
  );
}
