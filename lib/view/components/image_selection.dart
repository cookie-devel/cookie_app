import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

// 사진 촬영 및 갤러리 접근 class
class ImageSelectionDialog {
  File? _imageFile;

  Future<File?> show(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('새로운 프로필사진'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                GestureDetector(
                  child: const Text('갤러리에서 가져오기'),
                  onTap: () async {
                    final picker = ImagePicker();
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (context.mounted && pickedFile != null) {
                      _imageFile = File(pickedFile.path);
                      Navigator.pop(context);
                    }
                  },
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  child: const Text('카메라로 촬영하기'),
                  onTap: () async {
                    final picker = ImagePicker();
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.camera);
                    if (context.mounted && pickedFile != null) {
                      _imageFile = File(pickedFile.path);
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    return _imageFile;
  }
}
