import 'package:cookie_app/model/account/account_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class MessageModel {
  final PublicAccountModel sender;
  final String content;
  final DateTime time;

  MessageModel({
    required this.sender,
    required this.content,
    required this.time,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
}