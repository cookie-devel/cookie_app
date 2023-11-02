import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

import 'package:cookie_app/model/account/account.dart';
import 'package:cookie_app/model/chat/room.dart';
import 'package:cookie_app/types/account/profile.dart';

part 'account.g.dart';

@RestApi(baseUrl: "http://localhost:3000")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/account/info")
  Future<InfoResponse> getInfo();
}

@JsonSerializable()
class ErrorResponse {
  String? name;
  String? message;

  ErrorResponse({this.name, this.message});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);
}

@JsonSerializable()
class InfoResponse {
  String? id;
  String? name;
  String? phone;
  List<AccountModel>? friendList;
  Profile? profile;
  List<ChatRoomModel>? chatRooms;

  InfoResponse({
    this.id,
    this.name,
    this.phone,
    this.friendList,
    this.profile,
    this.chatRooms,
  });

  factory InfoResponse.fromJson(Map<String, dynamic> json) =>
      _$InfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InfoResponseToJson(this);

  AccountModel toPrivateAccount() {
    return AccountModel(
      id: id!,
      name: name!,
      phone: phone!,
      profile: profile!,
      friendList: friendList == null ? [] : friendList!,
      chatRooms: chatRooms == null ? [] : chatRooms!,
    );
  }
}
