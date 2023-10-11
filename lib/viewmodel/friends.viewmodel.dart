import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:cookie_app/repository/info.repo.dart';
import 'package:cookie_app/view/components/snackbar.dart';
import 'package:cookie_app/view/navigation_service.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';
import 'package:cookie_app/viewmodel/base.viewmodel.dart';

class FriendsViewModel extends BaseViewModel {
  final InfoRepository _repo = InfoRepositoryImpl();

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
      await context.read<FriendsViewModel>()._updateFriends();
      if (context.mounted) {
        showSnackBar(context: context, message: '친구 목록을 업데이트했습니다.');
      }
    } catch (e) {
      if (context.mounted) showErrorSnackBar(context, e.toString());
    }
  }

  Future<void> _updateFriends() async {
    setLoadState(busy: true, loaded: false);

    try {
      _friendMap = Map.fromEntries(
        (await _repo.getInfo())
            .friendList
            .map((e) => PublicAccountViewModel(model: e))
            .toList()
            .map((e) => MapEntry(e.id, e)),
      );

      setLoadState(busy: false, loaded: true);
    } catch (e) {
      setLoadState(busy: false, loaded: false);
      rethrow;
    }
  }
}
