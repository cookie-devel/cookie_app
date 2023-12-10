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
  logger.t("start");
  if (await checkLocationPermission()) {
    await startLocator();
    await BackgroundLocator.isServiceRunning().then((value) {
      showSnackBar(
        context,
        '위치 공유를 시작합니다.',
        icon: const Icon(Icons.cookie_outlined, color: Colors.orangeAccent),
      );
      context.read<MapViewModel>().isLocationUpdateRunning = true;
    });
  }
  if (context.mounted)
    context.read<MapService>().position(
          MapRequestType.startShare,
          context.read<AccountService>().friendIds,
        );
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
    context.read<MapViewModel>().isLocationUpdateRunning = false;
    logger.t('Location Update running: $value');
  });
  if (context.mounted) {
    context.read<MapService>().position(
          MapRequestType.endShare,
          context.read<AccountService>().friendIds,
        );
    context.read<MapViewModel>().mapLog = [];
    context.read<MapViewModel>().markers = {};
  }
}

Future<void> update(dynamic data) async {
  logger.t("Location updated");
  LocationDto? locationDto = (data != null)
      ? LocationDto.fromJson(data)
      : context.read<MapViewModel>().getCurrentLocation() as LocationDto?;
  await updateNotificationText(locationDto!);

  if (context.mounted) {
    context.read<MapService>().position(
          LatLng(locationDto.latitude, locationDto.longitude),
          context.read<AccountService>().friendIds,
        );
  }
}

Future<String> getAddress(double lat, double lon) async {
  final String url =
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lon&language=ko&key=${dotenv.env['GOOGLE_MAPS_API_KEY']}';
  final response = await http.get(Uri.parse(url));
  final data = jsonDecode(response.body);
  try {
    final String address = data['results'][0]['formatted_address'];
    return address;
  } catch (e) {
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
      return false;
    case PermissionStatus.denied:
      if (context.mounted)
        showSnackBar(context, '위치권한이 거부되었습니다.\n애플리케이션 위치 권한을 설정해주세요.');
      return false;
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
