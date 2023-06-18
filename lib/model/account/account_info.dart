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

  Map<String, dynamic> toJson() => _$PublicAccountModelToJson(this);
}

@JsonSerializable()
class PrivateAccountModel extends PublicAccountModel {
  String phone;
  List<PublicAccountModel> friends;

  PrivateAccountModel({
    required super.userid,
    required super.username,
    required this.phone,
    required this.friends,
    required super.profile,
  }) {
    friends.sort((a, b) {
      return a.username.compareTo(b.username);
    });
  }

  factory PrivateAccountModel.fromJson(Map<String, dynamic> json) =>
      _$PrivateAccountModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PrivateAccountModelToJson(this);
}
