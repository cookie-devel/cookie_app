import 'package:cookie_app/types/account/profile.dart';
import 'package:json_annotation/json_annotation.dart';

part 'signup.g.dart';

@JsonSerializable()
class SignUpFormModel {
  final String id;
  final String pw;
  final String name;
  final String birthday;
  final String phoneNumber;
  final Profile profile;

  SignUpFormModel({
    required this.id,
    required this.pw,
    required this.name,
    required this.birthday,
    required this.phoneNumber,
    required this.profile,
  });

  factory SignUpFormModel.fromJson(Map<String, dynamic> json) =>
      _$SignUpFormModelFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpFormModelToJson(this);
}
