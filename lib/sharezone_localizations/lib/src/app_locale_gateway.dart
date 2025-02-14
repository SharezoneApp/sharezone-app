// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:sharezone_localizations/sharezone_localizations.dart';

/// Gateway to store and retrieve the locale of the app.
///
/// This can be implemented using shared preferences or a remote service like
/// Firestore. The [AppLocaleProvider] listens to changes in the locale and
/// updates the UI accordingly.
abstract class AppLocaleProviderGateway {
  const AppLocaleProviderGateway();

  Stream<AppLocale> getLocale();

  Future<void> setLocale(AppLocale locale);
}

/// A mock implementation of the [AppLocaleProviderGateway].
class MockAppLocaleProviderGateway implements AppLocaleProviderGateway {
  MockAppLocaleProviderGateway({AppLocale initialLocale = AppLocale.system})
    : _locale = initialLocale;

  AppLocale _locale;

  @override
  Stream<AppLocale> getLocale() {
    return Stream.value(_locale);
  }

  @override
  Future<void> setLocale(AppLocale locale) async {
    _locale = locale;
  }
}
