import './profile.dart';

class PublicAccountInfo {
  String? userid;
  String? username;
  Profile? profile;

  PublicAccountInfo({
    this.userid,
    this.username,
    this.profile,
  });
}

class PrivateAccountInfo extends PublicAccountInfo {
  String? phone;
  List<PublicAccountInfo>? friends;

  PrivateAccountInfo({
    super.userid,
    super.username,
    this.phone,
    this.friends,
    super.profile,
  });
}
