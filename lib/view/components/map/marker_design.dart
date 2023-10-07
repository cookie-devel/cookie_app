import 'package:cookie_app/viewmodel/account.viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:cookie_app/view/components/map/image_process.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:typed_data';

class BottomSheetInside extends StatelessWidget {
  final PublicAccountViewModel user;
  const BottomSheetInside({
    Key? key,
    required this.user,
  }) : super(key: key);

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
                  border: Border.all(width: 2.0, color: Colors.white),
                  image: DecorationImage(
                    image: user.profile.image,
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
                            user.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
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
                          color: Colors.white,
                        ),
                        const SizedBox(width: 1),
                        const Text(
                          "777",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Flexible(
                      child: Text(
                        '${user.profile.message!}\n',
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
  PublicAccountViewModel user,
) {
  return showModalBottomSheet(
    context: context,
    useSafeArea: true,
    backgroundColor: Colors.deepOrange.withOpacity(0.9),
    builder: (BuildContext context) {
      return BottomSheetInside(user: user);
    },
  );
}

Future<Marker> addMarker(
  BuildContext context,
  PublicAccountViewModel user, {
  int size = 100,
  Color color = Colors.deepOrangeAccent,
  double width = 4,
}) async {
  Uint8List markIcons = await getRoundedImage(
    user.profile.image,
    width: size,
    borderColor: color,
    borderWidth: width,
  );
  return Marker(
    markerId: MarkerId(user.name.toString()),
    icon: BitmapDescriptor.fromBytes(markIcons),
    position: LatLng(
      0,0,
      // user.location?.latitude as double,
      // user.location?.longitude as double,
    ),
    onTap: () {
      markerBottomSheet(context, user);
    },
  );
}
