import 'package:cookie_app/handler/friends_refresh.handler.dart';
import 'package:cookie_app/schema/User.dart';
import 'package:cookie_app/utils/jwt.dart';
import 'package:cookie_app/utils/storage.dart';
import 'package:flutter/material.dart';

final accountStorage = Storage("account.json");

Future<Map<String, dynamic>> data = accountStorage.readJSON();

class Me {
  static bool _isLoaded = false;

  String? _id;
  String? _name;
  ImageProvider? _profileImage;
  String? _profileMessage;
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

  loadFromJWT() async {
    var decodedJWT = await JWT.decode();
    _id = decodedJWT["userid"];
    _name = decodedJWT["username"];
  }

  loadFromJSON(Map<String, dynamic> data) {
    _isLoaded = false;
    _id = data["id"];
    _name = data["name"];
    _profileImage = data["profile"]?["image"] != null
        ? NetworkImage(data["profile"]["image"])
        : const AssetImage("images/default_profile.png") as ImageProvider;
    _profileMessage = data["profile"]?["message"] ?? "";
    _phone = data["phone"];
    _friendList = data["friendList"];
    _isLoaded = true;
  }

  loadFromStorage() async {
    loadFromJSON(await accountStorage.readJSON());
    await loadFromJWT();
  }

  void updateFriendList() async {
    var data = await apiGetFriends();
    _friendList = data['result'];
    update();
  }

  void update() async {
    await accountStorage.writeJSON(
      {
        "id": id,
        "name": name,
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
    update();
  }

  set name(String? name) {
    _name = name;
    update();
  }

  set profileImage(ImageProvider? profileImage) {
    _profileImage = profileImage;
    update();
  }

  set profileMessage(String? profileMessage) {
    _profileMessage = profileMessage;
    update();
  }

  set phone(String? phone) {
    _phone = phone;
    update();
  }

  set friendList(List<dynamic>? friendList) {
    _friendList = friendList ?? [];
    update();
  }

  static bool get isLoaded => _isLoaded;
}

Me my = Me();
