import 'package:cookie_app/types/account/account_info.dart';

class GetFriendsResponse {
  List<PublicAccount> friendList;

  GetFriendsResponse({
    required this.friendList,
  });

  factory GetFriendsResponse.fromJson(Map<String, dynamic> json) {
    return GetFriendsResponse(
      friendList: (json['friendList'] as List<dynamic>)
          .map((e) => PublicAccount.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'friendList': friendList,
    };
  }
}
