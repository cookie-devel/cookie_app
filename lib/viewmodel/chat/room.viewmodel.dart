import 'package:flutter/material.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:provider/provider.dart';

import 'package:cookie_app/model/chat/room.dart';
import 'package:cookie_app/utils/navigation_service.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';
import 'package:cookie_app/viewmodel/base.viewmodel.dart';
import 'package:cookie_app/viewmodel/chat/message.viewmodel.dart';
import 'package:cookie_app/viewmodel/friends.viewmodel.dart';

class ChatRoomViewModel extends BaseChangeNotifier {
  final ChatRoomModel _model;

  ChatRoomViewModel({required ChatRoomModel model}) : _model = model;

  BuildContext context = NavigationService.navigatorKey.currentContext!;

  types.Room get chatRoom => types.Room(
        type: types.RoomType.group,
        id: _model.id,
        imageUrl: _model.image,
        name: _model.name,
        users: _model.members
            // .map((e) => PublicAccountViewModel(model: e).chatUser)
            .map(
              (id) => id != context.read<PrivateAccountViewModel>().id
                  ? context.read<FriendsViewModel>().friendMap[id]!.chatUser
                  : context.read<PrivateAccountViewModel>().chatUser,
            )
            .toList(growable: false),
      );

  String get id => _model.id;
  DateTime get createdAt => _model.createdAt;
  String get name => _model.name;
  ImageProvider get image => _model.image != null
      ? NetworkImage(_model.image!)
      : const AssetImage('assets/images/kz1.png') as ImageProvider;
  List<PublicAccountViewModel> get members => _model.members
      .map(
        (id) => id != context.read<PrivateAccountViewModel>().id
            ? context.read<FriendsViewModel>().friendMap[id]!
            : context.read<PrivateAccountViewModel>() as PublicAccountViewModel,
      )
      .toList(growable: false);
  List<types.User> get chatUsers => _model.members
      .map(
        (id) => id != context.read<PrivateAccountViewModel>().id
            ? context.read<FriendsViewModel>().friendMap[id]!.chatUser
            : context.read<PrivateAccountViewModel>().chatUser,
      )
      .toList(growable: false);
  List<MessageViewModel> get messages => _model.messages
      .map((e) => MessageViewModel(model: e))
      .toList(growable: false);
}
