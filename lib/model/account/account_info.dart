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

  Map<String, dynamic> toJson() => _$PublicAccountModelToJson(this);
}

@JsonSerializable()
class PrivateAccountModel extends PublicAccountModel {
  String phone;
  List<PublicAccountModel> friends;

  PrivateAccountModel({
    required super.id,
    required super.name,
    required this.phone,
    required this.friends,
    required super.profile,
  }) {
    friends.sort((a, b) {
      return a.name.compareTo(b.name);
    });
  }

  factory PrivateAccountModel.fromJson(Map<String, dynamic> json) =>
      _$PrivateAccountModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PrivateAccountModelToJson(this);
}
