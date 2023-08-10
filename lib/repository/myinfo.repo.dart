import 'package:cookie_app/repository/api/account.dart';
import 'package:cookie_app/repository/storage/account.storage.dart';
import 'package:cookie_app/model/account/account_info.dart';

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

class MyInfoRepositoryImpl implements MyInfoRepository {
  @override
  Future<PrivateAccountModel> getInfo() async {
    final _repository = await AccountStorage().isExist()
        ? MyInfoRepositoryStorageImpl()
        : MyInfoRepositoryApiImpl();
    return _repository.getInfo();
  }
}
