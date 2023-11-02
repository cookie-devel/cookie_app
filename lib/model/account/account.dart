import 'package:json_annotation/json_annotation.dart';

import 'package:cookie_app/model/chat/room.dart';
import 'package:cookie_app/types/account/profile.dart';

part 'account.g.dart';

@JsonSerializable()
class AccountModel {
  String id;
  String name;
  Profile profile;
  String? phone;
  List<AccountModel>? friendList;
  List<ChatRoomModel>? chatRooms;

  AccountModel({
    required this.id,
    required this.name,
    required this.profile,
    this.phone,
    this.friendList,
    this.chatRooms,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountModelToJson(this);
}
