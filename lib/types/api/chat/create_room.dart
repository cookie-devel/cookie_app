import 'package:json_annotation/json_annotation.dart';

part 'create_room.g.dart';

@JsonSerializable()
class CreateRoomRequest {
  // TODO
  CreateRoomRequest();

  factory CreateRoomRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateRoomRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateRoomRequestToJson(this);
}

@JsonSerializable()
class CreateRoomResponse {
  // TODO
  CreateRoomResponse();

  factory CreateRoomResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateRoomResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateRoomResponseToJson(this);
}
