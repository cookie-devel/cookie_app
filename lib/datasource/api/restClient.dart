import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

import 'package:cookie_app/model/account/account.dart';
import 'package:cookie_app/model/chat/room.dart';
import 'package:cookie_app/types/account/profile.dart';

part 'restClient.g.dart';

@RestApi(baseUrl: "http://localhost:3000")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/account/info")
  Future<InfoResponse> getInfo({
    @Query("fields") List<String>? fields,
  });

  @PATCH("/account/devices")
  Future<void> patchDeviceToken(
    @Field() String udid,
    @Field() String token,
  );
}

@JsonSerializable()
class InfoResponse {
  String? id;
  String? name;
  String? phone;
  Profile? profile;
  List<AccountModel>? friendList;
  List<ChatRoomModel>? chatRooms;

  InfoResponse({
    this.id,
    this.name,
    this.phone,
    this.profile,
    this.friendList,
    this.chatRooms,
  });

  factory InfoResponse.fromJson(Map<String, dynamic> json) =>
      _$InfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InfoResponseToJson(this);

  AccountModel toAccount() {
    return AccountModel(
      id: id!,
      name: name!,
      phone: phone!,
      profile: profile!,
    );
  }
}
