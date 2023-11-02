import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:cookie_app/datasource/api/account.dart';
import 'package:cookie_app/utils/logger.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';

class AccountService extends ChangeNotifier with DiagnosticableTreeMixin {
  ConnectionState _connectionState = ConnectionState.none;
  ConnectionState get connectionState => _connectionState;

  final Dio _dio = Dio();
  late RestClient _api;

  // AccountViewModel my;
  Map<String, AccountViewModel> _friends = {};
  Map<String, AccountViewModel> get friends => _friends;
  AccountViewModel getFriend(String id) {
    if (!_friends.containsKey(id)) {
      throw Exception('Friend not found');
    }
    return _friends[id]!;
  }

  AccountService(String token) {
    _dio.options.baseUrl = dotenv.env['BASE_URI']!;
    logger.t('token: $token');
    _dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Authorization'] = 'Bearer $token';
          return handler.next(options);
        },
      ),
      InterceptorsWrapper(
        onError: (e, handler) {
          logger.e('Error: $e');
          logger.t('Body: ${e.response?.data}');
          return handler.next(e);
        },
      ),
    ]);
    _api = RestClient(_dio);
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
    } catch (e) {
      rethrow;
    } finally {
      _connectionState = ConnectionState.done;
      notifyListeners();
    }
  }
}
