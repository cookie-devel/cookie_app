import 'package:cookie_app/view/components/map/friend_location_bottom_sheet.dart';
import 'package:cookie_app/view/components/snackbar.dart';
import 'package:cookie_app/view/pages/maps/location_background.dart';
import 'package:cookie_app/utils/navigation_service.dart';
import 'package:cookie_app/viewmodel/map.viewmodel.dart';
import 'package:cookie_app/service/map.service.dart';
import 'package:cookie_app/theme/default.dart';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

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
        child: Icon(icon, color: DefaultColor.colorMainWhite),
        label: label,
        labelBackgroundColor: DefaultColor.colorMainWhite,
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: DefaultColor.colorMainOrange,
          fontSize: 14.0,
        ),
        backgroundColor: DefaultColor.colorMainOrange,
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
      context.read<MapViewModel>().isLocationUpdateRunning
          ? speedDialChild("친구 찾기", Icons.person_search_rounded, () {
              friendLocationBottomSheet();
            })
          : speedDialChild("친구 찾기", Icons.person_search_rounded, () {
              showErrorSnackBar(context, '위치 공유를 활성화해주세요.');
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
      backgroundColor: DefaultColor.colorMainOrange,
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
        context.read<MapService>().moveToCurrentLocation(),
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: DefaultColor.colorMainOrange,
        ),
        child: const Center(
          child: Icon(
            Icons.location_searching_sharp,
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
