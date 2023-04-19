import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';


bool allCheck(idlengthCheck, pwlengthCheck) {
  if (idlengthCheck == true && pwlengthCheck == true) {
    return true;
  } else {
    return false;
  }
}

// creadte json structure
String createJsonData(String id, String pw) {
  Map<String, dynamic> data = {"userid": id, "password": pw};

  String jsonData = const JsonEncoder.withIndent('\t').convert(data);

  return jsonData;
}


Future<Map<String, dynamic>> sendDataToServer(String data) async {
  try {
    String address = '${dotenv.env['BASE_URI']}/account/signin';
    http.Response res = await http.post(Uri.parse(address),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: data);
    return json.decode(res.body);
  } catch (e) {
    print('Error sending data to server: $e');
    return {};
  }
}


Scaffold isLoadingScreen(){
  return Scaffold(
    backgroundColor: Colors.deepOrangeAccent,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 24.0),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          SizedBox(height: 16.0),
          Text(
            "Loading",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
    bottomNavigationBar: Container(
      height: 72.0,
      child: Center(
        child: Text(
          "C🍪🍪KIE",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 2.0,
                color: Colors.grey,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

