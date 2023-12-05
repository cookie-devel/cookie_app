import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cookie_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<Uint8List> getRoundedImage(
  ImageProvider image, {
  int width = 100,
  Color borderColor = const Color.fromRGBO(252, 147, 49, 1),
  double borderWidth = 4,
}) async {
  final imageStream = image.resolve(ImageConfiguration.empty);
  final completer = Completer<Uint8List>();

  imageStream.addListener(
    ImageStreamListener((ImageInfo info, bool _) async {
      final roundedImage = await _createRoundedImage(
        info.image,
        width,
        borderColor,
        borderWidth,
      );

      completer.complete(roundedImage);
    }),
  );

  return completer.future;
}

Future<Uint8List> _createRoundedImage(
  ui.Image image,
  int width,
  Color borderColor,
  double borderWidth,
) async {
  final paintRect = Offset.zero & Size(width.toDouble(), width.toDouble());
  final pictureRecorder = ui.PictureRecorder();
  final canvas = Canvas(pictureRecorder);

  final paint = Paint()..isAntiAlias = true;

  final double radius = width.toDouble() / 2;

  final borderPaint = Paint()
    ..color = borderColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = borderWidth;

  canvas.saveLayer(paintRect, Paint()); // Create a layer

  // Draw circular image
  canvas.drawCircle(Offset(radius, radius), radius, paint);

  // Clip the image
  canvas.clipPath(Path()..addOval(paintRect));

  // Draw the image
  canvas.drawImageRect(
    image,
    Rect.fromLTRB(0, 0, image.width.toDouble(), image.height.toDouble()),
    paintRect,
    paint,
  );

  // Draw the border
  canvas.drawCircle(
    Offset(radius, radius),
    radius - borderWidth / 2,
    borderPaint,
  );

  canvas.restore(); // Restore the layer

  final picture = pictureRecorder.endRecording();
  final roundedImage = await picture.toImage(width, width);
  final byteData =
      await roundedImage.toByteData(format: ui.ImageByteFormat.png);

  if (byteData != null) {
    return byteData.buffer.asUint8List();
  } else {
    throw Exception('Failed to convert image to byte data.');
  }
}

Future<bool> isUrlAccessible(String url) async {
  try {
    final response = await http.head(Uri.parse(url));
    return response.statusCode == 200;
  } catch (e) {
    return false;
  }
}

Future<String> getNetworkImage(String imageURL) async {
  try {
    bool isValidUrl = await isUrlAccessible('${dotenv.env['BASE_URI']}/$imageURL');
    if (isValidUrl) {
      return '${dotenv.env['BASE_URI']}/$imageURL';
    } else {
      return 'https://img.freepik.com/free-photo/abstract-surface-and-textures-of-white-concrete-stone-wall_74190-8189.jpg?w=740&t=st=1699954803~exp=1699955403~hmac=b06fdddf22160522cb93f9a159504e331c773055cf433fa5d5156348b4c49782';
    }
  } catch (e) {
    logger.t('getNetworkImage Error: $e');
    return 'https://img.freepik.com/free-photo/abstract-surface-and-textures-of-white-concrete-stone-wall_74190-8189.jpg?w=740&t=st=1699954803~exp=1699955403~hmac=b06fdddf22160522cb93f9a159504e331c773055cf433fa5d5156348b4c49782';
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
