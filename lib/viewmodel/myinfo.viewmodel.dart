import 'package:cookie_app/repository/myinfo.repo.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';

class MyInfoViewModel extends PrivateAccountViewModel {
  final MyInfoRepository _storageRepo = MyInfoRepositoryStorageImpl();
  final MyInfoRepository _apiRepo = MyInfoRepositoryApiImpl();

  MyInfoViewModel();

  Future<void> updateMyInfo() async {
    setBusy(true);

    // super.model = await _storageRepo.getInfo();
    super.model = await _apiRepo.getInfo();

    setBusy(false);
  }
}
