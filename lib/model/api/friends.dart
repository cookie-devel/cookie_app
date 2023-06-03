import 'package:cookie_app/model/account/account_info.dart';

class GetFriendsResponse {
  List<PublicAccountInfo> friendList;

  GetFriendsResponse({
    required this.friendList,
  });

  factory GetFriendsResponse.fromJson(Map<String, dynamic> json) {
    return GetFriendsResponse(
      friendList: (json['friendList'] as List<dynamic>)
          .map((e) => PublicAccountInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'friendList': friendList,
    };
  }
}
