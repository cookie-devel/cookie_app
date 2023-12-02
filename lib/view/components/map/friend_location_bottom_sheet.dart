import 'package:cookie_app/theme/default.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:cookie_app/service/map.service.dart';
import 'package:cookie_app/types/map/map_position_info.dart';
import 'package:cookie_app/utils/navigation_service.dart';
import 'package:cookie_app/viewmodel/map.viewmodel.dart';

class FriendLocationListTile extends StatelessWidget {
  final MarkerInfo log;

  const FriendLocationListTile({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(log.account.name),
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
      leading: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: DefaultColor.colorsecondaryOrange,
            width: 1.3,
          ),
        ),
        child: CircleAvatar(
          backgroundColor: DefaultColor.colorMainWhite,
          backgroundImage: log.account.profile.image,
        ),
      ),
      trailing: IconButton(
        icon: Icon(
          Icons.cookie_sharp,
          color: DefaultColor.colorsecondaryOrange,
        ),
        onPressed: () {},
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

// Seaching for friends
Future friendLocationBottomSheet() async {
  BuildContext context = NavigationService.navigatorKey.currentContext!;

  return showModalBottomSheet(
    context: context,
    useSafeArea: true,
    backgroundColor: DefaultColor.colorMainWhite,
    builder: (BuildContext context) {
      final mapInfo = context.watch<MapViewModel>().mapLog;
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
                        '현재 접속 중인 친구',
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 2,
              color: DefaultColor.colorMainWhite,
            ),
            mapInfo.isEmpty
                ? const Expanded(
                    child: Center(
                      child: Text(
                        '현재 접속 중인 친구가 없습니다.',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                : Expanded(
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
