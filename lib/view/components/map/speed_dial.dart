import 'package:cookie_app/utils/navigation_service.dart';
import 'package:cookie_app/view/components/map/friend_location_sheet.dart';
import 'package:cookie_app/viewmodel/map.viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

class SpeedDialPage extends StatelessWidget {
  SpeedDialPage({
    required this.onTapStart,
    required this.onTapStop,
  });

  BuildContext context = NavigationService.navigatorKey.currentContext!;
  final VoidCallback onTapStart;
  final VoidCallback onTapStop;

  Widget _floatingButtons() {
    SpeedDialChild speedDialChild(
      String label,
      IconData icon,
      VoidCallback onTap,
    ) {
      return SpeedDialChild(
        child: Icon(icon, color: Colors.white),
        label: label,
        labelBackgroundColor: Colors.white,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.blue,
          fontSize: 14.0,
        ),
        backgroundColor: Colors.blue,
        onTap: onTap,
      );
    }

    final List<SpeedDialChild> speedDialChildren = [
      context.read<MapViewModel>().isLocationUpdateRunning
          ? speedDialChild(
              "공유 해제",
              Icons.location_off_outlined,
              onTapStop,
            )
          : speedDialChild(
              "위치 공유",
              Icons.location_on_outlined,
              onTapStart,
            ),
      speedDialChild("친구 찾기", Icons.person_search_rounded, () {
        friendLocationBottomSheet();
      }),
    ];

    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      visible: true,
      buttonSize: const Size(48, 48),
      childrenButtonSize: const Size(48, 48),
      childMargin: const EdgeInsets.all(2),
      spaceBetweenChildren: 10.0,
      overlayOpacity: 0.0,
      curve: Curves.bounceIn,
      backgroundColor: Colors.blue,
      children: speedDialChildren,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _floatingButtons();
  }
}

// // speedDial => 친구찾기
// Future<void> _friendLocationBottomSheet({required List mapLog}) async {
//   BuildContext context = NavigationService.navigatorKey.currentContext!;
//   return showModalBottomSheet<void>(
//     context: context,
//     useSafeArea: true,
//     builder: (BuildContext context) {
//       return SizedBox(
//         height: MediaQuery.of(context).size.height * 0.45,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               alignment: Alignment.centerLeft,
//               padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.supervised_user_circle_outlined,
//                         color: Colors.green.shade400,
//                       ),
//                       const SizedBox(width: 10),
//                       const Text(
//                         '현재 접속중인 친구',
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                   // PopupMenuButton(
//                   //   offset: const Offset(0, 40),
//                   //   icon: const Icon(Icons.more_vert),
//                   //   itemBuilder: (BuildContext context) {
//                   //     return const [
//                   //       PopupMenuItem(
//                   //         value: 1,
//                   //         child: Text('이름순 (ㄱ-ㅎ)'),
//                   //       ),
//                   //       PopupMenuItem(
//                   //         value: 2,
//                   //         child: Text('이름순 (ㅎ-ㄱ)'),
//                   //       ),
//                   //       PopupMenuItem(
//                   //         value: 3,
//                   //         child: Text('친밀도순'),
//                   //       ),
//                   //     ];
//                   //   },
//                     // onSelected: (value) {
//                     //   setModalState(() {
//                     //     selectedSortOption = value;
//                     //     if (selectedSortOption == 1) {
//                     //       mapLog.sort(
//                     //         (a, b) =>
//                     //             a["username"].compareTo(b["username"]),
//                     //       );
//                     //     } else if (selectedSortOption == 2) {
//                     //       mapLog.sort(
//                     //         (b, a) =>
//                     //             a["username"].compareTo(b["username"]),
//                     //       );
//                     //     }
//                     //   });
//                     // },
//                   // ),
//                 ],
//               ),
//             ),
//             const Divider(),
//             // Expanded(
//             //   child: ListView.builder(
//             //     itemCount: mapLog.length,
//             //     padding: const EdgeInsets.fromLTRB(5, 4, 10, 4),
//             //     itemBuilder: (BuildContext context, int index) {
//             //       final MapInfoResponse log = mapLog[index];
//             //       return ListTile(
//             //         leading: const CircleAvatar(
//             //             // backgroundColor: Colors.transparent,
//             //             // backgroundImage:
//             //             //     AssetImage(log.userid),
//             //             ),
//             //         title: Row(
//             //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //           children: [
//             //             // Text(log["username"]),
//             //             Text(
//             //               context.read<MapViewModel>().calDistance(
//             //                     LatLng(
//             //                       log.latitude,
//             //                       log.longitude,
//             //                     ),
//             //                   ),
//             //             ),
//             //           ],
//             //         ),
//             //         onTap: () {
//             //           _moveToFriendLocation(
//             //             LatLng(
//             //               log.latitude,
//             //               log.longitude,
//             //             ),
//             //           );
//             //           Navigator.pop(context);
//             //           // markerBottomSheet(context, User.fromMap(log));
//             //         },
//             //       );
//             //     },
//             //   ),
//             // ),
//           ],
//         ),
//       );
//     },
//   );
// }
