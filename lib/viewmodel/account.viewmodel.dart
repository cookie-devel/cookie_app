import 'package:cookie_app/model/account/account_info.dart';
import 'package:cookie_app/repository/myinfo.repo.dart';
import 'package:cookie_app/view/components/icon_imageprovider.dart';
import 'package:cookie_app/viewmodel/base.viewmodel.dart';
import 'package:cookie_app/viewmodel/chat/room.viewmodel.dart';
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
  // : IconImageProvider(Icons.abc) as ImageProvider;
  String? get profileMessage => _model.profile.message;
  String get phone => _model.phone;
  List<ChatRoomViewModel> get chatRooms => _model.chatRooms
      .map((e) => ChatRoomViewModel(model: e))
      .toList(growable: false);

  PublicAccountViewModel getFriend(int index) {
    return PublicAccountViewModel(model: _model.friends[index]);
  }

  List<PublicAccountViewModel> get friends {
    return _model.friends
        .map((e) => PublicAccountViewModel(model: e))
        .toList(growable: false);
  }

  final MyInfoRepository _storageRepo = MyInfoRepositoryStorageImpl();
  final MyInfoRepository _apiRepo = MyInfoRepositoryApiImpl();

  Future<void> updateMyInfo({PrivateAccountModel? model}) async {
    setBusy(true);
    if (model != null) {
      _model = model;
    } else {
      // _model = await _storageRepo.getInfo();
      _model = await _apiRepo.getInfo();
    }

    setBusy(false);
  }
}
