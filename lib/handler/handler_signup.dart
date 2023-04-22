import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';  
import 'package:flutter_dotenv/flutter_dotenv.dart';


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
                    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
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
                    final pickedFile = await picker.pickImage(source: ImageSource.camera);
                    if (pickedFile != null) {
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



// jsondata to server
Future<Map<String, dynamic>> sendDataToServer(String data) async {
  try {
    String address = '${dotenv.env['BASE_URI']}/account/signup';
    http.Response res = await http.post(Uri.parse(address),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: data);

    return json.decode(res.body);
  } catch (e) {
    print('Error sending data to server: $e');
    return {'error': 'Error sending data to server'};
  }
}



// creadte json structure
String createJsonData(
    String id, String pw, String name, String date, String phoneNumber) {
  Map<String, dynamic> data = {
    "userid": id,
    "password": pw,
    "username": name,
    "birthday": date,
    "phone": phoneNumber,
    "profile": {
      "image": "https://i.imgur.com/1Q9ZQ9r.png",
      "message": "Hello, I'm new here!"
    }
  };

  String jsonData = const JsonEncoder.withIndent('\t').convert(data);

  return jsonData;
}



bool allCheck(
    idlengthCheck, pwlengthCheck, pwCheckErrorText, namelengthCheck) {
  if (idlengthCheck == true &&
      pwlengthCheck == true &&
      pwCheckErrorText == true &&
      namelengthCheck == true) {
    return true;
  } else {
    return false;
  }
}