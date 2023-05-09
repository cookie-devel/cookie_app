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

String tmpData = '''{
  "success": true,
  "result": [
    {
      "username" : "Unknown1",
      "profile": {
        "image": "assets/images/cookie_logo.png",
        "message": "안녕하세요!"
      },
      "userid": "Unknown1"
      "location": {
        "latitude": 37.2811339,
        "longitude": 127.0455020
      }
    },
    {
      "username" : "Unknown2",
      "profile": {
        "image": "assets/images/cookie_logo.png",
        "message": "안녕하세요."
      },
      "userid": "Unknown2"
      "location": {
        "latitude": 37.2811324,
        "longitude": 127.0455533
      }
    }
  ]
}''';

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

  @override
  void initState() {
    super.initState();
    _locationPermission();
    _getUserLocation();

    _addMarker(
      markers,
      FriendInfo(
        username: '김채원',
        profileImage: 'assets/images/cw1.png',
        profileMessage: '안녕하세요!안녕하세요!안녕하세요!안녕하세요!안녕하세요!안녕하세요!',
      ),
      const LatLng(37.2811339, 127.0455020),
    );
    _addMarker(
      markers,
      FriendInfo(
        username: '홍은채',
        profileImage: 'assets/images/ec1.png',
        profileMessage: '반가워요!',
      ),
      const LatLng(37.2822411, 127.0466999),
    );
    _addMarker(
      markers,
      FriendInfo(
        username: '허윤진',
        profileImage: 'assets/images/yj1.png',
        profileMessage: '안녕!',
      ),
      const LatLng(37.2833289, 127.0455020),
    );
    _addMarker(
      markers,
      FriendInfo(
        username: '카즈하',
        profileImage: 'assets/images/kz1.png',
        profileMessage: '반가워!',
      ),
      const LatLng(37.2842411, 127.0435222),
    );
    _addMarker(
      markers,
      FriendInfo(username: 'test1'),
      const LatLng(37.2842411, 127.0466999),
      size: 70,
      color: Colors.transparent,
      width: 0,
    );
    _addMarker(
      markers,
      FriendInfo(username: 'test2'),
      const LatLng(37.2837999, 127.0466999),
      size: 70,
      color: Colors.transparent,
      width: 0,
    );

    rootBundle.loadString('assets/data/mapStyle.json').then((string) {
      _mapStyle = string;
    });
  }

  // 추후에 json 형식으로 받아서 처리
  void _addMarker(
    List<Marker> markers,
    FriendInfo user,
    LatLng location, {
    int size = 100,
    Color color = Colors.deepOrangeAccent,
    double width = 4,
  }) async {
    Uint8List markIcons = await getRoundedImages(
      user.profileImage,
      size,
      borderColor: color,
      borderWidth: width,
    );

    setState(() {
      markers.add(
        addMarker(context, user, location, markIcons),
      );
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
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: FloatingActionButton(
                      backgroundColor: Colors.deepOrangeAccent,
                      onPressed: () {
                        _moveToCurrentLocation();
                      },
                      child: const Icon(
                        Icons.my_location,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : loadingScreen(),
    );
  }

  void _moveToCurrentLocation() {
    mapController.animateCamera(CameraUpdate.newLatLng(_currentLocation));
  }

  @override
  void dispose() {
    mapController.dispose();
    markers.clear();
    super.dispose();
  }
}

//reference
// https://snazzymaps.com/explore?text=&sort=popular&tag=&color= [google map theme]
