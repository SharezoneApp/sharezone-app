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
