import 'package:cookie_app/cookie.appbar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapsWidget extends StatefulWidget {
  const MapsWidget({Key? key}) : super(key: key);

  @override
  State<MapsWidget> createState() => _MapsWidgetState();
}

class _MapsWidgetState extends State<MapsWidget> {
  late GoogleMapController mapController;
  static List<Marker> markers = <Marker>[];
  static late LatLng _currentLocation;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _locationPermission();
    _getUserLocation();
    markers.add(
      Marker(
        markerId: const MarkerId("1"),
        draggable: true,
        onTap: () {
          print("Marker2!");
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("title"),
                content: Text("content"),
              );
            },
          );
        },
        position: const LatLng(37.2807339, 127.0437020),
      ),
    );

    markers.add(
      Marker(
        markerId: const MarkerId("2"),
        draggable: true,
        onTap: () {
          print("Marker2!");
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("title"),
                content: Text("content"),
              );
            },
          );
        },
        position: const LatLng(37.2822374, 127.0455223),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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
      print("currentLocation = ${_currentLocation.toString()}");
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CookieAppBar(title: 'C🍪🍪KIE'),
      body: loading == false
          ? GoogleMap(
              compassEnabled: true,
              mapType: MapType.normal,
              markers: Set.from(markers),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentLocation,
                zoom: 16.0,
              ),
            )
          : null,
    );
  }
}
