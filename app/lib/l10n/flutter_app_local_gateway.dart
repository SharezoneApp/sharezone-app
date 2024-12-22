import 'dart:convert';

import 'package:sharezone/util/cache/streaming_key_value_store.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

class FlutterAppLocaleProviderGateway extends AppLocaleProviderGateway {
  FlutterAppLocaleProviderGateway({required this.keyValueStore});

  final StreamingKeyValueStore keyValueStore;

  @override
  Stream<AppLocales> getLocale() {
    final defaultValue = jsonEncode(AppLocales.system.toMap());
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
