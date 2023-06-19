import 'package:cookie_app/model/chat/room.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cookie_app/model/account/account_info.dart';
import 'package:cookie_app/types/account/profile.dart';

part 'info.g.dart';

@JsonSerializable()
class InfoResponse {
  String? userid;
  String? username;
  String? phone;
  List<PublicAccountModel>? friendList;
  Profile? profile;
  List<ChatRoomModel>? chatRooms;

  InfoResponse({
    this.userid,
    this.username,
    this.phone,
    this.friendList,
    this.profile,
  });

  factory InfoResponse.fromJson(Map<String, dynamic> json) =>
      _$InfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InfoResponseToJson(this);

  PrivateAccountModel toPrivateAccount() {
    return PrivateAccountModel(
      userid: userid!,
      username: username!,
      phone: phone!,
      profile: profile!,
      friends: friendList == null ? [] : friendList!,
      chatRooms: chatRooms == null ? [] : chatRooms!,
    );
  }
}
