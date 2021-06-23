import 'package:bloc_base/bloc_base.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/util/cache/streaming_key_value_store.dart';
import 'package:sharezone_common/helper_functions.dart';

import 'navigation_experiment_option.dart';

class NavigationExperimentCache extends BlocBase {
  static const key = 'navigation-experiment-option-key';

  final StreamingKeyValueStore _cache;

  final _currentNavigationSubject =
      BehaviorSubject<NavigationExperimentOption>();

  ValueStream<NavigationExperimentOption> get currentNavigation =>
      _currentNavigationSubject;

  NavigationExperimentCache(this._cache) {
    _cache
        .getString(key,
            defaultValue: enumToString(NavigationExperimentOption.drawerAndBnb))
        .map(_toEnum)
        .listen(_currentNavigationSubject.sink.add);
  }

  NavigationExperimentOption _toEnum(String stringValue) {
    return enumFromString<NavigationExperimentOption>(
      NavigationExperimentOption.values,
      stringValue,
    );
  }

  void setNavigation(NavigationExperimentOption option) {
    _cache.setString(key, enumToString(option));
  }

  @override
  void dispose() {
    _currentNavigationSubject.close();
  }
}
