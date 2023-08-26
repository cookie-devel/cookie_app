import 'package:cookie_app/datasource/storage/storage.dart';

class AccountStorage extends BaseStorage {
  AccountStorage() : super('account.json');

  static AccountStorage? _instance;
  static AccountStorage get instance {
    _instance ??= AccountStorage();
    return _instance!;
  }
}
