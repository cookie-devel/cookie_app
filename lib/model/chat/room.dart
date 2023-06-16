import 'package:cookie_app/model/account/account_info.dart';
import 'package:cookie_app/model/chat/message.dart';
import 'package:json_annotation/json_annotation.dart';

part 'room.g.dart';

@JsonSerializable()
class RoomModel {
  final String id;
  final String name;
  final List<PublicAccountModel> users;
  final List<MessageModel> messages;

  RoomModel({
    required this.id,
    this.name = "Unknown Room",
    this.users = const [],
    this.messages = const [],
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) =>
      _$RoomModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoomModelToJson(this);
}
