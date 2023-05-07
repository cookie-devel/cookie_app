// 친구 정보 class
class FriendInfo {
  final String? username;
  final String? image;
  final String? message;
  final String? userid;

  FriendInfo({
    this.username = "Unknown",
    this.image = "assets/images/cookie_logo.png",
    this.message = "",
    this.userid = "",
  });
}

// dictionary -> FriendInfo
FriendInfo returnUserInfo(Map<String, dynamic> profile) {
  String username = profile['username'] ?? "Unknown";
  String userid = profile['userid'] ?? "";

  Map<String, dynamic> prof = profile['profile'] ?? {};
  String image = prof['image'] ?? "assets/images/cookie_logo.png";
  String message = prof['message'] ?? "";

  return FriendInfo(
    username: username,
    image: image,
    message: message,
    userid: userid,
  );
}
