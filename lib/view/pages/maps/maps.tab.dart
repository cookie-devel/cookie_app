import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:cookie_app/repository/location_service.repo.dart';
import 'package:cookie_app/utils/logger.dart';
import 'package:cookie_app/view/components/loading.dart';
import 'package:cookie_app/view/components/map/speedDial.dart';
import 'package:cookie_app/view/pages/maps/location_background.dart';
import 'package:cookie_app/viewmodel/map.viewmodel.dart';
import 'package:cookie_app/viewmodel/theme.provider.dart';

class MapsWidget extends StatefulWidget {
  const MapsWidget({super.key});

  @override
  State<MapsWidget> createState() => _MapsWidgetState();
}

class _MapsWidgetState extends State<MapsWidget> {
  late GoogleMapController mapController;
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
        logger.t('data: $data');
        await update(data);
      },
    );
  }

  @override
  void dispose() {
    mapController.dispose();
    context.read<MapViewModel>().setInitPlatformState(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, MapViewModel>(
      builder: (context, themeProvider, mapProvider, _) {
        String mapStyle = themeProvider.mapStyle;
        final currentLocation = mapProvider.currentLocation;
        final marker = mapProvider.markers;
        final isInit = mapProvider.isInitPlatformState;

        return isInit == true
            ? Stack(
                children: [
                  GoogleMap(
                    myLocationEnabled: true, // 본인 마커
                    mapToolbarEnabled: false, // 길찾기 버튼
                    zoomControlsEnabled: false, // 축소확대 버튼
                    myLocationButtonEnabled: false, // 내위치 버튼
                    minMaxZoomPreference:
                        const MinMaxZoomPreference(14, 20), // 줌 제한

                    onMapCreated: (GoogleMapController controller) {
                      mapController = controller;
                      mapController.setMapStyle(mapStyle);
                    },
                    mapType: MapType.normal,
                    markers: marker,
                    initialCameraPosition: CameraPosition(
                      target: currentLocation,
                      zoom: 18.0,
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: SpeedDialPage(
                      onTapCurrentLocation: _moveToCurrentLocation,
                      onTapStart: onStart,
                      onTapStop: onStop,
                    ),
                  ),
                ],
              )
            : const LoadingScreen();
      },
    );
  }

  // 해당 location으로 camera 이동
  void _moveToFriendLocation(LatLng location) {
    mapController.animateCamera(CameraUpdate.newLatLngZoom(location, 16.0));
  }

  // speedDial => 현위치
  void _moveToCurrentLocation() {
    LatLng position = context.read<MapViewModel>().currentLocation;
    mapController.animateCamera(CameraUpdate.newLatLng(position));
  }
}

// https://snazzymaps.com/explore?text=&sort=popular&tag=&color= [google map theme]
