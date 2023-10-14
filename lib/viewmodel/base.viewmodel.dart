import 'package:flutter/material.dart';

abstract class BaseViewModel extends ChangeNotifier {
  bool loaded = false;
  bool busy = false;

  void setLoadState({
    bool? loaded,
    bool? busy,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (loaded != null) this.loaded = loaded;
      if (busy != null) this.busy = busy;
      notifyListeners();
    });
  }
}
