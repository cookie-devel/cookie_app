// 친구 정보 class
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FriendInfo {
  final String? _userid;
  final String? _username;
  final String? _profileImage;
  final String? _profileMessage;

  FriendInfo({
    String? userid,
    String? username,
    String? profileImage,
    String? profileMessage,
  })  : _userid = userid,
        _username = username,
        _profileImage = profileImage,
        _profileMessage = profileMessage;

  String? get userid => _userid;
  String get username => _username ?? "Unknown User";
  String get profileImage =>
      _profileImage ?? '${dotenv.env['BASE_URI']}/cookie_logo.png';
  String? get profileMessage => _profileMessage;

  FriendInfo.fromMap(Map<String, dynamic> data)
      : _userid = data['userid'] ?? "",
        _username = data['username'] ?? "Unknown",
        _profileImage =
            '${dotenv.env['BASE_URI']}/${data['profile']['image'] ?? "cookie_logo.png"}',
        _profileMessage = data['profile']['message'] ?? "";
}
