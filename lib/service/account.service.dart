import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:cookie_app/datasource/api/account.dart';
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
  }

  // AccountViewModel my;

  // Friends
  Map<String, AccountViewModel> _friends = {};
  Map<String, AccountViewModel> get friends => _friends;
  AccountViewModel getFriendById(String id) {
    if (!_friends.containsKey(id)) {
      throw Exception('Friend not found');
    }
    return _friends[id]!;
  }

  Future<void> updateFriends() async {
    try {
      _connectionState = ConnectionState.waiting;
      notifyListeners();

      _friends = Map.fromEntries(
        (await _api.getInfo())
            .friendList!
            .map((e) => AccountViewModel(model: e))
            .toList()
            .map((e) => MapEntry(e.id, e)),
      );
    } on DioException catch (e) {
      logger.e(e);
      e.response == null
          ? throw Exception('친구 목록 업데이트 중 에러: 서버와 연결할 수 없습니다.')
          : throw Exception('친구 목록 업데이트 중 에러: ${e.response!.statusMessage!}');
    } catch (e) {
      logger.e(e);
      rethrow;
    } finally {
      _connectionState = ConnectionState.done;
      notifyListeners();
    }
  }
}
