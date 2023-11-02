import 'package:json_annotation/json_annotation.dart';

import 'package:cookie_app/model/account/account.dart';

part 'create_room.g.dart';

@JsonSerializable()
class CreateRoomRequest {
  String name;
  List<String> members;

  CreateRoomRequest({
    required this.name,
    required this.members,
  });

  factory CreateRoomRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateRoomRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateRoomRequestToJson(this);
}

@JsonSerializable()
class CreateRoomResponse {
  String id;
  DateTime createdAt;
  String name;
  List<AccountModel> members;

  CreateRoomResponse({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.members,
  });

  factory CreateRoomResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateRoomResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateRoomResponseToJson(this);
}
