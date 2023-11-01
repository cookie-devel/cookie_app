import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:cookie_app/service/account.service.dart';
import 'package:cookie_app/utils/navigation_service.dart';
import 'package:cookie_app/view/components/snackbar.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';

class FriendsViewModel extends ChangeNotifier with DiagnosticableTreeMixin {
  ConnectionState _connectionState = ConnectionState.none;
  ConnectionState get connectionState => _connectionState;

  Map<String, PublicAccountViewModel> _friendMap = {};
  List<PublicAccountViewModel> get friendList => _friendMap.values.toList();
  Map<String, PublicAccountViewModel> get friendMap => _friendMap;

  PublicAccountViewModel getFriend(String id) {
    if (!_friendMap.containsKey(id)) {
      throw Exception('Friend not found');
    }

    return _friendMap[id]!;
  }

  BuildContext context = NavigationService.navigatorKey.currentContext!;

  Future<void> updateFriends() async {
    try {
      await _updateFriends();
      if (context.mounted) showSnackBar(context, '친구 목록을 업데이트했습니다.');
    } catch (e) {
      if (context.mounted) showErrorSnackBar(context, e.toString());
      rethrow;
    }
  }

  Future<void> _updateFriends() async {
    try {
      _connectionState = ConnectionState.waiting;
      _friendMap = Map.fromEntries(
        (await context.read<AccountService>().getInfo())
            .friendList!
            .map((e) => PublicAccountViewModel(model: e))
            .toList()
            .map((e) => MapEntry(e.id, e)),
      );
    } catch (e) {
      rethrow;
    } finally {
      _connectionState = ConnectionState.done;
      notifyListeners();
    }
  }
}
