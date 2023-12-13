import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cookie_app/viewmodel/map/map.viewmodel.dart';
import 'package:cookie_app/utils/navigation_service.dart';
import 'package:cookie_app/viewmodel/map/marker.viewmodel.dart';

class FriendLocationListTile extends StatelessWidget {
  final MarkerViewModel user;

  const FriendLocationListTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.orangeAccent,
            width: 1.3,
          ),
        ),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: user.account.profile.image,
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            user.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      trailing: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.orangeAccent,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        child: Text(
          user.dist,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onTap: () => {
        context.read<MapViewModel>().moveCamera(user.position),
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
    backgroundColor: Colors.white,
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
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.orangeAccent,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.supervised_user_circle_outlined,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          '접속중인 친구',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 2,
              color: Colors.grey[300],
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
                        return FriendLocationListTile(user: mapInfo[index]);
                      },
                    ),
                  ),
          ],
        ),
      );
    },
  );
}
