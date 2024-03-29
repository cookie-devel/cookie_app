import 'dart:ui';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cookie_app/view/components/loading.dart';
import 'package:cookie_app/viewmodel/map/map.viewmodel.dart';
import 'package:cookie_app/view/pages/maps/my_google_map.dart';
import 'package:cookie_app/view/components/map/speed_dial.dart';
import 'package:cookie_app/repository/location_service.repo.dart';
import 'package:cookie_app/view/pages/maps/location_background.dart';

class MapsWidget extends StatefulWidget {
  const MapsWidget({super.key});

  @override
  State<MapsWidget> createState() => _MapsWidgetState();
}

class _MapsWidgetState extends State<MapsWidget> {
  ReceivePort port = ReceivePort();

  @override
  void initState() {
    super.initState();

    if (IsolateNameServer.lookupPortByName(
          LocationServiceRepository.isolateName,
        ) !=
        null) {
      IsolateNameServer.removePortNameMapping(
        LocationServiceRepository.isolateName,
      );
    }

    IsolateNameServer.registerPortWithName(
      port.sendPort,
      LocationServiceRepository.isolateName,
    );

    if (!context.read<MapViewModel>().isInitPlatformState) initPlatformState();

    port.listen(
      (dynamic data) async {
        await update(data);
      },
    );
  }

  @override
  void dispose() {
    context.read<MapViewModel>().mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isInit = context.watch<MapViewModel>().isInitPlatformState;
    return isInit
        ? Stack(
            children: [
              const MyGoogleMap(),
              Positioned(
                bottom: 80,
                right: 16,
                child: SpeedDialPage(
                  onTapStart: onStart,
                  onTapStop: onStop,
                ),
              ),
              const Positioned(
                bottom: 16,
                right: 16,
                child: CurrentPositionDial(),
              ),
            ],
          )
        : const LoadingScreen();
  }
}
