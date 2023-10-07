import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/location_dto.dart';
import 'package:background_locator_2/settings/android_settings.dart';
import 'package:background_locator_2/settings/ios_settings.dart';
import 'package:background_locator_2/settings/locator_settings.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart' as l2;
import 'package:location_permissions/location_permissions.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'package:cookie_app/repository/location_service.repo.dart';
import 'package:cookie_app/types/map/mapPosition_info.dart';
import 'package:cookie_app/view/components/loading.dart';
import 'package:cookie_app/view/pages/maps/location_callback_handler.dart';
import 'package:cookie_app/viewmodel/map.viewmodel.dart';
import 'package:cookie_app/viewmodel/theme.viewmodel.dart';

class MapsWidget extends StatefulWidget {
  const MapsWidget({Key? key}) : super(key: key);

  @override
  State<MapsWidget> createState() => _MapsWidgetState();
}

class _MapsWidgetState extends State<MapsWidget> {
  late List<MapPosition> mapData = [];
  late GoogleMapController mapController;
  final l2.Distance distance = const l2.Distance();
  final logger = Logger('_MapsWidgetState');
  List<Marker> markers = <Marker>[];
  int selectedSortOption = 1;

  ReceivePort port = ReceivePort();

  bool? isRunning;
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
    initPlatformState();
    isInit = true;
  }

  @override
  void dispose() {
    mapController.dispose();
    markers.clear();
    super.dispose();
  }

  Future<void> update(dynamic data) async {
    logger.info("update");
    LocationDto? locationDto =
        (data != null) ? LocationDto.fromJson(data) : null;
    await _updateNotificationText(locationDto!);

    if (context.mounted) {
      context
          .read<MapProvider>()
          .setCurrentLocation(locationDto.latitude, locationDto.longitude);
    }

    setState(() {
      if (data != null) {
        lastLocation = locationDto;
      }
    });
  }

  Future<void> _updateNotificationText(LocationDto data) async {
    await BackgroundLocator.updateNotificationText(
      title: "new location received",
      msg: "${DateTime.now()}",
      bigMsg: "${data.latitude}, ${data.longitude}",
    );
  }

  Future<void> initPlatformState() async {
    logger.info('Initializing...');
    await BackgroundLocator.initialize();
    logger.info('Initialization done');

    await BackgroundLocator.isServiceRunning().then((value) {
      setState(() {
        isRunning = value;
      });
      logger.info('Running ${isRunning.toString()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, MapProvider>(
      builder: (context, themeProvider, mapProvider, _) {
        String mapStyle = themeProvider.mapStyle;
        // ignore: unused_local_variable
        List mapData = mapProvider.mapLog;

        return Scaffold(
          appBar: AppBar(title: const Text('C🍪🍪KIE')),
          body: isInit == true
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
                      markers: Set.from(markers),
                      initialCameraPosition: lastLocation != null
                          ? CameraPosition(
                              target: LatLng(
                                lastLocation!.latitude,
                                lastLocation!.longitude,
                              ),
                              zoom: 18.0,
                            )
                          : const CameraPosition(
                              // 기본값 설정 또는 에러 처리
                              target:
                                  LatLng(37.7749, -122.4194), // 예시로 적어 둔 것입니다.
                              zoom: 18.0,
                            ),
                    ),
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: _floatingButtons(),
                    ),
                  ],
                )
              : const LoadingScreen(),
        );
      },
    );
  }

  void onStop() async {
    logger.info("stop");
    await BackgroundLocator.unRegisterLocationUpdate();
    await BackgroundLocator.isServiceRunning().then((value) {
      setState(() {
        isRunning = value;
      });
      logger.info('Running ${isRunning.toString()}');
    });
  }

  void _onStart() async {
    logger.info("start");
    if (await _checkLocationPermission()) {
      await _startLocator();
      await BackgroundLocator.isServiceRunning().then((value) {
        setState(() {
          isRunning = value;
          lastLocation = null;
        });
        logger.info('Running ${isRunning.toString()}');
      });
    } else {
      // show error
    }
  }

  Future<bool> _checkLocationPermission() async {
    final access = await LocationPermissions().checkPermissionStatus();
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

  Future<void> _startLocator() async {
    Map<String, dynamic> data = {'countInit': 1};
    return await BackgroundLocator.registerLocationUpdate(
      LocationCallbackHandler.callback,
      initCallback: LocationCallbackHandler.initCallback,
      initDataCallback: data,
      disposeCallback: LocationCallbackHandler.disposeCallback,
      // ignore: prefer_const_constructors
      iosSettings: IOSSettings(
        accuracy: LocationAccuracy.NAVIGATION,
        distanceFilter: 0,
        stopWithTerminate: true,
      ),
      autoStop: false,
      // ignore: prefer_const_constructors
      androidSettings: AndroidSettings(
        accuracy: LocationAccuracy.NAVIGATION,
        interval: 5,
        distanceFilter: 0,
        client: LocationClient.google,
        // ignore: prefer_const_constructors
        androidNotificationSettings: AndroidNotificationSettings(
          notificationChannelName: 'Location tracking',
          notificationTitle: 'Start Location Tracking',
          notificationMsg: 'Track location in background',
          notificationBigMsg:
              'Background location is on to keep the app up-tp-date with your location. This is required for main features to work properly when the app is not running.',
          notificationIconColor: Colors.grey,
          notificationTapCallback: LocationCallbackHandler.notificationCallback,
        ),
      ),
    );
  }

  // Future<void> _addMarkers() async {
  //   List<Marker> allMarkers = [];
  //   List<Future<Marker>> markerFutures = [];

  //   for (int i = 0; i < mapData.length; i++) {
  //     final PublicAccountViewModel friendInfo = User.fromMap(mapData[i]);

  //     final LatLng location = LatLng(
  //       mapData[i].latitude,
  //       mapData[i].longitude,
  //     );

  //     Future<Marker> markerFuture = addMarker(context, friendInfo, location);
  //     markerFutures.add(markerFuture);
  //   }

  //   List<Marker> mark = await Future.wait(markerFutures);
  //   allMarkers.addAll(mark);

  //   setState(() {
  //     markers.addAll(allMarkers);
  //   });
  // }

  // 해당 location으로 camera 이동
  void _moveToFriendLocation(LatLng location) {
    mapController.animateCamera(CameraUpdate.newLatLngZoom(location, 16.0));
  }

  // 두 좌표 간 거리계산
  String _calDistance(LatLng myLocation, LatLng friendLocation) {
    final latLong1 = l2.LatLng(myLocation.latitude, myLocation.longitude);
    final latLong2 =
        l2.LatLng(friendLocation.latitude, friendLocation.longitude);
    final dist = distance(latLong1, latLong2);

    final double distanceInMeters = dist < 1000 ? dist : dist / 1000;
    final String distanceString =
        distanceInMeters.toStringAsFixed(distanceInMeters < 10 ? 1 : 0);
    final String unit = dist < 1000 ? 'm' : 'km';

    return '$distanceString $unit';
  }

  // speedDial
  Widget _floatingButtons() {
    SpeedDialChild speedDialChild(
      String label,
      IconData icon,
      void Function()? onTap,
    ) {
      return SpeedDialChild(
        child: Icon(icon, color: Colors.white),
        label: label,
        labelBackgroundColor: Colors.white,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.deepOrangeAccent,
          fontSize: 13.0,
        ),
        backgroundColor: Colors.deepOrangeAccent,
        onTap: onTap,
      );
    }

    final List<SpeedDialChild> speedDialChildren = [
      speedDialChild(
        "설정",
        Icons.settings_sharp,
        () {},
      ),
      speedDialChild(
        "현위치",
        Icons.location_searching_sharp,
        _moveToCurrentLocation,
        // _moveToCurrentLocation,
      ),
      speedDialChild(
        "친구찾기",
        Icons.person_search_rounded,
        () => _friendLocationBottomSheet(mapLog: mapData),
      ),
      speedDialChild(
        "쿠키",
        Icons.cookie,
        () {},
      ),
      speedDialChild(
        "위치 켜기",
        Icons.wifi_rounded,
        () => _onStart(),
      ),
      speedDialChild(
        "위치 끄기",
        Icons.wifi_off_rounded,
        () => onStop(),
      ),
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

  // speedDial => 현위치
  void _moveToCurrentLocation() {
    LatLng position = context.read<MapProvider>().currentLocation;
    mapController.animateCamera(CameraUpdate.newLatLng(position));
  }

  // speedDial => 친구찾기
  Future<void> _friendLocationBottomSheet({required List mapLog}) async {
    return showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (
            BuildContext context,
            StateSetter setModalState,
          ) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.45,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.circle_outlined,
                              color: Colors.green.shade400,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              '현재 접속중인 친구',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setModalState(() {});
                              },
                              icon: const Icon(
                                Icons.replay,
                                size: 20,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        PopupMenuButton(
                          offset: const Offset(0, 40),
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (BuildContext context) {
                            return const [
                              PopupMenuItem(
                                value: 1,
                                child: Text('이름순 (ㄱ-ㅎ)'),
                              ),
                              PopupMenuItem(
                                value: 2,
                                child: Text('이름순 (ㅎ-ㄱ)'),
                              ),
                              PopupMenuItem(
                                value: 3,
                                child: Text('친밀도순'),
                              ),
                            ];
                          },
                          onSelected: (value) {
                            setModalState(() {
                              selectedSortOption = value;
                              if (selectedSortOption == 1) {
                                mapLog.sort(
                                  (a, b) =>
                                      a["username"].compareTo(b["username"]),
                                );
                              } else if (selectedSortOption == 2) {
                                mapLog.sort(
                                  (b, a) =>
                                      a["username"].compareTo(b["username"]),
                                );
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: mapLog.length,
                      padding: const EdgeInsets.fromLTRB(5, 4, 10, 4),
                      itemBuilder: (BuildContext context, int index) {
                        final MapPosition log = mapLog[index];
                        return ListTile(
                          leading: const CircleAvatar(
                              // backgroundColor: Colors.transparent,
                              // backgroundImage:
                              //     AssetImage(log.userid),
                              ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Text(log["username"]),
                              Text(
                                _calDistance(
                                  Provider.of<MapProvider>(
                                    context,
                                    listen: false,
                                  ).currentLocation,
                                  LatLng(
                                    log.latitude,
                                    log.longitude,
                                  ),
                                ),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            _moveToFriendLocation(
                              LatLng(
                                log.latitude,
                                log.longitude,
                              ),
                            );
                            Navigator.pop(context);
                            // markerBottomSheet(context, User.fromMap(log));
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// https://snazzymaps.com/explore?text=&sort=popular&tag=&color= [google map theme]
