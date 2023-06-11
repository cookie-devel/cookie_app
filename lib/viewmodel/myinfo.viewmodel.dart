import 'package:cookie_app/types/account/account_info.dart';
import 'package:cookie_app/model/myinfo.dart';
import 'package:cookie_app/viewmodel/base.viewmodel.dart';
import 'package:flutter/material.dart';

class MyInfoViewModel extends BaseViewModel {
  MyInfoModel? _model;

  String get id => _model!.id;
  String get name => _model!.name;
  String get phone => _model!.phone;
  List<PublicAccount> get friends => _model!.friends;
  ImageProvider get profileImage => _model!.profile.imageURL != null
      ? NetworkImage(_model!.profile.imageURL!)
      : const AssetImage('assets/images/default_profile.png') as ImageProvider;
  String? get profileMessage => _model!.profile.message!;

  MyInfoViewModel();

  Future<void> getMyInfo() async {
    setBusy(true);

    // MyInfoModel model = await _repository.getMyInfo();
    // InfoResponse myinfo = await AccountAPI.getInfo();

    // model = MyInfoModel(
    //   name: myinfo.username!,
    //   id: myinfo.userid!,
    //   phone: myinfo.phone!,
    //   friends: myinfo.friends!,
    //   profile: myinfo.profile!,
    // );

    setBusy(false);
  }
}
