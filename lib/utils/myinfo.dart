import 'package:cookie_app/api/friends.dart';
import 'package:cookie_app/utils/jwt.dart';
import 'package:cookie_app/utils/storage.dart';
import 'package:flutter/material.dart';

final accountStorage = Storage("account.json");

Future<Map<String, dynamic>> data = accountStorage.readJSON();

class Me {
  static bool _isLoaded = false;

  static String? _id;
  static String? _name;
  static ImageProvider? _profileImage;
  static String? _profileMessage;
  static String? _phone;
  static List<dynamic> _friendList = [];

  Me({
    String? id,
    String? name,
    ImageProvider? profileImage,
    String? profileMessage,
    String? phone,
    List<dynamic>? friendList,
  }) {
    _id = id;
    _name = name;
    _profileImage = profileImage;
    _profileMessage = profileMessage;
    _phone = phone;
    _friendList = friendList ?? [];
  }

  Me.loadFromJSON(data) {
    loadFromJSON(data);
  }

  Future<void> loadFromJWT() async {
    var decodedJWT = await JWT.decode();
    _id = decodedJWT["userid"];
    _name = decodedJWT["username"];
  }

  void loadFromJSON(Map<String, dynamic> data) {
    _isLoaded = false;
    _id = data["userid"];
    _name = data["username"];
    _profileImage = data["profile"]?["image"] != null
        ? NetworkImage(data["profile"]["image"])
        : const AssetImage("images/default_profile.png") as ImageProvider;
    _profileMessage = data["profile"]?["message"] ?? "";
    _phone = data["phone"];
    _friendList = data["friendList"];
    _isLoaded = true;
  }

  Future<void> loadFromStorage() async {
    loadFromJSON(await accountStorage.readJSON());
    await loadFromJWT();
  }

  Future<void> updateFriendList() async {
    var data = await apiGetFriends();
    _friendList = data['result'];
  }

  Future<void> update() async {
    await accountStorage.writeJSON(
      {
        "userid": id,
        "username": name,
        "profile": {
          "image": profileImage,
          "message": profileMessage,
        },
        "phone": phone,
        "friendList": friendList,
      },
    );
  }

  String? get id => _isLoaded ? _id : null;
  String? get name => _isLoaded ? _name : null;
  ImageProvider get profileImage => _isLoaded && _profileImage != null
      ? _profileImage!
      : const AssetImage("images/default_profile.png");
  String? get profileMessage => _isLoaded ? _profileMessage : null;
  String? get phone => _isLoaded ? _phone : null;
  List<dynamic>? get friendList => _isLoaded ? _friendList : null;

  set({
    String? id,
    String? name,
    ImageProvider? profileImage,
    String? profileMessage,
    String? phone,
    List<dynamic>? friendList,
  }) {
    _id = id ?? _id;
    _name = name ?? _name;
    _profileImage = profileImage ?? _profileImage;
    _profileMessage = profileMessage ?? _profileMessage;
    _phone = phone ?? _phone;
    _friendList = friendList ?? _friendList;
    update();
  }

  set id(String? id) {
    _id = id;
  }

  set name(String? name) {
    _name = name;
  }

  set profileImage(ImageProvider? profileImage) {
    _profileImage = profileImage;
  }

  set profileMessage(String? profileMessage) {
    _profileMessage = profileMessage;
  }

  set phone(String? phone) {
    _phone = phone;
  }

  set friendList(List<dynamic>? friendList) {
    _friendList = friendList ?? [];
  }
}

Me my = Me();
