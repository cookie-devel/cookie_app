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
        FriendInfo(
          username: '채원',
          image: 'assets/images/cw1.png',
          message: '안녕하세요!',
        ),
        LatLng(37.2811339, 127.0455020));
    _addMarker(
        markers,
        FriendInfo(
          username: '은채',
          image: 'assets/images/ec1.png',
          message: '반가워요!',
        ),
        LatLng(37.2822411, 127.0466999));
    _addMarker(
        markers,
        FriendInfo(
          username: '윤진',
          image: 'assets/images/yj1.png',
          message: '안녕!',
        ),
        LatLng(37.2833289, 127.0455020));
    _addMarker(
        markers,
        FriendInfo(
          username: '즈하',
          image: 'assets/images/kz1.png',
          message: '반가워!',
        ),
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
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              barrierColor: Colors.transparent,
              isDismissible: true, // 배경 터치 시 닫힐지 말지 설정
              enableDrag: true, // 드래그로 닫힐지 말지 설정
              builder: (BuildContext context) {
                return SafeArea(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.20,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 1, 5, 1),
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.height * 0.15,
                            height: MediaQuery.of(context).size.height * 0.15,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage(
                                  user.image ?? "assets/images/cookie_log.png",
                                ),
                                fit: BoxFit.cover,
                              ),
                              border:
                                  Border.all(width: 1.5, color: Colors.black45),
                            ),
                          ),
                          const SizedBox(width: 25),
                          Container(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                user.username ?? "Unknown",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                user.message ?? "Unknown",
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepOrangeAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: const BorderSide(
                                            color: Colors.black45, width: 1),
                                      ),
                                    ),
                                    child: const Text(
                                      '채팅하기',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {},
                                  ),
                                  const SizedBox(width: 16),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepOrangeAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: const BorderSide(
                                          color: Colors.black45,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      '친구신청',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {},
                                  ),
                                ],
                              )
                            ],
                          )),
                        ],
                      ),
                    ),
                  ),
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
              mapToolbarEnabled: false, // 길찾기 버튼
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
