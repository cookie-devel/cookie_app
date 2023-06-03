import './profile.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account_info.g.dart';

@JsonSerializable()
class PublicAccountInfo {
  String userid;
  String username;
  Profile profile;

  PublicAccountInfo({
    required this.userid,
    required this.username,
    required this.profile,
  });

  factory PublicAccountInfo.fromJson(Map<String, dynamic> json) =>
      _$PublicAccountInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PublicAccountInfoToJson(this);
}

@JsonSerializable()
class PrivateAccountInfo extends PublicAccountInfo {
  String phone;
  List<PublicAccountInfo> friends;

  PrivateAccountInfo({
    required super.userid,
    required super.username,
    required this.phone,
    required this.friends,
    required super.profile,
  });

  factory PrivateAccountInfo.fromJson(Map<String, dynamic> json) =>
      _$PrivateAccountInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PrivateAccountInfoToJson(this);
}
