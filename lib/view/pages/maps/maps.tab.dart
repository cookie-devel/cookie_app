import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/location_dto.dart';
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

  int selectedSortOption = 1;

  bool isRunning = false;
  LocationDto? lastLocation;
  bool isInit = false;

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

    port.listen(
      (dynamic data) async {
        await update(data);
      },
    );
    context.read<MapViewModel>().position();
    initPlatformState();
    isInit = true;
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  Future<void> update(dynamic data) async {
    logger.t("update");
    LocationDto? locationDto =
        (data != null) ? LocationDto.fromJson(data) : null;
    await updateNotificationText(locationDto!);

    if (context.mounted) {
      context
          .read<MapViewModel>()
          .setCurrentLocation(locationDto.latitude, locationDto.longitude);
    }

    setState(() {
      if (data != null) {
        lastLocation = locationDto;
      }
    });
  }

  Future<void> initPlatformState() async {
    logger.t('Initializing...');
    await BackgroundLocator.initialize();
    logger.t('Initialization done');

    await BackgroundLocator.isServiceRunning().then((value) {
      setState(() {
        isRunning = value;
      });
      logger.t('Running ${isRunning.toString()}');
    });
  }

  void onStop() async {
    logger.t("stop");
    await BackgroundLocator.unRegisterLocationUpdate();
    await BackgroundLocator.isServiceRunning().then((value) {
      setState(() {
        isRunning = value;
      });
      logger.t('Running ${isRunning.toString()}');
    });
  }

  void _onStart() async {
    logger.t("start");
    if (await checkLocationPermission()) {
      await startLocator();
      await BackgroundLocator.isServiceRunning().then((value) {
        setState(() {
          isRunning = value;
          lastLocation = null;
        });
        logger.t('Running ${isRunning.toString()}');
      });
    } else {
      // show error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, MapViewModel>(
      builder: (context, themeProvider, mapProvider, _) {
        String mapStyle = themeProvider.mapStyle;
        final currentLocation = mapProvider.currentLocation;
        final marker = mapProvider.markers;

        return isInit == true
            ? Stack(
                children: [
                  GoogleMap(
                    myLocationButtonEnabled: false, // 내위치 버튼
                    compassEnabled: true, // 나침반 버튼
                    myLocationEnabled: true, // 본인 마커
                    zoomControlsEnabled: false, // 축소확대 버튼
                    minMaxZoomPreference:
                        const MinMaxZoomPreference(14, 20), // 줌 제한
                    mapToolbarEnabled: false, // 길찾기 버튼
                    onMapCreated: (GoogleMapController controller) {
                      mapController = controller;
                      mapController.setMapStyle(mapStyle);
                    },
                    mapType: MapType.normal,
                    // markers: Set.from(markers),
                    markers: marker,
                    initialCameraPosition: lastLocation != null
                        ? CameraPosition(
                            target: LatLng(
                              lastLocation!.latitude,
                              lastLocation!.longitude,
                            ),
                            zoom: 18.0,
                          )
                        : CameraPosition(
                            target: currentLocation,
                            zoom: 18.0,
                          ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    // child: _floatingButtons(),
                    child: SpeedDialPage(
                      onTapCurrentLocation: _moveToCurrentLocation,
                      onTapStart: _onStart,
                      onTapStop: onStop,
                      isRunning: isRunning,
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
