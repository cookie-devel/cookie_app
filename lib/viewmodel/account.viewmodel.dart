import 'package:flutter/material.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:cookie_app/model/account/account.dart';
import 'package:cookie_app/types/account/profile.dart';
import 'package:cookie_app/view/components/icon_imageprovider.dart';

class ProfileViewModel extends ChangeNotifier {
  final Profile _model;

  ProfileViewModel({required Profile model}) : _model = model;

  ImageProvider get image => _model.image != null
      ? NetworkImage(imageURL!)
      : IconImageProvider(
          Icons.person,
          size: 800,
          color: Colors.grey,
        ) as ImageProvider;
  String? get imageURL => '${dotenv.env['BASE_URI']}/${_model.image}';
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

  // Type for flutter_chat_types
  User get toFlyer => User(
        id: _model.id,
        firstName: _model.name,
        imageUrl: profile.imageURL,
      );
}
