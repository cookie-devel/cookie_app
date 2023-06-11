import 'package:cookie_app/repository/api/account.dart';
import 'package:cookie_app/repository/storage/account.storage.dart';
import 'package:cookie_app/types/account/account_info.dart';

abstract class MyInfoRepository {
  Future<PrivateAccount> getInfo();
}

class MyInfoRepositoryStorageImpl implements MyInfoRepository {
  @override
  Future<PrivateAccount> getInfo() async {
    return PrivateAccount.fromJson(await AccountStorage().readJSON());
  }
}

class MyInfoRepositoryApiImpl implements MyInfoRepository {
  @override
  Future<PrivateAccount> getInfo() async {
    return (await AccountAPI.getInfo()).toPrivateAccount();
  }
}
