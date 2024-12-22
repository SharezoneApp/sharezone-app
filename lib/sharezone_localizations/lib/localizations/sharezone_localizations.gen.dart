import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'sharezone_localizations_de.gen.dart';
import 'sharezone_localizations_en.gen.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of SharezoneLocalizations
/// returned by `SharezoneLocalizations.of(context)`.
///
/// Applications need to include `SharezoneLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localizations/sharezone_localizations.gen.dart';
///
/// return MaterialApp(
///   localizationsDelegates: SharezoneLocalizations.localizationsDelegates,
///   supportedLocales: SharezoneLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the SharezoneLocalizations.supportedLocales
/// property.
abstract class SharezoneLocalizations {
  SharezoneLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static SharezoneLocalizations? of(BuildContext context) {
    return Localizations.of<SharezoneLocalizations>(
        context, SharezoneLocalizations);
  }

  static const LocalizationsDelegate<SharezoneLocalizations> delegate =
      _SharezoneLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'Sharezone'**
  String get app_name;

  /// No description provided for @common_actions_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get common_actions_cancel;

  /// No description provided for @common_actions_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get common_actions_confirm;

  /// No description provided for @language_page_title.
  ///
  /// In en, this message translates to:
  /// **'Langauge'**
  String get language_page_title;

  /// No description provided for @language_system_name.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get language_system_name;

  /// No description provided for @language_de_name.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get language_de_name;

  /// No description provided for @language_en_name.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language_en_name;
}

class _SharezoneLocalizationsDelegate
    extends LocalizationsDelegate<SharezoneLocalizations> {
  const _SharezoneLocalizationsDelegate();

  @override
  Future<SharezoneLocalizations> load(Locale locale) {
    return SynchronousFuture<SharezoneLocalizations>(
        lookupSharezoneLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_SharezoneLocalizationsDelegate old) => false;
}

SharezoneLocalizations lookupSharezoneLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return SharezoneLocalizationsDe();
    case 'en':
      return SharezoneLocalizationsEn();
  }

  throw FlutterError(
      'SharezoneLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
