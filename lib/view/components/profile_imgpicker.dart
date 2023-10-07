import 'dart:io';

import 'package:flutter/material.dart';

import 'package:cookie_app/view/components/image_selection.dart';
import 'package:cookie_app/view/components/rounded_image.dart';

class ProfileImagePicker extends StatelessWidget {
  final ImageProvider profileImg;
  final Function(File?)? setImage;

  const ProfileImagePicker({
    super.key,
    required this.profileImg,
    this.setImage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final imageSelectionDialog = ImageSelectionDialog();
        final imageFile = await imageSelectionDialog.show(context);
        if (imageFile != null && setImage != null) {
          setImage!(File(imageFile.path));
        }
      },
      child: Stack(
        children: [
          RoundedImage(
            image: profileImg,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white70,
                border: Border.fromBorderSide(
                  BorderSide(
                    color: Colors.grey,
                    width: 1.3,
                  ),
                ),
                shape: BoxShape.circle,
              ),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.edit,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
