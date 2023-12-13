import 'dart:async';
import 'dart:convert';
import 'package:cookie_app/service/account.service.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/location_dto.dart';
import 'package:background_locator_2/settings/android_settings.dart';
import 'package:background_locator_2/settings/ios_settings.dart';
import 'package:background_locator_2/settings/locator_settings.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:provider/provider.dart';

import 'package:cookie_app/service/map.service.dart';
import 'package:cookie_app/utils/logger.dart';
import 'package:cookie_app/utils/navigation_service.dart';
import 'package:cookie_app/view/components/snackbar.dart';
import 'package:cookie_app/view/pages/maps/location_callback_handler.dart';
import 'package:cookie_app/viewmodel/map/map.viewmodel.dart';

BuildContext context = NavigationService.navigatorKey.currentContext!;

Future<void> initPlatformState() async {
  logger.t('Initializing...');
  await BackgroundLocator.initialize();
  logger.t('Initialization done');
  await BackgroundLocator.isServiceRunning().then((value) {
    logger.t('Service running: $value');
    context.read<MapViewModel>().isInitPlatformState = true;
  });
}

void onStart() async {
  if (await checkLocationPermission()) {
    await startLocator();
    bool isServiceRunning = await BackgroundLocator.isServiceRunning();
    if (isServiceRunning && context.mounted) {
      context.read<MapViewModel>().isLocationUpdateRunning = true;
      context.read<MapService>().position(
            MapRequestType.startShare,
            context.read<AccountService>().friendIds,
          );
      showSnackBar(
        context,
        '위치 공유를 시작합니다.',
        icon: const Icon(Icons.cookie_outlined, color: Colors.orangeAccent),
      );
    }
    logger.t("[Start]: Location Share => isServiceRunning: $isServiceRunning");
  }
}

void onStop() async {
  await BackgroundLocator.unRegisterLocationUpdate();
  bool isServiceRunning = await BackgroundLocator.isServiceRunning();
  if (!isServiceRunning && context.mounted) {
    context.read<MapViewModel>().isLocationUpdateRunning = false;
    context.read<MapService>().position(
          MapRequestType.endShare,
          context.read<AccountService>().friendIds,
        );
    context.read<MapViewModel>().mapLog = [];
    context.read<MapViewModel>().markers = {};
    showSnackBar(
      context,
      '위치 공유를 종료합니다.',
      icon: const Icon(Icons.cookie_outlined, color: Colors.red),
    );
    logger.t("[End]: Location Share => isServiceRunning: $isServiceRunning");
  }
}

Future<void> update(dynamic data) async {
  bool isServiceRunning = await BackgroundLocator.isServiceRunning();
  if (!isServiceRunning) return;

  LocationDto? locationDto;
  if ((data != null)) {
    locationDto = LocationDto.fromJson(data);
  } else {
    if (context.mounted)
      locationDto =
          context.read<MapViewModel>().getCurrentLocation() as LocationDto?;
  }
  await updateNotificationText(locationDto!);

  if (context.mounted) {
    context.read<MapService>().position(
          LatLng(locationDto.latitude, locationDto.longitude),
          context.read<AccountService>().friendIds,
        );
  }
  // logger.t("Location updated");
}

Future<String> getAddress(double lat, double lon) async {
  const String getAddressUrl = 'https://maps.googleapis.com/maps/api/geocode/';
  final String url =
      '${getAddressUrl}json?latlng=$lat,$lon&language=ko&key=${dotenv.env['GOOGLE_MAPS_API_KEY']}';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final String address = data['results'][0]['formatted_address'];
    return address;
  } else {
    return '주소를 찾을 수 없습니다.';
  }
}

Future<void> updateNotificationText(LocationDto data) async {
  final int friendCount = context.read<MapViewModel>().mapLog.length;
  String addr = await getAddress(data.latitude, data.longitude);
  await BackgroundLocator.updateNotificationText(
    title: "$friendCount명의 친구와 위치를 공유하고 있어요",
    msg: addr,
    bigMsg: addr,
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
        permissionLevel: LocationPermissionLevel.locationWhenInUse,
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
      interval: 10,
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
