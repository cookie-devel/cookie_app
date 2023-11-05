import 'package:json_annotation/json_annotation.dart';

import 'package:cookie_app/types/account/profile.dart';

part 'account.g.dart';

@JsonSerializable()
class AccountModel {
  String id;
  String name;
  Profile profile;
  String? phone;

  AccountModel({
    required this.id,
    required this.name,
    required this.profile,
    this.phone,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountModelToJson(this);
}
