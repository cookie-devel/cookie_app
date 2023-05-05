import 'package:cookie_app/cookie.appbar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../schema/FriendInfo.dart';
import '../../../cookie.splash.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'dart:ui' as ui;
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

    rootBundle.loadString('assets/data/mapStyle.json').then((string) {
      _mapStyle = string;
    });

    addFriendMarker(context, markers, FriendInfo(name: "test1"));
  }

  void addFriendMarker(
    BuildContext context,
    List<Marker> markers,
    FriendInfo user,
  ) async {
    final Uint8List markIcons =
        await getImages('assets/images/cookie_logo.png', 100);

    markers.add(
      Marker(
        draggable: false,
        markerId: MarkerId(user.name.toString()),
        position: const LatLng(37.2807339, 127.0437020),
        icon: BitmapDescriptor.fromBytes(markIcons),
        infoWindow: InfoWindow(
          title: user.name,
          // snippet: '안녕~',
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(user.name ?? "Unknown"),
                content: const Text("user.location"),
              );
            },
          );
        },
      ),
    );
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
                zoom: 18.0,
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

Future<Uint8List> getImages(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(
    data.buffer.asUint8List(),
    targetHeight: width,
  );
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}

//reference
// https://snazzymaps.com/explore?text=&sort=popular&tag=&color= [google map theme]
