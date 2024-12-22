import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

/// Allows to change the locale of the app using the provider package.
class AppLocaleProvider with ChangeNotifier {
  AppLocaleProvider({
    AppLocales initialLocale = AppLocales.system,
    required this.gateway,
  }) : _locale = initialLocale {
    _subscription = gateway.getLocale().listen((event) {
      _locale = event;
      notifyListeners();
    });
  }

  AppLocaleProviderGateway gateway;
  late StreamSubscription<AppLocales> _subscription;
  AppLocales _locale;

  AppLocales get locale => _locale;

  set locale(AppLocales newLocale) {
    if (_locale != newLocale) {
      _locale = newLocale;
      gateway.setLocale(newLocale);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
