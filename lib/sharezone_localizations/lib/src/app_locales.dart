import 'package:flutter/widgets.dart';

enum AppLocales {
  system,
  en,
  de;

  /// Converts the enum value to a [Locale] object.
  /// You can access the system locale using [PlatformDispatcher.instance.locale].
  Locale toLocale({required Locale systemLocale}) {
    return switch (this) {
      system => systemLocale,
      en => SharezoneAppLocales.en,
      de => SharezoneAppLocales.de,
    };
  }
}

class SharezoneAppLocales {
  const SharezoneAppLocales._();

  static const List<Locale> supportedLocales = [
    de,
    en,
  ];

  static const Locale de = Locale('de');
  static const Locale en = Locale('en');
}
