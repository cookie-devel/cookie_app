import 'package:json_annotation/json_annotation.dart';
import 'package:cookie_app/model/account/account_info.dart';
import 'package:cookie_app/types/account/profile.dart';

part 'info.g.dart';

@JsonSerializable()
class InfoResponse {
  String? userid;
  String? username;
  String? phone;
  List<PublicAccountModel>? friends;
  Profile? profile;

  InfoResponse({
    this.userid,
    this.username,
    this.phone,
    this.friends,
    this.profile,
  });

  factory InfoResponse.fromJson(Map<String, dynamic> json) =>
      _$InfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InfoResponseToJson(this);

  PrivateAccountModel toPrivateAccount() {
    return PrivateAccountModel(
      id: userid!,
      name: username!,
      phone: phone!,
      profile: profile!,
      friends: friends!,
    );
  }
}
