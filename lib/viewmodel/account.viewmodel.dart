import 'package:flutter/material.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:cookie_app/model/account/account.dart';
import 'package:cookie_app/model/chat/room.dart';
import 'package:cookie_app/types/account/profile.dart';
import 'package:cookie_app/view/components/icon_imageprovider.dart';

class ProfileViewModel extends ChangeNotifier {
  final Profile _model;

  ProfileViewModel({required Profile model}) : _model = model;

  ImageProvider get image => _model.image != null
      ? NetworkImage('${dotenv.env['BASE_URI']}/${_model.image!}')
      : IconImageProvider(
          Icons.person,
          size: 800,
          color: Colors.grey,
        ) as ImageProvider;
  String? get imageURL => _model.image;
  String? get message => _model.message;
}

class AccountViewModel extends ChangeNotifier {
  final AccountModel _model;

  AccountViewModel({required AccountModel model}) : _model = model;

  String get id => _model.id;
  String get name => _model.name;
  ProfileViewModel get profile => ProfileViewModel(model: _model.profile);

  // Optional Fields
  String? get phone => _model.phone;

  // Optional Fields for Current User
  List<AccountModel>? get friendList => _model.friendList;
  List<ChatRoomModel>? get chatRooms => _model.chatRooms;

  // Type for flutter_chat_types
  types.User get chatUser => types.User(
        id: _model.id,
        firstName: _model.name,
        imageUrl: _model.profile.image,
      );
}
