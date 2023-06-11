import 'package:json_annotation/json_annotation.dart';

part 'signin.g.dart';

@JsonSerializable()
class SignInFormModel {
  String id;
  String pw;

  SignInFormModel({required this.id, required this.pw});

  factory SignInFormModel.fromJson(Map<String, dynamic> json) => _$SignInFormModelFromJson(json);

  Map<String, dynamic> toJson() => _$SignInFormModelToJson(this);
}