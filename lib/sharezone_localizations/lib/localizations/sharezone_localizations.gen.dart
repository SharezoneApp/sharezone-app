// Copyright (c) 2025 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

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

  /// No description provided for @appName.
  ///
  /// In de, this message translates to:
  /// **'Sharezone'**
  String get appName;

  /// No description provided for @commonActionsCancel.
  ///
  /// In de, this message translates to:
  /// **'Abbrechen'**
  String get commonActionsCancel;

  /// No description provided for @commonActionsConfirm.
  ///
  /// In de, this message translates to:
  /// **'Bestätigen'**
  String get commonActionsConfirm;

  /// No description provided for @commonActionsSave.
  ///
  /// In de, this message translates to:
  /// **'Speichern'**
  String get commonActionsSave;

  /// No description provided for @commonActionsClose.
  ///
  /// In de, this message translates to:
  /// **'Schließen'**
  String get commonActionsClose;

  /// No description provided for @commonActionsOk.
  ///
  /// In de, this message translates to:
  /// **'Ok'**
  String get commonActionsOk;

  /// No description provided for @commonActionsYes.
  ///
  /// In de, this message translates to:
  /// **'Ja'**
  String get commonActionsYes;

  /// No description provided for @commonActionsAlright.
  ///
  /// In de, this message translates to:
  /// **'Alles klar'**
  String get commonActionsAlright;

  /// No description provided for @commonActionsDelete.
  ///
  /// In de, this message translates to:
  /// **'Löschen'**
  String get commonActionsDelete;

  /// No description provided for @commonActionsContactSupport.
  ///
  /// In de, this message translates to:
  /// **'Support kontaktieren'**
  String get commonActionsContactSupport;

  /// No description provided for @commonDisplayError.
  ///
  /// In de, this message translates to:
  /// **'Fehler: {error}'**
  String commonDisplayError(String? error);

  /// No description provided for @instagram.
  ///
  /// In de, this message translates to:
  /// **'Instagram'**
  String get instagram;

  /// No description provided for @twitter.
  ///
  /// In de, this message translates to:
  /// **'Twitter'**
  String get twitter;

  /// No description provided for @linkedIn.
  ///
  /// In de, this message translates to:
  /// **'LinkedIn'**
  String get linkedIn;

  /// No description provided for @discord.
  ///
  /// In de, this message translates to:
  /// **'Discord'**
  String get discord;

  /// No description provided for @email.
  ///
  /// In de, this message translates to:
  /// **'E-Mail'**
  String get email;

  /// No description provided for @gitHub.
  ///
  /// In de, this message translates to:
  /// **'GitHub'**
  String get gitHub;

  /// No description provided for @contactSupportButton.
  ///
  /// In de, this message translates to:
  /// **'Support kontaktieren'**
  String get contactSupportButton;

  /// No description provided for @languagePageTitle.
  ///
  /// In de, this message translates to:
  /// **'Sprache'**
  String get languagePageTitle;

  /// No description provided for @languageSystemName.
  ///
  /// In de, this message translates to:
  /// **'System'**
  String get languageSystemName;

  /// No description provided for @languageDeName.
  ///
  /// In de, this message translates to:
  /// **'Deutsch'**
  String get languageDeName;

  /// No description provided for @languageEnName.
  ///
  /// In de, this message translates to:
  /// **'Englisch'**
  String get languageEnName;

  /// No description provided for @imprintPageTitle.
  ///
  /// In de, this message translates to:
  /// **'Impressum'**
  String get imprintPageTitle;

  /// No description provided for @aboutPageTitle.
  ///
  /// In de, this message translates to:
  /// **'Über uns'**
  String get aboutPageTitle;

  /// No description provided for @aboutPageHeaderTitle.
  ///
  /// In de, this message translates to:
  /// **'Sharezone'**
  String get aboutPageHeaderTitle;

  /// No description provided for @aboutPageHeaderSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Der vernetzte Schulplaner'**
  String get aboutPageHeaderSubtitle;

  /// No description provided for @aboutPageVersion.
  ///
  /// In de, this message translates to:
  /// **'Version: {version} ({buildNumber})'**
  String aboutPageVersion(String? version, String? buildNumber);

  /// No description provided for @aboutPageLoadingVersion.
  ///
  /// In de, this message translates to:
  /// **'Version wird geladen...'**
  String get aboutPageLoadingVersion;

  /// No description provided for @aboutPageFollowUsTitle.
  ///
  /// In de, this message translates to:
  /// **'Folge uns'**
  String get aboutPageFollowUsTitle;

  /// No description provided for @aboutPageFollowUsSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Folge uns auf unseren Kanälen, um immer auf dem neusten Stand zu bleiben.'**
  String get aboutPageFollowUsSubtitle;

  /// No description provided for @aboutPageAboutSectionTitle.
  ///
  /// In de, this message translates to:
  /// **'Was ist Sharezone?'**
  String get aboutPageAboutSectionTitle;

  /// No description provided for @aboutPageAboutSectionDescription.
  ///
  /// In de, this message translates to:
  /// **'Sharezone ist ein vernetzter Schulplaner, welcher die Organisation von Schülern, Lehrkräften und Eltern aus der Steinzeit in das digitale Zeitalter katapultiert. Das Hausaufgabenheft, der Terminplaner, die Dateiablage und vieles weitere wird direkt mit der kompletten Klasse geteilt. Dabei ist keine Registrierung der Schule und die Leitung einer Lehrkraft notwendig, so dass du direkt durchstarten und deinen Schulalltag bequem und einfach gestalten kannst.'**
  String get aboutPageAboutSectionDescription;

  /// No description provided for @aboutPageAboutSectionVisitWebsite.
  ///
  /// In de, this message translates to:
  /// **'Besuche für weitere Informationen einfach https://www.sharezone.net.'**
  String get aboutPageAboutSectionVisitWebsite;

  /// No description provided for @aboutPageEmailCopiedConfirmation.
  ///
  /// In de, this message translates to:
  /// **'E-Mail: {email_address}'**
  String aboutPageEmailCopiedConfirmation(String email_address);

  /// No description provided for @aboutPageTeamSectionTitle.
  ///
  /// In de, this message translates to:
  /// **'Über uns'**
  String get aboutPageTeamSectionTitle;

  /// No description provided for @changeTypeOfUserPageTitle.
  ///
  /// In de, this message translates to:
  /// **'Account-Type ändern'**
  String get changeTypeOfUserPageTitle;

  /// No description provided for @changeTypeOfUserPageErrorDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Fehler'**
  String get changeTypeOfUserPageErrorDialogTitle;

  /// No description provided for @changeTypeOfUserPageErrorDialogContentUnknown.
  ///
  /// In de, this message translates to:
  /// **'Fehler: {error}. Bitte kontaktiere den Support.'**
  String changeTypeOfUserPageErrorDialogContentUnknown(Object? error);

  /// No description provided for @changeTypeOfUserPageErrorDialogContentNoTypeOfUserSelected.
  ///
  /// In de, this message translates to:
  /// **'Es wurde kein Account-Typ ausgewählt.'**
  String get changeTypeOfUserPageErrorDialogContentNoTypeOfUserSelected;

  /// No description provided for @changeTypeOfUserPageErrorDialogContentTypeOfUserHasNotChanged.
  ///
  /// In de, this message translates to:
  /// **'Der Account-Typ hat sich nicht geändert.'**
  String get changeTypeOfUserPageErrorDialogContentTypeOfUserHasNotChanged;

  /// No description provided for @changeTypeOfUserPageErrorDialogContentChangedTypeOfUserTooOften.
  ///
  /// In de, this message translates to:
  /// **'Du kannst nur alle 14 Tage 2x den Account-Typ ändern. Diese Limit wurde erreicht. Bitte warte bis {blockedUntil}.'**
  String changeTypeOfUserPageErrorDialogContentChangedTypeOfUserTooOften(
      DateTime blockedUntil);

  /// No description provided for @changeTypeOfUserPagePermissionNote.
  ///
  /// In de, this message translates to:
  /// **'Beachte die folgende Hinweise:\n* Innerhalb von 14 Tagen kannst du nur 2x den Account-Typ ändern.\n* Durch das Ändern der Nutzer erhältst du keine weiteren Berechtigungen in den Gruppen. Ausschlaggebend sind die Gruppenberechtigungen (\"Administrator\", \"Aktives Mitglied\", \"Passives Mitglied\").'**
  String get changeTypeOfUserPagePermissionNote;

  /// The title of the dialog which will be displayed after a successful type of user change to explain that a restart is required.
  ///
  /// In de, this message translates to:
  /// **'Neustart erforderlich'**
  String get changeTypeOfUserPageRestartAppDialogTitle;

  /// The content of the dialog which will be displayed after a successful type of user change to explain that a restart is required.
  ///
  /// In de, this message translates to:
  /// **'Die Änderung deines Account-Typs war erfolgreich. Jedoch muss die App muss neu gestartet werden, damit die Änderung wirksam wird.'**
  String get changeTypeOfUserPageRestartAppDialogContent;

  /// No description provided for @changePasswordPageTitle.
  ///
  /// In de, this message translates to:
  /// **'Passwort ändern'**
  String get changePasswordPageTitle;

  /// No description provided for @changePasswordPageCurrentPasswordTextfieldLabel.
  ///
  /// In de, this message translates to:
  /// **'Aktuelles Passwort'**
  String get changePasswordPageCurrentPasswordTextfieldLabel;

  /// No description provided for @changePasswordPageNewPasswordTextfieldLabel.
  ///
  /// In de, this message translates to:
  /// **'Neues Passwort'**
  String get changePasswordPageNewPasswordTextfieldLabel;

  /// No description provided for @changePasswordPageResetCurrentPasswordButton.
  ///
  /// In de, this message translates to:
  /// **'Aktuelles Passwort vergessen?'**
  String get changePasswordPageResetCurrentPasswordButton;

  /// No description provided for @changePasswordPageResetCurrentPasswordDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Passwort zurücksetzen'**
  String get changePasswordPageResetCurrentPasswordDialogTitle;

  /// No description provided for @changePasswordPageResetCurrentPasswordDialogContent.
  ///
  /// In de, this message translates to:
  /// **'Sollen wir dir eine E-Mail schicken, mit der du dein Passwort zurücksetzen kannst?'**
  String get changePasswordPageResetCurrentPasswordDialogContent;

  /// Text that is displayed when the user confirmed to reset the current password
  ///
  /// In de, this message translates to:
  /// **'Verschicken der E-Mail wird vorbereitet...'**
  String get changePasswordPageResetCurrentPasswordLoading;

  /// The confirmation text that an email for resetting the password has been sent
  ///
  /// In de, this message translates to:
  /// **'Wir haben eine E-Mail zum Zurücksetzen deines Passworts verschickt.'**
  String get changePasswordPageResetCurrentPasswordEmailSentConfirmation;

  /// No description provided for @changeEmailAddressPageTitle.
  ///
  /// In de, this message translates to:
  /// **'E-Mail ändern'**
  String get changeEmailAddressPageTitle;

  /// The label for the text field which is used for the current email address
  ///
  /// In de, this message translates to:
  /// **'Aktuell'**
  String get changeEmailAddressPageCurrentEmailTextfieldLabel;

  /// The label for the text field which is used for the password
  ///
  /// In de, this message translates to:
  /// **'Neu'**
  String get changeEmailAddressPageNewEmailTextfieldLabel;

  /// No description provided for @changeEmailAddressPagePasswordTextfieldLabel.
  ///
  /// In de, this message translates to:
  /// **'Passwort'**
  String get changeEmailAddressPagePasswordTextfieldLabel;

  /// No description provided for @changeEmailAddressPageNoteOnAutomaticSignOutSignIn.
  ///
  /// In de, this message translates to:
  /// **'Hinweis: Wenn deine E-Mail geändert wurde, wirst du automatisch kurz ab- und sofort wieder angemeldet - also nicht wundern 😉'**
  String get changeEmailAddressPageNoteOnAutomaticSignOutSignIn;

  /// No description provided for @changeEmailAddressPageWhyWeNeedTheEmailInfoTitle.
  ///
  /// In de, this message translates to:
  /// **'Wozu brauchen wir deine E-Mail?'**
  String get changeEmailAddressPageWhyWeNeedTheEmailInfoTitle;

  /// No description provided for @changeEmailAddressPageWhyWeNeedTheEmailInfoContent.
  ///
  /// In de, this message translates to:
  /// **'Die E-Mail benötigst du um dich anzumelden. Solltest du zufällig mal dein Passwort vergessen haben, können wir dir an diese E-Mail-Adresse einen Link zum Zurücksetzen des Passworts schicken. Deine E-Mail Adresse ist nur für dich sichtbar, und sonst niemanden.'**
  String get changeEmailAddressPageWhyWeNeedTheEmailInfoContent;

  /// No description provided for @changeStatePageTitle.
  ///
  /// In de, this message translates to:
  /// **'Bundesland ändern'**
  String get changeStatePageTitle;

  /// No description provided for @changeStatePageErrorLoadingState.
  ///
  /// In de, this message translates to:
  /// **'Error beim Anzeigen der Bundesländer. Falls der Fehler besteht kontaktiere uns bitte.'**
  String get changeStatePageErrorLoadingState;

  /// No description provided for @changeStatePageErrorChangingState.
  ///
  /// In de, this message translates to:
  /// **'Fehler beim Ändern deines Bundeslandes! :('**
  String get changeStatePageErrorChangingState;

  /// No description provided for @changeStatePageWhyWeNeedTheStateInfoTitle.
  ///
  /// In de, this message translates to:
  /// **'Wozu brauchen wir dein Bundesland?'**
  String get changeStatePageWhyWeNeedTheStateInfoTitle;

  /// No description provided for @changeStatePageWhyWeNeedTheStateInfoContent.
  ///
  /// In de, this message translates to:
  /// **'Mithilfe des Bundeslandes können wir die restlichen Tage bis zu den nächsten Ferien berechnen. Wenn du diese Angabe nicht machen möchtest, dann wähle beim Bundesland bitte einfach den Eintrag \"Anonym bleiben.\" aus.'**
  String get changeStatePageWhyWeNeedTheStateInfoContent;

  /// No description provided for @stateBadenWuerttemberg.
  ///
  /// In de, this message translates to:
  /// **'Baden-Württemberg'**
  String get stateBadenWuerttemberg;

  /// No description provided for @stateBayern.
  ///
  /// In de, this message translates to:
  /// **'Bayern'**
  String get stateBayern;

  /// No description provided for @stateBerlin.
  ///
  /// In de, this message translates to:
  /// **'Berlin'**
  String get stateBerlin;

  /// No description provided for @stateBrandenburg.
  ///
  /// In de, this message translates to:
  /// **'Brandenburg'**
  String get stateBrandenburg;

  /// No description provided for @stateBremen.
  ///
  /// In de, this message translates to:
  /// **'Bremen'**
  String get stateBremen;

  /// No description provided for @stateHamburg.
  ///
  /// In de, this message translates to:
  /// **'Hamburg'**
  String get stateHamburg;

  /// No description provided for @stateHessen.
  ///
  /// In de, this message translates to:
  /// **'Hessen'**
  String get stateHessen;

  /// No description provided for @stateMecklenburgVorpommern.
  ///
  /// In de, this message translates to:
  /// **'Mecklenburg-Vorpommern'**
  String get stateMecklenburgVorpommern;

  /// No description provided for @stateNiedersachsen.
  ///
  /// In de, this message translates to:
  /// **'Niedersachsen'**
  String get stateNiedersachsen;

  /// No description provided for @stateNordrheinWestfalen.
  ///
  /// In de, this message translates to:
  /// **'Nordrhein-Westfalen'**
  String get stateNordrheinWestfalen;

  /// No description provided for @stateRheinlandPfalz.
  ///
  /// In de, this message translates to:
  /// **'Rheinland-Pfalz'**
  String get stateRheinlandPfalz;

  /// No description provided for @stateSaarland.
  ///
  /// In de, this message translates to:
  /// **'Saarland'**
  String get stateSaarland;

  /// No description provided for @stateSachsen.
  ///
  /// In de, this message translates to:
  /// **'Sachsen'**
  String get stateSachsen;

  /// No description provided for @stateSachsenAnhalt.
  ///
  /// In de, this message translates to:
  /// **'Sachsen-Anhalt'**
  String get stateSachsenAnhalt;

  /// No description provided for @stateSchleswigHolstein.
  ///
  /// In de, this message translates to:
  /// **'Schleswig-Holstein'**
  String get stateSchleswigHolstein;

  /// No description provided for @stateThueringen.
  ///
  /// In de, this message translates to:
  /// **'Thüringen'**
  String get stateThueringen;

  /// No description provided for @stateNotFromGermany.
  ///
  /// In de, this message translates to:
  /// **'Nicht aus Deutschland'**
  String get stateNotFromGermany;

  /// No description provided for @stateAnonymous.
  ///
  /// In de, this message translates to:
  /// **'Anonym bleiben'**
  String get stateAnonymous;

  /// No description provided for @stateNotSelected.
  ///
  /// In de, this message translates to:
  /// **'Nicht ausgewählt'**
  String get stateNotSelected;

  /// No description provided for @myProfilePageTitle.
  ///
  /// In de, this message translates to:
  /// **'Mein Konto'**
  String get myProfilePageTitle;

  /// No description provided for @myProfilePageNameTile.
  ///
  /// In de, this message translates to:
  /// **'Name'**
  String get myProfilePageNameTile;

  /// No description provided for @myProfilePageActivationCodeTile.
  ///
  /// In de, this message translates to:
  /// **'Aktivierungscode eingeben'**
  String get myProfilePageActivationCodeTile;

  /// No description provided for @myProfilePageEmailTile.
  ///
  /// In de, this message translates to:
  /// **'E-Mail'**
  String get myProfilePageEmailTile;

  /// No description provided for @myProfilePageEmailNotChangeable.
  ///
  /// In de, this message translates to:
  /// **'Dein Account ist mit einem Google-Konto verbunden. Aus diesem Grund kannst du deine E-Mail nicht ändern.'**
  String get myProfilePageEmailNotChangeable;

  /// No description provided for @myProfilePageEmailAccountTypeTitle.
  ///
  /// In de, this message translates to:
  /// **'Account-Typ'**
  String get myProfilePageEmailAccountTypeTitle;

  /// No description provided for @myProfilePageChangePasswordTile.
  ///
  /// In de, this message translates to:
  /// **'Passwort ändern'**
  String get myProfilePageChangePasswordTile;

  /// No description provided for @myProfilePageChangedPasswordConfirmation.
  ///
  /// In de, this message translates to:
  /// **'Das Passwort wurde erfolgreich geändert.'**
  String get myProfilePageChangedPasswordConfirmation;

  /// No description provided for @myProfilePageStateTile.
  ///
  /// In de, this message translates to:
  /// **'Bundesland'**
  String get myProfilePageStateTile;

  /// No description provided for @myProfilePageSignInMethodTile.
  ///
  /// In de, this message translates to:
  /// **'Anmeldemethode'**
  String get myProfilePageSignInMethodTile;

  /// No description provided for @myProfilePageSignInMethodChangeNotPossibleDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Anmeldemethode ändern nicht möglich'**
  String get myProfilePageSignInMethodChangeNotPossibleDialogTitle;

  /// No description provided for @myProfilePageSignInMethodChangeNotPossibleDialogContent.
  ///
  /// In de, this message translates to:
  /// **'Die Anmeldemethode kann aktuell nur bei der Registrierung gesetzt werden. Später kann diese nicht mehr geändert werden.'**
  String get myProfilePageSignInMethodChangeNotPossibleDialogContent;

  /// No description provided for @myProfilePageSupportTeamTile.
  ///
  /// In de, this message translates to:
  /// **'Entwickler unterstützen'**
  String get myProfilePageSupportTeamTile;

  /// No description provided for @myProfilePageSupportTeamDescription.
  ///
  /// In de, this message translates to:
  /// **'Durch das Teilen von anonymen Nutzerdaten hilfst du uns, die App noch einfacher und benutzerfreundlicher zu machen.'**
  String get myProfilePageSupportTeamDescription;

  /// No description provided for @myProfilePageCopyUserIdTile.
  ///
  /// In de, this message translates to:
  /// **'User ID'**
  String get myProfilePageCopyUserIdTile;

  /// No description provided for @myProfilePageCopyUserIdConfirmation.
  ///
  /// In de, this message translates to:
  /// **'User ID wurde kopiert.'**
  String get myProfilePageCopyUserIdConfirmation;

  /// No description provided for @myProfilePageSignOutButton.
  ///
  /// In de, this message translates to:
  /// **'Abmelden'**
  String get myProfilePageSignOutButton;

  /// No description provided for @myProfilePageDeleteAccountButton.
  ///
  /// In de, this message translates to:
  /// **'Konto löschen'**
  String get myProfilePageDeleteAccountButton;

  /// No description provided for @myProfilePageDeleteAccountDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Sollte dein Account gelöscht werden, werden alle deine Daten gelöscht. Dieser Vorgang lässt sich nicht wieder rückgängig machen.'**
  String get myProfilePageDeleteAccountDialogTitle;

  /// No description provided for @myProfilePageDeleteAccountDialogContent.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du deinen Account wirklich löschen?'**
  String get myProfilePageDeleteAccountDialogContent;

  /// No description provided for @myProfilePageDeleteAccountDialogPleaseEnterYourPassword.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib dein Passwort ein, um deinen Account zu löschen.'**
  String get myProfilePageDeleteAccountDialogPleaseEnterYourPassword;

  /// No description provided for @myProfilePageDeleteAccountDialogPasswordTextfieldLabel.
  ///
  /// In de, this message translates to:
  /// **'Passwort'**
  String get myProfilePageDeleteAccountDialogPasswordTextfieldLabel;

  /// No description provided for @themePageTitle.
  ///
  /// In de, this message translates to:
  /// **'Erscheinungsbild'**
  String get themePageTitle;

  /// No description provided for @themePageLightDarkModeSectionTitle.
  ///
  /// In de, this message translates to:
  /// **'Heller & Dunkler Modus'**
  String get themePageLightDarkModeSectionTitle;

  /// No description provided for @themePageDarkMode.
  ///
  /// In de, this message translates to:
  /// **'Dunkler Modus'**
  String get themePageDarkMode;

  /// No description provided for @themePageLightMode.
  ///
  /// In de, this message translates to:
  /// **'Heller Modus'**
  String get themePageLightMode;

  /// No description provided for @themePageSystemMode.
  ///
  /// In de, this message translates to:
  /// **'System'**
  String get themePageSystemMode;

  /// No description provided for @themePageRateOurAppCardTitle.
  ///
  /// In de, this message translates to:
  /// **'Gefällt dir Sharezone?'**
  String get themePageRateOurAppCardTitle;

  /// No description provided for @themePageRateOurAppCardContent.
  ///
  /// In de, this message translates to:
  /// **'Falls dir Sharezone gefällt, würden wir uns über eine Bewertung sehr freuen! 🙏  Dir gefällt etwas nicht? Kontaktiere einfach den Support 👍'**
  String get themePageRateOurAppCardContent;

  /// No description provided for @themePageRateOurAppCardRatingsNotAvailableOnWebDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'App-Bewertung nur über iOS & Android möglich!'**
  String get themePageRateOurAppCardRatingsNotAvailableOnWebDialogTitle;

  /// No description provided for @themePageRateOurAppCardRatingsNotAvailableOnWebDialogContent.
  ///
  /// In de, this message translates to:
  /// **'Über die Web-App kann die App nicht bewertet werden. Nimm dafür einfach dein Handy 👍'**
  String get themePageRateOurAppCardRatingsNotAvailableOnWebDialogContent;

  /// No description provided for @themePageRateOurAppCardRateButton.
  ///
  /// In de, this message translates to:
  /// **'Bewerten'**
  String get themePageRateOurAppCardRateButton;

  /// No description provided for @themePageNavigationExperimentSectionTitle.
  ///
  /// In de, this message translates to:
  /// **'Experiment: Neue Navigation'**
  String get themePageNavigationExperimentSectionTitle;

  /// No description provided for @themePageNavigationExperimentSectionContent.
  ///
  /// In de, this message translates to:
  /// **'Wir testen aktuell eine neue Navigation. Bitte gib über die Feedback-Box oder unseren Discord-Server eine kurze Rückmeldung, wie du die jeweiligen Optionen findest.'**
  String get themePageNavigationExperimentSectionContent;

  /// No description provided for @themePageNavigationExperimentOptionTile.
  ///
  /// In de, this message translates to:
  /// **'Option {number}: {name}'**
  String themePageNavigationExperimentOptionTile(int number, String name);

  /// No description provided for @navigationExperimentOptionDrawerAndBnb.
  ///
  /// In de, this message translates to:
  /// **'Aktuelle Navigation'**
  String get navigationExperimentOptionDrawerAndBnb;

  /// No description provided for @navigationExperimentOptionExtendableBnb.
  ///
  /// In de, this message translates to:
  /// **'Neue Navigation - Ohne Mehr-Button'**
  String get navigationExperimentOptionExtendableBnb;

  /// No description provided for @navigationExperimentOptionExtendableBnbWithMoreButton.
  ///
  /// In de, this message translates to:
  /// **'Neue Navigation - Mit Mehr-Button'**
  String get navigationExperimentOptionExtendableBnbWithMoreButton;

  /// No description provided for @timetableSettingsPageTitle.
  ///
  /// In de, this message translates to:
  /// **'Stundenplan'**
  String get timetableSettingsPageTitle;

  /// No description provided for @timetableSettingsPagePeriodsFieldTileTitle.
  ///
  /// In de, this message translates to:
  /// **'Stundenzeiten'**
  String get timetableSettingsPagePeriodsFieldTileTitle;

  /// No description provided for @timetableSettingsPagePeriodsFieldTileSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Stundenplanbeginn, Stundenlänge, etc.'**
  String get timetableSettingsPagePeriodsFieldTileSubtitle;

  /// No description provided for @timetableSettingsPageIcalLinksTitleTitle.
  ///
  /// In de, this message translates to:
  /// **'Termine, Prüfungen, Stundenplan exportieren (iCal)'**
  String get timetableSettingsPageIcalLinksTitleTitle;

  /// No description provided for @timetableSettingsPageIcalLinksTitleSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Synchronisierung mit Google Kalender, Apple Kalender usw.'**
  String get timetableSettingsPageIcalLinksTitleSubtitle;

  /// No description provided for @timetableSettingsPageIcalLinksPlusDialogContent.
  ///
  /// In de, this message translates to:
  /// **'Mit einem iCal-Link kannst du deinen Stundenplan und deine Termine in andere Kalender-Apps (wie z.B. Google Kalender, Apple Kalender) einbinden. Sobald sich dein Stundenplan oder deine Termine ändern, werden diese auch in deinen anderen Kalender Apps aktualisiert.\n\nAnders als beim \"Zum Kalender hinzufügen\" Button, musst du dich nicht darum kümmern, den Termin in deiner Kalender App zu aktualisieren, wenn sich etwas in Sharezone ändert.\n\niCal-Links ist nur für dich sichtbar und können nicht von anderen Personen eingesehen werden.\n\nBitte beachte, dass aktuell nur Termine und Prüfungen exportiert werden können. Die Schulstunden können noch nicht exportiert werden.'**
  String get timetableSettingsPageIcalLinksPlusDialogContent;

  /// No description provided for @timetableSettingsPageEnabledWeekDaysTileTitle.
  ///
  /// In de, this message translates to:
  /// **'Aktivierte Wochentage'**
  String get timetableSettingsPageEnabledWeekDaysTileTitle;

  /// No description provided for @timetableSettingsPageLessonLengthTileTile.
  ///
  /// In de, this message translates to:
  /// **'Länge einer Stunde'**
  String get timetableSettingsPageLessonLengthTileTile;

  /// No description provided for @timetableSettingsPageLessonLengthTileSubtile.
  ///
  /// In de, this message translates to:
  /// **'Länge einer Stunde'**
  String get timetableSettingsPageLessonLengthTileSubtile;

  /// A text that displays the length for lessons in minutes.
  ///
  /// In de, this message translates to:
  /// **'{length} Min.'**
  String timetableSettingsPageLessonLengthTileTrailing(int length);

  /// No description provided for @timetableSettingsPageLessonLengthSavedConfirmation.
  ///
  /// In de, this message translates to:
  /// **'Länge einer Stunde wurde gespeichert.'**
  String get timetableSettingsPageLessonLengthSavedConfirmation;

  /// No description provided for @timetableSettingsPageLessonLengthEditDialog.
  ///
  /// In de, this message translates to:
  /// **'Wähle die Länge der Stunde in Minuten aus.'**
  String get timetableSettingsPageLessonLengthEditDialog;

  /// No description provided for @timetableSettingsPageIsFiveMinutesIntervalActiveTileTitle.
  ///
  /// In de, this message translates to:
  /// **'Fünf-Minuten-Intervall beim Time-Picker'**
  String get timetableSettingsPageIsFiveMinutesIntervalActiveTileTitle;

  /// No description provided for @timetableSettingsPageShowLessonsAbbreviation.
  ///
  /// In de, this message translates to:
  /// **'Kürzel im Stundenplan anzeigen'**
  String get timetableSettingsPageShowLessonsAbbreviation;

  /// No description provided for @timetableSettingsPageABWeekTileTitle.
  ///
  /// In de, this message translates to:
  /// **'A/B Wochen'**
  String get timetableSettingsPageABWeekTileTitle;

  /// No description provided for @timetableSettingsPageAWeeksAreEvenSwitch.
  ///
  /// In de, this message translates to:
  /// **'A-Wochen sind gerade Kalenderwochen'**
  String get timetableSettingsPageAWeeksAreEvenSwitch;

  /// A text that is displayed below the set if the current week is a or b week
  ///
  /// In de, this message translates to:
  /// **'Diese Woche ist Kalenderwoche {calendar_week}. A-Wochen sind {is_a_week_even} Kalenderwochen und somit ist aktuell eine {even_or_odd_week}'**
  String timetableSettingsPageThisWeekIs(
      int calendar_week, String is_a_week_even, String even_or_odd_week);
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
