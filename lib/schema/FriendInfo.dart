// 친구 정보 class
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FriendInfo {
  final String? userid;
  String? username;
  String? profileImage;
  String? profileMessage;

  FriendInfo({
    this.userid,
    this.username,
    this.profileImage,
    this.profileMessage,
  });
  
  String get getUsername => username ?? "Unknown User";
  String get getProfileImage => profileImage ?? '${dotenv.env['BASE_URI']}/cookie_logo.png';

  FriendInfo.fromMap(Map<String, dynamic> data)
      : userid = data['userid'] ?? "",
        username = data['username'] ?? "Unknown",
        profileImage =
            '${dotenv.env['BASE_URI']}/${data['profile']['image'] ?? "cookie_logo.png"}',
        profileMessage = data['profile']['message'] ?? "";
}
