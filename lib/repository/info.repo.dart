import 'package:dio/dio.dart';

import 'package:cookie_app/datasource/api/account.dart';
import 'package:cookie_app/datasource/storage/account.storage.dart';
import 'package:cookie_app/model/account/account_info.dart';

abstract class InfoRepository {
  Future<PrivateAccountModel> getInfo();
}

class InfoRepositoryStorageImpl implements InfoRepository {
  @override
  Future<PrivateAccountModel> getInfo() async {
    return PrivateAccountModel.fromJson(await AccountStorage().readJSON());
  }
}

class InfoRepositoryApiImpl implements InfoRepository {
  @override
  Future<PrivateAccountModel> getInfo() async {
    // return (await NavigationService.context
    //         ?.read<ApiClient>()
    //         .client
    //         .getInfo())!
    //     .toPrivateAccount();
    // return (await AccountAPI.getInfo()).toPrivateAccount();
    return (await RestClient(Dio()).getInfo()).toPrivateAccount();
  }
}

class InfoRepositoryImpl implements InfoRepository {
  @override
  Future<PrivateAccountModel> getInfo() async {
    final repository = await AccountStorage().exists()
        ? InfoRepositoryStorageImpl()
        : InfoRepositoryApiImpl();
    return repository.getInfo();
  }
}
