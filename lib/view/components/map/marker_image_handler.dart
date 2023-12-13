import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:cookie_app/utils/logger.dart';

Future<bool> isUrlAccessible(String url) async {
  try {
    final response = await http.head(Uri.parse(url));
    logger.t('isUrlAccessible: ${response.statusCode}');
    return response.statusCode == 200;
  } catch (e) {
    return false;
  }
}

Future<String> getNetworkImage(String imageURL) async {
  try {
    bool isValidUrl = await isUrlAccessible(imageURL);
    logger.t('getNetworkImage: $imageURL');
    if (isValidUrl) {
      return imageURL;
    } else {
      const defaultImageUrl =
          'https://img.freepik.com/free-photo/abstract-surface-and-textures-of-white-concrete-stone-wall_74190-8189.jpg?w=740&t=st=1699954803~exp=1699955403~hmac=b06fdddf22160522cb93f9a159504e331c773055cf433fa5d5156348b4c49782';
      return defaultImageUrl;
    }
  } catch (e) {
    const defaultImageUrl =
        'https://img.freepik.com/free-photo/abstract-surface-and-textures-of-white-concrete-stone-wall_74190-8189.jpg?w=740&t=st=1699954803~exp=1699955403~hmac=b06fdddf22160522cb93f9a159504e331c773055cf433fa5d5156348b4c49782';
    logger.t('getNetworkImage Error: $e');
    return defaultImageUrl;
  }
}

Future<File> getCachedImage(String url) async {
  if (url.startsWith('http') || url.startsWith('https')) {
    File imageFile = await DefaultCacheManager().getSingleFile(url);
    return imageFile;
  } else {
    throw const FormatException('Invalid URL scheme');
  }
}
