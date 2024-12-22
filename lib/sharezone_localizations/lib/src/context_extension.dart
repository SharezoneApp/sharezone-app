import 'package:flutter/widgets.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

extension SharezoneLocalizationsContextExtension on BuildContext {
  /// Extension on [BuildContext] to access the [SharezoneLocalizations] object.
  ///
  /// Requires the SharezoneLocalizations to be available in the context,
  /// otherwise it will throw an exception. Add
  /// [SharezoneLocalizations.delegate] to the underlying App
  /// localizationsDelegates, for access in the context of the app.
  SharezoneLocalizations get sl => SharezoneLocalizations.of(this)!;
}
