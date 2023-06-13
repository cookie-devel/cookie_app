import 'package:cookie_app/model/account/account_info.dart';
import 'package:cookie_app/types/account/profile.dart';
import 'package:cookie_app/viewmodel/base.viewmodel.dart';
import 'package:flutter/material.dart';

class PublicAccountViewModel extends BaseViewModel {
  late PublicAccountModel _model;

  String get id => _model.id;
  String get name => _model.name;
  ImageProvider get profileImage => _model.profile.imageURL != null
      ? NetworkImage(_model.profile.imageURL!)
      : const AssetImage('assets/images/default_profile.png') as ImageProvider;
  String? get profileMessage => _model.profile.message!;

  PublicAccountViewModel({
    PublicAccountModel? model,
  }) {
    _model = model ??
        PublicAccountModel(
          id: '',
          name: '',
          profile: Profile(
            imageURL: '',
            message: '',
          ),
        );
  }
}

class PrivateAccountViewModel extends BaseViewModel {
  @protected
  late PrivateAccountModel model;

  String get id => model.id;
  String get name => model.name;
  ImageProvider get profileImage => model.profile.imageURL != null
      ? NetworkImage(model.profile.imageURL!)
      : const AssetImage('assets/images/default_profile.png') as ImageProvider;
  String? get profileMessage => model.profile.message;
  String get phone => model.phone;

  PublicAccountViewModel getFriend(int index) {
    return PublicAccountViewModel(model: model.friends[index]);
  }

  List<PublicAccountViewModel> get friends {
    return model.friends
        .map((e) => PublicAccountViewModel(model: e))
        .toList(growable: false);
  }
}
