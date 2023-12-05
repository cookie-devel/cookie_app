import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart' as l2;

import 'package:cookie_app/service/account.service.dart';
import 'package:cookie_app/utils/navigation_service.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';
import 'package:cookie_app/types/map/map_position_info.dart';

import 'package:cookie_app/viewmodel/map/map.viewmodel.dart';

class MarkerViewModel with ChangeNotifier {
  BuildContext context = NavigationService.navigatorKey.currentContext!;
  final l2.Distance distance = const l2.Distance();

  final MapInfoResponse _model;
  MarkerViewModel({required MapInfoResponse model}) : _model = model;

  String get id => _model.userid;
  double get latitude => _model.latitude;
  double get longitude => _model.longitude;
  LatLng get position => LatLng(latitude, longitude);

  AccountViewModel get account =>
      context.read<AccountService>().getUserById(id);
  String get name => account.name;
  bool get exist =>
      context.read<MapViewModel>().mapLog.any((element) => element.id == id);

  String get dist => calDistance();
  String calDistance() {
    final position = context.read<MapViewModel>().getCurrentLocation();
    final latLong1 = l2.LatLng(position.latitude, position.longitude);
    final latLong2 =
        l2.LatLng(latitude,longitude);
    final dist = distance(latLong1, latLong2);

    final double distanceInMeters = dist < 1000 ? dist : dist / 1000;
    final String distanceString =
        distanceInMeters.toStringAsFixed(distanceInMeters < 10 ? 1 : 0);
    final String unit = dist < 1000 ? 'm' : 'km';

    return '$distanceString $unit';
  }
}
