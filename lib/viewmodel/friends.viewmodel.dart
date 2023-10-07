import 'package:cookie_app/repository/info.repo.dart';
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

  Future<void> updateFriends() async {
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
