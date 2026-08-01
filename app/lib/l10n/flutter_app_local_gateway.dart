// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:convert';

import 'package:sharezone/logging/logging.dart';
import 'package:sharezone/util/cache/streaming_key_value_store.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

class FlutterAppLocaleProviderGateway extends AppLocaleProviderGateway {
  FlutterAppLocaleProviderGateway({required this.keyValueStore});

  final StreamingKeyValueStore keyValueStore;
  final _logger = szLogger.makeChild('AppLocaleProviderGateway');

  @override
  Stream<AppLocale> getLocale() {
    final defaultValue = jsonEncode(AppLocale.system.toMap());
    return keyValueStore
        .getString('locale', defaultValue: defaultValue)
        .map(_deserializeLocale);
  }

  @override
  Future<void> setLocale(AppLocale locale) async {
    final value = jsonEncode(locale.toMap());
    try {
      final didPersist = await keyValueStore.setString('locale', value);
      if (!didPersist) {
        throw StateError('The locale preference could not be persisted.');
      }
    } catch (error, stackTrace) {
      _logger.severe(
        'Could not persist the locale preference.',
        error,
        stackTrace,
      );
      rethrow;
    }
  }
}

AppLocale _deserializeLocale(String value) {
  try {
    return AppLocale.fromJson(jsonDecode(value));
  } on FormatException {
    // Older versions may have persisted a plain language tag instead of JSON.
    return AppLocale.fromLanguageTag(value);
  }
}
