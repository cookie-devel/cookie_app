import 'package:cookie_app/view/components/map/friend_invite_bottom_sheet.dart';
import 'package:cookie_app/view/components/map/friend_location_bottom_sheet.dart';
import 'package:cookie_app/view/pages/maps/location_background.dart';
import 'package:cookie_app/viewmodel/map/map.viewmodel.dart';
import 'package:cookie_app/view/components/snackbar.dart';
import 'package:cookie_app/utils/navigation_service.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

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
          color: Colors.deepOrangeAccent,
          fontSize: 14.0,
        ),
        backgroundColor: Colors.deepOrangeAccent,
        onTap: onTap,
      );
    }

    final isRunning = context.watch<MapViewModel>().isLocationUpdateRunning;
    final List<SpeedDialChild> speedDialChildren = [
      isRunning
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
      isRunning
          ? speedDialChild("친구 찾기", Icons.person_search_rounded, () {
              friendLocationBottomSheet();
            })
          : speedDialChild("친구 찾기", Icons.person_search_rounded, () {
              showErrorSnackBar(context, '위치 공유를 활성화해주세요.');
            }),
      speedDialChild("친구 초대", Icons.person_add_alt_1_rounded, () {
        friendInviteBottomSheet();
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
      backgroundColor: Colors.deepOrangeAccent,
      children: speedDialChildren,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _floatingButtons();
  }
}

class CurrentPositionDial extends StatelessWidget {
  const CurrentPositionDial({super.key});
  Widget _currentPositionButton() {
    return InkWell(
      onTap: () => {
        context.read<MapViewModel>().moveToCurrentLocation(),
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.deepOrangeAccent,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.location_searching_sharp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _currentPositionButton();
  }
}
