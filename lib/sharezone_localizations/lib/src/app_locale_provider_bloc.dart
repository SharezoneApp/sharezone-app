import 'package:bloc_base/bloc_base.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/subjects.dart';

import 'app_locales.dart';

/// Allows to change the locale of the app.
class AppLocaleProviderBloc extends BlocBase {
  AppLocaleProviderBloc({
    required this.gateway,
    AppLocales initialLocale = AppLocales.system,
  }) {
    localeSubject.add(initialLocale);
    gateway.localeStream.listen((locale) {
      localeSubject.add(locale);
    });
  }

  final AppLocaleProviderGateway gateway;

  final localeSubject = BehaviorSubject<AppLocales>();
  @override
  void dispose() {}

  static AppLocaleProviderBloc of(BuildContext context) {
    return BlocProvider.of<AppLocaleProviderBloc>(context);
  }
}

/// Abstraction for the locale provider.
/// This is underlying data source for the [AppLocaleProviderBloc].
/// Can be implemented for example with shared preferences locally or using a remote service like Firestore.
/// The [AppLocaleProviderBloc] will listen to changes in the locale and update the UI accordingly.
abstract class AppLocaleProviderGateway {
  Stream<AppLocales> get localeStream;

  Future<void> setLocale(AppLocales locale);
}

/// A mock implementation of the [AppLocaleProviderGateway].
class MockAppLocaleProviderGateway implements AppLocaleProviderGateway {
  MockAppLocaleProviderGateway({
    AppLocales initialLocale = AppLocales.system,
  }) {
    localeSubject.add(initialLocale);
  }

  final BehaviorSubject<AppLocales> localeSubject =
      BehaviorSubject<AppLocales>();

  @override
  Stream<AppLocales> get localeStream => localeSubject.stream;

  @override
  Future<void> setLocale(AppLocales locale) async {
    localeSubject.add(locale);
  }
}
