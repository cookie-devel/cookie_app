// 친구 정보 class
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FriendInfo {
  final String? _userid;
  final String? _username;
  final ImageProvider? _profileImage;
  final String? _profileMessage;

  FriendInfo({
    String? userid,
    String? username,
    ImageProvider? profileImage,
    String? profileMessage,
  })  : _userid = userid,
        _username = username,
        _profileImage = profileImage,
        _profileMessage = profileMessage;

  String? get userid => _userid;
  String get username => _username ?? "Unknown User";
  ImageProvider get profileImage =>
      _profileImage ?? const AssetImage('assets/images/cookie_logo.png');
  String? get profileMessage => _profileMessage;

  FriendInfo.fromMap(Map<String, dynamic> data)
      : _userid = data['userid'] ?? "",
        _username = data['username'] ?? "Unknown",
        _profileImage = data['profile']['image'] != null
            ? NetworkImage(
                '${dotenv.env['BASE_URI']}/${data['profile']['image']}',
              )
            : const AssetImage('assets/images/cookie_logo.png')
                as ImageProvider,
        _profileMessage = data['profile']['message'] ?? "";
}
