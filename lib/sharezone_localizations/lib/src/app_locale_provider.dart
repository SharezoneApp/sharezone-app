import 'package:flutter/material.dart';
import 'app_locales.dart';

/// Allows to change the locale of the app using the provider package.
class AppLocaleProvider with ChangeNotifier {
  AppLocaleProvider({
    AppLocales initialLocale = AppLocales.system,
  }) : _locale = initialLocale;

  AppLocales _locale;

  AppLocales get locale => _locale;

  set locale(AppLocales newLocale) {
    if (_locale != newLocale) {
      _locale = newLocale;
      notifyListeners();
    }
  }
}

/// Abstraction for the locale provider.
/// This can be implemented using shared preferences or a remote service like Firestore.
/// The [AppLocaleProvider] listens to changes in the locale and updates the UI accordingly.
abstract class AppLocaleProviderGateway {
  Stream<AppLocales> getLocale();

  Future<void> setLocale(AppLocales locale);
}

/// A mock implementation of the [AppLocaleProviderGateway].
class MockAppLocaleProviderGateway implements AppLocaleProviderGateway {
  MockAppLocaleProviderGateway({
    AppLocales initialLocale = AppLocales.system,
  }) : _locale = initialLocale;

  AppLocales _locale;

  @override
  Stream<AppLocales> getLocale() {
    return Stream.value(_locale);
  }

  @override
  Future<void> setLocale(AppLocales locale) async {
    _locale = locale;
  }
}
