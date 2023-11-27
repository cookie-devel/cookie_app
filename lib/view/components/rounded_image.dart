import 'package:cookie_app/theme/components/input.theme.dart';
import 'package:flutter/material.dart';

class RoundedImage extends StatelessWidget {
  final ImageProvider image;
  final double imageSize;
  final bool shadow;
  const RoundedImage({
    super.key,
    required this.image,
    this.imageSize = 100.0,
    this.shadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: imageSize,
      height: imageSize,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: image,
          fit: BoxFit.cover,
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: InputTheme.color3,
          width: 3.0,
        ),
        boxShadow: shadow == true
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
    );
  }
}
