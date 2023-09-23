import 'package:cookie_app/datasource/storage/account.storage.dart';
import 'package:cookie_app/model/chat/room.dart';
import 'package:cookie_app/types/account/profile.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account_info.g.dart';

@JsonSerializable()
class PublicAccountModel {
  String id;
  String name;
  Profile profile;

  PublicAccountModel({
    required this.id,
    required this.name,
    required this.profile,
  });

  factory PublicAccountModel.fromJson(Map<String, dynamic> json) =>
      _$PublicAccountModelFromJson(json);

  factory PublicAccountModel.fromPrivate(PrivateAccountModel model) =>
      PublicAccountModel(
        id: model.id,
        name: model.name,
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
    required super.id,
    required super.name,
    required this.phone,
    required this.friendList,
    required super.profile,
    required this.chatRooms,
  }) {
    friendList.sort((a, b) => a.name.compareTo(b.name));
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
