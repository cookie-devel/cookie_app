import 'package:flutter/material.dart';

import 'package:cookie_app/repository/info.repo.dart';
import 'package:cookie_app/utils/navigation_service.dart';
import 'package:cookie_app/view/components/snackbar.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';

class FriendsViewModel extends ChangeNotifier {
  final InfoRepository _repo = InfoRepositoryImpl();

  Future<Map<String, PublicAccountViewModel>> _friendMap;
  Future<List<PublicAccountViewModel>> get friendList async =>
      (await _friendMap).values.toList();
  Future<Map<String, PublicAccountViewModel>> get friendMap => _friendMap;

  FriendsViewModel()
      : _friendMap = InfoRepositoryApiImpl()
            .getInfo()
            .then(
              (value) => value.friendList
                  .map((e) => PublicAccountViewModel(model: e))
                  .map((e) => MapEntry(e.id, e)),
            )
            .then((fmap) => Map.fromEntries(fmap));

  Future<PublicAccountViewModel> getFriend(String id) async {
    Map<String, PublicAccountViewModel> friendMap = await _friendMap;

    if (!friendMap.containsKey(id)) {
      throw Exception('Friend not found');
    }

    return friendMap[id]!;
  }

  BuildContext context = NavigationService.navigatorKey.currentContext!;

  Future<Map<String, PublicAccountViewModel>> updateFriends() async {
    return _friendMap = _repo
        .getInfo()
        .onError((error, stackTrace) {
          showErrorSnackBar(context, error.toString());
          throw error!;
          // return Future.error(error!);
        })
        .then(
          (value) => value.friendList
              .map((e) => PublicAccountViewModel(model: e))
              .map((e) => MapEntry(e.id, e)),
        )
        .then((fmap) {
          showSnackBar(context, '친구 목록을 업데이트했습니다.');
          return Map.fromEntries(fmap);
        });
    // .then(() => showSnackBar(context, '친구 목록을 업데이트했습니다.'))
    // .then(() => notifyListeners());
  }
}
