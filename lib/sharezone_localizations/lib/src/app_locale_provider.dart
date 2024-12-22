import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

/// Allows to change the locale of the app using the provider package.
class AppLocaleProvider with ChangeNotifier {
  AppLocaleProvider({
    AppLocales initialLocale = AppLocales.system,
    required AppLocaleProviderGateway gateway,
  }) : _locale = initialLocale {
    _subscription = gateway.getLocale().listen((event) {
      locale = event;
      notifyListeners();
    });
  }

  late StreamSubscription<AppLocales> _subscription;
  AppLocales _locale;

  AppLocales get locale => _locale;

  set locale(AppLocales newLocale) {
    if (_locale != newLocale) {
      _locale = newLocale;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
