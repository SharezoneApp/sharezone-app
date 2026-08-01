// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

/// A wrapper around [Locale] to provide differentiation between the system
/// locale and the user selected locale.
enum AppLocale {
  system,
  en,
  de;

  /// Converts the enum value to a [Locale] object.
  Locale toLocale() {
    return switch (this) {
      system => getSystemLocale(),
      en => const Locale('en'),
      de => const Locale('de'),
    };
  }

  /// Returns the locale override that should be passed to [WidgetsApp.locale].
  ///
  /// A `null` locale lets Flutter follow the complete list of preferred system
  /// locales and react to changes to that list while the app is running.
  Locale? toFlutterLocale() => isSystem() ? null : toLocale();

  /// Returns the name of the locale in the native language, e.g. "Deutsch" for
  /// the [AppLocale.de] enum value.
  String getNativeName(BuildContext context) {
    return switch (this) {
      system => context.l10n.languageSystemName,
      en => 'English',
      de => 'Deutsch',
    };
  }

  /// Returns the name of the locale in the currently selected language, e.g.
  /// "German" for the [AppLocale.de] enum value when the app is in English.
  String getTranslatedName(BuildContext context) {
    return switch (this) {
      system => context.l10n.languageSystemName,
      en => context.l10n.languageEnName,
      de => context.l10n.languageDeName,
    };
  }

  String getTextEmoji() {
    return switch (this) {
      system => '🌐',
      en => '🇬🇧',
      de => '🇩🇪',
    };
  }

  /// The system-reported default locale of the device.
  static Locale getSystemLocale() {
    return PlatformDispatcher.instance.locale;
  }

  /// Resolves the preferred system locales to a locale supported by Sharezone.
  ///
  /// This is useful for places outside the widget tree, such as payloads sent
  /// to services that need the language effectively used by the app.
  static Locale resolveSystemLocale([List<Locale>? preferredLocales]) {
    return basicLocaleListResolution(
      preferredLocales ?? PlatformDispatcher.instance.locales,
      SharezoneLocalizations.supportedLocales,
    );
  }

  static AppLocale fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return system;
    }

    final isSystem = map['isSystem'];
    if (isSystem is! bool || isSystem) {
      return system;
    }

    final languageTag = map['languageTag'];
    if (languageTag is! String || languageTag.trim().isEmpty) {
      return system;
    }

    return fromLanguageTag(languageTag);
  }

  /// Deserializes the persisted locale preference.
  ///
  /// Plain language tags are supported for compatibility with older clients.
  static AppLocale fromJson(Object? json) {
    return switch (json) {
      final String languageTag => fromLanguageTag(languageTag),
      final Map<Object?, Object?> map => fromMap(
        map.map((key, value) => MapEntry(key.toString(), value)),
      ),
      _ => system,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'isSystem': isSystem(),
      'languageTag':
          isSystem() ? resolveSystemLocale().toLanguageTag() : _toLanguageTag(),
    };
  }

  bool isSystem() {
    return this == system;
  }

  /// Returns a syntactically valid Unicode BCP47 Locale Identifier.
  ///
  /// Some examples of such identifiers: "en", "es-419", "hi-Deva-IN" and
  /// "zh-Hans-CN". See http://www.unicode.org/reports/tr35/ for technical
  /// details.
  String _toLanguageTag() {
    return toLocale().toLanguageTag();
  }

  /// Returns the enum value for the given language tag.
  ///
  /// If the language tag is not supported, the system locale is returned.
  static AppLocale fromLanguageTag(String languageTag) {
    final languageCode =
        languageTag.trim().replaceAll('_', '-').split('-').first;
    return AppLocale.values.firstWhere(
      (element) => element.name == languageCode.toLowerCase(),
      orElse: () => system,
    );
  }
}
