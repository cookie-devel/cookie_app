import 'package:cookie_app/types/account/profile.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account_info.g.dart';

@JsonSerializable()
class PublicAccount {
  String id;
  String name;
  Profile profile;

  PublicAccount({
    required this.id,
    required this.name,
    required this.profile,
  });

  factory PublicAccount.fromJson(Map<String, dynamic> json) =>
      _$PublicAccountFromJson(json);

  Map<String, dynamic> toJson() => _$PublicAccountToJson(this);
}

@JsonSerializable()
class PrivateAccount extends PublicAccount {
  String phone;
  List<PublicAccount> friends;

  PrivateAccount({
    required super.id,
    required super.name,
    required this.phone,
    required this.friends,
    required super.profile,
  });

  factory PrivateAccount.fromJson(Map<String, dynamic> json) =>
      _$PrivateAccountFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PrivateAccountToJson(this);
}
