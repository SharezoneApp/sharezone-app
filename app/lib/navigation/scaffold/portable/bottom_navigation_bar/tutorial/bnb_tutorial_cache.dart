import 'package:key_value_store/key_value_store.dart';

class BnbTutorialCache {
  final KeyValueStore _cache;

  static const _tutorialKey = 'bnb-tutorial-key';

  BnbTutorialCache(this._cache);

  bool wasTutorialCompleted() =>
      _cache.containsKey(_tutorialKey) && _cache.getBool(_tutorialKey);

  void setTutorialAsCompleted() => _cache.setBool(_tutorialKey, true);
}
