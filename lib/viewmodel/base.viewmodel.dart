import 'package:flutter/material.dart';

abstract class BaseChangeNotifier extends ChangeNotifier {
  ConnectionState connectionState = ConnectionState.none;

  void setConnectionState(ConnectionState connectionState) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      this.connectionState = connectionState;
      notifyListeners();
    });
  }
}
