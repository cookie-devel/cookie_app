import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:cookie_app/repository/location_service.repo.dart';
import 'package:cookie_app/service/map.service.dart';
import 'package:cookie_app/theme/theme.provider.dart';
import 'package:cookie_app/view/components/loading.dart';
import 'package:cookie_app/view/components/map/speed_dial.dart';
import 'package:cookie_app/view/pages/maps/location_background.dart';
import 'package:cookie_app/view/pages/maps/myGoogleMap.dart';
import 'package:cookie_app/viewmodel/map.viewmodel.dart';

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

    initPlatformState();

    port.listen(
      (dynamic data) async {
        await update(data);
      },
    );
  }

  @override
  void dispose() {
    context.read<MapViewModel>().mapController.dispose();
    context.read<MapViewModel>().isInitPlatformState = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, MapViewModel>(
      builder: (context, themeProvider, mapProvider, _) {
        final isInit = mapProvider.isInitPlatformState;
        final isRunning = mapProvider.isLocationUpdateRunning;

        return isInit
            ? Stack(
                children: [
                  const MyGoogleMap(),
                  Positioned(
                    boconst ttom: 80,
                    right: 16,
                    child: SpeedDialPage(
                      onTapStart: onStart,
                      onTapStop: onStop,
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: InkWell(
                      onTap: () =>
                          context.read<MapService>().moveToCurrentLocation(),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        child: Center(
                          child: Icon(
                            isRunning
                                ? Icons.location_searching_sharp
                                : Icons.location_disabled_sharp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : const LoadingScreen();
      },
    );
  }
}

// https://snazzymaps.com/explore?text=&sort=popular&tag=&color= [google map theme]
