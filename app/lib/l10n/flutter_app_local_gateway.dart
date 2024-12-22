import 'dart:convert';

import 'package:sharezone/l10n/feature_flag_l10n.dart';
import 'package:sharezone/util/cache/streaming_key_value_store.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

class FlutterAppLocaleProviderGateway extends AppLocaleProviderGateway {
  FlutterAppLocaleProviderGateway({
    required this.keyValueStore,
    required this.featureFlagl10n,
  });

  final FeatureFlagl10n featureFlagl10n;
  final StreamingKeyValueStore keyValueStore;

  @override
  Stream<AppLocales> getLocale() {
    final defaultValue = jsonEncode(featureFlagl10n.isl10nEnabled
        ? AppLocales.system.toMap()
        : AppLocales.en.toMap());
    return keyValueStore
        .getString('locale', defaultValue: defaultValue)
        .map((event) => AppLocales.fromMap(jsonDecode(event)));
  }

  @override
  Future<void> setLocale(AppLocales locale) async {
    final value = jsonEncode(locale.toMap());
    keyValueStore.setString(
      'locale',
      value,
    );
  }
}
