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

  /// No description provided for @activationCodeCacheCleared.
  ///
  /// In de, this message translates to:
  /// **'Cache geleert. Möglicherweise ist ein App-Neustart notwendig, um die Änderungen zu sehen.'**
  String get activationCodeCacheCleared;

  /// No description provided for @activationCodeFeatureAdsLabel.
  ///
  /// In de, this message translates to:
  /// **'Ads'**
  String get activationCodeFeatureAdsLabel;

  /// No description provided for @activationCodeFeatureL10nLabel.
  ///
  /// In de, this message translates to:
  /// **'l10n'**
  String get activationCodeFeatureL10nLabel;

  /// No description provided for @activationCodeToggleDisabled.
  ///
  /// In de, this message translates to:
  /// **'deaktiviert'**
  String get activationCodeToggleDisabled;

  /// No description provided for @activationCodeToggleEnabled.
  ///
  /// In de, this message translates to:
  /// **'aktiviert'**
  String get activationCodeToggleEnabled;

  /// No description provided for @activationCodeToggleResult.
  ///
  /// In de, this message translates to:
  /// **'{feature} wurde {state}. Starte die App neu, um die Änderungen zu sehen.'**
  String activationCodeToggleResult(String feature, String state);

  /// No description provided for @appName.
  ///
  /// In de, this message translates to:
  /// **'Sharezone'**
  String get appName;

  /// Display name template for users without a chosen name.
  ///
  /// In de, this message translates to:
  /// **'Anonymer {animalName}'**
  String authAnonymousDisplayName(Object animalName);

  /// No description provided for @authProviderAnonymous.
  ///
  /// In de, this message translates to:
  /// **'Anonyme Anmeldung'**
  String get authProviderAnonymous;

  /// No description provided for @authProviderApple.
  ///
  /// In de, this message translates to:
  /// **'Apple Sign In'**
  String get authProviderApple;

  /// No description provided for @authProviderEmailAndPassword.
  ///
  /// In de, this message translates to:
  /// **'E-Mail und Passwort'**
  String get authProviderEmailAndPassword;

  /// No description provided for @authProviderGoogle.
  ///
  /// In de, this message translates to:
  /// **'Google Sign In'**
  String get authProviderGoogle;

  /// No description provided for @authValidationInvalidEmail.
  ///
  /// In de, this message translates to:
  /// **'Gib eine gueltige E-Mail ein'**
  String get authValidationInvalidEmail;

  /// No description provided for @authValidationInvalidName.
  ///
  /// In de, this message translates to:
  /// **'Ungueltiger Name'**
  String get authValidationInvalidName;

  /// No description provided for @authValidationInvalidPasswordTooShort.
  ///
  /// In de, this message translates to:
  /// **'Ungueltiges Passwort, bitte gib mehr als 8 Zeichen ein'**
  String get authValidationInvalidPasswordTooShort;

  /// Error message shown when a blackboard entry is missing a course.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib einen Kurs an!'**
  String get blackboardErrorCourseMissing;

  /// Error message shown when a blackboard entry title is missing.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib einen Titel für den Eintrag an!'**
  String get blackboardErrorTitleMissing;

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

  /// No description provided for @commonActionsCancelUppercase.
  ///
  /// In de, this message translates to:
  /// **'ABBRECHEN'**
  String get commonActionsCancelUppercase;

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

  /// No description provided for @commonActionsContinue.
  ///
  /// In de, this message translates to:
  /// **'Weiter'**
  String get commonActionsContinue;

  /// No description provided for @commonActionsDelete.
  ///
  /// In de, this message translates to:
  /// **'Löschen'**
  String get commonActionsDelete;

  /// No description provided for @commonActionsDeleteUppercase.
  ///
  /// In de, this message translates to:
  /// **'LÖSCHEN'**
  String get commonActionsDeleteUppercase;

  /// No description provided for @commonActionsLeave.
  ///
  /// In de, this message translates to:
  /// **'Verlassen'**
  String get commonActionsLeave;

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

  /// Error message shown when the course subject is missing.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib ein Fach an!'**
  String get commonErrorCourseSubjectMissing;

  /// Error message shown when the credential is already in use.
  ///
  /// In de, this message translates to:
  /// **'Es existiert bereits ein Nutzer mit dieser Anmeldemethode!'**
  String get commonErrorCredentialAlreadyInUse;

  /// Error message shown when a date is missing.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib ein Datum an!'**
  String get commonErrorDateMissing;

  /// Error message shown when an email is already in use.
  ///
  /// In de, this message translates to:
  /// **'Diese E-Mail Adresse wird bereits von einem anderen Nutzer verwendet.'**
  String get commonErrorEmailAlreadyInUse;

  /// Error message shown when an email has an invalid format.
  ///
  /// In de, this message translates to:
  /// **'Die E-Mail hat ein ungültiges Format.'**
  String get commonErrorEmailInvalidFormat;

  /// Error message shown when the email field is missing.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib deine E-Mail an.'**
  String get commonErrorEmailMissing;

  /// Error message shown when provided data is invalid.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib die Daten korrekt an!'**
  String get commonErrorIncorrectData;

  /// Error message shown when a share code is invalid.
  ///
  /// In de, this message translates to:
  /// **'Ungültiger Sharecode!'**
  String get commonErrorIncorrectSharecode;

  /// Generic error message shown when the user input is invalid.
  ///
  /// In de, this message translates to:
  /// **'Bitte überprüfe deine Eingabe!'**
  String get commonErrorInvalidInput;

  /// Error message shown when macOS Keychain sign-in fails.
  ///
  /// In de, this message translates to:
  /// **'Es gab einen Fehler beim Anmelden. Um diesen zu beheben, wähle die Option \'Immer erlauben\' bei der Passworteingabe bei dem Dialog für den macOS-Schlüsselbund (Keychain) aus.'**
  String get commonErrorKeychainSignInFailed;

  /// Error message shown when a name is missing.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib einen Namen an!'**
  String get commonErrorNameMissing;

  /// Error message shown when a name is too short.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib einen Namen an, der mehr als ein Zeichen hat.'**
  String get commonErrorNameTooShort;

  /// Error message shown when the name has not changed.
  ///
  /// In de, this message translates to:
  /// **'Dieser Name ist doch der gleiche wie vorher 😅'**
  String get commonErrorNameUnchanged;

  /// Error message shown when a network request failed.
  ///
  /// In de, this message translates to:
  /// **'Es gab einen Netzwerkfehler, weil keine stabile Internetverbindung besteht.'**
  String get commonErrorNetworkRequestFailed;

  /// Error message shown when the new password field is missing.
  ///
  /// In de, this message translates to:
  /// **'Oh, du hast vergessen dein neues Passwort einzugeben 😬'**
  String get commonErrorNewPasswordMissing;

  /// Error message shown when no Google account was selected.
  ///
  /// In de, this message translates to:
  /// **'Bitte wähle einen Account aus.'**
  String get commonErrorNoGoogleAccountSelected;

  /// Error message shown when there is no internet connection.
  ///
  /// In de, this message translates to:
  /// **'Dein Gerät hat leider keinen Zugang zum Internet...'**
  String get commonErrorNoInternetAccess;

  /// Error message shown when the password field is missing.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib dein Passwort an.'**
  String get commonErrorPasswordMissing;

  /// Error message shown when the entered name matches the previous one.
  ///
  /// In de, this message translates to:
  /// **'Das ist doch der selbe Name wie vorher 🙈'**
  String get commonErrorSameNameAsBefore;

  /// Error message shown when a title is missing.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib einen Titel an!'**
  String get commonErrorTitleMissing;

  /// Error message shown when too many requests were made.
  ///
  /// In de, this message translates to:
  /// **'Wir haben alle Anfragen von diesem Gerät aufgrund ungewöhnlicher Aktivitäten blockiert. Versuchen Sie es später noch einmal.'**
  String get commonErrorTooManyRequests;

  /// Fallback error message for unknown errors.
  ///
  /// In de, this message translates to:
  /// **'Es ist ein unbekannter Fehler ({error}) aufgetreten! Bitte kontaktiere den Support.'**
  String commonErrorUnknown(Object error);

  /// Error message shown when the account is disabled.
  ///
  /// In de, this message translates to:
  /// **'Dieser Account wurde von einem Administrator deaktiviert'**
  String get commonErrorUserDisabled;

  /// Error message shown when no user is found for the email address.
  ///
  /// In de, this message translates to:
  /// **'Es wurde kein Nutzer mit dieser E-Mail Adresse gefunden... Inaktive Nutzer werden nach 2 Jahren gelöscht.'**
  String get commonErrorUserNotFound;

  /// Error message shown when the password is too weak.
  ///
  /// In de, this message translates to:
  /// **'Dieses Passwort ist zu schwach. Bitte wähle eine stärkeres Passwort.'**
  String get commonErrorWeakPassword;

  /// Error message shown when the entered password is incorrect.
  ///
  /// In de, this message translates to:
  /// **'Das eingegebene Passwort ist falsch.'**
  String get commonErrorWrongPassword;

  /// No description provided for @commonLoadingPleaseWait.
  ///
  /// In de, this message translates to:
  /// **'Bitte warten...'**
  String get commonLoadingPleaseWait;

  /// No description provided for @commonStatusFailed.
  ///
  /// In de, this message translates to:
  /// **'Fehlgeschlagen'**
  String get commonStatusFailed;

  /// No description provided for @commonStatusNoInternetDescription.
  ///
  /// In de, this message translates to:
  /// **'Bitte überprüfen Sie die Internetverbindung.'**
  String get commonStatusNoInternetDescription;

  /// No description provided for @commonStatusNoInternetTitle.
  ///
  /// In de, this message translates to:
  /// **'Fehler: Keine Internetverbindung'**
  String get commonStatusNoInternetTitle;

  /// No description provided for @commonStatusSuccessful.
  ///
  /// In de, this message translates to:
  /// **'Erfolgreich'**
  String get commonStatusSuccessful;

  /// No description provided for @commonStatusUnknownErrorDescription.
  ///
  /// In de, this message translates to:
  /// **'Ein unbekannter Fehler ist aufgetreten! 😭'**
  String get commonStatusUnknownErrorDescription;

  /// No description provided for @commonStatusUnknownErrorTitle.
  ///
  /// In de, this message translates to:
  /// **'Unbekannter Fehler'**
  String get commonStatusUnknownErrorTitle;

  /// No description provided for @commonTitleNote.
  ///
  /// In de, this message translates to:
  /// **'Hinweis'**
  String get commonTitleNote;

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

  /// Week type for lessons that occur on week A.
  ///
  /// In de, this message translates to:
  /// **'A-Woche'**
  String get dateWeekTypeA;

  /// Week type for lessons that occur every week.
  ///
  /// In de, this message translates to:
  /// **'Immer'**
  String get dateWeekTypeAlways;

  /// Week type for lessons that occur on week B.
  ///
  /// In de, this message translates to:
  /// **'B-Woche'**
  String get dateWeekTypeB;

  /// Weekday name for Friday.
  ///
  /// In de, this message translates to:
  /// **'Freitag'**
  String get dateWeekdayFriday;

  /// Weekday name for Monday.
  ///
  /// In de, this message translates to:
  /// **'Montag'**
  String get dateWeekdayMonday;

  /// Weekday name for Saturday.
  ///
  /// In de, this message translates to:
  /// **'Samstag'**
  String get dateWeekdaySaturday;

  /// Weekday name for Sunday.
  ///
  /// In de, this message translates to:
  /// **'Sonntag'**
  String get dateWeekdaySunday;

  /// Weekday name for Thursday.
  ///
  /// In de, this message translates to:
  /// **'Donnerstag'**
  String get dateWeekdayThursday;

  /// Weekday name for Tuesday.
  ///
  /// In de, this message translates to:
  /// **'Dienstag'**
  String get dateWeekdayTuesday;

  /// Weekday name for Wednesday.
  ///
  /// In de, this message translates to:
  /// **'Mittwoch'**
  String get dateWeekdayWednesday;

  /// Label for yesterday in fuzzy date strings.
  ///
  /// In de, this message translates to:
  /// **'Gestern'**
  String get dateYesterday;

  /// No description provided for @feedbackDetailsCommentsTitle.
  ///
  /// In de, this message translates to:
  /// **'Kommentare:'**
  String get feedbackDetailsCommentsTitle;

  /// No description provided for @feedbackDetailsLoadingHeardFrom.
  ///
  /// In de, this message translates to:
  /// **'Freund'**
  String get feedbackDetailsLoadingHeardFrom;

  /// No description provided for @feedbackDetailsLoadingMissing.
  ///
  /// In de, this message translates to:
  /// **'Tolle App!'**
  String get feedbackDetailsLoadingMissing;

  /// No description provided for @feedbackDetailsPageTitle.
  ///
  /// In de, this message translates to:
  /// **'Feedback-Details'**
  String get feedbackDetailsPageTitle;

  /// No description provided for @feedbackDetailsResponseHint.
  ///
  /// In de, this message translates to:
  /// **'Antwort schreiben...'**
  String get feedbackDetailsResponseHint;

  /// No description provided for @feedbackDetailsSendError.
  ///
  /// In de, this message translates to:
  /// **'Fehler beim Senden der Nachricht: {error}'**
  String feedbackDetailsSendError(String error);

  /// No description provided for @feedbackNewLineHint.
  ///
  /// In de, this message translates to:
  /// **'Shift + Enter für neue Zeile'**
  String get feedbackNewLineHint;

  /// No description provided for @feedbackSendTooltip.
  ///
  /// In de, this message translates to:
  /// **'Senden (Enter)'**
  String get feedbackSendTooltip;

  /// No description provided for @homeworkSectionDayAfterTomorrow.
  ///
  /// In de, this message translates to:
  /// **'Übermorgen'**
  String get homeworkSectionDayAfterTomorrow;

  /// No description provided for @homeworkSectionLater.
  ///
  /// In de, this message translates to:
  /// **'Später'**
  String get homeworkSectionLater;

  /// No description provided for @homeworkSectionOverdue.
  ///
  /// In de, this message translates to:
  /// **'Überfällig'**
  String get homeworkSectionOverdue;

  /// No description provided for @homeworkSectionToday.
  ///
  /// In de, this message translates to:
  /// **'Heute'**
  String get homeworkSectionToday;

  /// No description provided for @homeworkSectionTomorrow.
  ///
  /// In de, this message translates to:
  /// **'Morgen'**
  String get homeworkSectionTomorrow;

  /// No description provided for @homeworkTodoDateTime.
  ///
  /// In de, this message translates to:
  /// **'{date} - {time} Uhr'**
  String homeworkTodoDateTime(String date, String time);

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

  /// No description provided for @launchMarkdownLinkWithWarningActualLink.
  ///
  /// In de, this message translates to:
  /// **'Tatsächliche Adresse'**
  String get launchMarkdownLinkWithWarningActualLink;

  /// No description provided for @launchMarkdownLinkWithWarningCouldNotOpenLink.
  ///
  /// In de, this message translates to:
  /// **'Der Link konnte nicht geöffnet werden!'**
  String get launchMarkdownLinkWithWarningCouldNotOpenLink;

  /// No description provided for @launchMarkdownLinkWithWarningDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Link überprüfen'**
  String get launchMarkdownLinkWithWarningDialogTitle;

  /// No description provided for @launchMarkdownLinkWithWarningDisplayedText.
  ///
  /// In de, this message translates to:
  /// **'Angezeigter Text'**
  String get launchMarkdownLinkWithWarningDisplayedText;

  /// No description provided for @launchMarkdownLinkWithWarningDoNotAskAgain.
  ///
  /// In de, this message translates to:
  /// **'Beim nächsten Mal nicht mehr nachfragen.'**
  String get launchMarkdownLinkWithWarningDoNotAskAgain;

  /// No description provided for @launchMarkdownLinkWithWarningLinkTextDoesNotMatch.
  ///
  /// In de, this message translates to:
  /// **'Der Link-Text stimmt nicht mit der tatsächlichen Adresse überein.'**
  String get launchMarkdownLinkWithWarningLinkTextDoesNotMatch;

  /// No description provided for @launchMarkdownLinkWithWarningOpenLink.
  ///
  /// In de, this message translates to:
  /// **'Link öffnen'**
  String get launchMarkdownLinkWithWarningOpenLink;

  /// Text for the checkbox to trust a domain
  ///
  /// In de, this message translates to:
  /// **'Domain {domain} vertrauen'**
  String launchMarkdownLinkWithWarningTrustDomain(String domain);

  /// No description provided for @legalChangeAppearance.
  ///
  /// In de, this message translates to:
  /// **'Darstellung ändern'**
  String get legalChangeAppearance;

  /// No description provided for @legalDownloadAsPdf.
  ///
  /// In de, this message translates to:
  /// **'Als PDF herunterladen'**
  String get legalDownloadAsPdf;

  /// Label for the last updated date in legal documents.
  ///
  /// In de, this message translates to:
  /// **'Zuletzt aktualisiert: {date}'**
  String legalMetadataLastUpdated(String date);

  /// No description provided for @legalMetadataTitle.
  ///
  /// In de, this message translates to:
  /// **'Metadaten'**
  String get legalMetadataTitle;

  /// Label for the metadata version in legal documents.
  ///
  /// In de, this message translates to:
  /// **'Version: v{version}'**
  String legalMetadataVersion(String version);

  /// No description provided for @legalMoreOptions.
  ///
  /// In de, this message translates to:
  /// **'Weitere Optionen'**
  String get legalMoreOptions;

  /// Shown under the privacy policy heading with the effective date.
  ///
  /// In de, this message translates to:
  /// **'Diese aktualisierte Datenschutzerklärung tritt am {date} in Kraft.'**
  String legalPrivacyPolicyEffectiveDate(String date);

  /// No description provided for @legalPrivacyPolicyTitle.
  ///
  /// In de, this message translates to:
  /// **'Datenschutzerklärung'**
  String get legalPrivacyPolicyTitle;

  /// No description provided for @legalTableOfContents.
  ///
  /// In de, this message translates to:
  /// **'Inhaltsverzeichnis'**
  String get legalTableOfContents;

  /// No description provided for @legalTermsOfServiceTitle.
  ///
  /// In de, this message translates to:
  /// **'Allgemeine Nutzungsbedingungen'**
  String get legalTermsOfServiceTitle;

  /// No description provided for @memberRoleAdmin.
  ///
  /// In de, this message translates to:
  /// **'Admin'**
  String get memberRoleAdmin;

  /// No description provided for @memberRoleCreator.
  ///
  /// In de, this message translates to:
  /// **'Aktives Mitglied (Schreib- und Leserechte)'**
  String get memberRoleCreator;

  /// No description provided for @memberRoleNone.
  ///
  /// In de, this message translates to:
  /// **'Nichts'**
  String get memberRoleNone;

  /// No description provided for @memberRoleOwner.
  ///
  /// In de, this message translates to:
  /// **'Besitzer'**
  String get memberRoleOwner;

  /// No description provided for @memberRoleStandard.
  ///
  /// In de, this message translates to:
  /// **'Passives Mitglied (Nur Leserechte)'**
  String get memberRoleStandard;

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

  /// No description provided for @selectStateDialogConfirmationSnackBar.
  ///
  /// In de, this message translates to:
  /// **'Region {region} ausgewählt'**
  String selectStateDialogConfirmationSnackBar(Object region);

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

  /// No description provided for @sharezonePlusAdvantageAddToCalendarDescription.
  ///
  /// In de, this message translates to:
  /// **'Füge mit nur einem Klick einen Termin zu deinem lokalen Kalender hinzu (z.B. Apple oder Google Kalender).\n\nBeachte, dass die Funktion nur auf Android & iOS verfügbar ist. Zudem aktualisiert sich der Termin in deinem Kalender nicht automatisch, wenn dieser in Sharezone geändert wird.'**
  String get sharezonePlusAdvantageAddToCalendarDescription;

  /// No description provided for @sharezonePlusAdvantageAddToCalendarTitle.
  ///
  /// In de, this message translates to:
  /// **'Termine zum lokalen Kalender hinzufügen'**
  String get sharezonePlusAdvantageAddToCalendarTitle;

  /// No description provided for @sharezonePlusAdvantageDiscordDescription.
  ///
  /// In de, this message translates to:
  /// **'Erhalte den Discord Sharezone Plus Rang auf unserem [Discord-Server](https://sharezone.net/discord). Dieser Rang zeigt, dass du Sharezone Plus hast und gibt dir Zugriff auf einen exklusive Channel nur für Sharezone Plus Nutzer.'**
  String get sharezonePlusAdvantageDiscordDescription;

  /// No description provided for @sharezonePlusAdvantageDiscordTitle.
  ///
  /// In de, this message translates to:
  /// **'Discord Sharezone Plus Rang'**
  String get sharezonePlusAdvantageDiscordTitle;

  /// No description provided for @sharezonePlusAdvantageGradesDescription.
  ///
  /// In de, this message translates to:
  /// **'Speichere deine Schulnoten mit Sharezone Plus und behalte den Überblick über deine Leistungen. Schriftliche Prüfungen, mündliche Mitarbeit, Halbjahresnoten - alles an einem Ort.'**
  String get sharezonePlusAdvantageGradesDescription;

  /// No description provided for @sharezonePlusAdvantageGradesTitle.
  ///
  /// In de, this message translates to:
  /// **'Noten'**
  String get sharezonePlusAdvantageGradesTitle;

  /// No description provided for @sharezonePlusAdvantageHomeworkReminderDescription.
  ///
  /// In de, this message translates to:
  /// **'Mit Sharezone Plus kannst du die Erinnerung am Vortag für die Hausaufgaben individuell im 30-Minuten-Tack einstellen, z.B. 15:00 oder 15:30 Uhr. Dieses Feature ist nur für Schüler*innen verfügbar.'**
  String get sharezonePlusAdvantageHomeworkReminderDescription;

  /// No description provided for @sharezonePlusAdvantageHomeworkReminderTitle.
  ///
  /// In de, this message translates to:
  /// **'Individuelle Uhrzeit für Hausaufgaben-Erinnerungen'**
  String get sharezonePlusAdvantageHomeworkReminderTitle;

  /// No description provided for @sharezonePlusAdvantageIcalDescription.
  ///
  /// In de, this message translates to:
  /// **'Mit einem iCal-Link kannst du deinen Stundenplan und deine Termine in andere Kalender-Apps (wie z.B. Google Kalender, Apple Kalender) einbinden. Sobald sich dein Stundenplan oder deine Termine ändern, werden diese auch in deinen anderen Kalender Apps aktualisiert.\n\nAnders als beim \"Zum Kalender hinzufügen\" Button, musst du dich nicht darum kümmern, den Termin in deiner Kalender App zu aktualisieren, wenn sich etwas in Sharezone ändert.\n\niCal-Links ist nur für dich sichtbar und können nicht von anderen Personen eingesehen werden.\n\nBitte beachte, dass aktuell nur Termine und Prüfungen exportiert werden können. Die Schulstunden können noch nicht exportiert werden.'**
  String get sharezonePlusAdvantageIcalDescription;

  /// No description provided for @sharezonePlusAdvantageIcalTitle.
  ///
  /// In de, this message translates to:
  /// **'Stundenplan exportieren (iCal)'**
  String get sharezonePlusAdvantageIcalTitle;

  /// No description provided for @sharezonePlusAdvantageMoreColorsDescription.
  ///
  /// In de, this message translates to:
  /// **'Sharezone Plus bietet dir über 200 (statt 19) Farben für deine Gruppen. Setzt du mit Sharezone Plus eine Farbe für deine Gruppe, so können auch deine Gruppenmitglieder diese Farbe sehen.'**
  String get sharezonePlusAdvantageMoreColorsDescription;

  /// No description provided for @sharezonePlusAdvantageMoreColorsTitle.
  ///
  /// In de, this message translates to:
  /// **'Mehr Farben für die Gruppen'**
  String get sharezonePlusAdvantageMoreColorsTitle;

  /// No description provided for @sharezonePlusAdvantageOpenSourceDescription.
  ///
  /// In de, this message translates to:
  /// **'Sharezone ist Open-Source im Frontend. Das bedeutet, dass jeder den Quellcode von Sharezone einsehen und sogar verbessern kann. Wir glauben, dass Open-Source die Zukunft ist und wollen Sharezone zu einem Vorzeigeprojekt machen.\n\nGitHub: [https://github.com/SharezoneApp/sharezone-app](https://sharezone.net/github)'**
  String get sharezonePlusAdvantageOpenSourceDescription;

  /// No description provided for @sharezonePlusAdvantageOpenSourceTitle.
  ///
  /// In de, this message translates to:
  /// **'Unterstützung von Open-Source'**
  String get sharezonePlusAdvantageOpenSourceTitle;

  /// No description provided for @sharezonePlusAdvantagePastEventsDescription.
  ///
  /// In de, this message translates to:
  /// **'Mit Sharezone Plus kannst du alle vergangenen Termine, wie z.B. Prüfungen, einsehen.'**
  String get sharezonePlusAdvantagePastEventsDescription;

  /// No description provided for @sharezonePlusAdvantagePastEventsTitle.
  ///
  /// In de, this message translates to:
  /// **'Vergangene Termine einsehen'**
  String get sharezonePlusAdvantagePastEventsTitle;

  /// No description provided for @sharezonePlusAdvantagePremiumSupportDescription.
  ///
  /// In de, this message translates to:
  /// **'Mit Sharezone Plus erhältst du Zugriff auf unseren Premium Support:\n- Innerhalb von wenigen Stunden eine Rückmeldung per E-Mail (anstatt bis zu 2 Wochen)\n- Videocall-Support nach Terminvereinbarung (ermöglicht das Teilen des Bildschirms)'**
  String get sharezonePlusAdvantagePremiumSupportDescription;

  /// No description provided for @sharezonePlusAdvantagePremiumSupportTitle.
  ///
  /// In de, this message translates to:
  /// **'Premium Support'**
  String get sharezonePlusAdvantagePremiumSupportTitle;

  /// No description provided for @sharezonePlusAdvantageQuickDueDateDescription.
  ///
  /// In de, this message translates to:
  /// **'Mit Sharezone Plus kannst du das Fälligkeitsdatum einer Hausaufgaben mit nur einem Fingertipp auf den nächsten Schultag oder eine beliebige Stunde in der Zukunft setzen.'**
  String get sharezonePlusAdvantageQuickDueDateDescription;

  /// No description provided for @sharezonePlusAdvantageQuickDueDateTitle.
  ///
  /// In de, this message translates to:
  /// **'Schnellauswahl für Fälligkeitsdatum'**
  String get sharezonePlusAdvantageQuickDueDateTitle;

  /// No description provided for @sharezonePlusAdvantageReadByDescription.
  ///
  /// In de, this message translates to:
  /// **'Erhalte eine Liste mit allen Gruppenmitgliedern samt Lesestatus für jeden Infozettel - und stelle somit sicher, dass wichtige Informationen bei allen Mitgliedern angekommen sind.'**
  String get sharezonePlusAdvantageReadByDescription;

  /// No description provided for @sharezonePlusAdvantageReadByTitle.
  ///
  /// In de, this message translates to:
  /// **'Gelesen-Status bei Infozetteln'**
  String get sharezonePlusAdvantageReadByTitle;

  /// No description provided for @sharezonePlusAdvantageRemoveAdsDescription.
  ///
  /// In de, this message translates to:
  /// **'Genieße Sharezone komplett werbefrei.\n\nHinweis: Wir testen derzeit die Anzeige von Werbung. Es ist möglich, dass wir in Zukunft die Werbung wieder für alle Nutzer entfernen.'**
  String get sharezonePlusAdvantageRemoveAdsDescription;

  /// No description provided for @sharezonePlusAdvantageRemoveAdsTitle.
  ///
  /// In de, this message translates to:
  /// **'Werbung entfernen'**
  String get sharezonePlusAdvantageRemoveAdsTitle;

  /// No description provided for @sharezonePlusAdvantageStorageDescription.
  ///
  /// In de, this message translates to:
  /// **'Mit Sharezone Plus erhältst du 30 GB Speicherplatz (statt 100 MB) für deine Dateien & Anhänge (bei Hausaufgaben & Infozetteln). Dies entspricht ca. 15.000 Fotos (2 MB pro Bild).\n\nDie Begrenzung gilt nicht für Dateien, die als Abgabe bei Hausaufgaben hochgeladen wird.'**
  String get sharezonePlusAdvantageStorageDescription;

  /// No description provided for @sharezonePlusAdvantageStorageTitle.
  ///
  /// In de, this message translates to:
  /// **'30 GB Speicherplatz'**
  String get sharezonePlusAdvantageStorageTitle;

  /// No description provided for @sharezonePlusAdvantageSubstitutionsDescription.
  ///
  /// In de, this message translates to:
  /// **'Schalte mit Sharezone Plus den Vertretungsplan frei:\n* Entfall einer Schulstunden markieren\n* Raumänderungen\n\nSogar Kursmitglieder ohne Sharezone Plus können den Vertretungsplan einsehen (jedoch nicht ändern). Ebenfalls können Kursmitglieder mit nur einem 1-Klick über die Änderung informiert werden. \n\nBeachte, dass der Vertretungsplan manuell eingetragen werden muss und nicht automatisch importiert wird.'**
  String get sharezonePlusAdvantageSubstitutionsDescription;

  /// No description provided for @sharezonePlusAdvantageSubstitutionsTitle.
  ///
  /// In de, this message translates to:
  /// **'Vertretungsplan'**
  String get sharezonePlusAdvantageSubstitutionsTitle;

  /// No description provided for @sharezonePlusAdvantageTeacherTimetableDescription.
  ///
  /// In de, this message translates to:
  /// **'Trage den Name der Lehrkraft zur jeweiligen Schulstunde im Stundenplan ein. Für Kursmitglieder ohne Sharezone Plus wird die Lehrkraft ebenfalls angezeigt.'**
  String get sharezonePlusAdvantageTeacherTimetableDescription;

  /// No description provided for @sharezonePlusAdvantageTeacherTimetableTitle.
  ///
  /// In de, this message translates to:
  /// **'Lehrkraft im Stundenplan'**
  String get sharezonePlusAdvantageTeacherTimetableTitle;

  /// No description provided for @sharezonePlusAdvantageTimetableByClassDescription.
  ///
  /// In de, this message translates to:
  /// **'Du bist in mehreren Klassen? Mit Sharezone Plus kannst du den Stundenplan für jede Klasse einzeln auswählen. So siehst du immer den richtigen Stundenplan.'**
  String get sharezonePlusAdvantageTimetableByClassDescription;

  /// No description provided for @sharezonePlusAdvantageTimetableByClassTitle.
  ///
  /// In de, this message translates to:
  /// **'Stundenplan nach Klasse auswählen'**
  String get sharezonePlusAdvantageTimetableByClassTitle;

  /// No description provided for @sharezonePlusBuyAction.
  ///
  /// In de, this message translates to:
  /// **'Kaufen'**
  String get sharezonePlusBuyAction;

  /// No description provided for @sharezonePlusBuyingDisabledContent.
  ///
  /// In de, this message translates to:
  /// **'Der Kauf von Sharezone Plus ist aktuell deaktiviert. Bitte versuche es später erneut.\n\nAuf unserem [Discord](https://sharezone.net/discord) halten wir dich auf dem Laufenden.'**
  String get sharezonePlusBuyingDisabledContent;

  /// No description provided for @sharezonePlusBuyingDisabledTitle.
  ///
  /// In de, this message translates to:
  /// **'Kaufen deaktiviert'**
  String get sharezonePlusBuyingDisabledTitle;

  /// No description provided for @sharezonePlusBuyingFailedContent.
  ///
  /// In de, this message translates to:
  /// **'Der Kauf von Sharezone Plus ist fehlgeschlagen. Bitte versuche es später erneut.\n\nFehler: {error}\n\nBei Fragen wende dich an [plus@sharezone.net](mailto:plus@sharezone.net).'**
  String sharezonePlusBuyingFailedContent(String error);

  /// No description provided for @sharezonePlusBuyingFailedTitle.
  ///
  /// In de, this message translates to:
  /// **'Kaufen fehlgeschlagen'**
  String get sharezonePlusBuyingFailedTitle;

  /// No description provided for @sharezonePlusCancelAction.
  ///
  /// In de, this message translates to:
  /// **'Kündigen'**
  String get sharezonePlusCancelAction;

  /// No description provided for @sharezonePlusCancelConfirmAction.
  ///
  /// In de, this message translates to:
  /// **'Kündigen'**
  String get sharezonePlusCancelConfirmAction;

  /// No description provided for @sharezonePlusCancelConfirmationContent.
  ///
  /// In de, this message translates to:
  /// **'Wenn du dein Sharezone-Plus Abo kündigst, verlierst du den Zugriff auf alle Plus-Funktionen.\n\nBist du sicher, dass du kündigen möchtest?'**
  String get sharezonePlusCancelConfirmationContent;

  /// No description provided for @sharezonePlusCancelConfirmationTitle.
  ///
  /// In de, this message translates to:
  /// **'Bist du dir sicher?'**
  String get sharezonePlusCancelConfirmationTitle;

  /// No description provided for @sharezonePlusCancelFailedContent.
  ///
  /// In de, this message translates to:
  /// **'Es ist ein Fehler aufgetreten. Bitte versuche es später erneut.\n\nFehler: {error}'**
  String sharezonePlusCancelFailedContent(String error);

  /// No description provided for @sharezonePlusCancelFailedTitle.
  ///
  /// In de, this message translates to:
  /// **'Kündigung fehlgeschlagen'**
  String get sharezonePlusCancelFailedTitle;

  /// No description provided for @sharezonePlusCanceledSubscriptionNote.
  ///
  /// In de, this message translates to:
  /// **'Du hast dein Sharezone-Plus Abo gekündigt. Du kannst deine Vorteile noch bis zum Ende des aktuellen Abrechnungszeitraums nutzen. Solltest du es dir anders überlegen, kannst du es jederzeit wieder erneut Sharezone-Plus abonnieren.'**
  String get sharezonePlusCanceledSubscriptionNote;

  /// No description provided for @sharezonePlusFaqContentCreatorContent.
  ///
  /// In de, this message translates to:
  /// **'Ja, als Content Creator kannst du Sharezone Plus (Lifetime) kostenlos erhalten.\n\nSo funktioniert es:\n1. Erstelle ein kreatives TikTok, YouTube Short oder Instagram Reel, in dem du Sharezone erwähnst oder vorstellst.\n2. Sorge dafür, dass dein Video mehr als 10.000 Aufrufe erzielt.\n3. Schick uns den Link zu deinem Video an plus@sharezone.net.\n\nDeiner Kreativität sind keine Grenzen gesetzt. Bitte beachte unsere Bedingungen für das Content Creator Programm: https://sharezone.net/content-creator-programm.'**
  String get sharezonePlusFaqContentCreatorContent;

  /// No description provided for @sharezonePlusFaqContentCreatorTitle.
  ///
  /// In de, this message translates to:
  /// **'Gibt es ein Content Creator Programm?'**
  String get sharezonePlusFaqContentCreatorTitle;

  /// No description provided for @sharezonePlusFaqEmailSnackBar.
  ///
  /// In de, this message translates to:
  /// **'E-Mail: {email}'**
  String sharezonePlusFaqEmailSnackBar(String email);

  /// No description provided for @sharezonePlusFaqFamilyLicenseContent.
  ///
  /// In de, this message translates to:
  /// **'Ja, für Familien mit mehreren Kindern bieten wir besondere Konditionen an. Schreib uns einfach eine E-Mail an [plus@sharezone.net](mailto:plus@sharezone.net), um mehr zu erfahren.'**
  String get sharezonePlusFaqFamilyLicenseContent;

  /// No description provided for @sharezonePlusFaqFamilyLicenseTitle.
  ///
  /// In de, this message translates to:
  /// **'Gibt es spezielle Angebote für Familien?'**
  String get sharezonePlusFaqFamilyLicenseTitle;

  /// No description provided for @sharezonePlusFaqGroupMembersContent.
  ///
  /// In de, this message translates to:
  /// **'Wenn du Sharezone Plus abonnierst, erhält nur dein Account Sharezone Plus. Deine Gruppenmitglieder erhalten Sharezone Plus nicht.\n\nJedoch gibt es einzelne Features, von denen auch deine Gruppenmitglieder profitieren. Solltest du beispielsweise eine die Kursfarbe von einer Gruppe zu einer Farbe ändern, die nur mit Sharezone Plus verfügbar ist, so wird diese Farbe auch für deine Gruppenmitglieder verwendet.'**
  String get sharezonePlusFaqGroupMembersContent;

  /// No description provided for @sharezonePlusFaqGroupMembersTitle.
  ///
  /// In de, this message translates to:
  /// **'Erhalten auch Gruppenmitglieder Sharezone Plus?'**
  String get sharezonePlusFaqGroupMembersTitle;

  /// No description provided for @sharezonePlusFaqOpenSourceContent.
  ///
  /// In de, this message translates to:
  /// **'Ja, Sharezone ist Open-Source im Frontend. Du kannst den Quellcode auf GitHub einsehen:'**
  String get sharezonePlusFaqOpenSourceContent;

  /// No description provided for @sharezonePlusFaqOpenSourceTitle.
  ///
  /// In de, this message translates to:
  /// **'Ist der Quellcode von Sharezone öffentlich?'**
  String get sharezonePlusFaqOpenSourceTitle;

  /// No description provided for @sharezonePlusFaqSchoolLicenseContent.
  ///
  /// In de, this message translates to:
  /// **'Du bist interessiert an einer Lizenz für deine gesamte Klasse? Schreib uns einfach eine E-Mail an [plus@sharezone.net](mailto:plus@sharezone.net).'**
  String get sharezonePlusFaqSchoolLicenseContent;

  /// No description provided for @sharezonePlusFaqSchoolLicenseTitle.
  ///
  /// In de, this message translates to:
  /// **'Gibt es spezielle Angebote für Schulklassen?'**
  String get sharezonePlusFaqSchoolLicenseTitle;

  /// No description provided for @sharezonePlusFaqStorageContent.
  ///
  /// In de, this message translates to:
  /// **'Nein, der Speicherplatz von 30 GB mit Sharezone Plus gilt nur für deinen Account und gilt über alle deine Kurse hinweg.\n\nDu könntest beispielsweise 5 GB in den Deutsch-Kurs hochladen, 15 GB in den Mathe-Kurs und hättest noch weitere 10 GB für alle Kurse zur Verfügung.\n\nDeine Gruppenmitglieder erhalten keinen zusätzlichen Speicherplatz.'**
  String get sharezonePlusFaqStorageContent;

  /// No description provided for @sharezonePlusFaqStorageTitle.
  ///
  /// In de, this message translates to:
  /// **'Erhält der gesamte Kurs 30 GB Speicherplatz?'**
  String get sharezonePlusFaqStorageTitle;

  /// No description provided for @sharezonePlusFaqWhoIsBehindContent.
  ///
  /// In de, this message translates to:
  /// **'Sharezone wird aktuell von Jonas und Nils entwickelt. Aus unserer persönlichen Frustration über die Organisation des Schulalltags während der Schulzeit entstand die Idee für Sharezone. Es ist unsere Vision, den Schulalltag für alle einfacher und übersichtlicher zu gestalten.'**
  String get sharezonePlusFaqWhoIsBehindContent;

  /// No description provided for @sharezonePlusFaqWhoIsBehindTitle.
  ///
  /// In de, this message translates to:
  /// **'Wer steht hinter Sharezone?'**
  String get sharezonePlusFaqWhoIsBehindTitle;

  /// No description provided for @sharezonePlusFeatureUnavailable.
  ///
  /// In de, this message translates to:
  /// **'Dieses Feature ist nur mit \"Sharezone Plus\" verfügbar.'**
  String get sharezonePlusFeatureUnavailable;

  /// No description provided for @sharezonePlusLegalTextLifetime.
  ///
  /// In de, this message translates to:
  /// **'Einmalige Zahlung von {price} (kein Abo o. ä.). Durch den Kauf bestätigst du, dass du die [ANBs](https://sharezone.net/terms-of-service) gelesen hast. Wir verarbeiten deine Daten gemäß unserer [Datenschutzerklärung](https://sharezone.net/privacy-policy)'**
  String sharezonePlusLegalTextLifetime(String price);

  /// No description provided for @sharezonePlusLegalTextMonthlyAndroid.
  ///
  /// In de, this message translates to:
  /// **'Dein Abo ({price}/Monat) ist monatlich kündbar. Es wird automatisch verlängert, wenn du es nicht mindestens 24 Stunden vor Ablauf der aktuellen Zahlungsperiode über Google Play kündigst. Durch den Kauf bestätigst du, dass du die [ANBs](https://sharezone.net/terms-of-service) gelesen hast. Wir verarbeiten deine Daten gemäß unserer [Datenschutzerklärung](https://sharezone.net/privacy-policy)'**
  String sharezonePlusLegalTextMonthlyAndroid(String price);

  /// No description provided for @sharezonePlusLegalTextMonthlyApple.
  ///
  /// In de, this message translates to:
  /// **'Dein Abo ({price}/Monat) ist monatlich kündbar. Es wird automatisch verlängert, wenn du es nicht mindestens 24 Stunden vor Ablauf der aktuellen Zahlungsperiode über den App Store kündigst. Durch den Kauf bestätigst du, dass du die [ANBs](https://sharezone.net/terms-of-service) gelesen hast. Wir verarbeiten deine Daten gemäß unserer [Datenschutzerklärung](https://sharezone.net/privacy-policy)'**
  String sharezonePlusLegalTextMonthlyApple(String price);

  /// No description provided for @sharezonePlusLegalTextMonthlyOther.
  ///
  /// In de, this message translates to:
  /// **'Dein Abo ({price}/Monat) ist monatlich kündbar. Es wird automatisch verlängert, wenn du es nicht vor Ablauf der aktuellen Zahlungsperiode über die App kündigst. Durch den Kauf bestätigst du, dass du die [ANBs](https://sharezone.net/terms-of-service) gelesen hast. Wir verarbeiten deine Daten gemäß unserer [Datenschutzerklärung](https://sharezone.net/privacy-policy)'**
  String sharezonePlusLegalTextMonthlyOther(String price);

  /// No description provided for @sharezonePlusLetParentsBuyAction.
  ///
  /// In de, this message translates to:
  /// **'Eltern bezahlen lassen'**
  String get sharezonePlusLetParentsBuyAction;

  /// No description provided for @sharezonePlusLetParentsBuyContent.
  ///
  /// In de, this message translates to:
  /// **'Du kannst deinen Eltern einen Link schicken, damit sie Sharezone-Plus für dich kaufen können.\n\nDer Link ist nur für dich gültig und enthält die Verbindung zu deinem Account.'**
  String get sharezonePlusLetParentsBuyContent;

  /// No description provided for @sharezonePlusLetParentsBuyTitle.
  ///
  /// In de, this message translates to:
  /// **'Eltern bezahlen lassen'**
  String get sharezonePlusLetParentsBuyTitle;

  /// No description provided for @sharezonePlusLinkCopiedToClipboard.
  ///
  /// In de, this message translates to:
  /// **'Link in die Zwischenablage kopiert.'**
  String get sharezonePlusLinkCopiedToClipboard;

  /// No description provided for @sharezonePlusLinkTokenLoadFailed.
  ///
  /// In de, this message translates to:
  /// **'Der Token für den Link konnte nicht geladen werden.'**
  String get sharezonePlusLinkTokenLoadFailed;

  /// No description provided for @sharezonePlusPurchasePeriodLifetime.
  ///
  /// In de, this message translates to:
  /// **'Lebenslang (einmaliger Kauf)'**
  String get sharezonePlusPurchasePeriodLifetime;

  /// No description provided for @sharezonePlusPurchasePeriodMonthly.
  ///
  /// In de, this message translates to:
  /// **'Monatlich'**
  String get sharezonePlusPurchasePeriodMonthly;

  /// No description provided for @sharezonePlusShareLinkAction.
  ///
  /// In de, this message translates to:
  /// **'Link teilen'**
  String get sharezonePlusShareLinkAction;

  /// No description provided for @sharezonePlusSubscribeAction.
  ///
  /// In de, this message translates to:
  /// **'Abonnieren'**
  String get sharezonePlusSubscribeAction;

  /// No description provided for @sharezonePlusTestFlightContent.
  ///
  /// In de, this message translates to:
  /// **'Du hast Sharezone über TestFlight installiert. Apple erlaubt keine In-App-Käufe über TestFlight.\n\nUm Sharezone-Plus zu kaufen, lade bitte die App aus dem App Store herunter. Dort kannst du Sharezone-Plus kaufen.\n\nDanach kannst du die App wieder über TestFlight installieren.'**
  String get sharezonePlusTestFlightContent;

  /// No description provided for @sharezonePlusTestFlightTitle.
  ///
  /// In de, this message translates to:
  /// **'TestFlight'**
  String get sharezonePlusTestFlightTitle;

  /// No description provided for @sharezonePlusUnsubscribeActiveText.
  ///
  /// In de, this message translates to:
  /// **'Du hast aktuell das Sharezone-Plus Abo. Solltest du nicht zufrieden sein, würden wir uns über ein [Feedback](#feedback) freuen! Natürlich kannst du dich jederzeit dafür entscheiden, das Abo zu kündigen.'**
  String get sharezonePlusUnsubscribeActiveText;

  /// No description provided for @sharezonePlusUnsubscribeLifetimeText.
  ///
  /// In de, this message translates to:
  /// **'Du hast Sharezone-Plus auf Lebenszeit. Solltest du nicht zufrieden sein, würden wir uns über ein [Feedback](#feedback) freuen!'**
  String get sharezonePlusUnsubscribeLifetimeText;

  /// No description provided for @sharezoneWidgetsCenteredErrorMessage.
  ///
  /// In de, this message translates to:
  /// **'Es gab leider einen Fehler beim Laden 😖\nVersuche es später einfach nochmal.'**
  String get sharezoneWidgetsCenteredErrorMessage;

  /// No description provided for @sharezoneWidgetsCourseTileNoCourseSelected.
  ///
  /// In de, this message translates to:
  /// **'Keinen Kurs ausgewählt'**
  String get sharezoneWidgetsCourseTileNoCourseSelected;

  /// No description provided for @sharezoneWidgetsCourseTileTitle.
  ///
  /// In de, this message translates to:
  /// **'Kurs'**
  String get sharezoneWidgetsCourseTileTitle;

  /// No description provided for @sharezoneWidgetsDatePickerSelectDate.
  ///
  /// In de, this message translates to:
  /// **'Datum auswählen'**
  String get sharezoneWidgetsDatePickerSelectDate;

  /// No description provided for @sharezoneWidgetsErrorCardContactSupport.
  ///
  /// In de, this message translates to:
  /// **'SUPPORT KONTAKTIEREN'**
  String get sharezoneWidgetsErrorCardContactSupport;

  /// No description provided for @sharezoneWidgetsErrorCardRetry.
  ///
  /// In de, this message translates to:
  /// **'ERNEUT VERSUCHEN'**
  String get sharezoneWidgetsErrorCardRetry;

  /// No description provided for @sharezoneWidgetsErrorCardTitle.
  ///
  /// In de, this message translates to:
  /// **'Es ist ein Fehler aufgetreten!'**
  String get sharezoneWidgetsErrorCardTitle;

  /// No description provided for @sharezoneWidgetsLeaveFormConfirm.
  ///
  /// In de, this message translates to:
  /// **'JA, VERLASSEN!'**
  String get sharezoneWidgetsLeaveFormConfirm;

  /// No description provided for @sharezoneWidgetsLeaveFormPromptFull.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du die Eingabe wirklich beenden? Die Daten werden nicht gespeichert!'**
  String get sharezoneWidgetsLeaveFormPromptFull;

  /// No description provided for @sharezoneWidgetsLeaveFormPromptNot.
  ///
  /// In de, this message translates to:
  /// **'nicht'**
  String get sharezoneWidgetsLeaveFormPromptNot;

  /// No description provided for @sharezoneWidgetsLeaveFormPromptPrefix.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du die Eingabe wirklich beenden? Die Daten werden '**
  String get sharezoneWidgetsLeaveFormPromptPrefix;

  /// No description provided for @sharezoneWidgetsLeaveFormPromptSuffix.
  ///
  /// In de, this message translates to:
  /// **' gespeichert!'**
  String get sharezoneWidgetsLeaveFormPromptSuffix;

  /// No description provided for @sharezoneWidgetsLeaveFormStay.
  ///
  /// In de, this message translates to:
  /// **'NEIN!'**
  String get sharezoneWidgetsLeaveFormStay;

  /// No description provided for @sharezoneWidgetsLeaveFormTitle.
  ///
  /// In de, this message translates to:
  /// **'Eingabe verlassen?'**
  String get sharezoneWidgetsLeaveFormTitle;

  /// No description provided for @sharezoneWidgetsLeaveOrSaveFormPrompt.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du die Eingabe verlassen oder speichern? Verlässt du die Eingabe, werden die Daten nicht gespeichert'**
  String get sharezoneWidgetsLeaveOrSaveFormPrompt;

  /// No description provided for @sharezoneWidgetsLeaveOrSaveFormTitle.
  ///
  /// In de, this message translates to:
  /// **'Verlassen oder Speichern?'**
  String get sharezoneWidgetsLeaveOrSaveFormTitle;

  /// No description provided for @sharezoneWidgetsLoadingEncryptedTransfer.
  ///
  /// In de, this message translates to:
  /// **'Daten werden verschlüsselt übertragen...'**
  String get sharezoneWidgetsLoadingEncryptedTransfer;

  /// No description provided for @sharezoneWidgetsLocationHint.
  ///
  /// In de, this message translates to:
  /// **'Ort/Raum'**
  String get sharezoneWidgetsLocationHint;

  /// No description provided for @sharezoneWidgetsLogoSemanticsLabel.
  ///
  /// In de, this message translates to:
  /// **'Logo von Sharezone: Ein blaues Heft-Icon mit einer Wolke, rechts daneben steht Sharezone.'**
  String get sharezoneWidgetsLogoSemanticsLabel;

  /// No description provided for @sharezoneWidgetsMarkdownSupportBold.
  ///
  /// In de, this message translates to:
  /// **'**fett**'**
  String get sharezoneWidgetsMarkdownSupportBold;

  /// No description provided for @sharezoneWidgetsMarkdownSupportItalic.
  ///
  /// In de, this message translates to:
  /// **'*kursiv*'**
  String get sharezoneWidgetsMarkdownSupportItalic;

  /// No description provided for @sharezoneWidgetsMarkdownSupportLabel.
  ///
  /// In de, this message translates to:
  /// **'Markdown: '**
  String get sharezoneWidgetsMarkdownSupportLabel;

  /// No description provided for @sharezoneWidgetsMarkdownSupportSeparator.
  ///
  /// In de, this message translates to:
  /// **', '**
  String get sharezoneWidgetsMarkdownSupportSeparator;

  /// No description provided for @sharezoneWidgetsNotAllowedCharactersError.
  ///
  /// In de, this message translates to:
  /// **'Folgende Zeichen sind nicht erlaubt: {characters}'**
  String sharezoneWidgetsNotAllowedCharactersError(String characters);

  /// No description provided for @sharezoneWidgetsOverlayCardCloseSemantics.
  ///
  /// In de, this message translates to:
  /// **'Schließe die Karte'**
  String get sharezoneWidgetsOverlayCardCloseSemantics;

  /// No description provided for @sharezoneWidgetsSnackbarComingSoon.
  ///
  /// In de, this message translates to:
  /// **'Diese Funktion ist bald verfügbar! 😊'**
  String get sharezoneWidgetsSnackbarComingSoon;

  /// No description provided for @sharezoneWidgetsSnackbarDataArrivalConfirmed.
  ///
  /// In de, this message translates to:
  /// **'Ankunft der Daten bestätigt'**
  String get sharezoneWidgetsSnackbarDataArrivalConfirmed;

  /// No description provided for @sharezoneWidgetsSnackbarLoginDataEncrypted.
  ///
  /// In de, this message translates to:
  /// **'Anmeldedaten werden verschlüsselt übertragen...'**
  String get sharezoneWidgetsSnackbarLoginDataEncrypted;

  /// No description provided for @sharezoneWidgetsSnackbarPatience.
  ///
  /// In de, this message translates to:
  /// **'Geduld! Daten werden noch geladen...'**
  String get sharezoneWidgetsSnackbarPatience;

  /// No description provided for @sharezoneWidgetsSnackbarSaved.
  ///
  /// In de, this message translates to:
  /// **'Änderung wurde erfolgreich gespeichert'**
  String get sharezoneWidgetsSnackbarSaved;

  /// No description provided for @sharezoneWidgetsSnackbarSendingDataToFrankfurt.
  ///
  /// In de, this message translates to:
  /// **'Daten werden nach Frankfurt transportiert...'**
  String get sharezoneWidgetsSnackbarSendingDataToFrankfurt;

  /// No description provided for @sharezoneWidgetsTextFieldCannotBeEmptyError.
  ///
  /// In de, this message translates to:
  /// **'Das Textfeld darf nicht leer sein!'**
  String get sharezoneWidgetsTextFieldCannotBeEmptyError;

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

  /// No description provided for @submissionsCreateAddFile.
  ///
  /// In de, this message translates to:
  /// **'Datei hinzufügen'**
  String get submissionsCreateAddFile;

  /// No description provided for @submissionsCreateAfterDeadlineContent.
  ///
  /// In de, this message translates to:
  /// **'Du kannst jetzt trotzdem noch abgeben, aber die Lehrkraft muss entscheiden wie sie damit umgeht ;)'**
  String get submissionsCreateAfterDeadlineContent;

  /// No description provided for @submissionsCreateAfterDeadlineTitle.
  ///
  /// In de, this message translates to:
  /// **'Abgabefrist verpasst? Du kannst trotzdem abgeben!'**
  String get submissionsCreateAfterDeadlineTitle;

  /// No description provided for @submissionsCreateEmptyStateTitle.
  ///
  /// In de, this message translates to:
  /// **'Lade jetzt Dateien hoch, die du für die Hausaufgabe abgeben willst!'**
  String get submissionsCreateEmptyStateTitle;

  /// No description provided for @submissionsCreateFileInvalidDialogContent.
  ///
  /// In de, this message translates to:
  /// **'{message}\nBitte kontaktiere den Support unter support@sharezone.net!'**
  String submissionsCreateFileInvalidDialogContent(String message);

  /// No description provided for @submissionsCreateFileInvalidDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Fehler'**
  String get submissionsCreateFileInvalidDialogTitle;

  /// No description provided for @submissionsCreateFileInvalidMultiple.
  ///
  /// In de, this message translates to:
  /// **'Die gewählten Dateien \"{fileNames}\" scheinen invalide zu sein.'**
  String submissionsCreateFileInvalidMultiple(String fileNames);

  /// No description provided for @submissionsCreateFileInvalidSingle.
  ///
  /// In de, this message translates to:
  /// **'Die gewählte Datei \"{fileName}\" scheint invalide zu sein.'**
  String submissionsCreateFileInvalidSingle(String fileName);

  /// No description provided for @submissionsCreateLeaveAction.
  ///
  /// In de, this message translates to:
  /// **'Verlassen'**
  String get submissionsCreateLeaveAction;

  /// No description provided for @submissionsCreateNotSubmittedContent.
  ///
  /// In de, this message translates to:
  /// **'Dein Lehrer wird deine Abgabe nicht sehen können, bis du diese abgibst.\n\nDeine bisher hochgeladenen Dateien bleiben trotzdem für dich gespeichert.'**
  String get submissionsCreateNotSubmittedContent;

  /// No description provided for @submissionsCreateNotSubmittedTitle.
  ///
  /// In de, this message translates to:
  /// **'Abgabe nicht abgegeben!'**
  String get submissionsCreateNotSubmittedTitle;

  /// No description provided for @submissionsCreateRemoveFileContent.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du die Datei \"{fileName}\" wirklich entfernen?'**
  String submissionsCreateRemoveFileContent(String fileName);

  /// No description provided for @submissionsCreateRemoveFileTitle.
  ///
  /// In de, this message translates to:
  /// **'Datei entfernen'**
  String get submissionsCreateRemoveFileTitle;

  /// No description provided for @submissionsCreateRemoveFileTooltip.
  ///
  /// In de, this message translates to:
  /// **'Datei entfernen'**
  String get submissionsCreateRemoveFileTooltip;

  /// No description provided for @submissionsCreateRenameActionUppercase.
  ///
  /// In de, this message translates to:
  /// **'UMBENENNEN'**
  String get submissionsCreateRenameActionUppercase;

  /// No description provided for @submissionsCreateRenameDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Datei umbenennen'**
  String get submissionsCreateRenameDialogTitle;

  /// No description provided for @submissionsCreateRenameErrorAlreadyExists.
  ///
  /// In de, this message translates to:
  /// **'Dieser Dateiname existiert bereits!'**
  String get submissionsCreateRenameErrorAlreadyExists;

  /// No description provided for @submissionsCreateRenameErrorEmpty.
  ///
  /// In de, this message translates to:
  /// **'Der Name darf nicht leer sein!'**
  String get submissionsCreateRenameErrorEmpty;

  /// No description provided for @submissionsCreateRenameErrorTooLong.
  ///
  /// In de, this message translates to:
  /// **'Der Name ist zu lang!'**
  String get submissionsCreateRenameErrorTooLong;

  /// No description provided for @submissionsCreateRenameTooltip.
  ///
  /// In de, this message translates to:
  /// **'Umbenennen'**
  String get submissionsCreateRenameTooltip;

  /// No description provided for @submissionsCreateSubmitAction.
  ///
  /// In de, this message translates to:
  /// **'Abgeben'**
  String get submissionsCreateSubmitAction;

  /// No description provided for @submissionsCreateSubmitDialogContent.
  ///
  /// In de, this message translates to:
  /// **'Nach der Abgabe kannst du keine Datei mehr löschen. Du kannst aber noch neue Dateien hinzufügen und alte Dateien umbenennen.'**
  String get submissionsCreateSubmitDialogContent;

  /// No description provided for @submissionsCreateSubmitDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Wirklich Abgeben?'**
  String get submissionsCreateSubmitDialogTitle;

  /// No description provided for @submissionsCreateSubmittedTitle.
  ///
  /// In de, this message translates to:
  /// **'Abgabe erfolgreich abgegeben!'**
  String get submissionsCreateSubmittedTitle;

  /// No description provided for @submissionsCreateUploadInProgressContent.
  ///
  /// In de, this message translates to:
  /// **'Wenn du den Dialog verlässt wird der Hochladevorgang für noch nicht hochgeladene Dateien abgebrochen.'**
  String get submissionsCreateUploadInProgressContent;

  /// No description provided for @submissionsCreateUploadInProgressTitle.
  ///
  /// In de, this message translates to:
  /// **'Dateien am hochladen!'**
  String get submissionsCreateUploadInProgressTitle;

  /// No description provided for @submissionsListAfterDeadlineSection.
  ///
  /// In de, this message translates to:
  /// **'Zu spät abgegeben 🕐'**
  String get submissionsListAfterDeadlineSection;

  /// No description provided for @submissionsListEditedSuffix.
  ///
  /// In de, this message translates to:
  /// **' (nachträglich bearbeitet)'**
  String get submissionsListEditedSuffix;

  /// No description provided for @submissionsListMissingSection.
  ///
  /// In de, this message translates to:
  /// **'Nicht abgegeben 😭'**
  String get submissionsListMissingSection;

  /// No description provided for @submissionsListNoMembersPlaceholder.
  ///
  /// In de, this message translates to:
  /// **'Vergessen Teilnehmer in den Kurs einzuladen?'**
  String get submissionsListNoMembersPlaceholder;

  /// No description provided for @submissionsListTitle.
  ///
  /// In de, this message translates to:
  /// **'Abgaben'**
  String get submissionsListTitle;

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

  /// Error message shown when the end time is before the next lesson's start time.
  ///
  /// In de, this message translates to:
  /// **'Die Endzeit ist vor der Startzeit der nächsten Stunde!'**
  String get timetableErrorEndTimeBeforeNextLessonStart;

  /// Error message shown when the end time is before the previous lesson's end time.
  ///
  /// In de, this message translates to:
  /// **'Die Endzeit ist vor der Endzeit der vorherigen Stunde!'**
  String get timetableErrorEndTimeBeforePreviousLessonEnd;

  /// Error message shown when the end time is before the start time.
  ///
  /// In de, this message translates to:
  /// **'Die Endzeit der Stunde ist vor der Startzeit!'**
  String get timetableErrorEndTimeBeforeStartTime;

  /// Error message shown when the end time is missing.
  ///
  /// In de, this message translates to:
  /// **'Bitte gibt eine Endzeit an!'**
  String get timetableErrorEndTimeMissing;

  /// Error message shown when lesson periods overlap or are invalid.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib korrekte Zeiten. Die Stunden dürfen sich nicht überschneiden!'**
  String get timetableErrorInvalidPeriodsOverlap;

  /// Error message shown when the start time is before the next lesson's start time.
  ///
  /// In de, this message translates to:
  /// **'Die Startzeit ist vor der Startzeit der nächsten Stunde!'**
  String get timetableErrorStartTimeBeforeNextLessonStart;

  /// Error message shown when the start time is before the previous lesson's end time.
  ///
  /// In de, this message translates to:
  /// **'Die Startzeit ist vor der Endzeit der vorherigen Stunde!'**
  String get timetableErrorStartTimeBeforePreviousLessonEnd;

  /// Error message shown when start and end time are the same.
  ///
  /// In de, this message translates to:
  /// **'Die Startzeit und die Endzeit darf nicht gleich sein!'**
  String get timetableErrorStartTimeEqualsEndTime;

  /// Error message shown when the start time is missing.
  ///
  /// In de, this message translates to:
  /// **'Bitte gibt eine Startzeit an!'**
  String get timetableErrorStartTimeMissing;

  /// Error message shown when no weekday is selected.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib einen Wochentag an!'**
  String get timetableErrorWeekdayMissing;

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

  /// No description provided for @timetableSettingsOpenUpcomingWeekOnNonSchoolDaysSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Wenn in dieser Woche keine aktivierten Wochentage mehr übrig sind, öffnet der Stundenplan die kommende Woche.'**
  String get timetableSettingsOpenUpcomingWeekOnNonSchoolDaysSubtitle;

  /// No description provided for @timetableSettingsOpenUpcomingWeekOnNonSchoolDaysTitle.
  ///
  /// In de, this message translates to:
  /// **'Kommende Woche an schulfreien Tagen öffnen'**
  String get timetableSettingsOpenUpcomingWeekOnNonSchoolDaysTitle;

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

  /// Label for the type of user parent.
  ///
  /// In de, this message translates to:
  /// **'Elternteil'**
  String get typeOfUserParent;

  /// Label for the type of user student.
  ///
  /// In de, this message translates to:
  /// **'Schüler*in'**
  String get typeOfUserStudent;

  /// Label for the type of user teacher.
  ///
  /// In de, this message translates to:
  /// **'Lehrkraft'**
  String get typeOfUserTeacher;

  /// Label for the type of user unknown.
  ///
  /// In de, this message translates to:
  /// **'Unbekannt'**
  String get typeOfUserUnknown;

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

  /// No description provided for @websiteAllInOneFeatureImageLabel.
  ///
  /// In de, this message translates to:
  /// **'Ein Bild der Funktion {feature}'**
  String websiteAllInOneFeatureImageLabel(String feature);

  /// No description provided for @websiteAllInOneHeadline.
  ///
  /// In de, this message translates to:
  /// **'Alles an einem Ort'**
  String get websiteAllInOneHeadline;

  /// No description provided for @websiteAllPlatformsHeadline.
  ///
  /// In de, this message translates to:
  /// **'Auf allen Geräten verfügbar.'**
  String get websiteAllPlatformsHeadline;

  /// No description provided for @websiteAllPlatformsSubline.
  ///
  /// In de, this message translates to:
  /// **'Sharezone funktioniert auf allen Systemen. Somit kannst Du jederzeit auf deine Daten zugreifen.'**
  String get websiteAllPlatformsSubline;

  /// No description provided for @websiteAppTitle.
  ///
  /// In de, this message translates to:
  /// **'Sharezone - Vernetzter Schulplaner'**
  String get websiteAppTitle;

  /// No description provided for @websiteDataProtectionAesTitle.
  ///
  /// In de, this message translates to:
  /// **'AES 256-Bit serverseitige Verschlüsselung'**
  String get websiteDataProtectionAesTitle;

  /// No description provided for @websiteDataProtectionHeadline.
  ///
  /// In de, this message translates to:
  /// **'Sicher & DSGVO-konform'**
  String get websiteDataProtectionHeadline;

  /// No description provided for @websiteDataProtectionIsoTitle.
  ///
  /// In de, this message translates to:
  /// **'ISO27001, ISO27012 & ISO27018 zertifiziert*'**
  String get websiteDataProtectionIsoTitle;

  /// No description provided for @websiteDataProtectionServerLocationSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Mit Ausnahme des Authentifizierungsserver\n(EU-Standardvertragsklauseln)'**
  String get websiteDataProtectionServerLocationSubtitle;

  /// No description provided for @websiteDataProtectionServerLocationTitle.
  ///
  /// In de, this message translates to:
  /// **'Standort der Server: Frankfurt (Deutschland)'**
  String get websiteDataProtectionServerLocationTitle;

  /// No description provided for @websiteDataProtectionSocSubtitle.
  ///
  /// In de, this message translates to:
  /// **'* Zertifizierung von unserem Hosting-Anbieter'**
  String get websiteDataProtectionSocSubtitle;

  /// No description provided for @websiteDataProtectionSocTitle.
  ///
  /// In de, this message translates to:
  /// **'SOC1, SOC2, & SOC3 zertifiziert*'**
  String get websiteDataProtectionSocTitle;

  /// No description provided for @websiteDataProtectionTlsTitle.
  ///
  /// In de, this message translates to:
  /// **'TLS-Verschlüsselung bei der Übertragung'**
  String get websiteDataProtectionTlsTitle;

  /// No description provided for @websiteFeatureAlwaysAvailableBulletpointMultiDevice.
  ///
  /// In de, this message translates to:
  /// **'Mit mehreren Geräten nutzbar'**
  String get websiteFeatureAlwaysAvailableBulletpointMultiDevice;

  /// No description provided for @websiteFeatureAlwaysAvailableBulletpointOffline.
  ///
  /// In de, this message translates to:
  /// **'Offline Inhalte eintragen'**
  String get websiteFeatureAlwaysAvailableBulletpointOffline;

  /// No description provided for @websiteFeatureAlwaysAvailableTitle.
  ///
  /// In de, this message translates to:
  /// **'Immer verfügbar'**
  String get websiteFeatureAlwaysAvailableTitle;

  /// No description provided for @websiteFeatureEventsBulletpointAtAGlance.
  ///
  /// In de, this message translates to:
  /// **'Prüfungen und Termine auf einen Blick'**
  String get websiteFeatureEventsBulletpointAtAGlance;

  /// No description provided for @websiteFeatureEventsTitle.
  ///
  /// In de, this message translates to:
  /// **'Termine'**
  String get websiteFeatureEventsTitle;

  /// No description provided for @websiteFeatureFileStorageBulletpointShareMaterials.
  ///
  /// In de, this message translates to:
  /// **'Arbeitsmaterialien teilen'**
  String get websiteFeatureFileStorageBulletpointShareMaterials;

  /// No description provided for @websiteFeatureFileStorageBulletpointUnlimitedStorage.
  ///
  /// In de, this message translates to:
  /// **'Optional: Unbegrenzter \nSpeicherplatz'**
  String get websiteFeatureFileStorageBulletpointUnlimitedStorage;

  /// No description provided for @websiteFeatureFileStorageTitle.
  ///
  /// In de, this message translates to:
  /// **'Dateiablage'**
  String get websiteFeatureFileStorageTitle;

  /// No description provided for @websiteFeatureGradesBulletpointMultipleSystems.
  ///
  /// In de, this message translates to:
  /// **'Verschiedene Notensysteme'**
  String get websiteFeatureGradesBulletpointMultipleSystems;

  /// No description provided for @websiteFeatureGradesBulletpointSaveGrades.
  ///
  /// In de, this message translates to:
  /// **'Speichere deine Noten in Sharezone'**
  String get websiteFeatureGradesBulletpointSaveGrades;

  /// No description provided for @websiteFeatureGradesTitle.
  ///
  /// In de, this message translates to:
  /// **'Notensystem'**
  String get websiteFeatureGradesTitle;

  /// No description provided for @websiteFeatureNoticesBulletpointComments.
  ///
  /// In de, this message translates to:
  /// **'Mit Kommentarfunktion'**
  String get websiteFeatureNoticesBulletpointComments;

  /// No description provided for @websiteFeatureNoticesBulletpointNotifications.
  ///
  /// In de, this message translates to:
  /// **'Mit Notifications'**
  String get websiteFeatureNoticesBulletpointNotifications;

  /// No description provided for @websiteFeatureNoticesBulletpointReadReceipt.
  ///
  /// In de, this message translates to:
  /// **'Mit Lesebestätigung'**
  String get websiteFeatureNoticesBulletpointReadReceipt;

  /// No description provided for @websiteFeatureNoticesTitle.
  ///
  /// In de, this message translates to:
  /// **'Infozettel'**
  String get websiteFeatureNoticesTitle;

  /// No description provided for @websiteFeatureNotificationsBulletpointAlwaysInformed.
  ///
  /// In de, this message translates to:
  /// **'Immer informiert'**
  String get websiteFeatureNotificationsBulletpointAlwaysInformed;

  /// No description provided for @websiteFeatureNotificationsBulletpointCustomizable.
  ///
  /// In de, this message translates to:
  /// **'Individuell einstellbar'**
  String get websiteFeatureNotificationsBulletpointCustomizable;

  /// No description provided for @websiteFeatureNotificationsBulletpointQuietHours.
  ///
  /// In de, this message translates to:
  /// **'Mit Ruhemodus'**
  String get websiteFeatureNotificationsBulletpointQuietHours;

  /// No description provided for @websiteFeatureNotificationsTitle.
  ///
  /// In de, this message translates to:
  /// **'Notifications'**
  String get websiteFeatureNotificationsTitle;

  /// No description provided for @websiteFeatureOverviewTitle.
  ///
  /// In de, this message translates to:
  /// **'Übersicht'**
  String get websiteFeatureOverviewTitle;

  /// No description provided for @websiteFeatureTasksBulletpointComments.
  ///
  /// In de, this message translates to:
  /// **'Mit Kommentarfunktion'**
  String get websiteFeatureTasksBulletpointComments;

  /// No description provided for @websiteFeatureTasksBulletpointReminder.
  ///
  /// In de, this message translates to:
  /// **'Mit Erinnerungsfunktion'**
  String get websiteFeatureTasksBulletpointReminder;

  /// No description provided for @websiteFeatureTasksBulletpointSubmissions.
  ///
  /// In de, this message translates to:
  /// **'Mit Abgabefunktion'**
  String get websiteFeatureTasksBulletpointSubmissions;

  /// No description provided for @websiteFeatureTasksTitle.
  ///
  /// In de, this message translates to:
  /// **'Aufgaben'**
  String get websiteFeatureTasksTitle;

  /// No description provided for @websiteFeatureTimetableBulletpointAbWeeks.
  ///
  /// In de, this message translates to:
  /// **'Mit A/B Wochen'**
  String get websiteFeatureTimetableBulletpointAbWeeks;

  /// No description provided for @websiteFeatureTimetableBulletpointWeekdays.
  ///
  /// In de, this message translates to:
  /// **'Wochentage individuell einstellbar'**
  String get websiteFeatureTimetableBulletpointWeekdays;

  /// No description provided for @websiteFeatureTimetableTitle.
  ///
  /// In de, this message translates to:
  /// **'Stundenplan'**
  String get websiteFeatureTimetableTitle;

  /// No description provided for @websiteFooterCommunityDiscord.
  ///
  /// In de, this message translates to:
  /// **'Discord'**
  String get websiteFooterCommunityDiscord;

  /// No description provided for @websiteFooterCommunitySubtitle.
  ///
  /// In de, this message translates to:
  /// **'Werde jetzt ein Teil unserer Community und bringe deine eigenen Ideen bei Sharezone ein.'**
  String get websiteFooterCommunitySubtitle;

  /// No description provided for @websiteFooterCommunityTicketSystem.
  ///
  /// In de, this message translates to:
  /// **'Ticketsystem'**
  String get websiteFooterCommunityTicketSystem;

  /// No description provided for @websiteFooterCommunityTitle.
  ///
  /// In de, this message translates to:
  /// **'Sharezone-Community'**
  String get websiteFooterCommunityTitle;

  /// No description provided for @websiteFooterDownloadAndroid.
  ///
  /// In de, this message translates to:
  /// **'Android'**
  String get websiteFooterDownloadAndroid;

  /// No description provided for @websiteFooterDownloadIos.
  ///
  /// In de, this message translates to:
  /// **'iOS'**
  String get websiteFooterDownloadIos;

  /// No description provided for @websiteFooterDownloadMacos.
  ///
  /// In de, this message translates to:
  /// **'macOS'**
  String get websiteFooterDownloadMacos;

  /// No description provided for @websiteFooterDownloadTitle.
  ///
  /// In de, this message translates to:
  /// **'Downloads'**
  String get websiteFooterDownloadTitle;

  /// No description provided for @websiteFooterHelpSupport.
  ///
  /// In de, this message translates to:
  /// **'Support'**
  String get websiteFooterHelpSupport;

  /// No description provided for @websiteFooterHelpTitle.
  ///
  /// In de, this message translates to:
  /// **'Hilfe'**
  String get websiteFooterHelpTitle;

  /// No description provided for @websiteFooterHelpVideos.
  ///
  /// In de, this message translates to:
  /// **'Erklärvideos'**
  String get websiteFooterHelpVideos;

  /// No description provided for @websiteFooterLegalImprint.
  ///
  /// In de, this message translates to:
  /// **'Impressum'**
  String get websiteFooterLegalImprint;

  /// No description provided for @websiteFooterLegalPrivacy.
  ///
  /// In de, this message translates to:
  /// **'Datenschutzerklärung'**
  String get websiteFooterLegalPrivacy;

  /// No description provided for @websiteFooterLegalTerms.
  ///
  /// In de, this message translates to:
  /// **'Allgemeine Nutzungsbedingungen (ANB)'**
  String get websiteFooterLegalTerms;

  /// No description provided for @websiteFooterLegalTitle.
  ///
  /// In de, this message translates to:
  /// **'Rechtliches'**
  String get websiteFooterLegalTitle;

  /// No description provided for @websiteFooterLinksDocs.
  ///
  /// In de, this message translates to:
  /// **'Dokumentation'**
  String get websiteFooterLinksDocs;

  /// No description provided for @websiteFooterLinksTitle.
  ///
  /// In de, this message translates to:
  /// **'Links'**
  String get websiteFooterLinksTitle;

  /// No description provided for @websiteLanguageSelectorTooltip.
  ///
  /// In de, this message translates to:
  /// **'Sprache auswählen'**
  String get websiteLanguageSelectorTooltip;

  /// No description provided for @websiteLaunchUrlFailed.
  ///
  /// In de, this message translates to:
  /// **'Link konnte nicht geöffnet werden!'**
  String get websiteLaunchUrlFailed;

  /// No description provided for @websiteNavDocs.
  ///
  /// In de, this message translates to:
  /// **'Docs'**
  String get websiteNavDocs;

  /// No description provided for @websiteNavHome.
  ///
  /// In de, this message translates to:
  /// **'Hauptseite'**
  String get websiteNavHome;

  /// No description provided for @websiteNavPlus.
  ///
  /// In de, this message translates to:
  /// **'Plus'**
  String get websiteNavPlus;

  /// No description provided for @websiteNavSupport.
  ///
  /// In de, this message translates to:
  /// **'Support'**
  String get websiteNavSupport;

  /// No description provided for @websiteNavWebApp.
  ///
  /// In de, this message translates to:
  /// **'Web-App'**
  String get websiteNavWebApp;

  /// No description provided for @websiteSharezonePlusAdvantagesTitle.
  ///
  /// In de, this message translates to:
  /// **'Vorteile von Sharezone Plus'**
  String get websiteSharezonePlusAdvantagesTitle;

  /// No description provided for @websiteSharezonePlusCustomerPortalContent.
  ///
  /// In de, this message translates to:
  /// **'Um dich zu authentifizieren, nutze bitte die E-Mail-Adresse, die du bei der Bestellung verwendet hast.'**
  String get websiteSharezonePlusCustomerPortalContent;

  /// No description provided for @websiteSharezonePlusCustomerPortalOpen.
  ///
  /// In de, this message translates to:
  /// **'Zum Kundenportal'**
  String get websiteSharezonePlusCustomerPortalOpen;

  /// No description provided for @websiteSharezonePlusCustomerPortalTitle.
  ///
  /// In de, this message translates to:
  /// **'Kundenportal'**
  String get websiteSharezonePlusCustomerPortalTitle;

  /// No description provided for @websiteSharezonePlusLoadError.
  ///
  /// In de, this message translates to:
  /// **'Error: {error}'**
  String websiteSharezonePlusLoadError(String error);

  /// No description provided for @websiteSharezonePlusLoadingName.
  ///
  /// In de, this message translates to:
  /// **'Lädt...'**
  String get websiteSharezonePlusLoadingName;

  /// No description provided for @websiteSharezonePlusManageSubscriptionText.
  ///
  /// In de, this message translates to:
  /// **'Du hast bereits ein Abo? Klicke [hier](https://billing.stripe.com/p/login/eVa7uh3DvbMfbTy144) um es zu verwalten (z.B. Kündigen, Zahlungsmethode ändern, etc.).'**
  String get websiteSharezonePlusManageSubscriptionText;

  /// No description provided for @websiteSharezonePlusPurchaseDialogContent.
  ///
  /// In de, this message translates to:
  /// **'Um Sharezone Plus für deinen eigenen Account zu erwerben, musst du Sharezone Plus über die Web-App kaufen.\n\nFalls du Sharezone Plus als Elternteil für dein Kind kaufen möchtest, musst du den Link öffnen, den du von deinem Kind erhalten hast.\n\nSolltest du Fragen haben, kannst du uns gerne eine E-Mail an [plus@sharezone.net](mailto:plus@sharezone.net) schreiben.'**
  String get websiteSharezonePlusPurchaseDialogContent;

  /// No description provided for @websiteSharezonePlusPurchaseDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Sharezone Plus kaufen'**
  String get websiteSharezonePlusPurchaseDialogTitle;

  /// No description provided for @websiteSharezonePlusPurchaseDialogToWebApp.
  ///
  /// In de, this message translates to:
  /// **'Zur Web-App'**
  String get websiteSharezonePlusPurchaseDialogToWebApp;

  /// No description provided for @websiteSharezonePlusPurchaseForTitle.
  ///
  /// In de, this message translates to:
  /// **'Sharezone Plus kaufen für'**
  String get websiteSharezonePlusPurchaseForTitle;

  /// No description provided for @websiteSharezonePlusSuccessMessage.
  ///
  /// In de, this message translates to:
  /// **'Du hast Sharezone Plus erfolgreich für dein Kind erworben.\nVielen Dank für deine Unterstützung!'**
  String get websiteSharezonePlusSuccessMessage;

  /// No description provided for @websiteSharezonePlusSuccessSupport.
  ///
  /// In de, this message translates to:
  /// **'Solltest du Fragen haben, kannst du dich jederzeit an unseren [Support](/support) wenden.'**
  String get websiteSharezonePlusSuccessSupport;

  /// No description provided for @websiteStoreAppStoreName.
  ///
  /// In de, this message translates to:
  /// **'AppStore'**
  String get websiteStoreAppStoreName;

  /// No description provided for @websiteStorePlayStoreName.
  ///
  /// In de, this message translates to:
  /// **'PlayStore'**
  String get websiteStorePlayStoreName;

  /// No description provided for @websiteSupportEmailCopy.
  ///
  /// In de, this message translates to:
  /// **'E-Mail: {email}'**
  String websiteSupportEmailCopy(String email);

  /// No description provided for @websiteSupportEmailLabel.
  ///
  /// In de, this message translates to:
  /// **'E-Mail'**
  String get websiteSupportEmailLabel;

  /// No description provided for @websiteSupportEmailSubject.
  ///
  /// In de, this message translates to:
  /// **'Ich brauche eure Hilfe! 😭'**
  String get websiteSupportEmailSubject;

  /// No description provided for @websiteSupportPageBody.
  ///
  /// In de, this message translates to:
  /// **'Kontaktiere uns einfach über einen Kanal deiner Wahl und wir werden dir schnellstmöglich weiterhelfen 😉\n\nBitte beachte, dass es manchmal länger dauern kann, bis wir antworten (1-2 Wochen).'**
  String get websiteSupportPageBody;

  /// No description provided for @websiteSupportPageHeadline.
  ///
  /// In de, this message translates to:
  /// **'Du brauchst Hilfe?'**
  String get websiteSupportPageHeadline;

  /// No description provided for @websiteSupportSectionButton.
  ///
  /// In de, this message translates to:
  /// **'Support kontaktieren'**
  String get websiteSupportSectionButton;

  /// No description provided for @websiteSupportSectionHeadline.
  ///
  /// In de, this message translates to:
  /// **'Nie im Stich gelassen.'**
  String get websiteSupportSectionHeadline;

  /// No description provided for @websiteSupportSectionSubline.
  ///
  /// In de, this message translates to:
  /// **'Unser Support ist für Dich jederzeit erreichbar. Egal welche Uhrzeit. Egal welcher Wochentag.'**
  String get websiteSupportSectionSubline;

  /// No description provided for @websiteUserCounterLabel.
  ///
  /// In de, this message translates to:
  /// **'registrierte Nutzer'**
  String get websiteUserCounterLabel;

  /// No description provided for @websiteUserCounterSemanticLabel.
  ///
  /// In de, this message translates to:
  /// **'user counter'**
  String get websiteUserCounterSemanticLabel;

  /// No description provided for @websiteUspCommunityButton.
  ///
  /// In de, this message translates to:
  /// **'Zur Sharezone-Community'**
  String get websiteUspCommunityButton;

  /// No description provided for @websiteUspHeadline.
  ///
  /// In de, this message translates to:
  /// **'Wirklich hilfreich.'**
  String get websiteUspHeadline;

  /// No description provided for @websiteUspSublineDetails.
  ///
  /// In de, this message translates to:
  /// **'Wir wissen, was für Lösungen nötig sind und was wirklich hilft, um den Schulalltag einfach zu machen.\nWo wir es nicht wissen, versuchen wir, mit agiler Arbeit und der Sharezone-Community die beste Lösung zu finden.'**
  String get websiteUspSublineDetails;

  /// No description provided for @websiteUspSublineIntro.
  ///
  /// In de, this message translates to:
  /// **'Sharezone ist aus den realen Problemen des Unterrichts entstanden.'**
  String get websiteUspSublineIntro;

  /// No description provided for @websiteWelcomeDescription.
  ///
  /// In de, this message translates to:
  /// **'Sharezone ist ein vernetzter Schulplaner, um sich gemeinsam zu organisieren. Eingetragene Inhalte, wie z.B. Hausaufgaben, werden blitzschnell mit allen anderen geteilt. So bleiben viele Nerven und viel Zeit erspart.'**
  String get websiteWelcomeDescription;

  /// No description provided for @websiteWelcomeDescriptionSemanticLabel.
  ///
  /// In de, this message translates to:
  /// **'Beschreibung der Sharezone App'**
  String get websiteWelcomeDescriptionSemanticLabel;

  /// No description provided for @websiteWelcomeHeadline.
  ///
  /// In de, this message translates to:
  /// **'Simpel. Sicher. Stabil.'**
  String get websiteWelcomeHeadline;

  /// No description provided for @websiteWelcomeHeadlineSemanticLabel.
  ///
  /// In de, this message translates to:
  /// **'Überschrift der Sharezone App'**
  String get websiteWelcomeHeadlineSemanticLabel;

  /// No description provided for @writePermissionEveryone.
  ///
  /// In de, this message translates to:
  /// **'Alle'**
  String get writePermissionEveryone;

  /// No description provided for @writePermissionOnlyAdmins.
  ///
  /// In de, this message translates to:
  /// **'Nur Admins'**
  String get writePermissionOnlyAdmins;
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
