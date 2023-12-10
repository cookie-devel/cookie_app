import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:cookie_app/theme/theme.provider.dart';
import 'package:cookie_app/viewmodel/map/map.viewmodel.dart';

class MyGoogleMap extends StatefulWidget {
  const MyGoogleMap({super.key});

  @override
  State<MyGoogleMap> createState() => _MyGoogleMapState();
}

class _MyGoogleMapState extends State<MyGoogleMap> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String mapStyle = context.watch<ThemeProvider>().mapStyle;
    Set<Marker> marker = context.watch<MapViewModel>().markers;
    bool isMarkerAvailable =
        context.watch<MapViewModel>().isLocationUpdateRunning;

    return GoogleMap(
      myLocationEnabled: true, // 본인 마커
      mapToolbarEnabled: false, // 길찾기 버튼
      zoomControlsEnabled: false, // 축소확대 버튼
      myLocationButtonEnabled: false, // 내위치 버튼
      markers: isMarkerAvailable ? marker : {},
      mapType: MapType.normal,

      minMaxZoomPreference: const MinMaxZoomPreference(12, 20), // 줌 제한

      onMapCreated: (GoogleMapController controller) {
        context.read<MapViewModel>().mapController = controller;
        context.read<MapViewModel>().mapController.setMapStyle(mapStyle);
      },

      initialCameraPosition: CameraPosition(
        target: context.read<MapViewModel>().getCurrentLocation(),
        zoom: 16.0,
      ),
    );
  }
}

/* 
https://snazzymaps.com/explore?text=&sort=popular&tag=&color= [google map theme]
*/
