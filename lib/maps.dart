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
  static LatLng _currentLocation = const LatLng(37.5642135, 127.0016985);

  @override
  void initState() {
    super.initState();

    markers.add(
      Marker(
        markerId: MarkerId("1"),
        draggable: true,
        onTap: () {
          print("Marker2!");
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("title"),
                content: Text("content"),
              );
            },
          );
        },
        position: LatLng(38.4537251, 126.7960716),
      ),
    );

    markers.add(
      Marker(
        markerId: MarkerId("2"),
        draggable: true,
        onTap: () {
          print("Marker2!");
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("title"),
                content: Text("content"),
              );
            },
          );
        },
        position: LatLng(37.4537251, 126.7960716),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    _locationPermission();
    _getUserLocation();

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
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      print("currentLocation = ${_currentLocation.toString()}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
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
      ),
    );
  }
}
