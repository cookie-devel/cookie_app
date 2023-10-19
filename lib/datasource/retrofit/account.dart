import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

import 'package:cookie_app/model/account/account_info.dart';
import 'package:cookie_app/model/chat/room.dart';
import 'package:cookie_app/types/account/profile.dart';

part 'account.g.dart';

@RestApi(baseUrl: "http://localhost:3000/account")
abstract class AccountRestClient {
  factory AccountRestClient(Dio dio, {String baseUrl}) = _AccountRestClient;

  @GET("/info")
  Future<InfoResponse> getInfo();
}

@JsonSerializable()
class ErrorResponse {
  String? errName;
  String? errMessage;

  ErrorResponse({this.errName, this.errMessage});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);
}

@JsonSerializable()
class InfoResponse extends ErrorResponse {
  String? id;
  String? name;
  String? phone;
  List<PublicAccountModel>? friendList;
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

 @override
   Map<String, dynamic> toJson() => _$InfoResponseToJson(this);

  PrivateAccountModel toPrivateAccount() {
    return PrivateAccountModel(
      id: id!,
      name: name!,
      phone: phone!,
      profile: profile!,
      friendList: friendList == null ? [] : friendList!,
      chatRooms: chatRooms == null ? [] : chatRooms!,
    );
  }
}
