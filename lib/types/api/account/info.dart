import 'package:json_annotation/json_annotation.dart';

import 'package:cookie_app/model/account/account.dart';
import 'package:cookie_app/model/chat/room.dart';
import 'package:cookie_app/types/account/profile.dart';

part 'info.g.dart';

@JsonSerializable()
class InfoResponse {
  String? id;
  String? name;
  String? phone;
  List<AccountModel>? friendList;
  Profile? profile;
  List<ChatRoomModel>? chatRooms;

  InfoResponse({
    this.id,
    this.name,
    this.phone,
    this.friendList,
    this.profile,
    this.chatRooms,
  });

  factory InfoResponse.fromJson(Map<String, dynamic> json) =>
      _$InfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InfoResponseToJson(this);

  AccountModel toPrivateAccount() {
    return AccountModel(
      id: id!,
      name: name!,
      phone: phone!,
      profile: profile!,
      friendList: friendList == null ? [] : friendList!,
      chatRooms: chatRooms == null ? [] : chatRooms!,
    );
  }
}
