import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:cookie_app/datasource/api/account.dart';
import 'package:cookie_app/model/account/account.dart';
import 'package:cookie_app/service/auth.service.dart';
import 'package:cookie_app/utils/logger.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';

class AccountService extends ChangeNotifier with DiagnosticableTreeMixin {
  AuthService authService;
  late RestClient _api;
  ConnectionState _connectionState = ConnectionState.none;
  ConnectionState get connectionState => _connectionState;

  AccountService(this.authService) {
    _api = RestClient(this.authService.dio, baseUrl: dotenv.env['BASE_URI']!);
    _api.getInfo().then((InfoResponse info) {
      this._my = AccountViewModel(model: info.toAccount());
      this._friends = Map.fromEntries(
        info.friendList!
            .map((e) => AccountViewModel(model: e))
            .toList()
            .map((e) => MapEntry(e.id, e)),
      );
    });
  }

  // My Account
  late AccountViewModel _my;
  AccountViewModel get my => _my;

  // Friends
  Map<String, AccountViewModel> _friends = {};
  Map<String, AccountViewModel> get friends => _friends;
  AccountViewModel getFriendById(String id) {
    if (!_friends.containsKey(id)) {
      throw Exception('Friend not found');
    }
    return _friends[id]!;
  }

  Future<void> update() async {
    try {
      _connectionState = ConnectionState.waiting;
      notifyListeners();

      InfoResponse info = await _api.getInfo();

      this._my = AccountViewModel(
        model: AccountModel(
          id: info.id!,
          name: info.name!,
          phone: info.phone!,
          profile: info.profile!,
        ),
      );
      this._friends = Map.fromEntries(
        info.friendList!
            .map((e) => AccountViewModel(model: e))
            .toList()
            .map((e) => MapEntry(e.id, e)),
      );
    } on DioException catch (e) {
      logger.e(e);
      e.response == null
          ? throw Exception('서버와 연결할 수 없습니다.')
          : throw Exception(e.response!.statusMessage!);
    } catch (e) {
      logger.e(e);
      rethrow;
    } finally {
      _connectionState = ConnectionState.done;
      notifyListeners();
    }
  }
}
