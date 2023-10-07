import 'package:flutter/material.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:cookie_app/model/account/account_info.dart';
import 'package:cookie_app/repository/info.repo.dart';
import 'package:cookie_app/types/account/profile.dart';
import 'package:cookie_app/view/components/icon_imageprovider.dart';
import 'package:cookie_app/viewmodel/base.viewmodel.dart';

class ProfileViewModel extends BaseViewModel {
  final Profile _model;

  ProfileViewModel({required Profile model}) : _model = model;

  ImageProvider get image => _model.image != null
      ? NetworkImage(
          Uri(
            scheme: dotenv.env['API_SCHEME'],
            host: dotenv.env['API_HOST'],
            port: int.parse(dotenv.env['API_PORT']!),
            path: _model.image!,
          ).toString(),
        )
      : IconImageProvider(
          Icons.person,
          size: 800,
          color: Colors.grey,
        ) as ImageProvider;
  String? get imageURL => _model.image;
  String? get message => _model.message;
}

abstract class AccountViewModel<T extends PublicAccountModel>
    extends BaseViewModel {
  late T _model;

  String get id => _model.id;
  String get name => _model.name;
  ProfileViewModel get profile => ProfileViewModel(model: _model.profile);

  // Type for flutter_chat_types
  types.User get chatUser => types.User(
        id: _model.id,
        firstName: _model.name,
        imageUrl: _model.profile.image,
      );
}

class PublicAccountViewModel extends AccountViewModel<PublicAccountModel> {
  PublicAccountViewModel({required model}) {
    _model = model;
  }
}

class PrivateAccountViewModel extends AccountViewModel<PrivateAccountModel> {
  String get phone => _model.phone;

  final InfoRepository _repo = InfoRepositoryStorageImpl();

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
