import 'package:cookie_app/service/account.service.dart';
import 'package:cookie_app/service/map.service.dart';
import 'package:cookie_app/types/map/mapPosition_info.dart';
import 'package:cookie_app/utils/navigation_service.dart';
import 'package:cookie_app/view/pages/maps/maps.tab.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';
import 'package:cookie_app/viewmodel/map.viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

// Seaching for friends
Future friendLocationBottomSheet() async {
  BuildContext context = NavigationService.navigatorKey.currentContext!;
  final mapInfo = context.read<MapViewModel>().mapLog;

  return showModalBottomSheet(
    context: context,
    useSafeArea: true,
    builder: (BuildContext context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.45,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.supervised_user_circle_outlined,
                        color: Colors.green.shade400,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        '현재 접속중인 친구',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: mapInfo.length,
                padding: const EdgeInsets.fromLTRB(5, 4, 10, 4),
                itemBuilder: (BuildContext context, int index) {
                  return FriendLocationListTile(log: mapInfo[index]);
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

class FriendLocationListTile extends StatelessWidget {
  final MarkerInfo log;

  const FriendLocationListTile({Key? key, required this.log}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AccountViewModel friend =
        context.read<AccountService>().getFriendById(log.userid);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(
          friend.profile.image.toString(),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(friend.name),
          Text(
            context.read<MapService>().calDistance(
                  LatLng(
                    log.latitude,
                    log.longitude,
                  ),
                ),
          ),
        ],
      ),
      onTap: () => {
        context.read<MapService>().moveCamera(
              LatLng(
                log.latitude,
                log.longitude,
              ),
            ),
      },
    );
  }
}
