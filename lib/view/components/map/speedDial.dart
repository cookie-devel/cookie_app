import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class SpeedDialPage extends StatelessWidget {
  final VoidCallback onTapCurrentLocation;
  final VoidCallback onTapStart;
  final VoidCallback onTapStop;
  final bool isRunning;

  SpeedDialPage({
    required this.onTapCurrentLocation,
    required this.onTapStart,
    required this.onTapStop,
    required this.isRunning,
  });

  @override
  Widget build(BuildContext context) {
    return _floatingButtons();
  }

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
          fontWeight: FontWeight.w500,
          color: Colors.deepOrangeAccent,
          fontSize: 13.0,
        ),
        backgroundColor: Colors.deepOrangeAccent,
        onTap: onTap,
      );
    }

    final List<SpeedDialChild> speedDialChildren = [
      speedDialChild(
        "현위치",
        Icons.location_searching_sharp,
        onTapCurrentLocation,
      ),
      isRunning
          ? speedDialChild(
              "위치 끄기",
              Icons.wifi_off_rounded,
              onTapStop,
            )
          : speedDialChild(
              "위치 켜기",
              Icons.wifi_rounded,
              onTapStart,
            ),
      // speedDialChild(
      //   "친구찾기",
      //   Icons.person_search_rounded,
      //   () => _friendLocationBottomSheet(mapLog: ),
      // ),
      // speedDialChild(
      //   "쿠키",
      //   Icons.cookie,
      //   () {},
      // ),
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
      backgroundColor: Colors.deepOrangeAccent,
      children: speedDialChildren,
    );
  }
}

// // speedDial => 친구찾기
// Future<void> _friendLocationBottomSheet({required List mapLog}) async {
//   return showModalBottomSheet<void>(
//     context: context,
//     useSafeArea: true,
//     builder: (BuildContext context) {
//       return StatefulBuilder(
//         builder: (
//           BuildContext context,
//           StateSetter setModalState,
//         ) {
//           return SizedBox(
//             height: MediaQuery.of(context).size.height * 0.45,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   alignment: Alignment.centerLeft,
//                   padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.circle_outlined,
//                             color: Colors.green.shade400,
//                           ),
//                           const SizedBox(width: 10),
//                           const Text(
//                             '현재 접속중인 친구',
//                             style: TextStyle(
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           IconButton(
//                             onPressed: () {
//                               setModalState(() {});
//                             },
//                             icon: const Icon(
//                               Icons.replay,
//                               size: 20,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ],
//                       ),
//                       PopupMenuButton(
//                         offset: const Offset(0, 40),
//                         icon: const Icon(Icons.more_vert),
//                         itemBuilder: (BuildContext context) {
//                           return const [
//                             PopupMenuItem(
//                               value: 1,
//                               child: Text('이름순 (ㄱ-ㅎ)'),
//                             ),
//                             PopupMenuItem(
//                               value: 2,
//                               child: Text('이름순 (ㅎ-ㄱ)'),
//                             ),
//                             PopupMenuItem(
//                               value: 3,
//                               child: Text('친밀도순'),
//                             ),
//                           ];
//                         },
//                         onSelected: (value) {
//                           setModalState(() {
//                             selectedSortOption = value;
//                             if (selectedSortOption == 1) {
//                               mapLog.sort(
//                                 (a, b) =>
//                                     a["username"].compareTo(b["username"]),
//                               );
//                             } else if (selectedSortOption == 2) {
//                               mapLog.sort(
//                                 (b, a) =>
//                                     a["username"].compareTo(b["username"]),
//                               );
//                             }
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//                 const Divider(),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: mapLog.length,
//                     padding: const EdgeInsets.fromLTRB(5, 4, 10, 4),
//                     itemBuilder: (BuildContext context, int index) {
//                       final MapInfoResponse log = mapLog[index];
//                       return ListTile(
//                         leading: const CircleAvatar(
//                             // backgroundColor: Colors.transparent,
//                             // backgroundImage:
//                             //     AssetImage(log.userid),
//                             ),
//                         title: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             // Text(log["username"]),
//                             Text(
//                               context.read<MapViewModel>().calDistance(
//                                     LatLng(
//                                       log.latitude,
//                                       log.longitude,
//                                     ),
//                                   ),
//                             ),
//                           ],
//                         ),
//                         onTap: () {
//                           _moveToFriendLocation(
//                             LatLng(
//                               log.latitude,
//                               log.longitude,
//                             ),
//                           );
//                           Navigator.pop(context);
//                           // markerBottomSheet(context, User.fromMap(log));
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//     },
//   );
// }
