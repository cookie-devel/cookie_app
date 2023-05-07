import 'package:cookie_app/cookie.appbar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cookie_app/schema/FriendInfo.dart';
import 'package:cookie_app/cookie.splash.dart';
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

    _addMarker(markers, FriendInfo(username: '채원', image:'assets/images/cw1.png'), LatLng(37.2811339, 127.0455020));
    _addMarker(markers, FriendInfo(username: '은채', image:'assets/images/ec1.png'), LatLng(37.2822411, 127.0466999));
    _addMarker(markers, FriendInfo(username: '윤진', image:'assets/images/yj1.png'), LatLng(37.2833289, 127.0477240));
    _addMarker(markers, FriendInfo(username: '즈하', image:'assets/images/kz1.png'), LatLng(37.2844555, 127.0488222));

    rootBundle.loadString('assets/data/mapStyle.json').then((string) {
      _mapStyle = string;
    });
  }

  void _addMarker(
    List<Marker> markers,
    FriendInfo user,
    LatLng location,
  ) async {
    // 추후에 json 형식으로 받아서 처리
    Uint8List markIcons = await _getRoundedImages(user.image!, 95, Colors.deepOrangeAccent, 4);

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
                  content: Text(location.latitude.toString()+'\n'+location.longitude.toString()),
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

Future<Uint8List> getImages(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(
    data.buffer.asUint8List(),
    targetHeight: width,
  );
  ui.FrameInfo fi = await codec.getNextFrame();
  Uint8List markIcons= (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
  
  return markIcons;
}


Future<Uint8List> _getRoundedImages(String path, int width, Color borderColor, double borderWidth) async {

  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());

  ui.FrameInfo fi = await codec.getNextFrame();

  final int imageSize = width;
  final ui.Image image = fi.image;
  final ui.Rect paintRect = Offset.zero & Size(imageSize.toDouble(), imageSize.toDouble());
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final ui.Canvas canvas = ui.Canvas(pictureRecorder);

  final Paint paint = Paint()
    ..isAntiAlias = true;
  
  final double radius = imageSize.toDouble() / 2;

  final Paint borderPaint = Paint()
    ..color = borderColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = borderWidth;

  canvas.saveLayer(paintRect, Paint()); // 레이어 생성

  // 원형 이미지 그리기
  canvas.drawCircle(Offset(radius, radius), radius, paint);

  // 이미지 클리핑
  canvas.clipPath(Path()..addOval(paintRect));

  // 이미지 그리기
  canvas.drawImageRect(
    image,
    ui.Rect.fromLTRB(0, 0, image.width.toDouble(), image.height.toDouble()),
    paintRect,
    paint,
  );

  // 테두리 그리기
  canvas.drawCircle(Offset(radius, radius), radius - borderWidth / 2, borderPaint);

  canvas.restore(); // 레이어 복원

  final ui.Picture picture = pictureRecorder.endRecording();
  final ui.Image roundedImage = await picture.toImage(imageSize, imageSize);
  final ByteData? byteData = await roundedImage.toByteData(format: ui.ImageByteFormat.png);

  if (byteData != null) {
    return byteData.buffer.asUint8List();
  } else {
    throw Exception('Failed to convert image to byte data.');
  }
}


//reference
// https://snazzymaps.com/explore?text=&sort=popular&tag=&color= [google map theme]
