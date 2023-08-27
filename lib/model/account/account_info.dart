import 'package:cookie_app/datasource/storage/account.storage.dart';
import 'package:cookie_app/model/chat/room.dart';
import 'package:cookie_app/types/account/profile.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account_info.g.dart';

@JsonSerializable()
class PublicAccountModel {
  String userid;
  String username;
  Profile profile;

  PublicAccountModel({
    required this.userid,
    required this.username,
    required this.profile,
  });

  factory PublicAccountModel.fromJson(Map<String, dynamic> json) =>
      _$PublicAccountModelFromJson(json);

  factory PublicAccountModel.fromPrivate(PrivateAccountModel model) =>
      PublicAccountModel(
        userid: model.userid,
        username: model.username,
        profile: model.profile,
      );

  Map<String, dynamic> toJson() => _$PublicAccountModelToJson(this);
}

@JsonSerializable()
class PrivateAccountModel extends PublicAccountModel {
  String phone;
  List<PublicAccountModel> friendList;
  List<ChatRoomModel> chatRooms;

  PrivateAccountModel({
    required super.userid,
    required super.username,
    required this.phone,
    required this.friendList,
    required super.profile,
    required this.chatRooms,
  }) {
    friendList.sort((a, b) => a.username.compareTo(b.username));
  }

  factory PrivateAccountModel.fromJson(Map<String, dynamic> json) =>
      _$PrivateAccountModelFromJson(json);

  static Future<PrivateAccountModel?> fromStorage({
    required AccountStorage storage,
  }) async {
    if (await storage.exists() == false) {
      return null;
    } else if ((await storage.readJSON()).isEmpty) {
      return null;
    }

    return PrivateAccountModel.fromJson(await storage.readJSON());
  }

  @override
  Map<String, dynamic> toJson() => _$PrivateAccountModelToJson(this);
  PublicAccountModel toPublic() => PublicAccountModel.fromPrivate(this);
}
