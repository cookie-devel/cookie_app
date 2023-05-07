import 'package:cookie_app/components/map/ImageProcess.dart';
import 'package:cookie_app/cookie.appbar.dart';
import 'package:cookie_app/schema/FriendInfo.dart';
import 'package:cookie_app/cookie.splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';

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
        FriendInfo(username: '채원', image: 'assets/images/cw1.png'),
        LatLng(37.2811339, 127.0455020));
    _addMarker(
        markers,
        FriendInfo(username: '은채', image: 'assets/images/ec1.png'),
        LatLng(37.2822411, 127.0466999));
    _addMarker(
        markers,
        FriendInfo(username: '윤진', image: 'assets/images/yj1.png'),
        LatLng(37.2833289, 127.0455020));
    _addMarker(
        markers,
        FriendInfo(username: '즈하', image: 'assets/images/kz1.png'),
        LatLng(37.2842411, 127.0435222));
    _addMarker(markers, FriendInfo(username: 'test1'),
        LatLng(37.2842411, 127.0466999));
    _addMarker(markers, FriendInfo(username: 'test2'),
        LatLng(37.2837999, 127.0466999));

    rootBundle.loadString('assets/data/mapStyle.json').then((string) {
      _mapStyle = string;
    });
  }

  void _addMarker(
    List<Marker> markers,
    FriendInfo user,
    LatLng location, {
    Color color = Colors.deepOrangeAccent,
    double width = 4,
  }) async {
    // 추후에 json 형식으로 받아서 처리
    Uint8List markIcons = await getRoundedImages(user.image!, 95,
        borderColor: color, borderWidth: width);

    setState(() {
      markers.add(
        Marker(
          draggable: false,
          markerId: MarkerId(user.username.toString()),
          position: location,
          icon: BitmapDescriptor.fromBytes(markIcons),
          infoWindow: InfoWindow(
            title: user.username,
            // snippet: '안녕~',
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(user.username ?? "Unknown"),
                  content: Text(location.latitude.toString() +
                      '\n' +
                      location.longitude.toString()),
                );
              },
            );
          },
        ),
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
          ? GoogleMap(
              compassEnabled: true,
              myLocationEnabled: true,
              zoomControlsEnabled: false, // 축소확대 버튼
              minMaxZoomPreference: const MinMaxZoomPreference(14, 20), // 줌 제한
              myLocationButtonEnabled: true,

              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
                mapController.setMapStyle(_mapStyle);
              },
              mapType: MapType.normal,
              markers: Set.from(markers),
              initialCameraPosition: CameraPosition(
                target: _currentLocation,
                zoom: 14.0,
              ),
            )
          : loadingScreen(),
    );
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
