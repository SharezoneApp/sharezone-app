import 'package:sharezone_localizations/sharezone_localizations.dart';

/// Gateway to store and retrieve the locale of the app.
///
/// This can be implemented using shared preferences or a remote service like
/// Firestore. The [AppLocaleProvider] listens to changes in the locale and
/// updates the UI accordingly.
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
