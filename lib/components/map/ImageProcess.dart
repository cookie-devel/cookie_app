import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;
import 'dart:typed_data';

// 일반적인 marker 이미지 불러오기
// Future<Uint8List> getImages(String path, int width) async {
//   ByteData data = await rootBundle.load(path);
//   ui.Codec codec = await ui.instantiateImageCodec(
//     data.buffer.asUint8List(),
//     targetHeight: width,
//   );
//   ui.FrameInfo fi = await codec.getNextFrame();
//   Uint8List markIcons =
//       (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
//           .buffer
//           .asUint8List();

//   return markIcons;
// }

// 원형 marker 이미지 불러오기
Future<Uint8List> getRoundedImages(
  ImageProvider image,
  int width, {
  Color borderColor = Colors.transparent,
  double borderWidth = 0.0,
}) async {
  // TODO: should convert ImageProvider to Uint8List BitmapDescriptor eventually
  ByteData data = await rootBundle.load(image.toString());
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());

  final int imageSize = width;
  final ui.Image asdfimage = (await codec.getNextFrame()).image;

  final ui.Rect paintRect =
      Offset.zero & Size(imageSize.toDouble(), imageSize.toDouble());
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final ui.Canvas canvas = ui.Canvas(pictureRecorder);

  final Paint paint = Paint()..isAntiAlias = true;

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
    asdfimage,
    ui.Rect.fromLTRB(
        0, 0, asdfimage.width.toDouble(), asdfimage.height.toDouble()),
    paintRect,
    paint,
  );

  // 테두리 그리기
  canvas.drawCircle(
    Offset(radius, radius),
    radius - borderWidth / 2,
    borderPaint,
  );

  canvas.restore(); // 레이어 복원

  final ui.Picture picture = pictureRecorder.endRecording();
  final ui.Image roundedImage = await picture.toImage(imageSize, imageSize);
  final ByteData? byteData =
      await roundedImage.toByteData(format: ui.ImageByteFormat.png);

  if (byteData != null) {
    return byteData.buffer.asUint8List();
  } else {
    throw Exception('Failed to convert image to byte data.');
  }
}

Future<Uint8List> getRoundedImage(
  ImageProvider image,
  int width, {
  Color borderColor = Colors.transparent,
  double borderWidth = 0.0,
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
