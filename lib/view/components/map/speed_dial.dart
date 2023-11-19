import 'package:flutter/material.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import 'package:cookie_app/utils/navigation_service.dart';
import 'package:cookie_app/view/components/map/friend_location_bottom_sheet.dart';
import 'package:cookie_app/viewmodel/map.viewmodel.dart';

class SpeedDialPage extends StatelessWidget {
  SpeedDialPage({
    super.key,
    required this.onTapStart,
    required this.onTapStop,
  });

  final VoidCallback onTapStart;
  final VoidCallback onTapStop;
  final BuildContext context = NavigationService.navigatorKey.currentContext!;

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
