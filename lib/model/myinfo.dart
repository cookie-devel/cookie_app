import 'package:cookie_app/repository/myinfo.repo.dart';
import 'package:cookie_app/types/account/account_info.dart';
import 'package:cookie_app/types/account/profile.dart';
import 'package:json_annotation/json_annotation.dart';

part 'myinfo.g.dart';

@JsonSerializable()
class MyInfoModel extends PrivateAccount {
  final MyInfoRepository _api = MyInfoRepositoryApiImpl();
  final MyInfoRepository _storage = MyInfoRepositoryStorageImpl();

  MyInfoModel({
    required super.id,
    required super.name,
    required super.phone,
    super.friends = const [],
    required super.profile,
  });

  factory MyInfoModel.fromJson(Map<String, dynamic> json) =>
      _$MyInfoModelFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MyInfoModelToJson(this);
}
