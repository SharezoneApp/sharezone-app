// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

/// Allows to change the locale of the app using the provider package.
class AppLocaleProvider with ChangeNotifier {
  AppLocaleProvider({
    AppLocale initialLocale = AppLocale.system,
    required this.gateway,
  }) : _locale = initialLocale {
    _subscription = gateway.getLocale().listen((event) {
      _locale = event;
      notifyListeners();
    });
  }

  AppLocaleProviderGateway gateway;
  late StreamSubscription<AppLocale> _subscription;
  AppLocale _locale;

  AppLocale get locale => _locale;

  Future<void> setLocale(AppLocale newLocale) async {
    if (_locale == newLocale) return;

    await gateway.setLocale(newLocale);
    // A streaming gateway will normally have emitted the new value while the
    // write was in progress. The assignment also supports one-shot gateways.
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
