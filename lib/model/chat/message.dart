import 'package:json_annotation/json_annotation.dart';

import 'package:cookie_app/model/account/account.dart';

part 'message.g.dart';

@JsonSerializable()
class MessageModel {
  final String id;
  final AccountModel sender;
  final String content;
  final DateTime time;

  MessageModel({
    required this.id,
    required this.sender,
    required this.content,
    required this.time,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
}
