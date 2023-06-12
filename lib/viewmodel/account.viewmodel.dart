import 'package:cookie_app/types/account/account_info.dart';
import 'package:cookie_app/viewmodel/base.viewmodel.dart';
import 'package:flutter/material.dart';

class PublicAccountViewModel extends BaseViewModel {
  PublicAccount? _model;

  String get id => _model!.id;
  String get name => _model!.name;
  ImageProvider get profileImage => _model!.profile.imageURL != null
      ? NetworkImage(_model!.profile.imageURL!)
      : const AssetImage('assets/images/default_profile.png') as ImageProvider;
  String? get profileMessage => _model!.profile.message!;
}

class PrivateAccountViewModel extends BaseViewModel {
  PrivateAccount? _model;

  String get id => _model!.id;
  String get name => _model!.name;
  ImageProvider get profileImage => _model!.profile.imageURL != null
      ? NetworkImage(_model!.profile.imageURL!)
      : const AssetImage('assets/images/default_profile.png') as ImageProvider;
  String? get profileMessage => _model!.profile.message!;
  String get phoneNumber => _model!.phone;
}
