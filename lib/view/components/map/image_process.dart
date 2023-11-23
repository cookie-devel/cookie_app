import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

Future<Uint8List> getRoundedImage(
  ImageProvider image, {
  int width = 100,
  Color borderColor = Colors.deepOrangeAccent,
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

Future<String> getNetworkImage(String url) async {
  bool isValidUrl = Uri.tryParse(url)?.isAbsolute ?? false;
  if (isValidUrl) {
    return url;
  } else {
    return 'https://img.freepik.com/free-photo/abstract-surface-and-textures-of-white-concrete-stone-wall_74190-8189.jpg?w=740&t=st=1699954803~exp=1699955403~hmac=b06fdddf22160522cb93f9a159504e331c773055cf433fa5d5156348b4c49782';
  }
}

Future<File> getCachedImage(String url) async {
  File imageFile = await DefaultCacheManager().getSingleFile(url);
  return imageFile;
}
