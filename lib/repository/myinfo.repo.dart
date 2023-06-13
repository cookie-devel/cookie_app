import 'package:cookie_app/repository/api/account.dart';
import 'package:cookie_app/repository/storage/account.storage.dart';
import 'package:cookie_app/model/account/account_info.dart';

// class MyInfoRepository {
//   final MyInfoRepositoryPattern _repositoryStorage =
//       MyInfoRepositoryStorageImpl();
//   final MyInfoRepositoryPattern _repositoryAPI = MyInfoRepositoryApiImpl();

//   MyInfoRepository();

//   Future<PrivateAccountModel> getInfo() async {
//     final _repository =
//         await AccountStorage().isExist() ? _repositoryStorage : _repositoryAPI;
//     return _repository.getInfo();
//   }
// }

abstract class MyInfoRepository {
  Future<PrivateAccountModel> getInfo();
}

class MyInfoRepositoryStorageImpl implements MyInfoRepository {
  @override
  Future<PrivateAccountModel> getInfo() async {
    return PrivateAccountModel.fromJson(await AccountStorage().readJSON());
  }
}

class MyInfoRepositoryApiImpl implements MyInfoRepository {
  @override
  Future<PrivateAccountModel> getInfo() async {
    return (await AccountAPI.getInfo()).toPrivateAccount();
  }
}
