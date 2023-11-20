import 'dart:async';

import 'package:flutter/material.dart';

import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/location_dto.dart';
import 'package:background_locator_2/settings/android_settings.dart';
import 'package:background_locator_2/settings/ios_settings.dart';
import 'package:background_locator_2/settings/locator_settings.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:provider/provider.dart';

import 'package:cookie_app/service/map.service.dart';
import 'package:cookie_app/utils/logger.dart';
import 'package:cookie_app/utils/navigation_service.dart';
import 'package:cookie_app/view/components/snackbar.dart';
import 'package:cookie_app/view/pages/maps/location_callback_handler.dart';
import 'package:cookie_app/viewmodel/map.viewmodel.dart';

BuildContext context = NavigationService.navigatorKey.currentContext!;

Future<void> initPlatformState() async {
  logger.t('Initializing...');
  await BackgroundLocator.initialize();
  logger.t('Initialization done');
  await BackgroundLocator.isServiceRunning().then((value) {
    logger.t('Service running: $value');
    context.read<MapViewModel>().isInitPlatformState = true;
    context.read<MapViewModel>().isLocationUpdateRunning = value;
  });
}

void onStart() async {
  logger.t("start");
  if (await checkLocationPermission()) {
    await startLocator();
    await BackgroundLocator.isServiceRunning().then((value) {
      showSnackBar(
        context,
        '위치 공유를 시작합니다.',
        icon: const Icon(Icons.cookie_outlined, color: Colors.orangeAccent),
      );
      context.read<MapViewModel>().isLocationUpdateRunning = value;
    });
  }
}

void onStop() async {
  logger.t("stop");
  await BackgroundLocator.unRegisterLocationUpdate();
  await BackgroundLocator.isServiceRunning().then((value) {
    showSnackBar(
      context,
      '위치 공유를 종료합니다.',
      icon: const Icon(Icons.cookie_outlined, color: Colors.red),
    );
    context.read<MapViewModel>().isLocationUpdateRunning = value;
    logger.t('Location Update running: $value');
  });
  if (context.mounted) context.read<MapService>().position(const LatLng(0, 0));
}

Future<void> update(dynamic data) async {
  logger.t("Location updated");
  LocationDto? locationDto = (data != null) ? LocationDto.fromJson(data) : null;
  await updateNotificationText(locationDto!);

  if (context.mounted) {
    context
        .read<MapService>()
        .setCurrentLocation(locationDto.latitude, locationDto.longitude);
    context
        .read<MapService>()
        .position(LatLng(locationDto.latitude, locationDto.longitude));
  }
}

Future<void> updateNotificationText(LocationDto data) async {
  final DateTime now = DateTime.now();
  final String hour = now.hour.toString().padLeft(2, '0');
  final String minute = now.minute.toString().padLeft(2, '0');
  final String second = now.second.toString().padLeft(2, '0');
  final int friendCount = context.read<MapViewModel>().mapLog.length;
  await BackgroundLocator.updateNotificationText(
    title: "$friendCount명의 친구와 위치를 공유하고 있어요",
    msg: "$hour:$minute:$second",
    bigMsg: "${data.latitude}, ${data.longitude}",
  );
}

Future<bool> checkLocationPermission() async {
  logger.t('checkLocationPermission');
  final access = await LocationPermissions().checkPermissionStatus();
  logger.t('access: $access');
  switch (access) {
    case PermissionStatus.unknown:
    case PermissionStatus.denied:
    case PermissionStatus.restricted:
      final permission = await LocationPermissions().requestPermissions(
        permissionLevel: LocationPermissionLevel.locationAlways,
      );
      if (permission == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }

    case PermissionStatus.granted:
      return true;

    default:
      return false;
  }
}

Future<void> startLocator() async {
  Map<String, dynamic> data = {'countInit': 1};
  return await BackgroundLocator.registerLocationUpdate(
    LocationCallbackHandler.callback,
    initCallback: LocationCallbackHandler.initCallback,
    initDataCallback: data,
    disposeCallback: LocationCallbackHandler.disposeCallback,
    iosSettings: const IOSSettings(
      accuracy: LocationAccuracy.NAVIGATION,
      distanceFilter: 0,
      stopWithTerminate: true,
    ),
    autoStop: false,
    androidSettings: const AndroidSettings(
      accuracy: LocationAccuracy.NAVIGATION,
      interval: 5,
      distanceFilter: 0,
      client: LocationClient.google,
      androidNotificationSettings: AndroidNotificationSettings(
        notificationChannelName: 'Location tracking',
        notificationTitle: 'Start Location Tracking',
        notificationMsg: 'Track location in background',
        notificationBigMsg:
            'Background location is on to keep the app up-tp-date with your location. This is required for main features to work properly when the app is not running.',
        notificationIconColor: Colors.orangeAccent,
        notificationTapCallback: LocationCallbackHandler.notificationCallback,
      ),
    ),
  );
}
