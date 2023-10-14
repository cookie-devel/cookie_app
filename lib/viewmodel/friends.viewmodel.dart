import 'package:flutter/material.dart';

import 'package:cookie_app/repository/info.repo.dart';
import 'package:cookie_app/utils/navigation_service.dart';
import 'package:cookie_app/view/components/snackbar.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';

class FriendsViewModel extends ChangeNotifier {
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

  Future<Map<String, PublicAccountViewModel>> updateFriends() async {
    try {
      _friendMap = Map.fromEntries(
        (await _repo.getInfo())
            .friendList
            .map((e) => PublicAccountViewModel(model: e))
            .toList()
            .map((e) => MapEntry(e.id, e)),
      );
      if (context.mounted) showSnackBar(context, '친구 목록을 업데이트했습니다.');
      return _friendMap;
    } catch (e) {
      if (context.mounted) showErrorSnackBar(context, e.toString());
      rethrow;
    }
  }
}
