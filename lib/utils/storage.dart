import 'dart:io';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';


// final prefs = SharedPreferences.getInstance();
FlutterSecureStorage secureStorage = const FlutterSecureStorage();

class Storage {
  String filename;
  Storage(this.filename);

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$filename');
  }

  Future<File> writeData(String data) async {
    final file = await _localFile;
    return file.writeAsString(data);
  }

  Future<String> readData() async {
    try {
      final file = await _localFile;
      String data = await file.readAsString();
      return data;
    } catch (e) {
      return 'error';
    }
  }

  Future<File> writeJSON(Map<String, dynamic> data) async {
    final file = await _localFile;
    return file.writeAsString(json.encode(data));
  }

  Future<Map<String, dynamic>> readJSON() async {
    try {
      final file = await _localFile;
      String data = await file.readAsString();
      return json.decode(data);
    } catch (e) {
      return {};
    }
  }

  Future<bool> deleteData() async {
    try {
      final file = await _localFile;
      await file.delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}