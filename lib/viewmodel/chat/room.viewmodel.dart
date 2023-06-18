import 'package:cookie_app/model/chat/room.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';
import 'package:cookie_app/viewmodel/base.viewmodel.dart';
import 'package:cookie_app/viewmodel/chat/message.viewmodel.dart';

class RoomViewModel extends BaseViewModel {
  late RoomModel _model;
  RoomViewModel() : super();

  String get id => _model.id;
  String get name => _model.name;
  List<PublicAccountViewModel> get users => _model.users
      .map((e) => PublicAccountViewModel(model: e))
      .toList(growable: false);
  List<MessageViewModel> get messages => _model.messages
      .map((e) => MessageViewModel(model: e))
      .toList(growable: false);
}
