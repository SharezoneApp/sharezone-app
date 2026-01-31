// Copyright (c) 2026 Sharezone UG (haftungsbeschränkt)
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
      context,
      SharezoneLocalizations,
    );
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
    Locale('en'),
  ];

  /// No description provided for @aboutEmailCopiedConfirmation.
  ///
  /// In de, this message translates to:
  /// **'E-Mail: {email_address}'**
  String aboutEmailCopiedConfirmation(String email_address);

  /// No description provided for @aboutFollowUsSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Folge uns auf unseren Kanälen, um immer auf dem neusten Stand zu bleiben.'**
  String get aboutFollowUsSubtitle;

  /// No description provided for @aboutFollowUsTitle.
  ///
  /// In de, this message translates to:
  /// **'Folge uns'**
  String get aboutFollowUsTitle;

  /// No description provided for @aboutHeaderSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Der vernetzte Schulplaner'**
  String get aboutHeaderSubtitle;

  /// No description provided for @aboutHeaderTitle.
  ///
  /// In de, this message translates to:
  /// **'Sharezone'**
  String get aboutHeaderTitle;

  /// No description provided for @aboutLoadingVersion.
  ///
  /// In de, this message translates to:
  /// **'Version wird geladen...'**
  String get aboutLoadingVersion;

  /// No description provided for @aboutSectionDescription.
  ///
  /// In de, this message translates to:
  /// **'Sharezone ist ein vernetzter Schulplaner, welcher die Organisation von Schülern, Lehrkräften und Eltern aus der Steinzeit in das digitale Zeitalter katapultiert. Das Hausaufgabenheft, der Terminplaner, die Dateiablage und vieles weitere wird direkt mit der kompletten Klasse geteilt. Dabei ist keine Registrierung der Schule und die Leitung einer Lehrkraft notwendig, so dass du direkt durchstarten und deinen Schulalltag bequem und einfach gestalten kannst.'**
  String get aboutSectionDescription;

  /// No description provided for @aboutSectionTitle.
  ///
  /// In de, this message translates to:
  /// **'Was ist Sharezone?'**
  String get aboutSectionTitle;

  /// No description provided for @aboutSectionVisitWebsite.
  ///
  /// In de, this message translates to:
  /// **'Besuche für weitere Informationen einfach https://www.sharezone.net.'**
  String get aboutSectionVisitWebsite;

  /// No description provided for @aboutTeamSectionTitle.
  ///
  /// In de, this message translates to:
  /// **'Über uns'**
  String get aboutTeamSectionTitle;

  /// No description provided for @aboutTitle.
  ///
  /// In de, this message translates to:
  /// **'Über uns'**
  String get aboutTitle;

  /// No description provided for @aboutVersion.
  ///
  /// In de, this message translates to:
  /// **'Version: {version} ({buildNumber})'**
  String aboutVersion(String? buildNumber, String? version);

  /// Tooltip for the edit profile button on the account page.
  ///
  /// In de, this message translates to:
  /// **'Profil bearbeiten'**
  String get accountEditProfileTooltip;

  /// Snackbar text when linking an account with Apple succeeded.
  ///
  /// In de, this message translates to:
  /// **'Dein Account wurde mit einem Apple-Konto verknüpft.'**
  String get accountLinkAppleConfirmation;

  /// Snackbar text when linking an account with Google succeeded.
  ///
  /// In de, this message translates to:
  /// **'Dein Account wurde mit einem Google-Konto verknüpft.'**
  String get accountLinkGoogleConfirmation;

  /// Title for the account page app bar.
  ///
  /// In de, this message translates to:
  /// **'Profil'**
  String get accountPageTitle;

  /// Tooltip for the QR code web login button in the account page app bar.
  ///
  /// In de, this message translates to:
  /// **'QR-Code Login für die Web-App'**
  String get accountPageWebLoginTooltip;

  /// Title for the tile that shows the user's state on the account page.
  ///
  /// In de, this message translates to:
  /// **'Bundesland'**
  String get accountStateTitle;

  /// No description provided for @appName.
  ///
  /// In de, this message translates to:
  /// **'Sharezone'**
  String get appName;

  /// The label for the text field which is used for the current email address
  ///
  /// In de, this message translates to:
  /// **'Aktuell'**
  String get changeEmailAddressCurrentEmailTextfieldLabel;

  /// Error message when the new email matches the current one.
  ///
  /// In de, this message translates to:
  /// **'Die eingegebene E-Mail ist identisch mit der alten! 🙈'**
  String get changeEmailAddressIdenticalError;

  /// The label for the text field which is used for the new email address
  ///
  /// In de, this message translates to:
  /// **'Neu'**
  String get changeEmailAddressNewEmailTextfieldLabel;

  /// No description provided for @changeEmailAddressNoteOnAutomaticSignOutSignIn.
  ///
  /// In de, this message translates to:
  /// **'Hinweis: Wenn deine E-Mail geändert wurde, wirst du automatisch kurz ab- und sofort wieder angemeldet - also nicht wundern 😉'**
  String get changeEmailAddressNoteOnAutomaticSignOutSignIn;

  /// The label for the text field which is used for the password
  ///
  /// In de, this message translates to:
  /// **'Passwort'**
  String get changeEmailAddressPasswordTextfieldLabel;

  /// No description provided for @changeEmailAddressTitle.
  ///
  /// In de, this message translates to:
  /// **'E-Mail ändern'**
  String get changeEmailAddressTitle;

  /// No description provided for @changeEmailAddressWhyWeNeedTheEmailInfoContent.
  ///
  /// In de, this message translates to:
  /// **'Die E-Mail benötigst du um dich anzumelden. Solltest du zufällig mal dein Passwort vergessen haben, können wir dir an diese E-Mail-Adresse einen Link zum Zurücksetzen des Passworts schicken. Deine E-Mail Adresse ist nur für dich sichtbar, und sonst niemanden.'**
  String get changeEmailAddressWhyWeNeedTheEmailInfoContent;

  /// No description provided for @changeEmailAddressWhyWeNeedTheEmailInfoTitle.
  ///
  /// In de, this message translates to:
  /// **'Wozu brauchen wir deine E-Mail?'**
  String get changeEmailAddressWhyWeNeedTheEmailInfoTitle;

  /// No description provided for @changePasswordCurrentPasswordTextfieldLabel.
  ///
  /// In de, this message translates to:
  /// **'Aktuelles Passwort'**
  String get changePasswordCurrentPasswordTextfieldLabel;

  /// A text for the SnackBar widget when the user presses the change password button
  ///
  /// In de, this message translates to:
  /// **'Neues Password wird an die Zentrale geschickt...'**
  String get changePasswordLoadingSnackbarText;

  /// No description provided for @changePasswordNewPasswordTextfieldLabel.
  ///
  /// In de, this message translates to:
  /// **'Neues Passwort'**
  String get changePasswordNewPasswordTextfieldLabel;

  /// No description provided for @changePasswordResetCurrentPasswordButton.
  ///
  /// In de, this message translates to:
  /// **'Aktuelles Passwort vergessen?'**
  String get changePasswordResetCurrentPasswordButton;

  /// No description provided for @changePasswordResetCurrentPasswordDialogContent.
  ///
  /// In de, this message translates to:
  /// **'Sollen wir dir eine E-Mail schicken, mit der du dein Passwort zurücksetzen kannst?'**
  String get changePasswordResetCurrentPasswordDialogContent;

  /// No description provided for @changePasswordResetCurrentPasswordDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Passwort zurücksetzen'**
  String get changePasswordResetCurrentPasswordDialogTitle;

  /// The confirmation text that an email for resetting the password has been sent
  ///
  /// In de, this message translates to:
  /// **'Wir haben eine E-Mail zum Zurücksetzen deines Passworts verschickt.'**
  String get changePasswordResetCurrentPasswordEmailSentConfirmation;

  /// Text that is displayed when the user confirmed to reset the current password
  ///
  /// In de, this message translates to:
  /// **'Verschicken der E-Mail wird vorbereitet...'**
  String get changePasswordResetCurrentPasswordLoading;

  /// No description provided for @changePasswordTitle.
  ///
  /// In de, this message translates to:
  /// **'Passwort ändern'**
  String get changePasswordTitle;

  /// No description provided for @changeStateErrorChangingState.
  ///
  /// In de, this message translates to:
  /// **'Fehler beim Ändern deines Bundeslandes! :('**
  String get changeStateErrorChangingState;

  /// No description provided for @changeStateErrorLoadingState.
  ///
  /// In de, this message translates to:
  /// **'Error beim Anzeigen der Bundesländer. Falls der Fehler besteht kontaktiere uns bitte.'**
  String get changeStateErrorLoadingState;

  /// No description provided for @changeStateTitle.
  ///
  /// In de, this message translates to:
  /// **'Bundesland ändern'**
  String get changeStateTitle;

  /// No description provided for @changeStateWhyWeNeedTheStateInfoContent.
  ///
  /// In de, this message translates to:
  /// **'Mithilfe des Bundeslandes können wir die restlichen Tage bis zu den nächsten Ferien berechnen. Wenn du diese Angabe nicht machen möchtest, dann wähle beim Bundesland bitte einfach den Eintrag \"Anonym bleiben.\" aus.'**
  String get changeStateWhyWeNeedTheStateInfoContent;

  /// No description provided for @changeStateWhyWeNeedTheStateInfoTitle.
  ///
  /// In de, this message translates to:
  /// **'Wozu brauchen wir dein Bundesland?'**
  String get changeStateWhyWeNeedTheStateInfoTitle;

  /// No description provided for @changeTypeOfUserErrorDialogContentChangedTypeOfUserTooOften.
  ///
  /// In de, this message translates to:
  /// **'Du kannst nur alle 14 Tage 2x den Account-Typ ändern. Diese Limit wurde erreicht. Bitte warte bis {blockedUntil}.'**
  String changeTypeOfUserErrorDialogContentChangedTypeOfUserTooOften(
    DateTime blockedUntil,
  );

  /// No description provided for @changeTypeOfUserErrorDialogContentNoTypeOfUserSelected.
  ///
  /// In de, this message translates to:
  /// **'Es wurde kein Account-Typ ausgewählt.'**
  String get changeTypeOfUserErrorDialogContentNoTypeOfUserSelected;

  /// No description provided for @changeTypeOfUserErrorDialogContentTypeOfUserHasNotChanged.
  ///
  /// In de, this message translates to:
  /// **'Der Account-Typ hat sich nicht geändert.'**
  String get changeTypeOfUserErrorDialogContentTypeOfUserHasNotChanged;

  /// No description provided for @changeTypeOfUserErrorDialogContentUnknown.
  ///
  /// In de, this message translates to:
  /// **'Fehler: {error}. Bitte kontaktiere den Support.'**
  String changeTypeOfUserErrorDialogContentUnknown(Object? error);

  /// No description provided for @changeTypeOfUserErrorDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Fehler'**
  String get changeTypeOfUserErrorDialogTitle;

  /// No description provided for @changeTypeOfUserPermissionNote.
  ///
  /// In de, this message translates to:
  /// **'Beachte die folgende Hinweise:\n* Innerhalb von 14 Tagen kannst du nur 2x den Account-Typ ändern.\n* Durch das Ändern der Nutzer erhältst du keine weiteren Berechtigungen in den Gruppen. Ausschlaggebend sind die Gruppenberechtigungen (\"Administrator\", \"Aktives Mitglied\", \"Passives Mitglied\").'**
  String get changeTypeOfUserPermissionNote;

  /// The content of the dialog which will be displayed after a successful type of user change to explain that a restart is required.
  ///
  /// In de, this message translates to:
  /// **'Die Änderung deines Account-Typs war erfolgreich. Jedoch muss die App muss neu gestartet werden, damit die Änderung wirksam wird.'**
  String get changeTypeOfUserRestartAppDialogContent;

  /// The title of the dialog which will be displayed after a successful type of user change to explain that a restart is required.
  ///
  /// In de, this message translates to:
  /// **'Neustart erforderlich'**
  String get changeTypeOfUserRestartAppDialogTitle;

  /// No description provided for @changeTypeOfUserTitle.
  ///
  /// In de, this message translates to:
  /// **'Account-Typ ändern'**
  String get changeTypeOfUserTitle;

  /// No description provided for @commonActionBack.
  ///
  /// In de, this message translates to:
  /// **'Zurück'**
  String get commonActionBack;

  /// No description provided for @commonActionChange.
  ///
  /// In de, this message translates to:
  /// **'Ändern'**
  String get commonActionChange;

  /// No description provided for @commonActionsAlright.
  ///
  /// In de, this message translates to:
  /// **'Alles klar'**
  String get commonActionsAlright;

  /// No description provided for @commonActionsCancel.
  ///
  /// In de, this message translates to:
  /// **'Abbrechen'**
  String get commonActionsCancel;

  /// No description provided for @commonActionsClose.
  ///
  /// In de, this message translates to:
  /// **'Schließen'**
  String get commonActionsClose;

  /// No description provided for @commonActionsCloseUppercase.
  ///
  /// In de, this message translates to:
  /// **'SCHLIESSEN'**
  String get commonActionsCloseUppercase;

  /// No description provided for @commonActionsConfirm.
  ///
  /// In de, this message translates to:
  /// **'Bestätigen'**
  String get commonActionsConfirm;

  /// No description provided for @commonActionsContactSupport.
  ///
  /// In de, this message translates to:
  /// **'Support kontaktieren'**
  String get commonActionsContactSupport;

  /// No description provided for @commonActionsDelete.
  ///
  /// In de, this message translates to:
  /// **'Löschen'**
  String get commonActionsDelete;

  /// No description provided for @commonActionsOk.
  ///
  /// In de, this message translates to:
  /// **'Ok'**
  String get commonActionsOk;

  /// No description provided for @commonActionsSave.
  ///
  /// In de, this message translates to:
  /// **'Speichern'**
  String get commonActionsSave;

  /// No description provided for @commonActionsYes.
  ///
  /// In de, this message translates to:
  /// **'Ja'**
  String get commonActionsYes;

  /// No description provided for @commonDisplayError.
  ///
  /// In de, this message translates to:
  /// **'Fehler: {error}'**
  String commonDisplayError(String? error);

  /// No description provided for @contactSupportButton.
  ///
  /// In de, this message translates to:
  /// **'Support kontaktieren'**
  String get contactSupportButton;

  /// No description provided for @countryAustria.
  ///
  /// In de, this message translates to:
  /// **'Österreich'**
  String get countryAustria;

  /// No description provided for @countryGermany.
  ///
  /// In de, this message translates to:
  /// **'Deutschland'**
  String get countryGermany;

  /// No description provided for @countrySwitzerland.
  ///
  /// In de, this message translates to:
  /// **'Schweiz'**
  String get countrySwitzerland;

  /// No description provided for @dashboardSelectStateButton.
  ///
  /// In de, this message translates to:
  /// **'Bundesland / Kanton auswählen'**
  String get dashboardSelectStateButton;

  /// No description provided for @imprintTitle.
  ///
  /// In de, this message translates to:
  /// **'Impressum'**
  String get imprintTitle;

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

  /// No description provided for @languageSystemName.
  ///
  /// In de, this message translates to:
  /// **'System'**
  String get languageSystemName;

  /// No description provided for @languageTitle.
  ///
  /// In de, this message translates to:
  /// **'Sprache'**
  String get languageTitle;

  /// No description provided for @myProfileActivationCodeTile.
  ///
  /// In de, this message translates to:
  /// **'Aktivierungscode eingeben'**
  String get myProfileActivationCodeTile;

  /// No description provided for @myProfileChangePasswordTile.
  ///
  /// In de, this message translates to:
  /// **'Passwort ändern'**
  String get myProfileChangePasswordTile;

  /// No description provided for @myProfileChangedPasswordConfirmation.
  ///
  /// In de, this message translates to:
  /// **'Das Passwort wurde erfolgreich geändert.'**
  String get myProfileChangedPasswordConfirmation;

  /// No description provided for @myProfileCopyUserIdConfirmation.
  ///
  /// In de, this message translates to:
  /// **'User ID wurde kopiert.'**
  String get myProfileCopyUserIdConfirmation;

  /// No description provided for @myProfileCopyUserIdTile.
  ///
  /// In de, this message translates to:
  /// **'User ID'**
  String get myProfileCopyUserIdTile;

  /// No description provided for @myProfileDeleteAccountButton.
  ///
  /// In de, this message translates to:
  /// **'Konto löschen'**
  String get myProfileDeleteAccountButton;

  /// No description provided for @myProfileDeleteAccountDialogContent.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du deinen Account wirklich löschen?'**
  String get myProfileDeleteAccountDialogContent;

  /// No description provided for @myProfileDeleteAccountDialogPasswordTextfieldLabel.
  ///
  /// In de, this message translates to:
  /// **'Passwort'**
  String get myProfileDeleteAccountDialogPasswordTextfieldLabel;

  /// No description provided for @myProfileDeleteAccountDialogPleaseEnterYourPassword.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib dein Passwort ein, um deinen Account zu löschen.'**
  String get myProfileDeleteAccountDialogPleaseEnterYourPassword;

  /// No description provided for @myProfileDeleteAccountDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Sollte dein Account gelöscht werden, werden alle deine Daten gelöscht. Dieser Vorgang lässt sich nicht wieder rückgängig machen.'**
  String get myProfileDeleteAccountDialogTitle;

  /// No description provided for @myProfileEmailAccountTypeTitle.
  ///
  /// In de, this message translates to:
  /// **'Account-Typ'**
  String get myProfileEmailAccountTypeTitle;

  /// No description provided for @myProfileEmailNotChangeable.
  ///
  /// In de, this message translates to:
  /// **'Dein Account ist mit einem Google-Konto verbunden. Aus diesem Grund kannst du deine E-Mail nicht ändern.'**
  String get myProfileEmailNotChangeable;

  /// No description provided for @myProfileEmailTile.
  ///
  /// In de, this message translates to:
  /// **'E-Mail'**
  String get myProfileEmailTile;

  /// No description provided for @myProfileNameTile.
  ///
  /// In de, this message translates to:
  /// **'Name'**
  String get myProfileNameTile;

  /// No description provided for @myProfileSignInMethodChangeNotPossibleDialogContent.
  ///
  /// In de, this message translates to:
  /// **'Die Anmeldemethode kann aktuell nur bei der Registrierung gesetzt werden. Später kann diese nicht mehr geändert werden.'**
  String get myProfileSignInMethodChangeNotPossibleDialogContent;

  /// No description provided for @myProfileSignInMethodChangeNotPossibleDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Anmeldemethode ändern nicht möglich'**
  String get myProfileSignInMethodChangeNotPossibleDialogTitle;

  /// No description provided for @myProfileSignInMethodTile.
  ///
  /// In de, this message translates to:
  /// **'Anmeldemethode'**
  String get myProfileSignInMethodTile;

  /// No description provided for @myProfileSignOutButton.
  ///
  /// In de, this message translates to:
  /// **'Abmelden'**
  String get myProfileSignOutButton;

  /// No description provided for @myProfileStateTile.
  ///
  /// In de, this message translates to:
  /// **'Bundesland'**
  String get myProfileStateTile;

  /// No description provided for @myProfileSupportTeamDescription.
  ///
  /// In de, this message translates to:
  /// **'Durch das Teilen von anonymen Nutzerdaten hilfst du uns, die App noch einfacher und benutzerfreundlicher zu machen.'**
  String get myProfileSupportTeamDescription;

  /// No description provided for @myProfileSupportTeamTile.
  ///
  /// In de, this message translates to:
  /// **'Entwickler unterstützen'**
  String get myProfileSupportTeamTile;

  /// No description provided for @myProfileTitle.
  ///
  /// In de, this message translates to:
  /// **'Mein Konto'**
  String get myProfileTitle;

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

  /// No description provided for @selectStateDialogConfirmationSnackBar.
  ///
  /// In de, this message translates to:
  /// **'Region {region} ausgewählt'**
  String selectStateDialogConfirmationSnackBar(Object region);

  /// Legal notice shown below the sign-in methods for anonymous users.
  ///
  /// In de, this message translates to:
  /// **'Melde dich jetzt an und übertrage deine Daten! Die Anmeldung ist aus datenschutzrechtlichen Gründen erst ab 16 Jahren erlaubt.'**
  String get registerAccountAgeNoticeText;

  /// Banner text indicating the user is only signed in anonymously.
  ///
  /// In de, this message translates to:
  /// **'Du bist nur anonym angemeldet!'**
  String get registerAccountAnonymousInfoTitle;

  /// Label for the long Apple sign-in button.
  ///
  /// In de, this message translates to:
  /// **'Mit Apple anmelden'**
  String get registerAccountAppleButtonLong;

  /// Label for the short Apple sign-in button.
  ///
  /// In de, this message translates to:
  /// **'Apple'**
  String get registerAccountAppleButtonShort;

  /// Subtitle describing the backup benefit for anonymous users.
  ///
  /// In de, this message translates to:
  /// **'Weiterhin Zugriff auf die Daten bei Verlust des Smartphones'**
  String get registerAccountBenefitBackupSubtitle;

  /// Title for the backup benefit list tile for anonymous users.
  ///
  /// In de, this message translates to:
  /// **'Automatisches Backup'**
  String get registerAccountBenefitBackupTitle;

  /// Subtitle describing the multi-device benefit for anonymous users.
  ///
  /// In de, this message translates to:
  /// **'Daten werden zwischen mehreren Geräten synchronisiert'**
  String get registerAccountBenefitMultiDeviceSubtitle;

  /// Title for the multi-device benefit list tile for anonymous users.
  ///
  /// In de, this message translates to:
  /// **'Nutzung auf mehreren Geräten'**
  String get registerAccountBenefitMultiDeviceTitle;

  /// Intro text for the benefits of creating an account.
  ///
  /// In de, this message translates to:
  /// **'Übertrage jetzt deinen Account auf ein richtiges Konto, um von folgenden Vorteilen zu profitieren:'**
  String get registerAccountBenefitsIntro;

  /// Dialog content explaining what to do when the email is already in use during linking.
  ///
  /// In de, this message translates to:
  /// **'So wie es aussieht, hast du versehentlich einen zweiten Sharezone-Account erstellt. Lösche einfach diesen Account und melde dich mit deinem richtigen Account an.\n\nFür den Fall, dass du nicht genau weißt, wie das funktioniert, haben wir für dich eine Anleitung vorbereitet :)'**
  String get registerAccountEmailAlreadyUsedContent;

  /// Dialog title when the email is already in use during linking.
  ///
  /// In de, this message translates to:
  /// **'Diese E-Mail wird schon verwendet!'**
  String get registerAccountEmailAlreadyUsedTitle;

  /// Label for the long email sign-in button.
  ///
  /// In de, this message translates to:
  /// **'Mit E-Mail anmelden'**
  String get registerAccountEmailButtonLong;

  /// Label for the short email sign-in button.
  ///
  /// In de, this message translates to:
  /// **'E-Mail'**
  String get registerAccountEmailButtonShort;

  /// Snackbar text when an email account link succeeds.
  ///
  /// In de, this message translates to:
  /// **'Dein Account wurde mit einem E-Mail-Konto verknüpft.'**
  String get registerAccountEmailLinkConfirmation;

  /// Label for the long Google sign-in button.
  ///
  /// In de, this message translates to:
  /// **'Mit Google anmelden'**
  String get registerAccountGoogleButtonLong;

  /// Label for the short Google sign-in button.
  ///
  /// In de, this message translates to:
  /// **'Google'**
  String get registerAccountGoogleButtonShort;

  /// Label for the dialog action that opens the instructions for using multiple devices.
  ///
  /// In de, this message translates to:
  /// **'Anleitung zeigen'**
  String get registerAccountShowInstructionAction;

  /// Helper text shown above the description field on the report page.
  ///
  /// In de, this message translates to:
  /// **'Bitte beschreibe uns, warum du diesen Inhalt melden möchtest. Gib uns dabei möglichst viele Informationen, damit wir den Fall schnell und sicher bearbeiten können.'**
  String get reportDescriptionHelperText;

  /// Label of the description text field on the report page.
  ///
  /// In de, this message translates to:
  /// **'Beschreibung'**
  String get reportDescriptionLabel;

  /// Content of the confirmation dialog before sending a report.
  ///
  /// In de, this message translates to:
  /// **'Wir werden den Fall schnellstmöglich bearbeiten!\n\nBitte beachte, dass ein mehrfacher Missbrauch des Report-Systems Konsequenzen für dich haben kann (z.B. Sperrung deines Accounts).'**
  String get reportDialogContent;

  /// Label for sending a report, used for dialog action and tooltip.
  ///
  /// In de, this message translates to:
  /// **'Senden'**
  String get reportDialogSendAction;

  /// Label for the reported item type blackboard/notice.
  ///
  /// In de, this message translates to:
  /// **'Infozettel'**
  String get reportItemTypeBlackboard;

  /// Label for the reported item type comment.
  ///
  /// In de, this message translates to:
  /// **'Kommentar'**
  String get reportItemTypeComment;

  /// Label for the reported item type course.
  ///
  /// In de, this message translates to:
  /// **'Kurs'**
  String get reportItemTypeCourse;

  /// Label for the reported item type event or exam.
  ///
  /// In de, this message translates to:
  /// **'Termin / Prüfung'**
  String get reportItemTypeEvent;

  /// Label for the reported item type file.
  ///
  /// In de, this message translates to:
  /// **'Datei'**
  String get reportItemTypeFile;

  /// Label for the reported item type homework.
  ///
  /// In de, this message translates to:
  /// **'Hausaufgabe'**
  String get reportItemTypeHomework;

  /// Label for the reported item type lesson.
  ///
  /// In de, this message translates to:
  /// **'Stunde'**
  String get reportItemTypeLesson;

  /// Label for the reported item type school class.
  ///
  /// In de, this message translates to:
  /// **'Schulklasse'**
  String get reportItemTypeSchoolClass;

  /// Label for the reported item type user.
  ///
  /// In de, this message translates to:
  /// **'Nutzer'**
  String get reportItemTypeUser;

  /// Error message shown when required report information is missing.
  ///
  /// In de, this message translates to:
  /// **'Bitte einen Grund und eine Beschreibung an.'**
  String get reportMissingInformation;

  /// Title for the report page and tooltip when reporting an item.
  ///
  /// In de, this message translates to:
  /// **'{itemType} melden'**
  String reportPageTitle(String itemType);

  /// No description provided for @selectStateDialogSelectBundesland.
  ///
  /// In de, this message translates to:
  /// **'Bundesland auswählen'**
  String get selectStateDialogSelectBundesland;

  /// No description provided for @selectStateDialogSelectCanton.
  ///
  /// In de, this message translates to:
  /// **'Kanton auswählen'**
  String get selectStateDialogSelectCanton;

  /// No description provided for @selectStateDialogSelectCountryTitle.
  ///
  /// In de, this message translates to:
  /// **'Land auswählen'**
  String get selectStateDialogSelectCountryTitle;

  /// No description provided for @selectStateDialogStayAnonymous.
  ///
  /// In de, this message translates to:
  /// **'Ich möchte anonym bleiben'**
  String get selectStateDialogStayAnonymous;

  /// Reason option for bullying.
  ///
  /// In de, this message translates to:
  /// **'Mobbing'**
  String get reportReasonBullying;

  /// Reason option for illegal content.
  ///
  /// In de, this message translates to:
  /// **'Rechtswidrige Inhalte'**
  String get reportReasonIllegalContent;

  /// Reason option for other reasons.
  ///
  /// In de, this message translates to:
  /// **'Sonstiges'**
  String get reportReasonOther;

  /// Reason option for pornographic content.
  ///
  /// In de, this message translates to:
  /// **'Pornografische Inhalte'**
  String get reportReasonPornographicContent;

  /// Reason option for spam.
  ///
  /// In de, this message translates to:
  /// **'Spam'**
  String get reportReasonSpam;

  /// Reason option for violent or repulsive content.
  ///
  /// In de, this message translates to:
  /// **'Gewaltsame oder abstoßende Inhalte'**
  String get reportReasonViolentContent;

  /// No description provided for @socialDiscord.
  ///
  /// In de, this message translates to:
  /// **'Discord'**
  String get socialDiscord;

  /// No description provided for @socialEmail.
  ///
  /// In de, this message translates to:
  /// **'E-Mail'**
  String get socialEmail;

  /// No description provided for @socialGitHub.
  ///
  /// In de, this message translates to:
  /// **'GitHub'**
  String get socialGitHub;

  /// No description provided for @socialInstagram.
  ///
  /// In de, this message translates to:
  /// **'Instagram'**
  String get socialInstagram;

  /// No description provided for @socialLinkedIn.
  ///
  /// In de, this message translates to:
  /// **'LinkedIn'**
  String get socialLinkedIn;

  /// No description provided for @socialTwitter.
  ///
  /// In de, this message translates to:
  /// **'Twitter'**
  String get socialTwitter;

  /// No description provided for @stateAargau.
  ///
  /// In de, this message translates to:
  /// **'Aargau'**
  String get stateAargau;

  /// No description provided for @stateAnonymous.
  ///
  /// In de, this message translates to:
  /// **'Anonym bleiben'**
  String get stateAnonymous;

  /// No description provided for @stateAppenzellAusserrhoden.
  ///
  /// In de, this message translates to:
  /// **'Appenzell Ausserrhoden'**
  String get stateAppenzellAusserrhoden;

  /// No description provided for @stateAppenzellInnerrhoden.
  ///
  /// In de, this message translates to:
  /// **'Appenzell Innerrhoden'**
  String get stateAppenzellInnerrhoden;

  /// No description provided for @stateBadenWuerttemberg.
  ///
  /// In de, this message translates to:
  /// **'Baden-Württemberg'**
  String get stateBadenWuerttemberg;

  /// No description provided for @stateBaselLandschaft.
  ///
  /// In de, this message translates to:
  /// **'Basel-Landschaft'**
  String get stateBaselLandschaft;

  /// No description provided for @stateBaselStadt.
  ///
  /// In de, this message translates to:
  /// **'Basel-Stadt'**
  String get stateBaselStadt;

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

  /// No description provided for @stateBern.
  ///
  /// In de, this message translates to:
  /// **'Bern'**
  String get stateBern;

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

  /// No description provided for @stateBurgenland.
  ///
  /// In de, this message translates to:
  /// **'Burgenland'**
  String get stateBurgenland;

  /// No description provided for @stateFribourg.
  ///
  /// In de, this message translates to:
  /// **'Freiburg'**
  String get stateFribourg;

  /// No description provided for @stateGeneva.
  ///
  /// In de, this message translates to:
  /// **'Genf'**
  String get stateGeneva;

  /// No description provided for @stateGlarus.
  ///
  /// In de, this message translates to:
  /// **'Glarus'**
  String get stateGlarus;

  /// No description provided for @stateGraubuenden.
  ///
  /// In de, this message translates to:
  /// **'Graubünden'**
  String get stateGraubuenden;

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

  /// No description provided for @stateJura.
  ///
  /// In de, this message translates to:
  /// **'Jura'**
  String get stateJura;

  /// No description provided for @stateKaernten.
  ///
  /// In de, this message translates to:
  /// **'Kärnten'**
  String get stateKaernten;

  /// No description provided for @stateLuzern.
  ///
  /// In de, this message translates to:
  /// **'Luzern'**
  String get stateLuzern;

  /// No description provided for @stateMecklenburgVorpommern.
  ///
  /// In de, this message translates to:
  /// **'Mecklenburg-Vorpommern'**
  String get stateMecklenburgVorpommern;

  /// No description provided for @stateNeuchatel.
  ///
  /// In de, this message translates to:
  /// **'Neuenburg'**
  String get stateNeuchatel;

  /// No description provided for @stateNidwalden.
  ///
  /// In de, this message translates to:
  /// **'Nidwalden'**
  String get stateNidwalden;

  /// No description provided for @stateNiederoesterreich.
  ///
  /// In de, this message translates to:
  /// **'Niederösterreich'**
  String get stateNiederoesterreich;

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

  /// No description provided for @stateNotFromGermany.
  ///
  /// In de, this message translates to:
  /// **'Nicht aus Deutschland'**
  String get stateNotFromGermany;

  /// No description provided for @stateNotSelected.
  ///
  /// In de, this message translates to:
  /// **'Nicht ausgewählt'**
  String get stateNotSelected;

  /// No description provided for @stateOberoesterreich.
  ///
  /// In de, this message translates to:
  /// **'Oberösterreich'**
  String get stateOberoesterreich;

  /// No description provided for @stateObwalden.
  ///
  /// In de, this message translates to:
  /// **'Obwalden'**
  String get stateObwalden;

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

  /// No description provided for @stateSalzburg.
  ///
  /// In de, this message translates to:
  /// **'Salzburg'**
  String get stateSalzburg;

  /// No description provided for @stateSchaffhausen.
  ///
  /// In de, this message translates to:
  /// **'Schaffhausen'**
  String get stateSchaffhausen;

  /// No description provided for @stateSchleswigHolstein.
  ///
  /// In de, this message translates to:
  /// **'Schleswig-Holstein'**
  String get stateSchleswigHolstein;

  /// No description provided for @stateSchwyz.
  ///
  /// In de, this message translates to:
  /// **'Schwyz'**
  String get stateSchwyz;

  /// No description provided for @stateSolothurn.
  ///
  /// In de, this message translates to:
  /// **'Solothurn'**
  String get stateSolothurn;

  /// No description provided for @stateStGallen.
  ///
  /// In de, this message translates to:
  /// **'St. Gallen'**
  String get stateStGallen;

  /// No description provided for @stateSteiermark.
  ///
  /// In de, this message translates to:
  /// **'Steiermark'**
  String get stateSteiermark;

  /// No description provided for @stateThueringen.
  ///
  /// In de, this message translates to:
  /// **'Thüringen'**
  String get stateThueringen;

  /// No description provided for @stateThurgau.
  ///
  /// In de, this message translates to:
  /// **'Thurgau'**
  String get stateThurgau;

  /// No description provided for @stateTicino.
  ///
  /// In de, this message translates to:
  /// **'Tessin'**
  String get stateTicino;

  /// No description provided for @stateTirol.
  ///
  /// In de, this message translates to:
  /// **'Tirol'**
  String get stateTirol;

  /// No description provided for @stateUri.
  ///
  /// In de, this message translates to:
  /// **'Uri'**
  String get stateUri;

  /// No description provided for @stateValais.
  ///
  /// In de, this message translates to:
  /// **'Wallis'**
  String get stateValais;

  /// No description provided for @stateVaud.
  ///
  /// In de, this message translates to:
  /// **'Waadt'**
  String get stateVaud;

  /// No description provided for @stateVorarlberg.
  ///
  /// In de, this message translates to:
  /// **'Vorarlberg'**
  String get stateVorarlberg;

  /// No description provided for @stateWien.
  ///
  /// In de, this message translates to:
  /// **'Wien'**
  String get stateWien;

  /// No description provided for @stateZug.
  ///
  /// In de, this message translates to:
  /// **'Zug'**
  String get stateZug;

  /// No description provided for @stateZurich.
  ///
  /// In de, this message translates to:
  /// **'Zürich'**
  String get stateZurich;

  /// No description provided for @themeDarkMode.
  ///
  /// In de, this message translates to:
  /// **'Dunkler Modus'**
  String get themeDarkMode;

  /// No description provided for @themeLightDarkModeSectionTitle.
  ///
  /// In de, this message translates to:
  /// **'Heller & Dunkler Modus'**
  String get themeLightDarkModeSectionTitle;

  /// No description provided for @themeLightMode.
  ///
  /// In de, this message translates to:
  /// **'Heller Modus'**
  String get themeLightMode;

  /// No description provided for @themeNavigationExperimentOptionTile.
  ///
  /// In de, this message translates to:
  /// **'Option {number}: {name}'**
  String themeNavigationExperimentOptionTile(String name, int number);

  /// No description provided for @themeNavigationExperimentSectionContent.
  ///
  /// In de, this message translates to:
  /// **'Wir testen aktuell eine neue Navigation. Bitte gib über die Feedback-Box oder unseren Discord-Server eine kurze Rückmeldung, wie du die jeweiligen Optionen findest.'**
  String get themeNavigationExperimentSectionContent;

  /// No description provided for @themeNavigationExperimentSectionTitle.
  ///
  /// In de, this message translates to:
  /// **'Experiment: Neue Navigation'**
  String get themeNavigationExperimentSectionTitle;

  /// No description provided for @themeRateOurAppCardContent.
  ///
  /// In de, this message translates to:
  /// **'Falls dir Sharezone gefällt, würden wir uns über eine Bewertung sehr freuen! 🙏  Dir gefällt etwas nicht? Kontaktiere einfach den Support 👍'**
  String get themeRateOurAppCardContent;

  /// No description provided for @themeRateOurAppCardRateButton.
  ///
  /// In de, this message translates to:
  /// **'Bewerten'**
  String get themeRateOurAppCardRateButton;

  /// No description provided for @themeRateOurAppCardRatingsNotAvailableOnWebDialogContent.
  ///
  /// In de, this message translates to:
  /// **'Über die Web-App kann die App nicht bewertet werden. Nimm dafür einfach dein Handy 👍'**
  String get themeRateOurAppCardRatingsNotAvailableOnWebDialogContent;

  /// No description provided for @themeRateOurAppCardRatingsNotAvailableOnWebDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'App-Bewertung nur über iOS & Android möglich!'**
  String get themeRateOurAppCardRatingsNotAvailableOnWebDialogTitle;

  /// No description provided for @themeRateOurAppCardTitle.
  ///
  /// In de, this message translates to:
  /// **'Gefällt dir Sharezone?'**
  String get themeRateOurAppCardTitle;

  /// No description provided for @themeSystemMode.
  ///
  /// In de, this message translates to:
  /// **'System'**
  String get themeSystemMode;

  /// No description provided for @themeTitle.
  ///
  /// In de, this message translates to:
  /// **'Erscheinungsbild'**
  String get themeTitle;

  /// No description provided for @timetableSettingsABWeekTileTitle.
  ///
  /// In de, this message translates to:
  /// **'A/B Wochen'**
  String get timetableSettingsABWeekTileTitle;

  /// No description provided for @timetableSettingsAWeeksAreEvenSwitch.
  ///
  /// In de, this message translates to:
  /// **'A-Wochen sind gerade Kalenderwochen'**
  String get timetableSettingsAWeeksAreEvenSwitch;

  /// No description provided for @timetableSettingsEnabledWeekDaysTileTitle.
  ///
  /// In de, this message translates to:
  /// **'Aktivierte Wochentage'**
  String get timetableSettingsEnabledWeekDaysTileTitle;

  /// No description provided for @timetableSettingsIcalLinksPlusDialogContent.
  ///
  /// In de, this message translates to:
  /// **'Mit einem iCal-Link kannst du deinen Stundenplan und deine Termine in andere Kalender-Apps (wie z.B. Google Kalender, Apple Kalender) einbinden. Sobald sich dein Stundenplan oder deine Termine ändern, werden diese auch in deinen anderen Kalender Apps aktualisiert.\n\nAnders als beim \"Zum Kalender hinzufügen\" Button, musst du dich nicht darum kümmern, den Termin in deiner Kalender App zu aktualisieren, wenn sich etwas in Sharezone ändert.\n\niCal-Links ist nur für dich sichtbar und können nicht von anderen Personen eingesehen werden.\n\nBitte beachte, dass aktuell nur Termine und Prüfungen exportiert werden können. Die Schulstunden können noch nicht exportiert werden.'**
  String get timetableSettingsIcalLinksPlusDialogContent;

  /// No description provided for @timetableSettingsIcalLinksTitleSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Synchronisierung mit Google Kalender, Apple Kalender usw.'**
  String get timetableSettingsIcalLinksTitleSubtitle;

  /// No description provided for @timetableSettingsIcalLinksTitleTitle.
  ///
  /// In de, this message translates to:
  /// **'Termine, Prüfungen, Stundenplan exportieren (iCal)'**
  String get timetableSettingsIcalLinksTitleTitle;

  /// No description provided for @timetableSettingsIsFiveMinutesIntervalActiveTileTitle.
  ///
  /// In de, this message translates to:
  /// **'Fünf-Minuten-Intervall beim Time-Picker'**
  String get timetableSettingsIsFiveMinutesIntervalActiveTileTitle;

  /// No description provided for @timetableSettingsLessonLengthEditDialog.
  ///
  /// In de, this message translates to:
  /// **'Wähle die Länge der Stunde in Minuten aus.'**
  String get timetableSettingsLessonLengthEditDialog;

  /// No description provided for @timetableSettingsLessonLengthSavedConfirmation.
  ///
  /// In de, this message translates to:
  /// **'Länge einer Stunde wurde gespeichert.'**
  String get timetableSettingsLessonLengthSavedConfirmation;

  /// No description provided for @timetableSettingsLessonLengthTileSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Länge einer Stunde'**
  String get timetableSettingsLessonLengthTileSubtitle;

  /// No description provided for @timetableSettingsLessonLengthTileTitle.
  ///
  /// In de, this message translates to:
  /// **'Länge einer Stunde'**
  String get timetableSettingsLessonLengthTileTitle;

  /// A text that displays the length for lessons in minutes.
  ///
  /// In de, this message translates to:
  /// **'{length} Min.'**
  String timetableSettingsLessonLengthTileTrailing(int length);

  /// No description provided for @timetableSettingsPeriodsFieldTileSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Stundenplanbeginn, Stundenlänge, etc.'**
  String get timetableSettingsPeriodsFieldTileSubtitle;

  /// No description provided for @timetableSettingsPeriodsFieldTileTitle.
  ///
  /// In de, this message translates to:
  /// **'Stundenzeiten'**
  String get timetableSettingsPeriodsFieldTileTitle;

  /// No description provided for @timetableSettingsShowLessonsAbbreviation.
  ///
  /// In de, this message translates to:
  /// **'Kürzel im Stundenplan anzeigen'**
  String get timetableSettingsShowLessonsAbbreviation;

  /// A text that is displayed below the set if the current week is a or b week
  ///
  /// In de, this message translates to:
  /// **'Diese Woche ist Kalenderwoche {calendar_week}. A-Wochen sind {is_a_week_even} Kalenderwochen und somit ist aktuell eine {even_or_odd_week}'**
  String timetableSettingsThisWeekIs(
    int calendar_week,
    String even_or_odd_week,
    String is_a_week_even,
  );

  /// No description provided for @timetableSettingsTitle.
  ///
  /// In de, this message translates to:
  /// **'Stundenplan'**
  String get timetableSettingsTitle;

  /// App bar title for the instructions on using multiple devices.
  ///
  /// In de, this message translates to:
  /// **'Anleitung'**
  String get useAccountInstructionsAppBarTitle;

  /// Headline question for using Sharezone on multiple devices.
  ///
  /// In de, this message translates to:
  /// **'Wie nutze ich Sharezone auf mehreren Geräten?'**
  String get useAccountInstructionsHeadline;

  /// No description provided for @useAccountInstructionsStep.
  ///
  /// In de, this message translates to:
  /// **'1. Gehe zurück zu deinem Profil\n2. Melde dich über das Sign-Out-Icon rechts oben ab.\n3. Bestätige, dass dabei dein Konto gelöscht wird.\n4. Klicke unten auf den Button \"Du hast schon ein Konto? Dann...\"\n5. Melde dich an.'**
  String get useAccountInstructionsStep;

  /// Title above the list of steps for using multiple devices.
  ///
  /// In de, this message translates to:
  /// **'Schritte:'**
  String get useAccountInstructionsStepsTitle;

  /// Title above the explanatory video for using multiple devices.
  ///
  /// In de, this message translates to:
  /// **'Video:'**
  String get useAccountInstructionsVideoTitle;

  /// Snackbar text while waiting for the user data to load before opening the edit screen.
  ///
  /// In de, this message translates to:
  /// **'Informationen werden geladen! Warte kurz.'**
  String get userEditLoadingUserSnackbar;

  /// Snackbar text confirming that the user's name was changed.
  ///
  /// In de, this message translates to:
  /// **'Dein Name wurde erfolgreich umbenannt.'**
  String get userEditNameChangedConfirmation;

  /// Title for the edit name page.
  ///
  /// In de, this message translates to:
  /// **'Name bearbeiten'**
  String get userEditPageTitle;

  /// Error snackbar text when saving the edited name failed.
  ///
  /// In de, this message translates to:
  /// **'Der Vorgang konnte nicht korrekt abgeschlossen werden. Bitte kontaktiere den Support!'**
  String get userEditSubmitFailed;

  /// Loading snackbar text shown while the edit form submits.
  ///
  /// In de, this message translates to:
  /// **'Daten werden nach Frankfurt transportiert...'**
  String get userEditSubmittingSnackbar;
}

class _SharezoneLocalizationsDelegate
    extends LocalizationsDelegate<SharezoneLocalizations> {
  const _SharezoneLocalizationsDelegate();

  @override
  Future<SharezoneLocalizations> load(Locale locale) {
    return SynchronousFuture<SharezoneLocalizations>(
      lookupSharezoneLocalizations(locale),
    );
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
    'that was used.',
  );
}
