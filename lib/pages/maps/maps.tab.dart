import 'package:cookie_app/components/map/ImageProcess.dart';
import 'package:cookie_app/components/map/markerDesign.dart';
import 'package:cookie_app/cookie.appbar.dart';
import 'package:cookie_app/schema/FriendInfo.dart';
import 'package:cookie_app/cookie.splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'dart:convert';

class MapsWidget extends StatefulWidget {
  const MapsWidget({Key? key}) : super(key: key);

  @override
  State<MapsWidget> createState() => _MapsWidgetState();
}

class _MapsWidgetState extends State<MapsWidget> {
  static List<Marker> markers = <Marker>[];
  late GoogleMapController mapController;
  static late LatLng _currentLocation;
  bool loading = true;
  String _mapStyle = '';
  final latlong.Distance distance = const latlong.Distance();

  List<dynamic> mapLog = [];

  @override
  void initState() {
    super.initState();

    _locationPermission();
    _getUserLocation();

    _getSampleData().then((_) {
      _addMarkers();
    });

    rootBundle.loadString('assets/data/mapStyle.json').then((string) {
      _mapStyle = string;
    });
  }

  // 임시로 json 데이터 생성하여 가져옴
  Future<void> _getSampleData() async {
    rootBundle.loadString('assets/data/map.json').then((string) {
      mapLog = json.decode(string)["result"];
    });
  }

  Future<void> _addMarker(
    List<Marker> markers,
    FriendInfo user,
    LatLng location,
  ) async {
    Marker marker = await addMarker(context, user, location);
    setState(() {
      markers.add(marker);
    });
  }

  Future<void> _addMarkers() async {
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

      _addMarker(markers, friendInfo, location);
    }
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
              ],
            )
          : loadingScreen(),
    );
  }

  void _moveToCurrentLocation() {
    mapController.animateCamera(CameraUpdate.newLatLng(_currentLocation));
  }

  void _moveToFriendLocation(LatLng location) {
    mapController.animateCamera(CameraUpdate.newLatLng(location));
  }

  String _calDistance(LatLng mylocation, LatLng friendlocation) {
    final dist = distance(
      latlong.LatLng(mylocation.latitude, mylocation.longitude),
      latlong.LatLng(friendlocation.latitude, friendlocation.longitude),
    );

    if (dist < 1000) {
      return "${dist.toStringAsFixed(0)} m";
    } else {
      return "${(dist / 1000).toStringAsFixed(1)} km";
    }
  }

  @override
  void dispose() {
    mapController.dispose();
    markers.clear();
    super.dispose();
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

  List<SpeedDialChild> speedDialChildren() {
    return [
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
    ];
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
      children: speedDialChildren(),
    );
  }

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
                      ],
                    ),
                    PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(
                            child: const Text('거리순'),
                            value: 1,
                          ),
                          PopupMenuItem(
                            child: const Text('친밀도순'),
                            value: 2,
                          ),
                        ];
                      },
                      onSelected: (value) {
                        print(value);
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
                        backgroundImage: AssetImage(log["profile"]["image"]),
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
  }
}

//reference
// https://snazzymaps.com/explore?text=&sort=popular&tag=&color= [google map theme]
