// 친구 정보 class
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class User {
  final String? _id;
  final String? _name;
  final ImageProvider? _profileImage;
  final String? _profileMessage;

  User({
    String? id,
    String? name = "Unknown User",
    ImageProvider<Object>? profileImage =
        const AssetImage('assets/images/cookie_logo.png'),
    String? profileMessage,
  })  : _profileMessage = profileMessage,
        _profileImage = profileImage,
        _name = name,
        _id = id;

  get id => _id ?? "";
  get name => _name ?? "Unknown User";
  get profileImage =>
      _profileImage ?? const AssetImage('assets/images/cookie_logo.png');
  get profileMessage => _profileMessage;

  User.fromMap(Map<String, dynamic> data)
      : _id = data['userid'],
        _name = data['username'],
        _profileImage = data['profile']['image'] != null
            ? NetworkImage(
                '${dotenv.env['BASE_URI']}/${data['profile']['image']}',
              )
            : const AssetImage('assets/images/cookie_logo.png')
                as ImageProvider,
        _profileMessage = data['profile']['message'];
}
