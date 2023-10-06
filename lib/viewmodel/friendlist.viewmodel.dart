import 'package:cookie_app/repository/info.repo.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';
import 'package:cookie_app/viewmodel/base.viewmodel.dart';

class FriendsListViewModel extends BaseViewModel {
  final InfoRepository _repo = InfoRepositoryImpl();

  List<PublicAccountViewModel> _friends = [];
  List<PublicAccountViewModel> get friends => _friends;

  Future<void> updateFriends() async {
    setLoadState(busy: true, loaded: false);

    try {
      _friends = (await _repo.getInfo())
          .friendList
          .map((e) => PublicAccountViewModel(model: e))
          .toList();

      setLoadState(busy: false, loaded: true);
    } catch (e) {
      setLoadState(busy: false, loaded: false);
      rethrow;
    }
  }
}
