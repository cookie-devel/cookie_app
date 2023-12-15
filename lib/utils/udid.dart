import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

Future<String?> getUdid() async {
  var deviceinfo = DeviceInfoPlugin();

  if (Platform.isIOS) {
    var ios = await deviceinfo.iosInfo;
    return ios.identifierForVendor; // unique id on ios
    // return '${ios.name}:${ios.identifierForVendor}'; // unique id on ios
  } else if (Platform.isAndroid) {
    var android = await deviceinfo.androidInfo;
    return '${android.model}:${android.id}'; // unique id on android
  }

  return null;
}
