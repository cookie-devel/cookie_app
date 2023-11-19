import 'package:cookie_app/theme/theme.provider.dart';
import 'package:cookie_app/viewmodel/map.viewmodel.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

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
    return Consumer2<ThemeProvider, MapViewModel>(
      builder: (context, themeProvider, mapProvider, _) {
        String mapStyle = themeProvider.mapStyle;
        final currentLocation = mapProvider.currentLocation;
        final marker = mapProvider.markers;

        return GoogleMap(
          myLocationEnabled: true, // 본인 마커
          mapToolbarEnabled: false, // 길찾기 버튼
          zoomControlsEnabled: false, // 축소확대 버튼
          myLocationButtonEnabled: false, // 내위치 버튼
          markers: marker,
          mapType: MapType.normal,

          minMaxZoomPreference: const MinMaxZoomPreference(14, 20), // 줌 제한

          onMapCreated: (GoogleMapController controller) {
            context.read<MapViewModel>().mapController = controller;
            context.read<MapViewModel>().mapController.setMapStyle(mapStyle);
          },

          initialCameraPosition: CameraPosition(
            target: currentLocation,
            zoom: 17.0,
          ),
        );
      },
    );
  }
}
