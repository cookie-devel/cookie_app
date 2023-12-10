import 'package:cookie_app/service/account.service.dart';
import 'package:cookie_app/service/map.service.dart';
import 'package:cookie_app/view/components/dialog.dart';
import 'package:cookie_app/utils/navigation_service.dart';
import 'package:cookie_app/view/components/snackbar.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';
import 'package:cookie_app/viewmodel/map/map.viewmodel.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendInviteListTile extends StatelessWidget {
  final AccountViewModel user;

  const FriendInviteListTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    bool userInMap = context
        .watch<MapViewModel>()
        .mapLog
        .any((marker) => marker.id == user.id);
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(user.name),
        ],
      ),
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
          backgroundImage: user.profile.image,
        ),
      ),
      trailing: userInMap
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.orangeAccent,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              child: const Text(
                '접속중',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : IconButton(
              icon: const Icon(
                Icons.cookie_outlined,
                color: Colors.orangeAccent,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => Alert(
                    title: "위치 공유",
                    content: "${user.name}님에게 위치를 공유할래요?",
                    onCancel: () {
                      Navigator.of(context).pop();
                    },
                    onConfirm: () {
                      // TODO: FCM
                      context
                          .read<MapService>()
                          .position(MapRequestType.posReq, [user.id]);
                      showSnackBar(
                        context,
                        "${user.name}님에게 위치 공유를 요청했어요!",
                      );
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  ),
                );
              },
            ),
    );
  }
}

Future friendInviteBottomSheet() async {
  BuildContext context = NavigationService.navigatorKey.currentContext!;

  return showModalBottomSheet(
    context: context,
    useSafeArea: true,
    backgroundColor: Colors.white,
    builder: (BuildContext context) {
      final friends = context.watch<AccountService>().users;
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
                        Icons.person_search_rounded,
                        color: Colors.green.shade400,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        '친구 목록',
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 2,
              color: Colors.white,
            ),
            friends.isEmpty
                ? const Expanded(
                    child: Center(
                      child: Text(
                        '친구가 존재하지 않습니다.',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: friends.length,
                      padding: const EdgeInsets.fromLTRB(5, 4, 10, 4),
                      itemBuilder: (BuildContext context, int index) {
                        return FriendInviteListTile(
                          user: friends.values.toList()[index],
                        );
                      },
                    ),
                  ),
          ],
        ),
      );
    },
  );
}
