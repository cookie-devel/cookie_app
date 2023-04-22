// 친구 정보 class
class FriendInfo {
  final String? name;
  final String? image;
  final Map? log;

  FriendInfo({
    this.name = "Unknown",
    this.image = "assets/images/user.jpg",
    this.log = const {},
  });
}

// dictionary -> FriendInfo
FriendInfo returnUserInfo(Map<String, dynamic> profile) {
  String name = profile['name'] as String;
  String image = profile['image'] as String;

  Map log = {};
  if (profile['log'] != null) {
    Map log = profile['log'] as Map;
  } else {
    Map log = {};
  }
  return FriendInfo(name: name, image: image, log: log);
}
