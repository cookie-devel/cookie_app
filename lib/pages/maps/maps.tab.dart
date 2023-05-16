import 'package:cookie_app/components/map/markerDesign.dart';
import 'package:cookie_app/cookie.appbar.dart';
import 'package:cookie_app/schema/FriendInfo.dart';
import 'package:cookie_app/cookie.splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'dart:convert';
import 'dart:async';

class MapsWidget extends StatefulWidget {
  const MapsWidget({Key? key}) : super(key: key);

  @override
  State<MapsWidget> createState() => _MapsWidgetState();
}

class _MapsWidgetState extends State<MapsWidget> {
  bool loading = true;
  String _mapStyle = '';
  List<dynamic> mapLog = [];
  static late LatLng _currentLocation;
  late GoogleMapController mapController;
  static List<Marker> markers = <Marker>[];
  final latlong.Distance distance = const latlong.Distance();
  int selectedSortOption = 1;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _locationPermission();
    _getUserLocation();
    _loadMapStyle();
    startLocationUpdates();
  }

  @override
  void dispose() {
    mapController.dispose();
    markers.clear();
    stopLocationUpdates();
    super.dispose();
  }

  void startLocationUpdates() {
    stopLocationUpdates();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _getUserLocation();
    });
  }

  void stopLocationUpdates() {
    _timer?.cancel();
  }

  Future<void> _loadMapStyle() async {
    rootBundle.loadString('assets/data/mapStyle.json').then((string) {
      _mapStyle = string;
    });
  }

  Future<void> _initializeData() async {
    await _getSampleData();
    _addMarkers();
  }

  // 임시로 json 데이터 생성하여 가져옴
  Future<void> _getSampleData() async {
    String jsonString = await rootBundle.loadString('assets/data/map.json');
    setState(() {
      mapLog = json.decode(jsonString)["result"];
    });
  }

  Future<void> _addMarkers() async {
    List<Marker> allMarkers = [];
    for (int i = 0; i < mapLog.length; i++) {
      final FriendInfo friendInfo = FriendInfo(
        username: mapLog[i]["username"],
        profileImage: Image.asset(mapLog[i]["profile"]["image"]).image,
        profileMessage: mapLog[i]["profile"]["message"],
      );

      final LatLng location = LatLng(
        mapLog[i]["location"]["latitude"],
        mapLog[i]["location"]["longitude"],
      );

      Marker marker = await addMarker(context, friendInfo, location);
      allMarkers.add(marker);
    }
    setState(() {
      markers.addAll(allMarkers);
    });
  }

  // https://kanoos-stu.tistory.com/64
  void _locationPermission() async {
    var requestStatus = await Permission.location.request();
    var status = await Permission.location.status;
    if (requestStatus.isGranted && status.isLimited) {
      // isLimited - 제한적 동의 (ios 14 < )
      // 요청 동의됨
      if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
        _getUserLocation();
      } else {
        // 요청 동의 + gps 꺼짐
      }
    } else if (requestStatus.isPermanentlyDenied ||
        status.isPermanentlyDenied) {
      // 권한 요청 거부, 해당 권한에 대한 요청에 대해 다시 묻지 않음 선택하여 설정화면에서 변경해야함. android
      openAppSettings();
    } else if (status.isRestricted) {
      // 권한 요청 거부, 해당 권한에 대한 요청을 표시하지 않도록 선택하여 설정화면에서 변경해야함. ios
      openAppSettings();
    } else if (status.isDenied) {
      // 권한 요청 거절
    }
  }

  void _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      loading = false;
      print("currentLocation = ${_currentLocation.toString()}");
    });
  }

  // speedDial => 현위치
  void _moveToCurrentLocation() {
    mapController.animateCamera(CameraUpdate.newLatLng(_currentLocation));
  }

  // 해당 location으로 camera 이동
  void _moveToFriendLocation(LatLng location) {
    mapController.animateCamera(CameraUpdate.newLatLng(location));
  }

  // 두 좌표 간 거리계산
  String _calDistance(LatLng myLocation, LatLng friendLocation) {
    final latLong1 = latlong.LatLng(myLocation.latitude, myLocation.longitude);
    final latLong2 =
        latlong.LatLng(friendLocation.latitude, friendLocation.longitude);
    final dist = distance(latLong1, latLong2);

    final double distanceInMeters = dist < 1000 ? dist : dist / 1000;
    final String distanceString =
        distanceInMeters.toStringAsFixed(distanceInMeters < 10 ? 1 : 0);
    final String unit = dist < 1000 ? 'm' : 'km';

    return '$distanceString $unit';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CookieAppBar(title: 'C🍪🍪KIE'),
      body: loading == false
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
                    mapController.setMapStyle(_mapStyle);
                  },
                  mapType: MapType.normal,
                  markers: Set.from(markers),
                  initialCameraPosition: CameraPosition(
                    target: _currentLocation,
                    zoom: 15.2,
                  ),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: _floatingButtons(),
                ),
                // Positioned(
                //   bottom: 0,
                //   left: 0,
                //   child: Container(
                //     color: Colors.white,
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text(_currentLocation.latitude.toString()),
                //         Text(_currentLocation.longitude.toString()),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            )
          : loadingScreen(),
    );
  }

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

  Widget _floatingButtons() {
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
      children: [
        speedDialChild(
          "설정",
          Icons.settings_sharp,
          () {},
        ),
        speedDialChild(
          "현위치",
          Icons.location_searching_sharp,
          () {
            _moveToCurrentLocation();
          },
        ),
        speedDialChild(
          "친구찾기",
          Icons.person_search_rounded,
          () {
            _friendLocationBottomSheet(mapLog: mapLog);
          },
        ),
        speedDialChild(
          "쿠키",
          Icons.cookie,
          () {},
        ),
      ],
    );
  }

  // speedDial => 친구찾기
  Future<void> _friendLocationBottomSheet({required List mapLog}) async {
    return showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      barrierColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (
            BuildContext context,
            StateSetter setModalState,
          ) {
            return SafeArea(
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
                                setModalState(() {
                                  _currentLocation = _currentLocation;
                                });
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
                          offset: const Offset(0,40),
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
                        final Map<String, dynamic> log = mapLog[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                AssetImage(log["profile"]["image"]),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(log["username"]),
                              Text(
                                _calDistance(
                                  _currentLocation,
                                  LatLng(
                                    log["location"]["latitude"],
                                    log["location"]["longitude"],
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
                                log["location"]["latitude"],
                                log["location"]["longitude"],
                              ),
                            );
                            Navigator.pop(context);
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

//reference
// https://snazzymaps.com/explore?text=&sort=popular&tag=&color= [google map theme]
