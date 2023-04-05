import 'package:flutter/material.dart';
import 'package:key_value_store/key_value_store.dart';

class SubscriptionEnabledFlag extends ChangeNotifier {
  SubscriptionEnabledFlag(this.keyValueStore) {
    _isEnabled = keyValueStore.tryGetBool(cacheKey) ?? false;
  }
  final KeyValueStore keyValueStore;

  bool _isEnabled = false;
  bool get isEnabled => _isEnabled;

  static const cacheKey = 'is_sharezone_plus_prototype_enabled';

  void toggle() {
    _isEnabled = !_isEnabled;
    keyValueStore.setBool(cacheKey, _isEnabled);
    notifyListeners();
  }
}
