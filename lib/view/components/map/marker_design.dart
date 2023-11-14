import 'dart:io';

import 'package:cookie_app/view/components/map/image_process.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';
import 'package:cookie_app/types/map/mapPosition_info.dart';
import 'package:cookie_app/service/account.service.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:custom_marker/marker_icon.dart';

class BottomSheetInside extends StatelessWidget {
  final File image;
  final String name;
  final String message;
  const BottomSheetInside({
    super.key,
    required this.image,
    required this.name,
    this.message = '',
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
                  border:
                      Border.all(width: 2.0, color: Colors.deepOrangeAccent),
                  image: DecorationImage(
                    image: FileImage(image),
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
                            name,
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
                        '$message\n',
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
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.favorite_border_outlined,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.cookie_outlined,
                            color: Colors.white,
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
  AccountViewModel user,
) async {
  String imageUrl = await getNetworkImage(user.profile.image.toString());
  File imageFile = await getCachedImage(imageUrl);
  if (!context.mounted) return;
  return showModalBottomSheet(
    context: context,
    useSafeArea: true,
    backgroundColor: Colors.white60.withOpacity(0.9),
    builder: (BuildContext context) {
      return BottomSheetInside(
        image: imageFile,
        name: user.name.toString(),
        message: user.profile.message.toString(),
      );
    },
  );
}

Future<Marker> addMarker(
  BuildContext context,
  MarkerInfo user, {
  int size = 150,
  Color color = Colors.blue,
  double width = 5,
}) async {
  AccountViewModel friendInfo =
      Provider.of<AccountService>(context, listen: false)
          .getFriendById(user.userid);
  String imageUrl = await getNetworkImage(friendInfo.profile.image.toString());
  return Marker(
    markerId: MarkerId(user.userid.toString()),
    icon: await MarkerIcon.downloadResizePictureCircle(
      imageUrl,
      size: size,
      addBorder: true,
      borderColor: color,
      borderSize: width,
    ),
    position: LatLng(
      user.latitude,
      user.longitude,
    ),
    onTap: () {
      markerBottomSheet(context, friendInfo);
    },
  );
}
