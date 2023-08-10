import 'package:cookie_app/repository/myinfo.repo.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';
import 'package:cookie_app/viewmodel/base.viewmodel.dart';

class FriendsListViewModel extends BaseViewModel {
  final MyInfoRepository _repo = MyInfoRepositoryImpl();

  List<PublicAccountViewModel> _friends = [];
  List<PublicAccountViewModel> get friends => _friends;

  Future<void> updateFriends() async {
    setBusy(true);

    _friends = (await _repo.getInfo())
        .friendList
        .map((e) => PublicAccountViewModel(model: e))
        .toList();

    setBusy(false);
  }
}
