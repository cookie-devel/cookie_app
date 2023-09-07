import 'package:cookie_app/model/account/account_info.dart';
import 'package:cookie_app/repository/myinfo.repo.dart';
import 'package:cookie_app/view/components/icon_imageprovider.dart';
import 'package:cookie_app/viewmodel/base.viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PublicAccountViewModel extends BaseViewModel {
  late PublicAccountModel _model;

  String get id => _model.userid;
  String get name => _model.username;
  ImageProvider get profileImage => _model.profile.image != null
      ? NetworkImage(
          Uri(
            scheme: dotenv.env['API_SCHEME'],
            host: dotenv.env['API_HOST'],
            port: int.parse(dotenv.env['API_PORT']!),
            path: _model.profile.image!,
          ).toString(),
        )
      : IconImageProvider(
          Icons.person,
          size: 800,
          color: Colors.grey,
        ) as ImageProvider;

  String? get profileMessage => _model.profile.message;

  PublicAccountViewModel({
    required PublicAccountModel model,
  }) : super() {
    _model = model;
  }
}

class PrivateAccountViewModel extends BaseViewModel {
  @protected
  late PrivateAccountModel _model;

  String get id => _model.userid;
  String get name => _model.username;
  ImageProvider get profileImage => _model.profile.image != null
      ? NetworkImage(_model.profile.image!)
      : const AssetImage('assets/images/user.jpg') as ImageProvider;
  String? get profileMessage => _model.profile.message;
  String get phone => _model.phone;

  final MyInfoRepository _repo = MyInfoRepositoryStorageImpl();

  Future<void> updateMyInfo({PrivateAccountModel? model}) async {
    setLoadState(busy: true, loaded: false);
    try {
      _model = model ?? await _repo.getInfo();
      setLoadState(busy: false, loaded: true);
    } catch (e) {
      setLoadState(busy: false, loaded: false);
    }
  }
}
