import 'package:cookie_app/datasource/api/account.dart';
import 'package:cookie_app/datasource/storage/account.storage.dart';
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
    final repository = await AccountStorage().isExist()
        ? MyInfoRepositoryStorageImpl()
        : MyInfoRepositoryApiImpl();
    return repository.getInfo();
  }
}
