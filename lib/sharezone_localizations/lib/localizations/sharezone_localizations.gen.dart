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

  /// No description provided for @activationCodeErrorInvalidDescription.
  ///
  /// In de, this message translates to:
  /// **'Entweder wurde dieser Code schon aufgebracht oder er ist außerhalb des Gültigkeitszeitraumes.'**
  String get activationCodeErrorInvalidDescription;

  /// No description provided for @activationCodeErrorInvalidTitle.
  ///
  /// In de, this message translates to:
  /// **'Ein Fehler ist aufgetreten: Dieser Code ist nicht gültig 🤨'**
  String get activationCodeErrorInvalidTitle;

  /// No description provided for @activationCodeErrorNoInternetDescription.
  ///
  /// In de, this message translates to:
  /// **'Wir konnten nicht versuchen, den Code einzulösen, da wir keine Internetverbindung herstellen konnten. Bitte überprüfe dein WLAN bzw. deine Mobilfunkdaten.'**
  String get activationCodeErrorNoInternetDescription;

  /// No description provided for @activationCodeErrorNoInternetTitle.
  ///
  /// In de, this message translates to:
  /// **'Ein Fehler ist aufgetreten: Keine Internetverbindung ☠️'**
  String get activationCodeErrorNoInternetTitle;

  /// No description provided for @activationCodeErrorNotFoundDescription.
  ///
  /// In de, this message translates to:
  /// **'Wir konnten den eingegebenen Aktivierungscode nicht finden. Bitte überprüfe die Groß- und Kleinschreibung und ob dieser Aktivierungscode noch gültig ist.'**
  String get activationCodeErrorNotFoundDescription;

  /// No description provided for @activationCodeErrorNotFoundTitle.
  ///
  /// In de, this message translates to:
  /// **'Ein Fehler ist aufgetreten: Aktivierungscode nicht gefunden ❌'**
  String get activationCodeErrorNotFoundTitle;

  /// No description provided for @activationCodeErrorUnknownDescription.
  ///
  /// In de, this message translates to:
  /// **'Dies könnte eventuell an deiner Internetverbindung liegen. Bitte überprüfe diese!'**
  String get activationCodeErrorUnknownDescription;

  /// No description provided for @activationCodeErrorUnknownTitle.
  ///
  /// In de, this message translates to:
  /// **'Ein unbekannter Fehler ist aufgetreten 😭'**
  String get activationCodeErrorUnknownTitle;

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

  /// No description provided for @activationCodeFieldHint.
  ///
  /// In de, this message translates to:
  /// **'z.B. NavigationV2'**
  String get activationCodeFieldHint;

  /// No description provided for @activationCodeFieldLabel.
  ///
  /// In de, this message translates to:
  /// **'Aktivierungscode'**
  String get activationCodeFieldLabel;

  /// No description provided for @activationCodeInfoDescription.
  ///
  /// In de, this message translates to:
  /// **'Mit dem Aktivierungscode können Features, die noch in der Entwicklung sind, freigeschaltet und bereits getestet werden. Der Aktivierungscode wird von uns bereitgestellt und ist nur für Testzwecke gedacht.\n\nFalls du einen Sharecode hast und einer Gruppe beitreten willst, musst du diesen über die Seite \"Gruppen\" eingeben.'**
  String get activationCodeInfoDescription;

  /// No description provided for @activationCodeInfoTitle.
  ///
  /// In de, this message translates to:
  /// **'Was ist der Aktivierungscode?'**
  String get activationCodeInfoTitle;

  /// No description provided for @activationCodeResultDoneAction.
  ///
  /// In de, this message translates to:
  /// **'Fertig'**
  String get activationCodeResultDoneAction;

  /// No description provided for @activationCodeSuccessTitle.
  ///
  /// In de, this message translates to:
  /// **'Erfolgreich aktiviert: {value} 🎉'**
  String activationCodeSuccessTitle(Object value);

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

  /// No description provided for @adInfoDialogBodyPrefix.
  ///
  /// In de, this message translates to:
  /// **'Innerhalb der nächsten Wochen führen wir ein Experiment mit Werbung in Sharezone durch. Wenn du keine Werbung sehen möchten, kannst du '**
  String get adInfoDialogBodyPrefix;

  /// No description provided for @adInfoDialogBodySuffix.
  ///
  /// In de, this message translates to:
  /// **' erwerben.'**
  String get adInfoDialogBodySuffix;

  /// No description provided for @adInfoDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Werbung in Sharezone'**
  String get adInfoDialogTitle;

  /// No description provided for @adsLoading.
  ///
  /// In de, this message translates to:
  /// **'Anzeige lädt...'**
  String get adsLoading;

  /// No description provided for @appName.
  ///
  /// In de, this message translates to:
  /// **'Sharezone'**
  String get appName;

  /// No description provided for @attachFileCameraPermissionError.
  ///
  /// In de, this message translates to:
  /// **'Die App hat leider keinen Zugang zur Kamera...'**
  String get attachFileCameraPermissionError;

  /// No description provided for @attachFileDocumentTitle.
  ///
  /// In de, this message translates to:
  /// **'Dokument'**
  String get attachFileDocumentTitle;

  /// Display name template for users without a chosen name.
  ///
  /// In de, this message translates to:
  /// **'Anonymer {animalName}'**
  String authAnonymousDisplayName(Object animalName);

  /// No description provided for @authEmailAndPasswordLinkFillFormComplete.
  ///
  /// In de, this message translates to:
  /// **'Füll das Formular komplett aus! 😉'**
  String get authEmailAndPasswordLinkFillFormComplete;

  /// No description provided for @authEmailAndPasswordLinkNicknameHint.
  ///
  /// In de, this message translates to:
  /// **'Dieser Nickname ist nur für deine Gruppenmitglieder sichtbar und sollte ein Pseudonym sein.'**
  String get authEmailAndPasswordLinkNicknameHint;

  /// No description provided for @authEmailAndPasswordLinkNicknameLabel.
  ///
  /// In de, this message translates to:
  /// **'Nickname'**
  String get authEmailAndPasswordLinkNicknameLabel;

  /// No description provided for @authEmailAndPasswordLinkSubmitAction.
  ///
  /// In de, this message translates to:
  /// **'Verknüpfen'**
  String get authEmailAndPasswordLinkSubmitAction;

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

  /// No description provided for @blackboardCardAttachmentTooltip.
  ///
  /// In de, this message translates to:
  /// **'Enthält Anhänge'**
  String get blackboardCardAttachmentTooltip;

  /// No description provided for @blackboardCardMyEntryTooltip.
  ///
  /// In de, this message translates to:
  /// **'Mein Eintrag'**
  String get blackboardCardMyEntryTooltip;

  /// No description provided for @blackboardComposeMessageHint.
  ///
  /// In de, this message translates to:
  /// **'Nachricht verfassen'**
  String get blackboardComposeMessageHint;

  /// No description provided for @blackboardCustomImageUnavailableMessage.
  ///
  /// In de, this message translates to:
  /// **'Bisher können keine eigenen Bilder aufgenommen/hochgeladen werden 😔\n\nDiese Funktion wird sehr bald verfügbar sein!'**
  String get blackboardCustomImageUnavailableMessage;

  /// No description provided for @blackboardDeleteAttachmentsDialogDescription.
  ///
  /// In de, this message translates to:
  /// **'Sollen die Anhänge des Eintrags aus der Dateiablage gelöscht oder die Verknüpfung zwischen beiden aufgehoben werden?'**
  String get blackboardDeleteAttachmentsDialogDescription;

  /// No description provided for @blackboardDeleteDialogDescription.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du wirklich diesen Eintrag für den kompletten Kurs löschen?'**
  String get blackboardDeleteDialogDescription;

  /// No description provided for @blackboardDeleteDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Eintrag löschen?'**
  String get blackboardDeleteDialogTitle;

  /// No description provided for @blackboardDetailsAttachmentsCount.
  ///
  /// In de, this message translates to:
  /// **'Anhänge: {value}'**
  String blackboardDetailsAttachmentsCount(Object value);

  /// No description provided for @blackboardDetailsTitle.
  ///
  /// In de, this message translates to:
  /// **'Details'**
  String get blackboardDetailsTitle;

  /// No description provided for @blackboardDialogSaveTooltip.
  ///
  /// In de, this message translates to:
  /// **'Eintrag speichern'**
  String get blackboardDialogSaveTooltip;

  /// No description provided for @blackboardDialogTitleHint.
  ///
  /// In de, this message translates to:
  /// **'Titel eingeben'**
  String get blackboardDialogTitleHint;

  /// No description provided for @blackboardEntryDeleted.
  ///
  /// In de, this message translates to:
  /// **'Eintrag wurde gelöscht.'**
  String get blackboardEntryDeleted;

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

  /// No description provided for @blackboardMarkAsRead.
  ///
  /// In de, this message translates to:
  /// **'Als gelesen markieren'**
  String get blackboardMarkAsRead;

  /// No description provided for @blackboardMarkAsUnread.
  ///
  /// In de, this message translates to:
  /// **'Als ungelesen markieren'**
  String get blackboardMarkAsUnread;

  /// No description provided for @blackboardPageAddInfoSheet.
  ///
  /// In de, this message translates to:
  /// **'Infozettel hinzufügen'**
  String get blackboardPageAddInfoSheet;

  /// No description provided for @blackboardPageEmptyDescription.
  ///
  /// In de, this message translates to:
  /// **'Hier können wichtige Ankündigungen in Form eines digitalen Zettels an Schüler, Lehrkräfte und Eltern ausgeteilt werden. Ideal für beispielsweise den Elternsprechtag, den Wandertag, das Sportfest, usw.'**
  String get blackboardPageEmptyDescription;

  /// No description provided for @blackboardPageEmptyTitle.
  ///
  /// In de, this message translates to:
  /// **'Du hast alle Infozettel gelesen 👍'**
  String get blackboardPageEmptyTitle;

  /// No description provided for @blackboardPageFabTooltip.
  ///
  /// In de, this message translates to:
  /// **'Neuen Infozettel'**
  String get blackboardPageFabTooltip;

  /// No description provided for @blackboardReadByInfoVisibleForRole.
  ///
  /// In de, this message translates to:
  /// **'Diese Information ist für dich als {role} sichtbar.'**
  String blackboardReadByInfoVisibleForRole(String role);

  /// No description provided for @blackboardReadByPercent.
  ///
  /// In de, this message translates to:
  /// **'Gelesen von: {percent}%'**
  String blackboardReadByPercent(int percent);

  /// No description provided for @blackboardReadByRoleAdmin.
  ///
  /// In de, this message translates to:
  /// **'Admin'**
  String get blackboardReadByRoleAdmin;

  /// No description provided for @blackboardReadByRoleAuthor.
  ///
  /// In de, this message translates to:
  /// **'Autor'**
  String get blackboardReadByRoleAuthor;

  /// No description provided for @blackboardReadByUsersPlusDescription.
  ///
  /// In de, this message translates to:
  /// **'Erwerbe Sharezone Plus, um nachzuvollziehen, wer den Infozettel bereits gelesen hat.'**
  String get blackboardReadByUsersPlusDescription;

  /// No description provided for @blackboardReadByUsersTitle.
  ///
  /// In de, this message translates to:
  /// **'Gelesen von'**
  String get blackboardReadByUsersTitle;

  /// No description provided for @blackboardRemoveAttachment.
  ///
  /// In de, this message translates to:
  /// **'Anhang entfernen'**
  String get blackboardRemoveAttachment;

  /// No description provided for @blackboardSelectCoverImage.
  ///
  /// In de, this message translates to:
  /// **'Titelbild auswählen'**
  String get blackboardSelectCoverImage;

  /// No description provided for @blackboardSendNotificationDescription.
  ///
  /// In de, this message translates to:
  /// **'Sende eine Benachrichtigung an deine Kursmitglieder, dass du einen neuen Eintrag erstellt hast.'**
  String get blackboardSendNotificationDescription;

  /// No description provided for @bnbTutorialDescription.
  ///
  /// In de, this message translates to:
  /// **'Ziehe die untere Navigationsleiste nach oben, um auf weitere Funktionen zuzugreifen.'**
  String get bnbTutorialDescription;

  /// No description provided for @bnbTutorialSemanticsLabel.
  ///
  /// In de, this message translates to:
  /// **'Schaubild: Wie die Navigationsleiste nach oben gezogen wird, um weitere Navigationselemente zu zeigen.'**
  String get bnbTutorialSemanticsLabel;

  /// No description provided for @calendricalEventsAddEvent.
  ///
  /// In de, this message translates to:
  /// **'Termin eintragen'**
  String get calendricalEventsAddEvent;

  /// No description provided for @calendricalEventsAddExam.
  ///
  /// In de, this message translates to:
  /// **'Prüfung eintragen'**
  String get calendricalEventsAddExam;

  /// No description provided for @calendricalEventsCreateEventTooltip.
  ///
  /// In de, this message translates to:
  /// **'Neuen Termin erstellen'**
  String get calendricalEventsCreateEventTooltip;

  /// No description provided for @calendricalEventsCreateExamTooltip.
  ///
  /// In de, this message translates to:
  /// **'Neue Prüfung erstellen'**
  String get calendricalEventsCreateExamTooltip;

  /// No description provided for @calendricalEventsCreateNew.
  ///
  /// In de, this message translates to:
  /// **'Neu erstellen'**
  String get calendricalEventsCreateNew;

  /// No description provided for @calendricalEventsEmptyTitle.
  ///
  /// In de, this message translates to:
  /// **'Es stehen keine Termine und Prüfungen in der Zukunft an.'**
  String get calendricalEventsEmptyTitle;

  /// No description provided for @calendricalEventsFabTooltip.
  ///
  /// In de, this message translates to:
  /// **'Neue Prüfung oder Termin'**
  String get calendricalEventsFabTooltip;

  /// No description provided for @calendricalEventsSwitchToGrid.
  ///
  /// In de, this message translates to:
  /// **'Auf Kacheln umschalten'**
  String get calendricalEventsSwitchToGrid;

  /// No description provided for @calendricalEventsSwitchToList.
  ///
  /// In de, this message translates to:
  /// **'Auf Liste umschalten'**
  String get calendricalEventsSwitchToList;

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

  /// No description provided for @changeEmailAddressSubmitSnackbar.
  ///
  /// In de, this message translates to:
  /// **'Neue E-Mail-Adresse wird an die Zentrale geschickt...'**
  String get changeEmailAddressSubmitSnackbar;

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

  /// No description provided for @changeEmailReauthenticationDialogBody.
  ///
  /// In de, this message translates to:
  /// **'Nach der Änderung der E-Mail-Adresse musst du abgemeldet und wieder angemeldet werden. Danach kannst du die App wie gewohnt weiter nutzen.\n\nKlicke auf \"Weiter\" um eine Abmeldung und eine Anmeldung von Sharezone durchzuführen.\n\nEs kann sein, dass die Anmeldung nicht funktioniert (z.B. weil die E-Mail-Adresse noch nicht bestätigt wurde). Führe in diesem Fall die Anmeldung selbständig durch.'**
  String get changeEmailReauthenticationDialogBody;

  /// No description provided for @changeEmailReauthenticationDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Re-Authentifizierung'**
  String get changeEmailReauthenticationDialogTitle;

  /// No description provided for @changeEmailVerifyDialogAfterWord.
  ///
  /// In de, this message translates to:
  /// **'Nachdem'**
  String get changeEmailVerifyDialogAfterWord;

  /// No description provided for @changeEmailVerifyDialogBodyPrefix.
  ///
  /// In de, this message translates to:
  /// **'Wir haben dir einen Link geschickt. Bitte klicke jetzt auf den Link, um deine E-Mail zu bestätigen. Prüfe auch deinen Spam-Ordner.\n\n'**
  String get changeEmailVerifyDialogBodyPrefix;

  /// No description provided for @changeEmailVerifyDialogBodySuffix.
  ///
  /// In de, this message translates to:
  /// **' du die neue E-Mail-Adresse bestätigt hast, klicke auf \"Weiter\".'**
  String get changeEmailVerifyDialogBodySuffix;

  /// No description provided for @changeEmailVerifyDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Neue E-Mail Adresse bestätigen'**
  String get changeEmailVerifyDialogTitle;

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

  /// No description provided for @changelogPageTitle.
  ///
  /// In de, this message translates to:
  /// **'Was ist neu?'**
  String get changelogPageTitle;

  /// No description provided for @changelogSectionBugFixes.
  ///
  /// In de, this message translates to:
  /// **'Fehlerbehebungen:'**
  String get changelogSectionBugFixes;

  /// No description provided for @changelogSectionImprovements.
  ///
  /// In de, this message translates to:
  /// **'Verbesserungen:'**
  String get changelogSectionImprovements;

  /// No description provided for @changelogSectionNewFeatures.
  ///
  /// In de, this message translates to:
  /// **'Neue Funktionen:'**
  String get changelogSectionNewFeatures;

  /// No description provided for @changelogUpdatePromptStore.
  ///
  /// In de, this message translates to:
  /// **'Wir haben bemerkt, dass du eine veraltete Version der App installiert hast. Lade dir deswegen jetzt die Version im {store} herunter! 👍'**
  String changelogUpdatePromptStore(String store);

  /// No description provided for @changelogUpdatePromptTitle.
  ///
  /// In de, this message translates to:
  /// **'Neues Update verfügbar!'**
  String get changelogUpdatePromptTitle;

  /// No description provided for @changelogUpdatePromptWeb.
  ///
  /// In de, this message translates to:
  /// **'Wir haben bemerkt, dass du eine veraltete Version der App verwendest. Lade die Seite neu, um die neuste Version zu erhalten! 👍'**
  String get changelogUpdatePromptWeb;

  /// No description provided for @commentActionsCopyText.
  ///
  /// In de, this message translates to:
  /// **'Text kopieren'**
  String get commentActionsCopyText;

  /// No description provided for @commentActionsReport.
  ///
  /// In de, this message translates to:
  /// **'Kommentar melden'**
  String get commentActionsReport;

  /// No description provided for @commentDeletePrompt.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du wirklich den Kommentar für alle löschen?'**
  String get commentDeletePrompt;

  /// No description provided for @commentDeletedConfirmation.
  ///
  /// In de, this message translates to:
  /// **'Kommentar wurde gelöscht.'**
  String get commentDeletedConfirmation;

  /// No description provided for @commentSectionReplyPrompt.
  ///
  /// In de, this message translates to:
  /// **'Stell eine Rückfrage...'**
  String get commentSectionReplyPrompt;

  /// No description provided for @commentsSectionTitle.
  ///
  /// In de, this message translates to:
  /// **'Kommentare: {value}'**
  String commentsSectionTitle(Object value);

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

  /// No description provided for @commonActionRename.
  ///
  /// In de, this message translates to:
  /// **'Umbenennen'**
  String get commonActionRename;

  /// No description provided for @commonActionsAdd.
  ///
  /// In de, this message translates to:
  /// **'Hinzufügen'**
  String get commonActionsAdd;

  /// No description provided for @commonActionsAlright.
  ///
  /// In de, this message translates to:
  /// **'Alles klar'**
  String get commonActionsAlright;

  /// No description provided for @commonActionsBack.
  ///
  /// In de, this message translates to:
  /// **'Zurück'**
  String get commonActionsBack;

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

  /// No description provided for @commonActionsCreate.
  ///
  /// In de, this message translates to:
  /// **'Erstellen'**
  String get commonActionsCreate;

  /// No description provided for @commonActionsCreateUppercase.
  ///
  /// In de, this message translates to:
  /// **'ERSTELLEN'**
  String get commonActionsCreateUppercase;

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

  /// No description provided for @commonActionsDone.
  ///
  /// In de, this message translates to:
  /// **'Fertig'**
  String get commonActionsDone;

  /// No description provided for @commonActionsEdit.
  ///
  /// In de, this message translates to:
  /// **'Bearbeiten'**
  String get commonActionsEdit;

  /// No description provided for @commonActionsHelp.
  ///
  /// In de, this message translates to:
  /// **'Hilfe'**
  String get commonActionsHelp;

  /// No description provided for @commonActionsJoin.
  ///
  /// In de, this message translates to:
  /// **'Beitreten'**
  String get commonActionsJoin;

  /// No description provided for @commonActionsLeave.
  ///
  /// In de, this message translates to:
  /// **'Verlassen'**
  String get commonActionsLeave;

  /// No description provided for @commonActionsNo.
  ///
  /// In de, this message translates to:
  /// **'Nein'**
  String get commonActionsNo;

  /// No description provided for @commonActionsNotNow.
  ///
  /// In de, this message translates to:
  /// **'Nicht jetzt'**
  String get commonActionsNotNow;

  /// No description provided for @commonActionsOk.
  ///
  /// In de, this message translates to:
  /// **'Ok'**
  String get commonActionsOk;

  /// No description provided for @commonActionsReport.
  ///
  /// In de, this message translates to:
  /// **'Melden'**
  String get commonActionsReport;

  /// No description provided for @commonActionsSave.
  ///
  /// In de, this message translates to:
  /// **'Speichern'**
  String get commonActionsSave;

  /// No description provided for @commonActionsSend.
  ///
  /// In de, this message translates to:
  /// **'Senden'**
  String get commonActionsSend;

  /// No description provided for @commonActionsShare.
  ///
  /// In de, this message translates to:
  /// **'Teilen'**
  String get commonActionsShare;

  /// No description provided for @commonActionsSignOut.
  ///
  /// In de, this message translates to:
  /// **'Abmelden'**
  String get commonActionsSignOut;

  /// No description provided for @commonActionsSignOutUppercase.
  ///
  /// In de, this message translates to:
  /// **'ABMELDEN'**
  String get commonActionsSignOutUppercase;

  /// No description provided for @commonActionsSkip.
  ///
  /// In de, this message translates to:
  /// **'Überspringen'**
  String get commonActionsSkip;

  /// No description provided for @commonActionsYes.
  ///
  /// In de, this message translates to:
  /// **'Ja'**
  String get commonActionsYes;

  /// No description provided for @commonDate.
  ///
  /// In de, this message translates to:
  /// **'Datum'**
  String get commonDate;

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

  /// No description provided for @commonErrorGeneric.
  ///
  /// In de, this message translates to:
  /// **'Es ist ein Fehler aufgetreten.'**
  String get commonErrorGeneric;

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

  /// No description provided for @commonErrorTitle.
  ///
  /// In de, this message translates to:
  /// **'Fehler'**
  String get commonErrorTitle;

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

  /// No description provided for @commonFieldName.
  ///
  /// In de, this message translates to:
  /// **'Name'**
  String get commonFieldName;

  /// No description provided for @commonLoadingPleaseWait.
  ///
  /// In de, this message translates to:
  /// **'Bitte warten...'**
  String get commonLoadingPleaseWait;

  /// No description provided for @commonPleaseWaitMoment.
  ///
  /// In de, this message translates to:
  /// **'Bitte warte einen kurzen Augenblick.'**
  String get commonPleaseWaitMoment;

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

  /// No description provided for @commonTextCopiedToClipboard.
  ///
  /// In de, this message translates to:
  /// **'Text wurde in die Zwischenablage kopiert'**
  String get commonTextCopiedToClipboard;

  /// No description provided for @commonTitle.
  ///
  /// In de, this message translates to:
  /// **'Titel'**
  String get commonTitle;

  /// No description provided for @commonTitleNote.
  ///
  /// In de, this message translates to:
  /// **'Hinweis'**
  String get commonTitleNote;

  /// No description provided for @commonUnknownError.
  ///
  /// In de, this message translates to:
  /// **'Es ist ein Fehler aufgetreten.'**
  String get commonUnknownError;

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

  /// No description provided for @courseActionsDeleteUppercase.
  ///
  /// In de, this message translates to:
  /// **'KURS LÖSCHEN'**
  String get courseActionsDeleteUppercase;

  /// No description provided for @courseActionsKickUppercase.
  ///
  /// In de, this message translates to:
  /// **'AUS DEM KURS KICKEN'**
  String get courseActionsKickUppercase;

  /// No description provided for @courseActionsLeaveUppercase.
  ///
  /// In de, this message translates to:
  /// **'KURS VERLASSEN'**
  String get courseActionsLeaveUppercase;

  /// No description provided for @courseAllowJoinExplanation.
  ///
  /// In de, this message translates to:
  /// **'Über diese Einstellungen kannst du regulieren, ob neue Mitglieder dem Kurs beitreten dürfen.'**
  String get courseAllowJoinExplanation;

  /// No description provided for @courseCreateAbbreviationHint.
  ///
  /// In de, this message translates to:
  /// **'z.B. M'**
  String get courseCreateAbbreviationHint;

  /// No description provided for @courseCreateAbbreviationLabel.
  ///
  /// In de, this message translates to:
  /// **'Kürzel des Kurses'**
  String get courseCreateAbbreviationLabel;

  /// No description provided for @courseCreateNameDescription.
  ///
  /// In de, this message translates to:
  /// **'Der Kursname dient hauptsächlich für die Lehrkräfte, damit diese Kurse mit dem gleichen Fach unterscheiden können (z.B. \'Mathematik Klasse 8A\' und \'Mathematik Klasse 8B\').'**
  String get courseCreateNameDescription;

  /// No description provided for @courseCreateNameHint.
  ///
  /// In de, this message translates to:
  /// **'z.B. Mathematik GK Q2'**
  String get courseCreateNameHint;

  /// No description provided for @courseCreateSubjectHint.
  ///
  /// In de, this message translates to:
  /// **'z.B. Mathematik'**
  String get courseCreateSubjectHint;

  /// No description provided for @courseCreateSubjectRequiredLabel.
  ///
  /// In de, this message translates to:
  /// **'Fach des Kurses (erforderlich)'**
  String get courseCreateSubjectRequiredLabel;

  /// No description provided for @courseCreateTitle.
  ///
  /// In de, this message translates to:
  /// **'Kurs erstellen'**
  String get courseCreateTitle;

  /// No description provided for @courseDeleteDialogDescription.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du den Kurs \"{courseName}\" wirklich endgültig löschen?\n\nEs werden alle Stunden & Termine aus dem Stundenplan, Hausaufgaben und Infozettel gelöscht.\n\nAuf den Kurs kann von niemandem mehr zugegriffen werden!'**
  String courseDeleteDialogDescription(String courseName);

  /// No description provided for @courseDeleteDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Kurs löschen?'**
  String get courseDeleteDialogTitle;

  /// No description provided for @courseDeleteSuccess.
  ///
  /// In de, this message translates to:
  /// **'Du hast erfolgreich den Kurs gelöscht.'**
  String get courseDeleteSuccess;

  /// No description provided for @courseDesignColorChangeFailed.
  ///
  /// In de, this message translates to:
  /// **'Farbe konnte nicht geändert werden.'**
  String get courseDesignColorChangeFailed;

  /// No description provided for @courseDesignCourseColorChanged.
  ///
  /// In de, this message translates to:
  /// **'Farbe wurde erfolgreich für den gesamten Kurs geändert.'**
  String get courseDesignCourseColorChanged;

  /// No description provided for @courseDesignPersonalColorRemoved.
  ///
  /// In de, this message translates to:
  /// **'Persönliche Farbe wurde entfernt.'**
  String get courseDesignPersonalColorRemoved;

  /// No description provided for @courseDesignPersonalColorSet.
  ///
  /// In de, this message translates to:
  /// **'Persönliche Farbe wurde gesetzt.'**
  String get courseDesignPersonalColorSet;

  /// No description provided for @courseDesignPlusColorsHint.
  ///
  /// In de, this message translates to:
  /// **'Nicht genug Farben? Schalte mit Sharezone Plus +200 zusätzliche Farben frei.'**
  String get courseDesignPlusColorsHint;

  /// No description provided for @courseDesignRemovePersonalColor.
  ///
  /// In de, this message translates to:
  /// **'Persönliche Farbe entfernen'**
  String get courseDesignRemovePersonalColor;

  /// No description provided for @courseDesignTypeCourseSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Farbe gilt für den gesamten Kurs'**
  String get courseDesignTypeCourseSubtitle;

  /// No description provided for @courseDesignTypeCourseTitle.
  ///
  /// In de, this message translates to:
  /// **'Kurs'**
  String get courseDesignTypeCourseTitle;

  /// No description provided for @courseDesignTypePersonalSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Gilt nur für dich und liegt über der Kursfarbe'**
  String get courseDesignTypePersonalSubtitle;

  /// No description provided for @courseDesignTypePersonalTitle.
  ///
  /// In de, this message translates to:
  /// **'Persönlich'**
  String get courseDesignTypePersonalTitle;

  /// No description provided for @courseEditSuccess.
  ///
  /// In de, this message translates to:
  /// **'Der Kurs wurde erfolgreich bearbeitet!'**
  String get courseEditSuccess;

  /// No description provided for @courseEditTitle.
  ///
  /// In de, this message translates to:
  /// **'Kurs bearbeiten'**
  String get courseEditTitle;

  /// No description provided for @courseFieldsAbbreviationLabel.
  ///
  /// In de, this message translates to:
  /// **'Kürzel des Fachs'**
  String get courseFieldsAbbreviationLabel;

  /// No description provided for @courseFieldsNameLabel.
  ///
  /// In de, this message translates to:
  /// **'Name des Kurses'**
  String get courseFieldsNameLabel;

  /// No description provided for @courseFieldsSubjectLabel.
  ///
  /// In de, this message translates to:
  /// **'Fach'**
  String get courseFieldsSubjectLabel;

  /// No description provided for @courseJoinNotificationAlreadyMember.
  ///
  /// In de, this message translates to:
  /// **'Du bist der Gruppe bereits beigetreten'**
  String get courseJoinNotificationAlreadyMember;

  /// No description provided for @courseJoinNotificationGroupNotFound.
  ///
  /// In de, this message translates to:
  /// **'Gruppe nicht gefunden'**
  String get courseJoinNotificationGroupNotFound;

  /// No description provided for @courseJoinNotificationJoinForbidden.
  ///
  /// In de, this message translates to:
  /// **'Beitreten verboten. Kontaktiere den Admin der Gruppe.'**
  String get courseJoinNotificationJoinForbidden;

  /// No description provided for @courseJoinNotificationJoinedClass.
  ///
  /// In de, this message translates to:
  /// **'Du bist der Klasse \"{groupName}\" beigetreten'**
  String courseJoinNotificationJoinedClass(Object groupName);

  /// No description provided for @courseJoinNotificationJoinedCourse.
  ///
  /// In de, this message translates to:
  /// **'Du bist dem Kurs \"{groupName}\" beigetreten'**
  String courseJoinNotificationJoinedCourse(Object groupName);

  /// No description provided for @courseJoinNotificationLoading.
  ///
  /// In de, this message translates to:
  /// **'{sharecode} beitreten...'**
  String courseJoinNotificationLoading(Object sharecode);

  /// No description provided for @courseJoinNotificationNoInternet.
  ///
  /// In de, this message translates to:
  /// **'Keine Internetverbindung'**
  String get courseJoinNotificationNoInternet;

  /// No description provided for @courseJoinNotificationUnknownError.
  ///
  /// In de, this message translates to:
  /// **'Ein Fehler ist aufgetreten. Bitte kontaktiere den Support.'**
  String get courseJoinNotificationUnknownError;

  /// No description provided for @courseJoinNotificationUnknownErrorWithReason.
  ///
  /// In de, this message translates to:
  /// **'Ein Fehler ist aufgetreten: {reason}. Bitte kontaktiere den Support.'**
  String courseJoinNotificationUnknownErrorWithReason(Object reason);

  /// No description provided for @courseLeaveAndDeleteDialogDescription.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du den Kurs wirklich verlassen? Da du der letzte Teilnehmer im Kurs bist, wird der Kurs gelöscht.'**
  String get courseLeaveAndDeleteDialogDescription;

  /// No description provided for @courseLeaveAndDeleteDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Kurs verlassen und löschen?'**
  String get courseLeaveAndDeleteDialogTitle;

  /// No description provided for @courseLeaveDialogDescription.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du den Kurs wirklich verlassen?'**
  String get courseLeaveDialogDescription;

  /// No description provided for @courseLeaveDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Kurs verlassen?'**
  String get courseLeaveDialogTitle;

  /// No description provided for @courseLeaveSuccess.
  ///
  /// In de, this message translates to:
  /// **'Du hast erfolgreich den Kurs verlassen.'**
  String get courseLeaveSuccess;

  /// No description provided for @courseLongPressTitle.
  ///
  /// In de, this message translates to:
  /// **'Kurs: {courseName}'**
  String courseLongPressTitle(String courseName);

  /// No description provided for @courseMemberOptionsAloneHint.
  ///
  /// In de, this message translates to:
  /// **'Da du der einzige im Kurs bist, kannst du deine Rolle nicht bearbeiten.'**
  String get courseMemberOptionsAloneHint;

  /// No description provided for @courseMemberOptionsOnlyAdminHint.
  ///
  /// In de, this message translates to:
  /// **'Du bist der einzige Admin in diesem Kurs. Daher kannst du dir keine Rechte entziehen.'**
  String get courseMemberOptionsOnlyAdminHint;

  /// No description provided for @courseSelectColorsTooltip.
  ///
  /// In de, this message translates to:
  /// **'Farben auswählen'**
  String get courseSelectColorsTooltip;

  /// No description provided for @courseTemplateAlreadyExistsDescription.
  ///
  /// In de, this message translates to:
  /// **'Du hast bereits einen Kurs für das Fach {subject} erstellt. Möchtest du einen weiteren Kurs erstellen?'**
  String courseTemplateAlreadyExistsDescription(String subject);

  /// No description provided for @courseTemplateAlreadyExistsTitle.
  ///
  /// In de, this message translates to:
  /// **'Kurs bereits vorhanden'**
  String get courseTemplateAlreadyExistsTitle;

  /// No description provided for @courseTemplateCourseCreated.
  ///
  /// In de, this message translates to:
  /// **'Kurs \"{courseName}\" wurde erstellt.'**
  String courseTemplateCourseCreated(String courseName);

  /// No description provided for @courseTemplateCreateCustomCourseUppercase.
  ///
  /// In de, this message translates to:
  /// **'EIGENEN KURS ERSTELLEN'**
  String get courseTemplateCreateCustomCourseUppercase;

  /// No description provided for @courseTemplateCustomCourseMissingPrompt.
  ///
  /// In de, this message translates to:
  /// **'Dein Kurs ist nicht dabei?'**
  String get courseTemplateCustomCourseMissingPrompt;

  /// No description provided for @courseTemplateDeletedCourse.
  ///
  /// In de, this message translates to:
  /// **'Kurs wurde gelöscht.'**
  String get courseTemplateDeletedCourse;

  /// No description provided for @courseTemplateDeletingCourse.
  ///
  /// In de, this message translates to:
  /// **'Kurs wird wieder gelöscht...'**
  String get courseTemplateDeletingCourse;

  /// No description provided for @courseTemplateSchoolClassSelectionDescription.
  ///
  /// In de, this message translates to:
  /// **'Du bist in einer oder mehreren Schulklasse(n) Administrator. Wähle eine Schulklasse aus, um festzulegen, zu welcher Schulklasse die Kurse verknüpft werden sollen.'**
  String get courseTemplateSchoolClassSelectionDescription;

  /// No description provided for @courseTemplateSchoolClassSelectionInfo.
  ///
  /// In de, this message translates to:
  /// **'Kurse, die ab jetzt erstellt werden, werden mit der Schulklasse \"{name}\" verknüpft.'**
  String courseTemplateSchoolClassSelectionInfo(String name);

  /// No description provided for @courseTemplateSchoolClassSelectionNoneInfo.
  ///
  /// In de, this message translates to:
  /// **'Kurse, die ab jetzt erstellt werden, werden mit keiner Schulklasse verknüpft.'**
  String get courseTemplateSchoolClassSelectionNoneInfo;

  /// No description provided for @courseTemplateSchoolClassSelectionNoneOption.
  ///
  /// In de, this message translates to:
  /// **'Mit keiner Schulklasse verknüpfen'**
  String get courseTemplateSchoolClassSelectionNoneOption;

  /// No description provided for @courseTemplateSchoolClassSelectionTitle.
  ///
  /// In de, this message translates to:
  /// **'Schulklasse auswählen'**
  String get courseTemplateSchoolClassSelectionTitle;

  /// No description provided for @courseTemplateSubjectArt.
  ///
  /// In de, this message translates to:
  /// **'Kunst'**
  String get courseTemplateSubjectArt;

  /// No description provided for @courseTemplateSubjectBiology.
  ///
  /// In de, this message translates to:
  /// **'Biologie'**
  String get courseTemplateSubjectBiology;

  /// No description provided for @courseTemplateSubjectCatholicReligion.
  ///
  /// In de, this message translates to:
  /// **'Katholische Religion'**
  String get courseTemplateSubjectCatholicReligion;

  /// No description provided for @courseTemplateSubjectChemistry.
  ///
  /// In de, this message translates to:
  /// **'Chemie'**
  String get courseTemplateSubjectChemistry;

  /// No description provided for @courseTemplateSubjectComputerScience.
  ///
  /// In de, this message translates to:
  /// **'Informatik'**
  String get courseTemplateSubjectComputerScience;

  /// No description provided for @courseTemplateSubjectEconomics.
  ///
  /// In de, this message translates to:
  /// **'Wirtschaft'**
  String get courseTemplateSubjectEconomics;

  /// No description provided for @courseTemplateSubjectEnglish.
  ///
  /// In de, this message translates to:
  /// **'Englisch'**
  String get courseTemplateSubjectEnglish;

  /// No description provided for @courseTemplateSubjectEthics.
  ///
  /// In de, this message translates to:
  /// **'Ethik'**
  String get courseTemplateSubjectEthics;

  /// No description provided for @courseTemplateSubjectFrench.
  ///
  /// In de, this message translates to:
  /// **'Französisch'**
  String get courseTemplateSubjectFrench;

  /// No description provided for @courseTemplateSubjectGeography.
  ///
  /// In de, this message translates to:
  /// **'Geografie'**
  String get courseTemplateSubjectGeography;

  /// No description provided for @courseTemplateSubjectGeographyErdkunde.
  ///
  /// In de, this message translates to:
  /// **'Erdkunde'**
  String get courseTemplateSubjectGeographyErdkunde;

  /// No description provided for @courseTemplateSubjectGerman.
  ///
  /// In de, this message translates to:
  /// **'Deutsch'**
  String get courseTemplateSubjectGerman;

  /// No description provided for @courseTemplateSubjectHistory.
  ///
  /// In de, this message translates to:
  /// **'Geschichte'**
  String get courseTemplateSubjectHistory;

  /// No description provided for @courseTemplateSubjectHomeEconomics.
  ///
  /// In de, this message translates to:
  /// **'Hauswirtschaftslehre'**
  String get courseTemplateSubjectHomeEconomics;

  /// No description provided for @courseTemplateSubjectLatin.
  ///
  /// In de, this message translates to:
  /// **'Latein'**
  String get courseTemplateSubjectLatin;

  /// No description provided for @courseTemplateSubjectMath.
  ///
  /// In de, this message translates to:
  /// **'Mathematik'**
  String get courseTemplateSubjectMath;

  /// No description provided for @courseTemplateSubjectMusic.
  ///
  /// In de, this message translates to:
  /// **'Musik'**
  String get courseTemplateSubjectMusic;

  /// No description provided for @courseTemplateSubjectNaturalSciences.
  ///
  /// In de, this message translates to:
  /// **'Naturwissenschaften'**
  String get courseTemplateSubjectNaturalSciences;

  /// No description provided for @courseTemplateSubjectPedagogy.
  ///
  /// In de, this message translates to:
  /// **'Pädagogik'**
  String get courseTemplateSubjectPedagogy;

  /// No description provided for @courseTemplateSubjectPhilosophy.
  ///
  /// In de, this message translates to:
  /// **'Philosophie'**
  String get courseTemplateSubjectPhilosophy;

  /// No description provided for @courseTemplateSubjectPhysics.
  ///
  /// In de, this message translates to:
  /// **'Physik'**
  String get courseTemplateSubjectPhysics;

  /// No description provided for @courseTemplateSubjectPolitics.
  ///
  /// In de, this message translates to:
  /// **'Politik'**
  String get courseTemplateSubjectPolitics;

  /// No description provided for @courseTemplateSubjectPracticalPhilosophy.
  ///
  /// In de, this message translates to:
  /// **'Praktische Philosophie'**
  String get courseTemplateSubjectPracticalPhilosophy;

  /// No description provided for @courseTemplateSubjectProtestantReligion.
  ///
  /// In de, this message translates to:
  /// **'Evangelische Religion'**
  String get courseTemplateSubjectProtestantReligion;

  /// No description provided for @courseTemplateSubjectSocialStudies.
  ///
  /// In de, this message translates to:
  /// **'Gesellschaftslehre'**
  String get courseTemplateSubjectSocialStudies;

  /// No description provided for @courseTemplateSubjectSpanish.
  ///
  /// In de, this message translates to:
  /// **'Spanisch'**
  String get courseTemplateSubjectSpanish;

  /// No description provided for @courseTemplateSubjectSport.
  ///
  /// In de, this message translates to:
  /// **'Sport'**
  String get courseTemplateSubjectSport;

  /// No description provided for @courseTemplateSubjectTechnology.
  ///
  /// In de, this message translates to:
  /// **'Technik'**
  String get courseTemplateSubjectTechnology;

  /// No description provided for @courseTemplateSubjectWorkEducation.
  ///
  /// In de, this message translates to:
  /// **'Arbeitslehre'**
  String get courseTemplateSubjectWorkEducation;

  /// No description provided for @courseTemplateTitle.
  ///
  /// In de, this message translates to:
  /// **'Vorlagen'**
  String get courseTemplateTitle;

  /// No description provided for @courseTemplateUndoUppercase.
  ///
  /// In de, this message translates to:
  /// **'RÜCKGÄNGIG MACHEN'**
  String get courseTemplateUndoUppercase;

  /// No description provided for @dashboardAdSectionAcquireSuffix.
  ///
  /// In de, this message translates to:
  /// **' erwerben.'**
  String get dashboardAdSectionAcquireSuffix;

  /// No description provided for @dashboardAdSectionPrefix.
  ///
  /// In de, this message translates to:
  /// **'Dank dieser Anzeige ist Sharezone kostenlos. Falls du die Anzeige nicht sehen möchtest, kannst du '**
  String get dashboardAdSectionPrefix;

  /// No description provided for @dashboardAdSectionSharezonePlusLabel.
  ///
  /// In de, this message translates to:
  /// **'Sharezone Plus'**
  String get dashboardAdSectionSharezonePlusLabel;

  /// No description provided for @dashboardDebugClearCache.
  ///
  /// In de, this message translates to:
  /// **'[DEBUG] Cache löschen'**
  String get dashboardDebugClearCache;

  /// No description provided for @dashboardDebugOpenV2Dialog.
  ///
  /// In de, this message translates to:
  /// **'V2 Dialog öffnen'**
  String get dashboardDebugOpenV2Dialog;

  /// No description provided for @dashboardFabAddBlackboardTitle.
  ///
  /// In de, this message translates to:
  /// **'Infozettel'**
  String get dashboardFabAddBlackboardTitle;

  /// No description provided for @dashboardFabAddHomeworkTitle.
  ///
  /// In de, this message translates to:
  /// **'Hausaufgabe'**
  String get dashboardFabAddHomeworkTitle;

  /// No description provided for @dashboardFabCreateHomeworkTooltip.
  ///
  /// In de, this message translates to:
  /// **'Neue Hausaufgabe erstellen'**
  String get dashboardFabCreateHomeworkTooltip;

  /// No description provided for @dashboardFabCreateLessonTooltip.
  ///
  /// In de, this message translates to:
  /// **'Neue Schulstunde erstellen'**
  String get dashboardFabCreateLessonTooltip;

  /// No description provided for @dashboardFabTooltip.
  ///
  /// In de, this message translates to:
  /// **'Neue Elemente hinzufügen'**
  String get dashboardFabTooltip;

  /// No description provided for @dashboardHolidayCountdownDayUnitDay.
  ///
  /// In de, this message translates to:
  /// **'Tag'**
  String get dashboardHolidayCountdownDayUnitDay;

  /// No description provided for @dashboardHolidayCountdownDayUnitDays.
  ///
  /// In de, this message translates to:
  /// **'Tage'**
  String get dashboardHolidayCountdownDayUnitDays;

  /// No description provided for @dashboardHolidayCountdownDisplayError.
  ///
  /// In de, this message translates to:
  /// **'Es gab einen Fehler beim Anzeigen von den Ferien.\nFalls dieser Fehler öfter auftaucht, kontaktiere uns bitte.'**
  String get dashboardHolidayCountdownDisplayError;

  /// No description provided for @dashboardHolidayCountdownGeneralError.
  ///
  /// In de, this message translates to:
  /// **'💣 Boooomm.... Etwas ist kaputt gegangen. Starte am besten die App einmal neu 👍'**
  String get dashboardHolidayCountdownGeneralError;

  /// No description provided for @dashboardHolidayCountdownHolidayLine.
  ///
  /// In de, this message translates to:
  /// **'{title}: {text}'**
  String dashboardHolidayCountdownHolidayLine(String text, String title);

  /// No description provided for @dashboardHolidayCountdownInDays.
  ///
  /// In de, this message translates to:
  /// **'In {days} Tagen {emoji}'**
  String dashboardHolidayCountdownInDays(int days, String emoji);

  /// No description provided for @dashboardHolidayCountdownLastDay.
  ///
  /// In de, this message translates to:
  /// **'Letzter Tag 😱'**
  String get dashboardHolidayCountdownLastDay;

  /// No description provided for @dashboardHolidayCountdownNow.
  ///
  /// In de, this message translates to:
  /// **'JETZT, WOOOOOOO! {emoji}'**
  String dashboardHolidayCountdownNow(String emoji);

  /// No description provided for @dashboardHolidayCountdownRemaining.
  ///
  /// In de, this message translates to:
  /// **'Noch {days} {dayUnit} {emoji}'**
  String dashboardHolidayCountdownRemaining(
    String dayUnit,
    int days,
    String emoji,
  );

  /// No description provided for @dashboardHolidayCountdownSelectStateHint.
  ///
  /// In de, this message translates to:
  /// **'Durch das Auswählen deiner Region können wir berechnen, wie lange du dich noch in der Schule quälen musst, bis endlich die Ferien sind 😉'**
  String get dashboardHolidayCountdownSelectStateHint;

  /// No description provided for @dashboardHolidayCountdownTitle.
  ///
  /// In de, this message translates to:
  /// **'Ferien-Countdown'**
  String get dashboardHolidayCountdownTitle;

  /// No description provided for @dashboardHolidayCountdownTomorrow.
  ///
  /// In de, this message translates to:
  /// **'Morgen 😱🎉'**
  String get dashboardHolidayCountdownTomorrow;

  /// No description provided for @dashboardHolidayCountdownUnsupportedStateError.
  ///
  /// In de, this message translates to:
  /// **'Ferien können für dein ausgewähltes Bundesland nicht angezeigt werden! 😫\nDu kannst das Bundesland in den Einstellungen ändern.'**
  String get dashboardHolidayCountdownUnsupportedStateError;

  /// No description provided for @dashboardHolidayCountdownUnsupportedStateShortError.
  ///
  /// In de, this message translates to:
  /// **'Ferien konnten für dein Bundesland nicht angezeigt werden'**
  String get dashboardHolidayCountdownUnsupportedStateShortError;

  /// No description provided for @dashboardNoLessonsToday.
  ///
  /// In de, this message translates to:
  /// **'Yeah! Heute stehen keine Schulstunden an! 😍'**
  String get dashboardNoLessonsToday;

  /// No description provided for @dashboardNoUpcomingEventsInNext14Days.
  ///
  /// In de, this message translates to:
  /// **'In den nächsten 14 Tagen stehen keine Termine an! 👻'**
  String get dashboardNoUpcomingEventsInNext14Days;

  /// No description provided for @dashboardNoUrgentHomework.
  ///
  /// In de, this message translates to:
  /// **'Es stehen keine dringenden Hausaufgaben an 😅\nJetzt ist Zeit für die wichtigen Dinge! 😉'**
  String get dashboardNoUrgentHomework;

  /// No description provided for @dashboardRateOurAppActionTitle.
  ///
  /// In de, this message translates to:
  /// **'App bewerten'**
  String get dashboardRateOurAppActionTitle;

  /// No description provided for @dashboardRateOurAppText.
  ///
  /// In de, this message translates to:
  /// **'Wir wären dir unglaublich dankbar, wenn du uns eine Bewertung im App-/PlayStore hinterlassen könntest 🐵'**
  String get dashboardRateOurAppText;

  /// No description provided for @dashboardRateOurAppTitle.
  ///
  /// In de, this message translates to:
  /// **'Gefällt dir Sharezone?'**
  String get dashboardRateOurAppTitle;

  /// No description provided for @dashboardSchoolIsOver.
  ///
  /// In de, this message translates to:
  /// **'Endlich Schulschluss! 😍'**
  String get dashboardSchoolIsOver;

  /// No description provided for @dashboardSelectStateButton.
  ///
  /// In de, this message translates to:
  /// **'Bundesland / Kanton auswählen'**
  String get dashboardSelectStateButton;

  /// No description provided for @dashboardUnreadBlackboardTitle.
  ///
  /// In de, this message translates to:
  /// **'Ungelesene Infozettel'**
  String get dashboardUnreadBlackboardTitle;

  /// No description provided for @dashboardUnreadBlackboardTitleWithCount.
  ///
  /// In de, this message translates to:
  /// **'Ungelesene Infozettel ({count})'**
  String dashboardUnreadBlackboardTitleWithCount(int count);

  /// No description provided for @dashboardUpcomingEventsTitle.
  ///
  /// In de, this message translates to:
  /// **'Anstehende Termine'**
  String get dashboardUpcomingEventsTitle;

  /// No description provided for @dashboardUpcomingEventsTitleWithCount.
  ///
  /// In de, this message translates to:
  /// **'Anstehende Termine ({count})'**
  String dashboardUpcomingEventsTitleWithCount(int count);

  /// No description provided for @dashboardUrgentHomeworkTitle.
  ///
  /// In de, this message translates to:
  /// **'Dringende Hausaufgaben'**
  String get dashboardUrgentHomeworkTitle;

  /// No description provided for @dashboardUrgentHomeworkTitleWithCount.
  ///
  /// In de, this message translates to:
  /// **'Dringende Hausaufgaben ({count})'**
  String dashboardUrgentHomeworkTitleWithCount(int count);

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

  /// No description provided for @deleteAccountConfirmationCheckbox.
  ///
  /// In de, this message translates to:
  /// **'Ja, ich möchte mein Konto löschen.'**
  String get deleteAccountConfirmationCheckbox;

  /// No description provided for @drawerAboutTooltip.
  ///
  /// In de, this message translates to:
  /// **'Über uns'**
  String get drawerAboutTooltip;

  /// No description provided for @drawerNavigationTooltip.
  ///
  /// In de, this message translates to:
  /// **'Navigation'**
  String get drawerNavigationTooltip;

  /// No description provided for @drawerOpenSemanticsLabel.
  ///
  /// In de, this message translates to:
  /// **'Navigation öffnen'**
  String get drawerOpenSemanticsLabel;

  /// No description provided for @drawerProfileTooltip.
  ///
  /// In de, this message translates to:
  /// **'Profile'**
  String get drawerProfileTooltip;

  /// No description provided for @dynamicLinksNewLinkNotification.
  ///
  /// In de, this message translates to:
  /// **'Neuer Dynamic Link:\n{link}'**
  String dynamicLinksNewLinkNotification(Object link);

  /// No description provided for @feedbackBoxCooldownError.
  ///
  /// In de, this message translates to:
  /// **'Error! Dein Cool Down ({coolDown}) ist noch nicht abgelaufen.'**
  String feedbackBoxCooldownError(Object coolDown);

  /// No description provided for @feedbackBoxDislikeLabel.
  ///
  /// In de, this message translates to:
  /// **'Was gefällt Dir nicht?'**
  String get feedbackBoxDislikeLabel;

  /// No description provided for @feedbackBoxEmptyError.
  ///
  /// In de, this message translates to:
  /// **'Du musst auch schon was reinschreiben 😉'**
  String get feedbackBoxEmptyError;

  /// No description provided for @feedbackBoxGeneralRatingLabel.
  ///
  /// In de, this message translates to:
  /// **'Allgemeine Bewertung:'**
  String get feedbackBoxGeneralRatingLabel;

  /// No description provided for @feedbackBoxGenericError.
  ///
  /// In de, this message translates to:
  /// **'Error! Versuche es nochmal oder schicke uns dein Feedback gerne auch per E-Mail! :)'**
  String get feedbackBoxGenericError;

  /// No description provided for @feedbackBoxHeardFromLabel.
  ///
  /// In de, this message translates to:
  /// **'Wie hast Du von Sharezone erfahren?'**
  String get feedbackBoxHeardFromLabel;

  /// No description provided for @feedbackBoxLikeMostLabel.
  ///
  /// In de, this message translates to:
  /// **'Was gefällt Dir am besten?'**
  String get feedbackBoxLikeMostLabel;

  /// No description provided for @feedbackBoxMissingLabel.
  ///
  /// In de, this message translates to:
  /// **'Was fehlt Dir noch?'**
  String get feedbackBoxMissingLabel;

  /// No description provided for @feedbackBoxPageTitle.
  ///
  /// In de, this message translates to:
  /// **'Feedback-Box'**
  String get feedbackBoxPageTitle;

  /// No description provided for @feedbackBoxSubmitUppercase.
  ///
  /// In de, this message translates to:
  /// **'ABSCHICKEN'**
  String get feedbackBoxSubmitUppercase;

  /// No description provided for @feedbackBoxWhyWeNeedFeedbackDescription.
  ///
  /// In de, this message translates to:
  /// **'Wir möchten die beste App zum Organisieren des Schulalltags entwickeln! Damit wir das schaffen, brauchen wir Dich! Fülle einfach das Formular aus und schick es ab.\n\nAlle Fragen sind selbstverständlich freiwillig.'**
  String get feedbackBoxWhyWeNeedFeedbackDescription;

  /// No description provided for @feedbackBoxWhyWeNeedFeedbackTitle.
  ///
  /// In de, this message translates to:
  /// **'Warum wir Dein Feedback brauchen:'**
  String get feedbackBoxWhyWeNeedFeedbackTitle;

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

  /// No description provided for @feedbackHistoryPageEmpty.
  ///
  /// In de, this message translates to:
  /// **'Du hast bisher kein Feedback gegeben 😢'**
  String get feedbackHistoryPageEmpty;

  /// No description provided for @feedbackHistoryPageTitle.
  ///
  /// In de, this message translates to:
  /// **'Meine Feedbacks'**
  String get feedbackHistoryPageTitle;

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

  /// No description provided for @feedbackThankYouRatePromptPrefix.
  ///
  /// In de, this message translates to:
  /// **'Dir gefällt unsere App? Dann würden wir uns über eine Bewertung im '**
  String get feedbackThankYouRatePromptPrefix;

  /// No description provided for @feedbackThankYouRatePromptSuffix.
  ///
  /// In de, this message translates to:
  /// **' riesig freuen! 😄'**
  String get feedbackThankYouRatePromptSuffix;

  /// No description provided for @feedbackThankYouTitle.
  ///
  /// In de, this message translates to:
  /// **'Vielen Dank für dein Feedback!'**
  String get feedbackThankYouTitle;

  /// No description provided for @fileSharingCourseFoldersHeadline.
  ///
  /// In de, this message translates to:
  /// **'Kursordner'**
  String get fileSharingCourseFoldersHeadline;

  /// No description provided for @fileSharingDeleteFolderDescription.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du wirklich den Ordner mit dem Namen \"{value}\" löschen?'**
  String fileSharingDeleteFolderDescription(Object value);

  /// No description provided for @fileSharingDeleteFolderTitle.
  ///
  /// In de, this message translates to:
  /// **'Ordner löschen?'**
  String get fileSharingDeleteFolderTitle;

  /// No description provided for @fileSharingDownloadError.
  ///
  /// In de, this message translates to:
  /// **'Fehler: {value}'**
  String fileSharingDownloadError(Object value);

  /// No description provided for @fileSharingDownloadingFileMessage.
  ///
  /// In de, this message translates to:
  /// **'Datei wird heruntergeladen...'**
  String get fileSharingDownloadingFileMessage;

  /// No description provided for @fileSharingFabCameraTitle.
  ///
  /// In de, this message translates to:
  /// **'Kamera'**
  String get fileSharingFabCameraTitle;

  /// No description provided for @fileSharingFabCameraTooltip.
  ///
  /// In de, this message translates to:
  /// **'Kamera öffnen'**
  String get fileSharingFabCameraTooltip;

  /// No description provided for @fileSharingFabCreateFolderTitle.
  ///
  /// In de, this message translates to:
  /// **'Ordner erstellen'**
  String get fileSharingFabCreateFolderTitle;

  /// No description provided for @fileSharingFabCreateFolderTooltip.
  ///
  /// In de, this message translates to:
  /// **'Neuen Ordner erstellen'**
  String get fileSharingFabCreateFolderTooltip;

  /// No description provided for @fileSharingFabCreateNewTitle.
  ///
  /// In de, this message translates to:
  /// **'Neu erstellen'**
  String get fileSharingFabCreateNewTitle;

  /// No description provided for @fileSharingFabCreateNewTooltip.
  ///
  /// In de, this message translates to:
  /// **'Neu erstellen'**
  String get fileSharingFabCreateNewTooltip;

  /// No description provided for @fileSharingFabFilesTitle.
  ///
  /// In de, this message translates to:
  /// **'Dateien'**
  String get fileSharingFabFilesTitle;

  /// No description provided for @fileSharingFabFilesTooltip.
  ///
  /// In de, this message translates to:
  /// **'Dateien'**
  String get fileSharingFabFilesTooltip;

  /// No description provided for @fileSharingFabFolderNameHint.
  ///
  /// In de, this message translates to:
  /// **'Ordnername'**
  String get fileSharingFabFolderNameHint;

  /// No description provided for @fileSharingFabFolderTitle.
  ///
  /// In de, this message translates to:
  /// **'Ordner'**
  String get fileSharingFabFolderTitle;

  /// No description provided for @fileSharingFabImagesTitle.
  ///
  /// In de, this message translates to:
  /// **'Bilder'**
  String get fileSharingFabImagesTitle;

  /// No description provided for @fileSharingFabImagesTooltip.
  ///
  /// In de, this message translates to:
  /// **'Bilder'**
  String get fileSharingFabImagesTooltip;

  /// No description provided for @fileSharingFabMissingCameraPermission.
  ///
  /// In de, this message translates to:
  /// **'Oh! Die Berechtigung für die Kamera fehlt!'**
  String get fileSharingFabMissingCameraPermission;

  /// No description provided for @fileSharingFabUploadTitle.
  ///
  /// In de, this message translates to:
  /// **'Hochladen'**
  String get fileSharingFabUploadTitle;

  /// No description provided for @fileSharingFabUploadTooltip.
  ///
  /// In de, this message translates to:
  /// **'Neue Datei hochladen'**
  String get fileSharingFabUploadTooltip;

  /// No description provided for @fileSharingFabVideosTitle.
  ///
  /// In de, this message translates to:
  /// **'Videos'**
  String get fileSharingFabVideosTitle;

  /// No description provided for @fileSharingFabVideosTooltip.
  ///
  /// In de, this message translates to:
  /// **'Videos'**
  String get fileSharingFabVideosTooltip;

  /// No description provided for @fileSharingFoldersHeadline.
  ///
  /// In de, this message translates to:
  /// **'Ordner'**
  String get fileSharingFoldersHeadline;

  /// No description provided for @fileSharingMoveEmptyFoldersMessage.
  ///
  /// In de, this message translates to:
  /// **'Es befinden sich an diesem Ort keine weiteren Ordner... Navigiere zwischen den Ordnern über die Leiste oben.'**
  String get fileSharingMoveEmptyFoldersMessage;

  /// No description provided for @fileSharingNewNameHint.
  ///
  /// In de, this message translates to:
  /// **'Neuer Name'**
  String get fileSharingNewNameHint;

  /// No description provided for @fileSharingNoCourseFoldersFoundDescription.
  ///
  /// In de, this message translates to:
  /// **'Es wurden keine Ordner gefunden, da du noch keinen Kursen beigetreten bist. Trete einfach einem Kurs bei oder erstelle einen eigenen Kurs.'**
  String get fileSharingNoCourseFoldersFoundDescription;

  /// No description provided for @fileSharingNoFilesFoundDescription.
  ///
  /// In de, this message translates to:
  /// **'Lade jetzt einfach eine Datei hoch, um diese mit deinem Kurs zu teilen 👍'**
  String get fileSharingNoFilesFoundDescription;

  /// No description provided for @fileSharingNoFilesFoundTitle.
  ///
  /// In de, this message translates to:
  /// **'Keine Dateien gefunden 😶'**
  String get fileSharingNoFilesFoundTitle;

  /// No description provided for @fileSharingNoFoldersFoundTitle.
  ///
  /// In de, this message translates to:
  /// **'Keine Ordner gefunden! 😬'**
  String get fileSharingNoFoldersFoundTitle;

  /// No description provided for @fileSharingPreparingDownloadMessage.
  ///
  /// In de, this message translates to:
  /// **'Die Datei wird auf dein Gerät gebeamt...'**
  String get fileSharingPreparingDownloadMessage;

  /// No description provided for @fileSharingRenameActionUppercase.
  ///
  /// In de, this message translates to:
  /// **'UMBENENNEN'**
  String get fileSharingRenameActionUppercase;

  /// No description provided for @fileSharingRenameFolderTitle.
  ///
  /// In de, this message translates to:
  /// **'Ordner umbenennen'**
  String get fileSharingRenameFolderTitle;

  /// No description provided for @filesAddAttachment.
  ///
  /// In de, this message translates to:
  /// **'Anhang hinzufügen'**
  String get filesAddAttachment;

  /// No description provided for @filesCreator.
  ///
  /// In de, this message translates to:
  /// **'von {value}'**
  String filesCreator(Object value);

  /// No description provided for @filesDeleteDialogDescription.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du wirklich die Datei mit dem Namen \"{fileName}\" löschen?'**
  String filesDeleteDialogDescription(String fileName);

  /// No description provided for @filesDeleteDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Datei löschen?'**
  String get filesDeleteDialogTitle;

  /// No description provided for @filesDisplayErrorTitle.
  ///
  /// In de, this message translates to:
  /// **'Anzeigefehler'**
  String get filesDisplayErrorTitle;

  /// No description provided for @filesDownloadBrokenFileError.
  ///
  /// In de, this message translates to:
  /// **'Die Datei ist beschädigt und kann nicht heruntergeladen werden.'**
  String get filesDownloadBrokenFileError;

  /// No description provided for @filesDownloadStarted.
  ///
  /// In de, this message translates to:
  /// **'Download wurde gestartet...'**
  String get filesDownloadStarted;

  /// No description provided for @filesLoading.
  ///
  /// In de, this message translates to:
  /// **'Laden...'**
  String get filesLoading;

  /// No description provided for @filesMoveAcrossCoursesNotSupported.
  ///
  /// In de, this message translates to:
  /// **'Ein Verschieben zu einem anderen Kurs ist aktuell noch nicht möglich.'**
  String get filesMoveAcrossCoursesNotSupported;

  /// No description provided for @filesMoveTo.
  ///
  /// In de, this message translates to:
  /// **'Verschieben nach {value}'**
  String filesMoveTo(Object value);

  /// No description provided for @filesMoveUppercase.
  ///
  /// In de, this message translates to:
  /// **'VERSCHIEBEN'**
  String get filesMoveUppercase;

  /// No description provided for @filesNoCourseMembershipHint.
  ///
  /// In de, this message translates to:
  /// **'Du bist noch kein Mitglied eines Kurses 😔\nErstelle oder tritt einem Kurs bei 😃'**
  String get filesNoCourseMembershipHint;

  /// No description provided for @filesPrivateVisibleOnlyToYou.
  ///
  /// In de, this message translates to:
  /// **'Privat (nur für dich sichtbar)'**
  String get filesPrivateVisibleOnlyToYou;

  /// No description provided for @filesRenameDialogHint.
  ///
  /// In de, this message translates to:
  /// **'Neuer Name'**
  String get filesRenameDialogHint;

  /// No description provided for @filesRenameDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Datei umbenennen'**
  String get filesRenameDialogTitle;

  /// No description provided for @filesSelectCourseTitle.
  ///
  /// In de, this message translates to:
  /// **'Wähle einen Kurs aus'**
  String get filesSelectCourseTitle;

  /// No description provided for @filesSizeMegabytes.
  ///
  /// In de, this message translates to:
  /// **'Größe: {size} MB'**
  String filesSizeMegabytes(String size);

  /// No description provided for @filesUploadError.
  ///
  /// In de, this message translates to:
  /// **'Es gab einen Fehler: {error}'**
  String filesUploadError(Object error);

  /// No description provided for @filesUploadProgress.
  ///
  /// In de, this message translates to:
  /// **'Die Datei wird auf den Server hochgeladen: {progress}/100'**
  String filesUploadProgress(Object progress);

  /// No description provided for @filesUploadedOn.
  ///
  /// In de, this message translates to:
  /// **'Hochgeladen am: {date}'**
  String filesUploadedOn(String date);

  /// No description provided for @gradesCommonName.
  ///
  /// In de, this message translates to:
  /// **'Name'**
  String get gradesCommonName;

  /// No description provided for @gradesCreateTermCurrentTerm.
  ///
  /// In de, this message translates to:
  /// **'Aktuelles Halbjahr'**
  String get gradesCreateTermCurrentTerm;

  /// No description provided for @gradesCreateTermGradingSystemInfo.
  ///
  /// In de, this message translates to:
  /// **'Nur Noten von dem Notensystem, welches für das Halbjahr festlegt wurde, können für den Schnitt des Halbjahres berücksichtigt werden. Solltest du beispielsweise für das Halbjahr das Notensystem \"1 - 6\" festlegen und eine Note mit dem Notensystem \"15 - 0\" eintragen, kann diese Note für den Halbjahresschnitt nicht berücksichtigt werden.'**
  String get gradesCreateTermGradingSystemInfo;

  /// No description provided for @gradesCreateTermInvalidNameError.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib einen gültigen Namen ein.'**
  String get gradesCreateTermInvalidNameError;

  /// No description provided for @gradesCreateTermSaveFailedError.
  ///
  /// In de, this message translates to:
  /// **'Das Halbjahr konnte nicht gespeichert werden: {error}'**
  String gradesCreateTermSaveFailedError(Object error);

  /// No description provided for @gradesCreateTermSaved.
  ///
  /// In de, this message translates to:
  /// **'Halbjahr gespeichert.'**
  String get gradesCreateTermSaved;

  /// No description provided for @gradesDetailsDeletePrompt.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du diese Note wirklich löschen?'**
  String get gradesDetailsDeletePrompt;

  /// No description provided for @gradesDetailsDeleteTitle.
  ///
  /// In de, this message translates to:
  /// **'Note löschen'**
  String get gradesDetailsDeleteTitle;

  /// No description provided for @gradesDetailsDeleteTooltip.
  ///
  /// In de, this message translates to:
  /// **'Note löschen'**
  String get gradesDetailsDeleteTooltip;

  /// No description provided for @gradesDetailsDeleted.
  ///
  /// In de, this message translates to:
  /// **'Note gelöscht.'**
  String get gradesDetailsDeleted;

  /// No description provided for @gradesDetailsDummyDetails.
  ///
  /// In de, this message translates to:
  /// **'This is a test grade for algebra.'**
  String get gradesDetailsDummyDetails;

  /// No description provided for @gradesDetailsDummyTopic.
  ///
  /// In de, this message translates to:
  /// **'Algebra'**
  String get gradesDetailsDummyTopic;

  /// No description provided for @gradesDetailsEditTooltip.
  ///
  /// In de, this message translates to:
  /// **'Note bearbeiten'**
  String get gradesDetailsEditTooltip;

  /// No description provided for @gradesDialogCreateTerm.
  ///
  /// In de, this message translates to:
  /// **'Halbjahr erstellen'**
  String get gradesDialogCreateTerm;

  /// No description provided for @gradesDialogCustomGradeType.
  ///
  /// In de, this message translates to:
  /// **'Benutzerdefinierter Notentyp'**
  String get gradesDialogCustomGradeType;

  /// No description provided for @gradesDialogDateHelpDescription.
  ///
  /// In de, this message translates to:
  /// **'Das Datum stellt das Datum dar, an dem du die Note erhalten hast. Falls du das Datum nicht mehr genau weißt, kannst du einfach ein ungefähres Datum von dem Tag angeben, an dem du die Note erhalten hast.'**
  String get gradesDialogDateHelpDescription;

  /// No description provided for @gradesDialogDateHelpTitle.
  ///
  /// In de, this message translates to:
  /// **'Wozu dient das Datum?'**
  String get gradesDialogDateHelpTitle;

  /// No description provided for @gradesDialogDifferentGradingSystemInfo.
  ///
  /// In de, this message translates to:
  /// **'Das Notensystem, welches du ausgewählt hast, ist nicht dasselbe wie das Notensystem deines Halbjahres. Du kannst die Note weiterhin eintragen, aber sie wird nicht in den Schnitt deines Halbjahres einfließen.'**
  String get gradesDialogDifferentGradingSystemInfo;

  /// No description provided for @gradesDialogEditSubjectDescription.
  ///
  /// In de, this message translates to:
  /// **'Du kannst das Fach von bereits erstellten Noten nicht nachträglich ändern.\n\nLösche diese Note und erstelle sie erneut, um ein anderes Fach auszuwählen.'**
  String get gradesDialogEditSubjectDescription;

  /// No description provided for @gradesDialogEditSubjectTitle.
  ///
  /// In de, this message translates to:
  /// **'Fach ändern'**
  String get gradesDialogEditSubjectTitle;

  /// No description provided for @gradesDialogEditTermDescription.
  ///
  /// In de, this message translates to:
  /// **'Du kannst das Halbjahr von bereits erstellten Noten nicht nachträglich ändern.\n\nLösche diese Note und erstelle sie erneut, um ein anderes Halbjahr auszuwählen.'**
  String get gradesDialogEditTermDescription;

  /// No description provided for @gradesDialogEditTermTitle.
  ///
  /// In de, this message translates to:
  /// **'Halbjahr ändern'**
  String get gradesDialogEditTermTitle;

  /// No description provided for @gradesDialogEnterGradeError.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib eine Note an.'**
  String get gradesDialogEnterGradeError;

  /// No description provided for @gradesDialogEnterTitleError.
  ///
  /// In de, this message translates to:
  /// **'Bitte einen Titel eingeben.'**
  String get gradesDialogEnterTitleError;

  /// No description provided for @gradesDialogGoToSharezonePlus.
  ///
  /// In de, this message translates to:
  /// **'Zu Sharezone Plus'**
  String get gradesDialogGoToSharezonePlus;

  /// No description provided for @gradesDialogGradeInvalid.
  ///
  /// In de, this message translates to:
  /// **'Die Note ist ungültig.'**
  String get gradesDialogGradeInvalid;

  /// No description provided for @gradesDialogGradeIsInvalidError.
  ///
  /// In de, this message translates to:
  /// **'Die Eingabe ist keine gültige Zahl.'**
  String get gradesDialogGradeIsInvalidError;

  /// No description provided for @gradesDialogGradeIsOutOfRangeError.
  ///
  /// In de, this message translates to:
  /// **'Die Note ist außerhalb des gültigen Bereichs.'**
  String get gradesDialogGradeIsOutOfRangeError;

  /// No description provided for @gradesDialogGradeLabel.
  ///
  /// In de, this message translates to:
  /// **'Note'**
  String get gradesDialogGradeLabel;

  /// No description provided for @gradesDialogGradeTypeLabel.
  ///
  /// In de, this message translates to:
  /// **'Notentyp'**
  String get gradesDialogGradeTypeLabel;

  /// No description provided for @gradesDialogGradingSystemLabel.
  ///
  /// In de, this message translates to:
  /// **'Notensystem'**
  String get gradesDialogGradingSystemLabel;

  /// No description provided for @gradesDialogHintFifteenZero.
  ///
  /// In de, this message translates to:
  /// **'z.B. 15.0'**
  String get gradesDialogHintFifteenZero;

  /// No description provided for @gradesDialogHintOnePlus.
  ///
  /// In de, this message translates to:
  /// **'z.B. 1+'**
  String get gradesDialogHintOnePlus;

  /// No description provided for @gradesDialogHintOneThree.
  ///
  /// In de, this message translates to:
  /// **'z.B. 1.3'**
  String get gradesDialogHintOneThree;

  /// No description provided for @gradesDialogHintSeventyEightEight.
  ///
  /// In de, this message translates to:
  /// **'z.B. 78.8'**
  String get gradesDialogHintSeventyEightEight;

  /// No description provided for @gradesDialogHintSixZero.
  ///
  /// In de, this message translates to:
  /// **'z.B. 6.0'**
  String get gradesDialogHintSixZero;

  /// No description provided for @gradesDialogIncludeGradeInAverage.
  ///
  /// In de, this message translates to:
  /// **'Note in Schnitt einbringen'**
  String get gradesDialogIncludeGradeInAverage;

  /// No description provided for @gradesDialogInvalidFieldsCombined.
  ///
  /// In de, this message translates to:
  /// **'Folgende Felder fehlen oder sind ungültig: {fieldMessages}.'**
  String gradesDialogInvalidFieldsCombined(Object fieldMessages);

  /// No description provided for @gradesDialogInvalidGradeField.
  ///
  /// In de, this message translates to:
  /// **'Die Note fehlt oder ist ungültig.'**
  String get gradesDialogInvalidGradeField;

  /// No description provided for @gradesDialogInvalidSubjectField.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib ein Fach für die Note an.'**
  String get gradesDialogInvalidSubjectField;

  /// No description provided for @gradesDialogInvalidTermField.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib ein Halbjahr für die Note an.'**
  String get gradesDialogInvalidTermField;

  /// No description provided for @gradesDialogInvalidTitleField.
  ///
  /// In de, this message translates to:
  /// **'Der Titel fehlt oder ist ungültig.'**
  String get gradesDialogInvalidTitleField;

  /// No description provided for @gradesDialogNoGradeSelected.
  ///
  /// In de, this message translates to:
  /// **'Keine Note ausgewählt'**
  String get gradesDialogNoGradeSelected;

  /// No description provided for @gradesDialogNoSubjectSelected.
  ///
  /// In de, this message translates to:
  /// **'Kein Fach ausgewählt'**
  String get gradesDialogNoSubjectSelected;

  /// No description provided for @gradesDialogNoTermSelected.
  ///
  /// In de, this message translates to:
  /// **'Kein Halbjahr ausgewählt'**
  String get gradesDialogNoTermSelected;

  /// No description provided for @gradesDialogNoTermsYetInfo.
  ///
  /// In de, this message translates to:
  /// **'Bisher hast du keine Halbjahre erstellt. Bitte erstelle ein Halbjahr, um eine Note einzutragen.'**
  String get gradesDialogNoTermsYetInfo;

  /// No description provided for @gradesDialogNotesLabel.
  ///
  /// In de, this message translates to:
  /// **'Notizen'**
  String get gradesDialogNotesLabel;

  /// No description provided for @gradesDialogPlusSubjectsLimitInfo.
  ///
  /// In de, this message translates to:
  /// **'Du kannst zum Testen der Notenfunktion maximal 3 Fächer benutzen. Um alle Fächer zu benutzen, kaufe Sharezone Plus.'**
  String get gradesDialogPlusSubjectsLimitInfo;

  /// No description provided for @gradesDialogRequestAdditionalGradingSystem.
  ///
  /// In de, this message translates to:
  /// **'Weiteres Notensystem anfragen'**
  String get gradesDialogRequestAdditionalGradingSystem;

  /// No description provided for @gradesDialogRequestAdditionalGradingSystemSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Notensystem nicht dabei? Schreib uns, welches Notensystem du gerne hättest!'**
  String get gradesDialogRequestAdditionalGradingSystemSubtitle;

  /// No description provided for @gradesDialogSavedSnackBar.
  ///
  /// In de, this message translates to:
  /// **'Note gespeichert'**
  String get gradesDialogSavedSnackBar;

  /// No description provided for @gradesDialogSelectGrade.
  ///
  /// In de, this message translates to:
  /// **'Note auswählen'**
  String get gradesDialogSelectGrade;

  /// No description provided for @gradesDialogSelectGradeType.
  ///
  /// In de, this message translates to:
  /// **'Notentyp auswählen'**
  String get gradesDialogSelectGradeType;

  /// No description provided for @gradesDialogSelectGradingSystem.
  ///
  /// In de, this message translates to:
  /// **'Notensystem auswählen'**
  String get gradesDialogSelectGradingSystem;

  /// No description provided for @gradesDialogSelectGradingSystemHint.
  ///
  /// In de, this message translates to:
  /// **'Der erste Wert entspricht der besten Noten, z.B. bei dem Notensystem \"1 - 6\" ist \"1\" die beste Note.'**
  String get gradesDialogSelectGradingSystemHint;

  /// No description provided for @gradesDialogSelectSubject.
  ///
  /// In de, this message translates to:
  /// **'Fach auswählen'**
  String get gradesDialogSelectSubject;

  /// No description provided for @gradesDialogSelectTerm.
  ///
  /// In de, this message translates to:
  /// **'Halbjahr auswählen'**
  String get gradesDialogSelectTerm;

  /// No description provided for @gradesDialogSubjectLabel.
  ///
  /// In de, this message translates to:
  /// **'Fach'**
  String get gradesDialogSubjectLabel;

  /// No description provided for @gradesDialogTermLabel.
  ///
  /// In de, this message translates to:
  /// **'Halbjahr'**
  String get gradesDialogTermLabel;

  /// No description provided for @gradesDialogTitleHelpDescription.
  ///
  /// In de, this message translates to:
  /// **'Falls die Note beispielsweise zu einer Klausur gehört, kannst du das Thema / den Titel der Klausur angeben, um die Note später besser zuordnen zu können.'**
  String get gradesDialogTitleHelpDescription;

  /// No description provided for @gradesDialogTitleHelpTitle.
  ///
  /// In de, this message translates to:
  /// **'Wozu dient der Titel?'**
  String get gradesDialogTitleHelpTitle;

  /// No description provided for @gradesDialogTitleHint.
  ///
  /// In de, this message translates to:
  /// **'z.B. Lineare Funktionen'**
  String get gradesDialogTitleHint;

  /// No description provided for @gradesDialogTitleLabel.
  ///
  /// In de, this message translates to:
  /// **'Titel'**
  String get gradesDialogTitleLabel;

  /// No description provided for @gradesDialogUnknownCustomGradeType.
  ///
  /// In de, this message translates to:
  /// **'Unbekannt/Eigener Notentyp'**
  String get gradesDialogUnknownCustomGradeType;

  /// No description provided for @gradesDialogUnknownError.
  ///
  /// In de, this message translates to:
  /// **'Unbekannter Fehler: {error}'**
  String gradesDialogUnknownError(Object error);

  /// No description provided for @gradesDialogZeroWeightGradeTypeInfo.
  ///
  /// In de, this message translates to:
  /// **'Der ausgewählte Notentyp hat aktuell eine Gewichtung von 0. Du kannst die Note weiterhin eintragen, aber sie wird den Schnitt der Fachnote nicht beeinflussen. Du kannst die Gewichtung nach Speichern der Note im Fach oder im Halbjahr anpassen, damit die Note in den Schnitt einfließt.'**
  String get gradesDialogZeroWeightGradeTypeInfo;

  /// No description provided for @gradesFinalGradeTypeHelpDialogText.
  ///
  /// In de, this message translates to:
  /// **'Die Endnote ist die abschließende Note, die du in einem Fach bekommst, zum Beispiel die Note auf deinem Zeugnis. Manchmal berücksichtigt deine Lehrkraft zusätzliche Faktoren, die von der üblichen Berechnungsformel abweichen können – etwa 50% Prüfungen und 50% mündliche Beteiligung. In solchen Fällen kannst du die in Sharezone automatisch berechnete Note durch diese finale Note ersetzen.\n\nDiese Einstellung kann entweder für alle Fächer eines Halbjahres gleichzeitig festgelegt oder für jedes Fach individuell angepasst werden. So hast du die Flexibilität, je nach Bedarf spezifische Anpassungen vorzunehmen.'**
  String get gradesFinalGradeTypeHelpDialogText;

  /// No description provided for @gradesFinalGradeTypeHelpDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Was ist die Endnote eines Faches?'**
  String get gradesFinalGradeTypeHelpDialogTitle;

  /// No description provided for @gradesFinalGradeTypeHelpTooltip.
  ///
  /// In de, this message translates to:
  /// **'Was ist die Endnote?'**
  String get gradesFinalGradeTypeHelpTooltip;

  /// No description provided for @gradesFinalGradeTypeSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Die berechnete Fachnote kann von einem Notentyp überschrieben werden.'**
  String get gradesFinalGradeTypeSubtitle;

  /// No description provided for @gradesFinalGradeTypeTitle.
  ///
  /// In de, this message translates to:
  /// **'Endnote eines Faches'**
  String get gradesFinalGradeTypeTitle;

  /// No description provided for @gradesPageAddGrade.
  ///
  /// In de, this message translates to:
  /// **'Note eintragen'**
  String get gradesPageAddGrade;

  /// No description provided for @gradesPageCurrentGradesLabel.
  ///
  /// In de, this message translates to:
  /// **'Aktuelle Noten'**
  String get gradesPageCurrentGradesLabel;

  /// No description provided for @gradesPagePastTermTitle.
  ///
  /// In de, this message translates to:
  /// **'Vergangenes Halbjahr'**
  String get gradesPagePastTermTitle;

  /// No description provided for @gradesSettingsPageTitle.
  ///
  /// In de, this message translates to:
  /// **'Noten-Einstellungen'**
  String get gradesSettingsPageTitle;

  /// No description provided for @gradesSettingsSubjectsSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Verwalte Fächer und verbundene Kurse'**
  String get gradesSettingsSubjectsSubtitle;

  /// No description provided for @gradesSettingsSubjectsTitle.
  ///
  /// In de, this message translates to:
  /// **'Fächer'**
  String get gradesSettingsSubjectsTitle;

  /// No description provided for @gradesSubjectSettingsPageTitle.
  ///
  /// In de, this message translates to:
  /// **'Einstellungen: {subjectDisplayName}'**
  String gradesSubjectSettingsPageTitle(Object subjectDisplayName);

  /// No description provided for @gradesSubjectsPageCourseNotAssigned.
  ///
  /// In de, this message translates to:
  /// **'Dieser Kurs ist noch keinem Notenfach zugeordnet.'**
  String get gradesSubjectsPageCourseNotAssigned;

  /// No description provided for @gradesSubjectsPageCoursesLabel.
  ///
  /// In de, this message translates to:
  /// **'Kurse: {courseNames}'**
  String gradesSubjectsPageCoursesLabel(Object courseNames);

  /// No description provided for @gradesSubjectsPageCoursesWithoutSubject.
  ///
  /// In de, this message translates to:
  /// **'Kurse ohne Notenfach'**
  String get gradesSubjectsPageCoursesWithoutSubject;

  /// No description provided for @gradesSubjectsPageDeleteDescription.
  ///
  /// In de, this message translates to:
  /// **'Beim Löschen werden alle zugehörigen Noten dauerhaft entfernt.'**
  String get gradesSubjectsPageDeleteDescription;

  /// No description provided for @gradesSubjectsPageDeleteFailure.
  ///
  /// In de, this message translates to:
  /// **'Fach konnte nicht gelöscht werden: {error}'**
  String gradesSubjectsPageDeleteFailure(Object error);

  /// No description provided for @gradesSubjectsPageDeleteSuccess.
  ///
  /// In de, this message translates to:
  /// **'Fach und zugehörige Noten gelöscht.'**
  String get gradesSubjectsPageDeleteSuccess;

  /// No description provided for @gradesSubjectsPageDeleteTitle.
  ///
  /// In de, this message translates to:
  /// **'{subjectName} löschen'**
  String gradesSubjectsPageDeleteTitle(Object subjectName);

  /// No description provided for @gradesSubjectsPageDeleteTooltip.
  ///
  /// In de, this message translates to:
  /// **'Fach löschen'**
  String get gradesSubjectsPageDeleteTooltip;

  /// No description provided for @gradesSubjectsPageGradeSubjects.
  ///
  /// In de, this message translates to:
  /// **'Notenfächer'**
  String get gradesSubjectsPageGradeSubjects;

  /// No description provided for @gradesSubjectsPageInfoBody.
  ///
  /// In de, this message translates to:
  /// **'In Sharezone werden alle Inhalte (wie Hausaufgaben oder Prüfungen) einem Kurs zugeordnet. Deine Noten werden jedoch in Notenfächern gespeichert - nicht in Kursen. So bleiben sie erhalten, auch wenn du einen Kurs verlässt.\n\nDas hat noch einen Vorteil: Du kannst deine Noten nach Fächern sortieren und später deine Entwicklung in einem Fach über mehrere Jahre hinweg verfolgen (diese Funktion ist bald verfügbar).\n\nSharezone legt automatisch ein Notenfach an, sobald du eine Note in einem Kurs erstellst.'**
  String get gradesSubjectsPageInfoBody;

  /// No description provided for @gradesSubjectsPageInfoHeader.
  ///
  /// In de, this message translates to:
  /// **'Notenfächer vs Kurse'**
  String get gradesSubjectsPageInfoHeader;

  /// No description provided for @gradesSubjectsPageMultipleGrades.
  ///
  /// In de, this message translates to:
  /// **'{count} Noten'**
  String gradesSubjectsPageMultipleGrades(Object count);

  /// No description provided for @gradesSubjectsPageNoGrades.
  ///
  /// In de, this message translates to:
  /// **'Keine Noten'**
  String get gradesSubjectsPageNoGrades;

  /// No description provided for @gradesSubjectsPageNoGradesRecorded.
  ///
  /// In de, this message translates to:
  /// **'Für dieses Fach wurden noch keine Noten erfasst.'**
  String get gradesSubjectsPageNoGradesRecorded;

  /// No description provided for @gradesSubjectsPageSingleGrade.
  ///
  /// In de, this message translates to:
  /// **'1 Note'**
  String get gradesSubjectsPageSingleGrade;

  /// No description provided for @gradesTermDetailsDeleteDescription.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du das Halbjahr inkl. aller Noten wirklich löschen?\n\nDiese Aktion kann nicht rückgängig gemacht werden.'**
  String get gradesTermDetailsDeleteDescription;

  /// No description provided for @gradesTermDetailsDeleteTitle.
  ///
  /// In de, this message translates to:
  /// **'Halbjahr löschen'**
  String get gradesTermDetailsDeleteTitle;

  /// No description provided for @gradesTermDetailsDeleteTooltip.
  ///
  /// In de, this message translates to:
  /// **'Halbjahr löschen'**
  String get gradesTermDetailsDeleteTooltip;

  /// No description provided for @gradesTermDetailsEditSubjectTooltip.
  ///
  /// In de, this message translates to:
  /// **'Fachnote bearbeiten'**
  String get gradesTermDetailsEditSubjectTooltip;

  /// No description provided for @gradesTermDetailsPageTitle.
  ///
  /// In de, this message translates to:
  /// **'Halbjahresdetails'**
  String get gradesTermDetailsPageTitle;

  /// No description provided for @gradesTermDialogNameLabel.
  ///
  /// In de, this message translates to:
  /// **'Name des Halbjahres'**
  String get gradesTermDialogNameLabel;

  /// No description provided for @gradesTermSettingsCourseWeightingDescription.
  ///
  /// In de, this message translates to:
  /// **'Solltest du Kurse haben, die doppelt gewichtet werden, kannst du bei diesen eine 2.0 eintragen.'**
  String get gradesTermSettingsCourseWeightingDescription;

  /// No description provided for @gradesTermSettingsCourseWeightingTitle.
  ///
  /// In de, this message translates to:
  /// **'Gewichtung der Kurse für Notenschnitt vom Halbjahr'**
  String get gradesTermSettingsCourseWeightingTitle;

  /// No description provided for @gradesTermSettingsEditNameDescription.
  ///
  /// In de, this message translates to:
  /// **'Der Name beschreibt das Halbjahr, z.B. \'10/2\' für das zweite Halbjahr der 10. Klasse.'**
  String get gradesTermSettingsEditNameDescription;

  /// No description provided for @gradesTermSettingsEditNameTitle.
  ///
  /// In de, this message translates to:
  /// **'Name ändern'**
  String get gradesTermSettingsEditNameTitle;

  /// No description provided for @gradesTermSettingsEditWeightDescription.
  ///
  /// In de, this message translates to:
  /// **'Die Gewichtung beschreibt, wie stark die Note des Kurses in den Halbjahresschnitt einfließt.'**
  String get gradesTermSettingsEditWeightDescription;

  /// No description provided for @gradesTermSettingsEditWeightTitle.
  ///
  /// In de, this message translates to:
  /// **'Gewichtung ändern'**
  String get gradesTermSettingsEditWeightTitle;

  /// No description provided for @gradesTermSettingsNameHint.
  ///
  /// In de, this message translates to:
  /// **'z.B. 10/2'**
  String get gradesTermSettingsNameHint;

  /// No description provided for @gradesTermSettingsNameRequired.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib einen Namen ein.'**
  String get gradesTermSettingsNameRequired;

  /// No description provided for @gradesTermSettingsNoSubjectsYet.
  ///
  /// In de, this message translates to:
  /// **'Du hast bisher noch keine Fächer erstellt.'**
  String get gradesTermSettingsNoSubjectsYet;

  /// No description provided for @gradesTermSettingsTitle.
  ///
  /// In de, this message translates to:
  /// **'Einstellung: {name}'**
  String gradesTermSettingsTitle(Object name);

  /// No description provided for @gradesTermSettingsWeightDisplayTypeFactor.
  ///
  /// In de, this message translates to:
  /// **'Faktor'**
  String get gradesTermSettingsWeightDisplayTypeFactor;

  /// No description provided for @gradesTermSettingsWeightDisplayTypePercent.
  ///
  /// In de, this message translates to:
  /// **'Prozent'**
  String get gradesTermSettingsWeightDisplayTypePercent;

  /// No description provided for @gradesTermSettingsWeightDisplayTypeTitle.
  ///
  /// In de, this message translates to:
  /// **'Gewichtungssystem'**
  String get gradesTermSettingsWeightDisplayTypeTitle;

  /// No description provided for @gradesTermSettingsWeightHint.
  ///
  /// In de, this message translates to:
  /// **'z.B. 1.0'**
  String get gradesTermSettingsWeightHint;

  /// No description provided for @gradesTermSettingsWeightInvalid.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib eine Zahl ein.'**
  String get gradesTermSettingsWeightInvalid;

  /// No description provided for @gradesTermSettingsWeightLabel.
  ///
  /// In de, this message translates to:
  /// **'Gewichtung'**
  String get gradesTermSettingsWeightLabel;

  /// No description provided for @gradesTermTileEditTooltip.
  ///
  /// In de, this message translates to:
  /// **'Bearbeiten des Schnitts'**
  String get gradesTermTileEditTooltip;

  /// No description provided for @gradesWeightSettingsAddWeight.
  ///
  /// In de, this message translates to:
  /// **'Neue Gewichtung hinzufügen'**
  String get gradesWeightSettingsAddWeight;

  /// No description provided for @gradesWeightSettingsHelpDialogText.
  ///
  /// In de, this message translates to:
  /// **'In Sharezone kannst du genau bestimmen, wie die Note für jedes Fach berechnet wird, indem du die Gewichtung der verschiedenen Notentypen festlegst. Zum Beispiel kannst du einstellen, dass die Gesamtnote aus 50% schriftlichen Prüfungen und 50% mündlicher Beteiligung zusammengesetzt wird.\n\nDiese Flexibilität ermöglicht es dir, die Bewertungskriterien deiner Schule genau abzubilden und sicherzustellen, dass jede Art von Leistung angemessen berücksichtigt wird.'**
  String get gradesWeightSettingsHelpDialogText;

  /// No description provided for @gradesWeightSettingsHelpDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Wie wird die Note eines Fachs berechnet?'**
  String get gradesWeightSettingsHelpDialogTitle;

  /// No description provided for @gradesWeightSettingsHelpTooltip.
  ///
  /// In de, this message translates to:
  /// **'Wie wird die Note berechnet?'**
  String get gradesWeightSettingsHelpTooltip;

  /// No description provided for @gradesWeightSettingsInvalidWeightInput.
  ///
  /// In de, this message translates to:
  /// **'Bitte gebe eine gültige Zahl (>= 0) ein.'**
  String get gradesWeightSettingsInvalidWeightInput;

  /// No description provided for @gradesWeightSettingsPercentHint.
  ///
  /// In de, this message translates to:
  /// **'z.B. 56.5'**
  String get gradesWeightSettingsPercentHint;

  /// No description provided for @gradesWeightSettingsPercentLabel.
  ///
  /// In de, this message translates to:
  /// **'Gewichtung in %'**
  String get gradesWeightSettingsPercentLabel;

  /// No description provided for @gradesWeightSettingsRemoveTooltip.
  ///
  /// In de, this message translates to:
  /// **'Entfernen'**
  String get gradesWeightSettingsRemoveTooltip;

  /// No description provided for @gradesWeightSettingsSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Lege die Gewichtung der Notentypen für die Berechnung der Fachnote fest.'**
  String get gradesWeightSettingsSubtitle;

  /// No description provided for @gradesWeightSettingsTitle.
  ///
  /// In de, this message translates to:
  /// **'Berechnung der Fachnote'**
  String get gradesWeightSettingsTitle;

  /// No description provided for @gradingSystemAustrianBehaviouralGrades.
  ///
  /// In de, this message translates to:
  /// **'Österreichische Verhaltensnoten'**
  String get gradingSystemAustrianBehaviouralGrades;

  /// No description provided for @gradingSystemOneToFiveWithDecimals.
  ///
  /// In de, this message translates to:
  /// **'1 - 5 (mit Kommazahlen)'**
  String get gradingSystemOneToFiveWithDecimals;

  /// No description provided for @gradingSystemOneToSixWithDecimals.
  ///
  /// In de, this message translates to:
  /// **'1 - 6 (mit Kommazahlen)'**
  String get gradingSystemOneToSixWithDecimals;

  /// No description provided for @gradingSystemOneToSixWithPlusAndMinus.
  ///
  /// In de, this message translates to:
  /// **'1 - 6 (+-)'**
  String get gradingSystemOneToSixWithPlusAndMinus;

  /// No description provided for @gradingSystemSixToOneWithDecimals.
  ///
  /// In de, this message translates to:
  /// **'6 - 1 (mit Kommazahlen)'**
  String get gradingSystemSixToOneWithDecimals;

  /// No description provided for @gradingSystemZeroToFifteenPoints.
  ///
  /// In de, this message translates to:
  /// **'15 - 0 Punkte'**
  String get gradingSystemZeroToFifteenPoints;

  /// No description provided for @gradingSystemZeroToFifteenPointsWithDecimals.
  ///
  /// In de, this message translates to:
  /// **'15 - 0 Punkte (mit Kommazahlen)'**
  String get gradingSystemZeroToFifteenPointsWithDecimals;

  /// No description provided for @gradingSystemZeroToHundredPercentWithDecimals.
  ///
  /// In de, this message translates to:
  /// **'100% - 0% (mit Kommazahlen)'**
  String get gradingSystemZeroToHundredPercentWithDecimals;

  /// No description provided for @groupCourseDetailsLoadError.
  ///
  /// In de, this message translates to:
  /// **'Es gab einen Fehler beim Laden des Kurses.\n\nMöglicherweise bist du nicht mehr ein Teilnehmer dieses Kurses.'**
  String get groupCourseDetailsLoadError;

  /// No description provided for @groupDesignSelectBaseColorTitle.
  ///
  /// In de, this message translates to:
  /// **'Grundfarbe auswählen'**
  String get groupDesignSelectBaseColorTitle;

  /// No description provided for @groupHelpDifferenceDescription.
  ///
  /// In de, this message translates to:
  /// **'Kurs: Spiegelt ein Schulfach wieder.\n\nSchulklasse: Besteht aus mehreren Kursen und ermöglicht das Beitreten all dieser Kurse mit nur einem Sharecode.\n\nGruppe: Ist der Oberbegriff für einen Kurs und eine Schulklasse.'**
  String get groupHelpDifferenceDescription;

  /// No description provided for @groupHelpDifferenceTitle.
  ///
  /// In de, this message translates to:
  /// **'Was ist der Unterschied zwischen einer Gruppe, einem Kurs und einer Schulklasse?'**
  String get groupHelpDifferenceTitle;

  /// No description provided for @groupHelpHowToJoinOverview.
  ///
  /// In de, this message translates to:
  /// **'Um einer Gruppe von deinen Mitschülern oder Lehrern beizutreten, gibt es zwei Möglichkeiten:\n\n1. Sharecode über einen QR-Code scannen\n2. Händisch den Sharecode eingeben'**
  String get groupHelpHowToJoinOverview;

  /// No description provided for @groupHelpHowToJoinTitle.
  ///
  /// In de, this message translates to:
  /// **'Wie trete ich einer Gruppe bei?'**
  String get groupHelpHowToJoinTitle;

  /// No description provided for @groupHelpRolesDescription.
  ///
  /// In de, this message translates to:
  /// **'Administrator:\nEin Admin verwaltet eine Gruppe. Das bedeutet, dass er diese bearbeiten, löschen und Teilnehmer rauswerfen kann. Zudem kann ein Admin alle weiteren Einstellungen für die Gruppe treffen, wie z.B. das Beitreten aktivieren/deaktivieren.\n\nAktives Mitglied:\nEin aktives Mitglied in einer Gruppe darf Inhalte erstellen und bearbeiten, sprich Hausaufgaben eintragen, Termine eintragen, Schulstunden bearbeiten, etc. Er hat somit Schreib- und Leserechte.\n\nPassives Mitglied:\nEin passives Mitglied in einer Gruppe hat ausschließlich Leserechte. Somit dürfen keine Inhalte erstellt oder bearbeitet werden.'**
  String get groupHelpRolesDescription;

  /// No description provided for @groupHelpRolesTitle.
  ///
  /// In de, this message translates to:
  /// **'Gruppenrollen erklärt: Was ist ein passives Mitglied, aktives Mitglied, Administrator?'**
  String get groupHelpRolesTitle;

  /// No description provided for @groupHelpScanQrCodeDescription.
  ///
  /// In de, this message translates to:
  /// **'1. Eine Person, die sich schon in diesem Kurs befindet, klickt unter der Seite \"Gruppe\" auf den gewünschten Kurs.\n2. Diese Person klickt nun auf den Button \"QR-Code anzeigen\".\n3. Nun öffnet sich unten eine neue Anzeige mit einem QR-Code.\n4. Die Person, die dem Kurs beitreten möchte, klickt unten auf der Seite \"Gruppen\" auf den roten Button.\n5. Als nächstes wählt die Person \"Kurs/Klasse beitreten\".\n6. Jetzt öffnet sich ein Fenster - dort klickt der Nutzer auf die blaue Grafik, um den QR-Code zu scannen.\n7. Abschließend nur noch die Kamera auf den QR-Code der anderen Person halten.'**
  String get groupHelpScanQrCodeDescription;

  /// No description provided for @groupHelpScanQrCodeTitle.
  ///
  /// In de, this message translates to:
  /// **'Sharecode mit einem QR-Code scannen'**
  String get groupHelpScanQrCodeTitle;

  /// No description provided for @groupHelpTitle.
  ///
  /// In de, this message translates to:
  /// **'Hilfe: Gruppen'**
  String get groupHelpTitle;

  /// No description provided for @groupHelpTypeSharecodeDescription.
  ///
  /// In de, this message translates to:
  /// **'1. Eine Person, die sich schon in diesem Kurs befindet, klickt unter der Seite \"Gruppen\" auf den gewünschten Kurs.\n2. Auf dieser Seite wird nun direkt unter dem Kursnamen der Sharecode angezeigt.\n3. Die Person, die dem Kurs beitreten möchte, klickt unten auf der Seite \"Gruppen\" auf den roten Button.\n4. Als nächstes wählt die Person \"Kurs/Klasse beitreten\".\n5. Jetzt öffnet sich ein Fenster - dort muss dann nur noch der Sharecode von der anderen Person in das Textfeld unten eingeben werden.'**
  String get groupHelpTypeSharecodeDescription;

  /// No description provided for @groupHelpTypeSharecodeTitle.
  ///
  /// In de, this message translates to:
  /// **'Händisch den Sharecode eingeben'**
  String get groupHelpTypeSharecodeTitle;

  /// No description provided for @groupHelpWhatIsSharecodeDescription.
  ///
  /// In de, this message translates to:
  /// **'Der Sharecode ist ein Zugangsschlüssel für einen Kurs. Mit diesem können Mitschüler und Lehrer dem Kurs beitreten.\n\nDank des Sharecodes braucht es kein Austauschen persönlicher Daten, wie z.B. der E-Mail Adresse oder der privaten Handynummer, unter den Kursmitgliedern - anders als es z.B. bei WhatsApp-Gruppen oder den meisten E-Mail Verteilern der Fall ist.\n\nEin Kursmitglied sieht nur den Namen (kann auch ein Pseudonym sein) der anderen Kursmitglieder.'**
  String get groupHelpWhatIsSharecodeDescription;

  /// No description provided for @groupHelpWhatIsSharecodeTitle.
  ///
  /// In de, this message translates to:
  /// **'Was ist ein Sharecode?'**
  String get groupHelpWhatIsSharecodeTitle;

  /// No description provided for @groupHelpWhyDifferentSharecodesDescription.
  ///
  /// In de, this message translates to:
  /// **'Jeder Teilnehmer aus einem Kurs hat einen individuellen Sharecode.\n\nDas hat den Grund, dass getrackt werden kann, welcher Nutzer wen eingeladen hat.\n\nDank dieser Funktion zählen auch Weiterempfehlungen ohne die Verwendung eines Empfehlunglinks.'**
  String get groupHelpWhyDifferentSharecodesDescription;

  /// No description provided for @groupHelpWhyDifferentSharecodesTitle.
  ///
  /// In de, this message translates to:
  /// **'Warum hat jeder Teilnehmer aus einer Gruppe einen anderen Sharecode?'**
  String get groupHelpWhyDifferentSharecodesTitle;

  /// No description provided for @groupJoinCourseSelectionParentHint.
  ///
  /// In de, this message translates to:
  /// **'Falls dein Kind in Wahlfächern (z.B. Französisch) ist, solltest du diese Kurse aus der Auswahl aufheben.'**
  String get groupJoinCourseSelectionParentHint;

  /// No description provided for @groupJoinCourseSelectionStudentHint.
  ///
  /// In de, this message translates to:
  /// **'Falls du in Wahlfächern (z.B. Französisch) bist, solltest du diese Kurse aus der Auswahl aufheben.'**
  String get groupJoinCourseSelectionStudentHint;

  /// No description provided for @groupJoinCourseSelectionTeacherHint.
  ///
  /// In de, this message translates to:
  /// **'Wähle die Kurse aus, in denen du unterrichtest.'**
  String get groupJoinCourseSelectionTeacherHint;

  /// No description provided for @groupJoinCourseSelectionTitle.
  ///
  /// In de, this message translates to:
  /// **'Beizutretende Kurse der {groupName}'**
  String groupJoinCourseSelectionTitle(String groupName);

  /// No description provided for @groupJoinErrorAlreadyMemberDescription.
  ///
  /// In de, this message translates to:
  /// **'Du bist bereits Mitglied in dieser Gruppe, daher musst du dieser nicht mehr beitreten.'**
  String get groupJoinErrorAlreadyMemberDescription;

  /// No description provided for @groupJoinErrorAlreadyMemberTitle.
  ///
  /// In de, this message translates to:
  /// **'Ein Fehler ist aufgetreten: Bereits Mitglied 🤨'**
  String get groupJoinErrorAlreadyMemberTitle;

  /// No description provided for @groupJoinErrorNoInternetDescription.
  ///
  /// In de, this message translates to:
  /// **'Wir konnten nicht versuchen, der Gruppe beizutreten, da wir keine Internetverbindung herstellen konnten. Bitte überprüfe dein WLAN bzw. deine Mobilfunkdaten.'**
  String get groupJoinErrorNoInternetDescription;

  /// No description provided for @groupJoinErrorNoInternetTitle.
  ///
  /// In de, this message translates to:
  /// **'Ein Fehler ist aufgetreten: Keine Internetverbindung ☠️'**
  String get groupJoinErrorNoInternetTitle;

  /// No description provided for @groupJoinErrorNotPublicDescription.
  ///
  /// In de, this message translates to:
  /// **'Die Gruppe erlaubt aktuell kein Beitreten. Dies ist in den Gruppeneinstellungen deaktiviert. Bitte wende dich an einen Admin dieser Gruppe.'**
  String get groupJoinErrorNotPublicDescription;

  /// No description provided for @groupJoinErrorNotPublicTitle.
  ///
  /// In de, this message translates to:
  /// **'Ein Fehler ist aufgetreten: Beitreten verboten ⛔️'**
  String get groupJoinErrorNotPublicTitle;

  /// No description provided for @groupJoinErrorSharecodeNotFoundDescription.
  ///
  /// In de, this message translates to:
  /// **'Wir konnten den eingegebenen Sharecode nicht finden. Bitte überprüfe die Groß- und Kleinschreibung und ob dieser Sharecode noch gültig ist.'**
  String get groupJoinErrorSharecodeNotFoundDescription;

  /// No description provided for @groupJoinErrorSharecodeNotFoundTitle.
  ///
  /// In de, this message translates to:
  /// **'Ein Fehler ist aufgetreten: Sharecode nicht gefunden ❌'**
  String get groupJoinErrorSharecodeNotFoundTitle;

  /// No description provided for @groupJoinErrorUnknownDescription.
  ///
  /// In de, this message translates to:
  /// **'Dies könnte eventuell an deiner Internetverbindung liegen. Bitte überprüfe diese!'**
  String get groupJoinErrorUnknownDescription;

  /// No description provided for @groupJoinErrorUnknownTitle.
  ///
  /// In de, this message translates to:
  /// **'Ein unbekannter Fehler ist aufgetreten 😭'**
  String get groupJoinErrorUnknownTitle;

  /// No description provided for @groupJoinPasteSharecodeDescription.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du den Sharecode \"{sharecode}\" aus deiner Zwischenablage übernehmen?'**
  String groupJoinPasteSharecodeDescription(String sharecode);

  /// No description provided for @groupJoinPasteSharecodeTitle.
  ///
  /// In de, this message translates to:
  /// **'Sharecode einfügen'**
  String get groupJoinPasteSharecodeTitle;

  /// No description provided for @groupJoinRequireCourseSelectionDescription.
  ///
  /// In de, this message translates to:
  /// **'Du musst zum Beitreten die Kurse auswählen, in welchen du bist.'**
  String get groupJoinRequireCourseSelectionDescription;

  /// No description provided for @groupJoinRequireCourseSelectionTitle.
  ///
  /// In de, this message translates to:
  /// **'Klasse gefunden: {groupName}'**
  String groupJoinRequireCourseSelectionTitle(String groupName);

  /// No description provided for @groupJoinResultJoinMoreAction.
  ///
  /// In de, this message translates to:
  /// **'Mehr beitreten'**
  String get groupJoinResultJoinMoreAction;

  /// No description provided for @groupJoinResultRetryAction.
  ///
  /// In de, this message translates to:
  /// **'Nochmal versuchen'**
  String get groupJoinResultRetryAction;

  /// No description provided for @groupJoinResultSelectCoursesAction.
  ///
  /// In de, this message translates to:
  /// **'Kurse auswählen'**
  String get groupJoinResultSelectCoursesAction;

  /// No description provided for @groupJoinScanQrCodeDescription.
  ///
  /// In de, this message translates to:
  /// **'Scanne einen QR-Code, um einer Gruppe beizutreten.'**
  String get groupJoinScanQrCodeDescription;

  /// No description provided for @groupJoinScanQrCodeTooltip.
  ///
  /// In de, this message translates to:
  /// **'QR-Code scannen'**
  String get groupJoinScanQrCodeTooltip;

  /// No description provided for @groupJoinSharecodeHint.
  ///
  /// In de, this message translates to:
  /// **'z.B. Qb32vF'**
  String get groupJoinSharecodeHint;

  /// No description provided for @groupJoinSharecodeLabel.
  ///
  /// In de, this message translates to:
  /// **'Sharecode'**
  String get groupJoinSharecodeLabel;

  /// No description provided for @groupJoinSuccessDescription.
  ///
  /// In de, this message translates to:
  /// **'{groupName} wurde erfolgreich hinzugefügt. Du bist nun Mitglied.'**
  String groupJoinSuccessDescription(String groupName);

  /// No description provided for @groupJoinSuccessTitle.
  ///
  /// In de, this message translates to:
  /// **'Erfolgreich beigetreten 🎉'**
  String get groupJoinSuccessTitle;

  /// No description provided for @groupOnboardingChooseNameTitle.
  ///
  /// In de, this message translates to:
  /// **'Welcher Name soll anderen Schülern, Lehrkräften und Eltern angezeigt werden?'**
  String get groupOnboardingChooseNameTitle;

  /// No description provided for @groupOnboardingCreateCoursesTitleOther.
  ///
  /// In de, this message translates to:
  /// **'Welche Kurse sollen mit der Klasse verbunden werden?'**
  String get groupOnboardingCreateCoursesTitleOther;

  /// No description provided for @groupOnboardingCreateCoursesTitleTeacher.
  ///
  /// In de, this message translates to:
  /// **'Welche Kurse unterrichtest du?'**
  String get groupOnboardingCreateCoursesTitleTeacher;

  /// No description provided for @groupOnboardingCreateNewGroupsAction.
  ///
  /// In de, this message translates to:
  /// **'Nein, ich möchte neue Gruppen erstellen'**
  String get groupOnboardingCreateNewGroupsAction;

  /// No description provided for @groupOnboardingCreateSchoolClassTitleParent.
  ///
  /// In de, this message translates to:
  /// **'Wie heißt die Klasse deines Kindes?'**
  String get groupOnboardingCreateSchoolClassTitleParent;

  /// No description provided for @groupOnboardingCreateSchoolClassTitleStudent.
  ///
  /// In de, this message translates to:
  /// **'Wie heißt deine Klasse / Stufe?'**
  String get groupOnboardingCreateSchoolClassTitleStudent;

  /// No description provided for @groupOnboardingCreateSchoolClassTitleTeacher.
  ///
  /// In de, this message translates to:
  /// **'Wie heißt die Klasse?'**
  String get groupOnboardingCreateSchoolClassTitleTeacher;

  /// No description provided for @groupOnboardingFirstPersonHint.
  ///
  /// In de, this message translates to:
  /// **'Wenn ein Mitschüler schon Sharezone verwendet, kann dir dieser einen Sharecode geben, damit du seiner Klasse beitreten kannst.'**
  String get groupOnboardingFirstPersonHint;

  /// No description provided for @groupOnboardingFirstPersonParentTitle.
  ///
  /// In de, this message translates to:
  /// **'Wurden bereits Gruppen von Schülern oder Lehrkräften erstellt?'**
  String get groupOnboardingFirstPersonParentTitle;

  /// No description provided for @groupOnboardingFirstPersonStudentTitle.
  ///
  /// In de, this message translates to:
  /// **'Haben Mitschüler oder dein Lehrer / deine Lehrerin schon einen Kurs, eine Klasse oder Stufe erstellt? 💪'**
  String get groupOnboardingFirstPersonStudentTitle;

  /// No description provided for @groupOnboardingFirstPersonTeacherTitle.
  ///
  /// In de, this message translates to:
  /// **'Wurden bereits Gruppen von einer anderen Person erstellt? 💪'**
  String get groupOnboardingFirstPersonTeacherTitle;

  /// No description provided for @groupOnboardingIsClassTeacherCreateClassAction.
  ///
  /// In de, this message translates to:
  /// **'Ja, ich möchte eine Klasse erstellen'**
  String get groupOnboardingIsClassTeacherCreateClassAction;

  /// No description provided for @groupOnboardingIsClassTeacherCreateCoursesOnlyAction.
  ///
  /// In de, this message translates to:
  /// **'Nein, ich möchte nur Kurse erstellen'**
  String get groupOnboardingIsClassTeacherCreateCoursesOnlyAction;

  /// No description provided for @groupOnboardingIsClassTeacherTitle.
  ///
  /// In de, this message translates to:
  /// **'Leitest du eine Klasse? (Klassenlehrer)'**
  String get groupOnboardingIsClassTeacherTitle;

  /// No description provided for @groupOnboardingJoinMultipleGroupsAction.
  ///
  /// In de, this message translates to:
  /// **'Ja, ich möchte diesen Gruppen beitreten'**
  String get groupOnboardingJoinMultipleGroupsAction;

  /// No description provided for @groupOnboardingJoinSingleGroupAction.
  ///
  /// In de, this message translates to:
  /// **'Ja, ich möchte dieser Gruppe beitreten'**
  String get groupOnboardingJoinSingleGroupAction;

  /// No description provided for @groupOnboardingSchoolClassHint.
  ///
  /// In de, this message translates to:
  /// **'z.B. 10A'**
  String get groupOnboardingSchoolClassHint;

  /// No description provided for @groupOnboardingSharecodeGroupTypeCourse.
  ///
  /// In de, this message translates to:
  /// **'des Kurses'**
  String get groupOnboardingSharecodeGroupTypeCourse;

  /// No description provided for @groupOnboardingSharecodeGroupTypeSchoolClass.
  ///
  /// In de, this message translates to:
  /// **'der Schulklasse'**
  String get groupOnboardingSharecodeGroupTypeSchoolClass;

  /// No description provided for @groupOnboardingSharecodeInviteClassmatesAndTeacher.
  ///
  /// In de, this message translates to:
  /// **'Lade jetzt deine Mitschüler und deinen Lehrer / deine Lehrerin ein!'**
  String get groupOnboardingSharecodeInviteClassmatesAndTeacher;

  /// No description provided for @groupOnboardingSharecodeInviteMixed.
  ///
  /// In de, this message translates to:
  /// **'Lade jetzt andere Schüler, Eltern oder Lehrkräfte ein!'**
  String get groupOnboardingSharecodeInviteMixed;

  /// No description provided for @groupOnboardingSharecodeInviteStudents.
  ///
  /// In de, this message translates to:
  /// **'Lade jetzt deine Schüler und Schülerinnen ein!'**
  String get groupOnboardingSharecodeInviteStudents;

  /// No description provided for @groupOnboardingSharecodeJoinHint.
  ///
  /// In de, this message translates to:
  /// **'Mitschüler, Lehrer und Eltern können über den Sharecode der Klasse beitreten. Dadurch können Infozettel, Hausausgaben, Termine, Dateien und der Stundenplan gemeinsam organisiert werden.'**
  String get groupOnboardingSharecodeJoinHint;

  /// No description provided for @groupOnboardingSharecodeJoinLabel.
  ///
  /// In de, this message translates to:
  /// **'Zum Beitreten {groupType} ({groupName}):'**
  String groupOnboardingSharecodeJoinLabel(String groupName, String groupType);

  /// No description provided for @groupParticipantsEmpty.
  ///
  /// In de, this message translates to:
  /// **'Es befinden sich keine Teilnehmer in dieser Gruppe 😭'**
  String get groupParticipantsEmpty;

  /// No description provided for @groupShareActionCopy.
  ///
  /// In de, this message translates to:
  /// **'kopieren'**
  String get groupShareActionCopy;

  /// No description provided for @groupShareActionShare.
  ///
  /// In de, this message translates to:
  /// **'verschicken'**
  String get groupShareActionShare;

  /// No description provided for @groupShareInviteDescription.
  ///
  /// In de, this message translates to:
  /// **'Verschicke einfach den Link zum Beitreten über eine beliebige App oder zeige den QR-Code an, damit deine Mitschüler & Lehrer diesen abscannen können 👍🚀'**
  String get groupShareInviteDescription;

  /// No description provided for @groupShareInviteTargetClass.
  ///
  /// In de, this message translates to:
  /// **'diese Klasse'**
  String get groupShareInviteTargetClass;

  /// No description provided for @groupShareInviteTargetGroup.
  ///
  /// In de, this message translates to:
  /// **'diese Gruppe'**
  String get groupShareInviteTargetGroup;

  /// No description provided for @groupShareInviteTitle.
  ///
  /// In de, this message translates to:
  /// **'Lade deine Mitschüler & Lehrer in {target} ein!'**
  String groupShareInviteTitle(String target);

  /// No description provided for @groupShareLinkButtonTitle.
  ///
  /// In de, this message translates to:
  /// **'Link'**
  String get groupShareLinkButtonTitle;

  /// No description provided for @groupShareSharecodeButtonTitle.
  ///
  /// In de, this message translates to:
  /// **'Sharecode'**
  String get groupShareSharecodeButtonTitle;

  /// No description provided for @groupsAllowJoinTitle.
  ///
  /// In de, this message translates to:
  /// **'Beitreten erlauben'**
  String get groupsAllowJoinTitle;

  /// No description provided for @groupsContactSupportLinkText.
  ///
  /// In de, this message translates to:
  /// **'Support'**
  String get groupsContactSupportLinkText;

  /// No description provided for @groupsContactSupportPrefix.
  ///
  /// In de, this message translates to:
  /// **'Du brauchst Hilfe? Dann kontaktiere einfach unseren '**
  String get groupsContactSupportPrefix;

  /// No description provided for @groupsContactSupportSuffix.
  ///
  /// In de, this message translates to:
  /// **' 😉'**
  String get groupsContactSupportSuffix;

  /// No description provided for @groupsCreateCourseDescription.
  ///
  /// In de, this message translates to:
  /// **'Einen Kurs kannst du dir wie ein Schulfach vorstellen. Jedes Fach wird mit einem Kurs abgebildet.'**
  String get groupsCreateCourseDescription;

  /// No description provided for @groupsCreateSchoolClassDescription.
  ///
  /// In de, this message translates to:
  /// **'Eine Klasse besteht aus mehreren Kursen. Jedes Mitglied tritt beim Betreten der Klasse automatisch allen dazugehörigen Kursen bei.'**
  String get groupsCreateSchoolClassDescription;

  /// No description provided for @groupsEmptyTitle.
  ///
  /// In de, this message translates to:
  /// **'Du bist noch keinem Kurs, bzw. keiner Klasse beigetreten!'**
  String get groupsEmptyTitle;

  /// No description provided for @groupsFabJoinOrCreateTooltip.
  ///
  /// In de, this message translates to:
  /// **'Gruppe beitreten/erstellen'**
  String get groupsFabJoinOrCreateTooltip;

  /// No description provided for @groupsInviteParticipants.
  ///
  /// In de, this message translates to:
  /// **'Teilnehmer einladen'**
  String get groupsInviteParticipants;

  /// No description provided for @groupsJoinCourseOrClassDescription.
  ///
  /// In de, this message translates to:
  /// **'Falls einer deiner Mitschüler schon eine Klasse oder einen Kurs erstellt hat, kannst du diesem einfach beitreten.'**
  String get groupsJoinCourseOrClassDescription;

  /// No description provided for @groupsJoinCourseOrClassTitle.
  ///
  /// In de, this message translates to:
  /// **'Kurs/Klasse beitreten'**
  String get groupsJoinCourseOrClassTitle;

  /// No description provided for @groupsJoinTitle.
  ///
  /// In de, this message translates to:
  /// **'Beitreten'**
  String get groupsJoinTitle;

  /// No description provided for @groupsLinkCopied.
  ///
  /// In de, this message translates to:
  /// **'Link wurde kopiert'**
  String get groupsLinkCopied;

  /// No description provided for @groupsMemberCount.
  ///
  /// In de, this message translates to:
  /// **'Anzahl der Teilnehmer: {value}'**
  String groupsMemberCount(Object value);

  /// No description provided for @groupsMemberOptionsNoAdminRightsHint.
  ///
  /// In de, this message translates to:
  /// **'Da du kein Admin bist, hast du keine Rechte, um andere Mitglieder zu verwalten.'**
  String get groupsMemberOptionsNoAdminRightsHint;

  /// No description provided for @groupsMemberYou.
  ///
  /// In de, this message translates to:
  /// **'Du'**
  String get groupsMemberYou;

  /// No description provided for @groupsMembersActiveMemberTitle.
  ///
  /// In de, this message translates to:
  /// **'Aktives Mitglied (Schreib- und Leserechte)'**
  String get groupsMembersActiveMemberTitle;

  /// No description provided for @groupsMembersAdminsTitle.
  ///
  /// In de, this message translates to:
  /// **'Administratoren'**
  String get groupsMembersAdminsTitle;

  /// No description provided for @groupsMembersLegendTitle.
  ///
  /// In de, this message translates to:
  /// **'Legenden'**
  String get groupsMembersLegendTitle;

  /// No description provided for @groupsMembersPassiveMemberTitle.
  ///
  /// In de, this message translates to:
  /// **'Passives Mitglied (nur Leserechte)'**
  String get groupsMembersPassiveMemberTitle;

  /// No description provided for @groupsPageMyCourses.
  ///
  /// In de, this message translates to:
  /// **'Meine Kurse:'**
  String get groupsPageMyCourses;

  /// No description provided for @groupsPageMySchoolClass.
  ///
  /// In de, this message translates to:
  /// **'Meine Klasse:'**
  String get groupsPageMySchoolClass;

  /// No description provided for @groupsPageMySchoolClasses.
  ///
  /// In de, this message translates to:
  /// **'Meine Klassen:'**
  String get groupsPageMySchoolClasses;

  /// No description provided for @groupsPageTitle.
  ///
  /// In de, this message translates to:
  /// **'Gruppen'**
  String get groupsPageTitle;

  /// No description provided for @groupsQrCodeHelpText.
  ///
  /// In de, this message translates to:
  /// **'Was muss ich machen?\nNun muss dein Mitschüler oder dein Lehrer den QR-Code abscannen, indem er auf der \"Meine Kurse\" Seite auf \"Kurs beitreten\" klickt.'**
  String get groupsQrCodeHelpText;

  /// No description provided for @groupsQrCodeSubtitle.
  ///
  /// In de, this message translates to:
  /// **'anzeigen'**
  String get groupsQrCodeSubtitle;

  /// No description provided for @groupsQrCodeTitle.
  ///
  /// In de, this message translates to:
  /// **'QR-Code'**
  String get groupsQrCodeTitle;

  /// No description provided for @groupsRoleActiveMemberDescription.
  ///
  /// In de, this message translates to:
  /// **'Schreib- und Leserechte'**
  String get groupsRoleActiveMemberDescription;

  /// No description provided for @groupsRoleAdminDescription.
  ///
  /// In de, this message translates to:
  /// **'Schreib- und Leserechte & Verwaltung'**
  String get groupsRoleAdminDescription;

  /// No description provided for @groupsRoleReadOnlyDescription.
  ///
  /// In de, this message translates to:
  /// **'Leserechte'**
  String get groupsRoleReadOnlyDescription;

  /// No description provided for @groupsSharecodeCopied.
  ///
  /// In de, this message translates to:
  /// **'Sharecode wurde kopiert'**
  String get groupsSharecodeCopied;

  /// No description provided for @groupsSharecodeCopiedToClipboard.
  ///
  /// In de, this message translates to:
  /// **'Sharecode wurde in die Zwischenablage kopiert.'**
  String get groupsSharecodeCopiedToClipboard;

  /// No description provided for @groupsSharecodeLoading.
  ///
  /// In de, this message translates to:
  /// **'Sharecode wird geladen...'**
  String get groupsSharecodeLoading;

  /// No description provided for @groupsSharecodeLowercaseCharacter.
  ///
  /// In de, this message translates to:
  /// **'kleines {character}'**
  String groupsSharecodeLowercaseCharacter(String character);

  /// No description provided for @groupsSharecodePrefix.
  ///
  /// In de, this message translates to:
  /// **'Sharecode: '**
  String get groupsSharecodePrefix;

  /// No description provided for @groupsSharecodeSemanticsLabel.
  ///
  /// In de, this message translates to:
  /// **'Sharecode: {sharecode}'**
  String groupsSharecodeSemanticsLabel(String sharecode);

  /// No description provided for @groupsSharecodeText.
  ///
  /// In de, this message translates to:
  /// **'Sharecode: {sharecode}'**
  String groupsSharecodeText(String sharecode);

  /// No description provided for @groupsSharecodeUppercaseCharacter.
  ///
  /// In de, this message translates to:
  /// **'großes {character}'**
  String groupsSharecodeUppercaseCharacter(String character);

  /// No description provided for @groupsWritePermissionsEveryoneDescription.
  ///
  /// In de, this message translates to:
  /// **'Jeder erhält die Rolle ”aktives Mitglied (Lese- und Schreibrechte)\"'**
  String get groupsWritePermissionsEveryoneDescription;

  /// No description provided for @groupsWritePermissionsExplanation.
  ///
  /// In de, this message translates to:
  /// **'Mit dieser Einstellung kann reguliert werden, welche Nutzergruppen Schreibrechte erhalten.'**
  String get groupsWritePermissionsExplanation;

  /// No description provided for @groupsWritePermissionsOnlyAdminsDescription.
  ///
  /// In de, this message translates to:
  /// **'Alle, außer die Admins, erhalten die Rolle \"passives Mitglied (Nur Leserechte)\"'**
  String get groupsWritePermissionsOnlyAdminsDescription;

  /// No description provided for @groupsWritePermissionsSheetQuestion.
  ///
  /// In de, this message translates to:
  /// **'Wer ist dazu berechtigt, neue Einträge, neue Hausaufgaben, neue Dateien, etc. zu erstellen, bzw. hochzuladen?'**
  String get groupsWritePermissionsSheetQuestion;

  /// No description provided for @groupsWritePermissionsTitle.
  ///
  /// In de, this message translates to:
  /// **'Schreibrechte'**
  String get groupsWritePermissionsTitle;

  /// No description provided for @homeworkAddAction.
  ///
  /// In de, this message translates to:
  /// **'Hausaufgabe eintragen'**
  String get homeworkAddAction;

  /// No description provided for @homeworkBottomBarMoreIdeas.
  ///
  /// In de, this message translates to:
  /// **'Noch Ideen?'**
  String get homeworkBottomBarMoreIdeas;

  /// No description provided for @homeworkCardViewCompletedByTooltip.
  ///
  /// In de, this message translates to:
  /// **'\"Erledigt von\" anzeigen'**
  String get homeworkCardViewCompletedByTooltip;

  /// No description provided for @homeworkCardViewSubmissionsTooltip.
  ///
  /// In de, this message translates to:
  /// **'Abgaben anzeigen'**
  String get homeworkCardViewSubmissionsTooltip;

  /// No description provided for @homeworkCompletionPlusDescription.
  ///
  /// In de, this message translates to:
  /// **'Erwerbe Sharezone Plus, um nachzuvollziehen, wer bereits die Hausaufgabe als erledigt markiert hat.'**
  String get homeworkCompletionPlusDescription;

  /// No description provided for @homeworkCompletionReadByTitle.
  ///
  /// In de, this message translates to:
  /// **'Erledigt von'**
  String get homeworkCompletionReadByTitle;

  /// No description provided for @homeworkDeleteAttachmentsDialogDescription.
  ///
  /// In de, this message translates to:
  /// **'Sollen die Anhänge der Hausaufgabe aus der Dateiablage gelöscht oder die Verknüpfung zwischen beiden aufgehoben werden?'**
  String get homeworkDeleteAttachmentsDialogDescription;

  /// No description provided for @homeworkDeleteAttachmentsDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Anhänge ebenfalls löschen?'**
  String get homeworkDeleteAttachmentsDialogTitle;

  /// No description provided for @homeworkDeleteAttachmentsUnlink.
  ///
  /// In de, this message translates to:
  /// **'Entknüpfen'**
  String get homeworkDeleteAttachmentsUnlink;

  /// No description provided for @homeworkDeleteScopeDialogDescription.
  ///
  /// In de, this message translates to:
  /// **'Soll die Hausaufgabe nur für dich oder für den gesamten Kurs gelöscht werden?'**
  String get homeworkDeleteScopeDialogDescription;

  /// No description provided for @homeworkDeleteScopeDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Für alle löschen?'**
  String get homeworkDeleteScopeDialogTitle;

  /// No description provided for @homeworkDeleteScopeOnlyMe.
  ///
  /// In de, this message translates to:
  /// **'Nur für mich'**
  String get homeworkDeleteScopeOnlyMe;

  /// No description provided for @homeworkDeleteScopeWholeCourse.
  ///
  /// In de, this message translates to:
  /// **'Für gesamten Kurs'**
  String get homeworkDeleteScopeWholeCourse;

  /// No description provided for @homeworkDetailsAdditionalInfo.
  ///
  /// In de, this message translates to:
  /// **'Zusatzinformationen'**
  String get homeworkDetailsAdditionalInfo;

  /// No description provided for @homeworkDetailsAttachmentsCount.
  ///
  /// In de, this message translates to:
  /// **'Anhänge: {count}'**
  String homeworkDetailsAttachmentsCount(int count);

  /// No description provided for @homeworkDetailsChangeAccountTypeContent.
  ///
  /// In de, this message translates to:
  /// **'Wenn du eine Hausaufgabe abgeben möchtest, musst dein Account als Schüler registriert sein. Der Support kann deinen Account in einen Schüler-Account umwandeln, damit du Hausaufgaben abgeben darfst.'**
  String get homeworkDetailsChangeAccountTypeContent;

  /// No description provided for @homeworkDetailsChangeAccountTypeEmailBody.
  ///
  /// In de, this message translates to:
  /// **'Liebes Sharezone-Team, bitte ändert meinen Account-Typ zum Schüler ab.'**
  String get homeworkDetailsChangeAccountTypeEmailBody;

  /// No description provided for @homeworkDetailsChangeAccountTypeEmailSubject.
  ///
  /// In de, this message translates to:
  /// **'Typ des Accounts zu Schüler ändern [{uid}]'**
  String homeworkDetailsChangeAccountTypeEmailSubject(String uid);

  /// No description provided for @homeworkDetailsChangeAccountTypeTitle.
  ///
  /// In de, this message translates to:
  /// **'Account-Typ ändern?'**
  String get homeworkDetailsChangeAccountTypeTitle;

  /// No description provided for @homeworkDetailsCourseTitle.
  ///
  /// In de, this message translates to:
  /// **'Kurs'**
  String get homeworkDetailsCourseTitle;

  /// No description provided for @homeworkDetailsCreatedBy.
  ///
  /// In de, this message translates to:
  /// **'Erstellt von:'**
  String get homeworkDetailsCreatedBy;

  /// No description provided for @homeworkDetailsDoneByStudentsCount.
  ///
  /// In de, this message translates to:
  /// **'Von {count} SuS erledigt'**
  String homeworkDetailsDoneByStudentsCount(int count);

  /// No description provided for @homeworkDetailsMarkAsDone.
  ///
  /// In de, this message translates to:
  /// **'Als erledigt markieren'**
  String get homeworkDetailsMarkAsDone;

  /// No description provided for @homeworkDetailsMarkAsUndone.
  ///
  /// In de, this message translates to:
  /// **'Als unerledigt markieren'**
  String get homeworkDetailsMarkAsUndone;

  /// No description provided for @homeworkDetailsMarkDoneAction.
  ///
  /// In de, this message translates to:
  /// **'Abhaken'**
  String get homeworkDetailsMarkDoneAction;

  /// No description provided for @homeworkDetailsMySubmission.
  ///
  /// In de, this message translates to:
  /// **'Meine Abgabe'**
  String get homeworkDetailsMySubmission;

  /// No description provided for @homeworkDetailsNoPermissionTitle.
  ///
  /// In de, this message translates to:
  /// **'Keine Berechtigung'**
  String get homeworkDetailsNoPermissionTitle;

  /// No description provided for @homeworkDetailsNoSubmissionContent.
  ///
  /// In de, this message translates to:
  /// **'Du hast bisher keine Abgabe gemacht. Möchtest du wirklich die Hausaufgabe ohne Abgabe als erledigt markieren?'**
  String get homeworkDetailsNoSubmissionContent;

  /// No description provided for @homeworkDetailsNoSubmissionTitle.
  ///
  /// In de, this message translates to:
  /// **'Keine Abgabe bisher'**
  String get homeworkDetailsNoSubmissionTitle;

  /// No description provided for @homeworkDetailsNoSubmissionYet.
  ///
  /// In de, this message translates to:
  /// **'Keine Abgabe bisher eingereicht'**
  String get homeworkDetailsNoSubmissionYet;

  /// No description provided for @homeworkDetailsParentsCannotSubmit.
  ///
  /// In de, this message translates to:
  /// **'Eltern dürfen keine Hausaufgaben abgeben'**
  String get homeworkDetailsParentsCannotSubmit;

  /// No description provided for @homeworkDetailsPrivateSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Diese Hausaufgabe wird nicht mit dem Kurs geteilt.'**
  String get homeworkDetailsPrivateSubtitle;

  /// No description provided for @homeworkDetailsPrivateTitle.
  ///
  /// In de, this message translates to:
  /// **'Privat'**
  String get homeworkDetailsPrivateTitle;

  /// No description provided for @homeworkDetailsSubmissionsCount.
  ///
  /// In de, this message translates to:
  /// **'{count} Abgaben'**
  String homeworkDetailsSubmissionsCount(int count);

  /// No description provided for @homeworkDetailsViewCompletionNoPermissionContent.
  ///
  /// In de, this message translates to:
  /// **'Eine Lehrkraft darf aus Sicherheitsgründen nur mit Admin-Rechten in der jeweiligen Gruppe die Erledigt-Liste anschauen.\n\nAnsonsten könnte jeder Schüler einen neuen Account als Lehrkraft erstellen und der Gruppe beitreten, um einzusehen, welche Mitschüler die Hausaufgaben bereits erledigt haben.'**
  String get homeworkDetailsViewCompletionNoPermissionContent;

  /// No description provided for @homeworkDetailsViewSubmissionsNoPermissionContent.
  ///
  /// In de, this message translates to:
  /// **'Eine Lehrkraft darf aus Sicherheitsgründen nur mit Admin-Rechten in der jeweiligen Gruppe die Abgabe anschauen.\n\nAnsonsten könnte jeder Schüler einen neuen Account als Lehrkraft erstellen und der Gruppe beitreten, um die Abgabe der anderen Mitschüler anzuschauen.'**
  String get homeworkDetailsViewSubmissionsNoPermissionContent;

  /// No description provided for @homeworkDialogCourseChangeDisabled.
  ///
  /// In de, this message translates to:
  /// **'Der Kurs kann nachträglich nicht mehr geändert werden. Bitte lösche die Hausaufgabe und erstelle eine neue, falls du den Kurs ändern möchtest.'**
  String get homeworkDialogCourseChangeDisabled;

  /// No description provided for @homeworkDialogDescriptionHint.
  ///
  /// In de, this message translates to:
  /// **'Zusatzinformationen eingeben'**
  String get homeworkDialogDescriptionHint;

  /// No description provided for @homeworkDialogDueDateAfterNextLesson.
  ///
  /// In de, this message translates to:
  /// **'Übernächste Stunde'**
  String get homeworkDialogDueDateAfterNextLesson;

  /// No description provided for @homeworkDialogDueDateChipsPlusDescription.
  ///
  /// In de, this message translates to:
  /// **'Mit Sharezone Plus kannst du Hausaufgaben mit nur einem Fingertipp auf den nächsten Schultag oder eine beliebige Stunde in der Zukunft setzen.'**
  String get homeworkDialogDueDateChipsPlusDescription;

  /// No description provided for @homeworkDialogDueDateInXHours.
  ///
  /// In de, this message translates to:
  /// **'In X Stunden'**
  String get homeworkDialogDueDateInXHours;

  /// No description provided for @homeworkDialogDueDateInXLessons.
  ///
  /// In de, this message translates to:
  /// **'{count}.-nächste Stunde'**
  String homeworkDialogDueDateInXLessons(int count);

  /// No description provided for @homeworkDialogDueDateNextLesson.
  ///
  /// In de, this message translates to:
  /// **'Nächste Stunde'**
  String get homeworkDialogDueDateNextLesson;

  /// No description provided for @homeworkDialogDueDateNextSchoolday.
  ///
  /// In de, this message translates to:
  /// **'Nächster Schultag'**
  String get homeworkDialogDueDateNextSchoolday;

  /// No description provided for @homeworkDialogEmptyTitleError.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib einen Titel für die Hausaufgabe an!'**
  String get homeworkDialogEmptyTitleError;

  /// No description provided for @homeworkDialogNextLessonSuffix.
  ///
  /// In de, this message translates to:
  /// **'.-nächste Stunde'**
  String get homeworkDialogNextLessonSuffix;

  /// No description provided for @homeworkDialogNoCourseSelected.
  ///
  /// In de, this message translates to:
  /// **'Keinen Kurs ausgewählt'**
  String get homeworkDialogNoCourseSelected;

  /// No description provided for @homeworkDialogNotifyCourseMembers.
  ///
  /// In de, this message translates to:
  /// **'Kursmitglieder benachrichtigen'**
  String get homeworkDialogNotifyCourseMembers;

  /// No description provided for @homeworkDialogNotifyCourseMembersDescription.
  ///
  /// In de, this message translates to:
  /// **'Kursmitglieder über neue Hausaufgabe benachrichtigen.'**
  String get homeworkDialogNotifyCourseMembersDescription;

  /// No description provided for @homeworkDialogNotifyCourseMembersEditing.
  ///
  /// In de, this message translates to:
  /// **'Kursmitglieder über die Änderungen benachrichtigen'**
  String get homeworkDialogNotifyCourseMembersEditing;

  /// No description provided for @homeworkDialogPrivateSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Hausaufgabe nicht mit dem Kurs teilen.'**
  String get homeworkDialogPrivateSubtitle;

  /// No description provided for @homeworkDialogPrivateTitle.
  ///
  /// In de, this message translates to:
  /// **'Privat'**
  String get homeworkDialogPrivateTitle;

  /// No description provided for @homeworkDialogRequiredFieldsMissing.
  ///
  /// In de, this message translates to:
  /// **'Bitte fülle alle erforderlichen Felder aus!'**
  String get homeworkDialogRequiredFieldsMissing;

  /// No description provided for @homeworkDialogSaveTooltip.
  ///
  /// In de, this message translates to:
  /// **'Hausaufgabe speichern'**
  String get homeworkDialogSaveTooltip;

  /// No description provided for @homeworkDialogSavingFailed.
  ///
  /// In de, this message translates to:
  /// **'Hausaufgabe konnte nicht gespeichert werden.\n\n{error}\n\nFalls der Fehler weiterhin auftritt, kontaktiere bitte den Support.'**
  String homeworkDialogSavingFailed(String error);

  /// No description provided for @homeworkDialogSelectLessonOffsetDescription.
  ///
  /// In de, this message translates to:
  /// **'Wähle aus, in wie vielen Stunden die Hausaufgabe fällig ist.'**
  String get homeworkDialogSelectLessonOffsetDescription;

  /// No description provided for @homeworkDialogSelectLessonOffsetTitle.
  ///
  /// In de, this message translates to:
  /// **'Stundenzeit auswählen'**
  String get homeworkDialogSelectLessonOffsetTitle;

  /// No description provided for @homeworkDialogSubmissionTimeTitle.
  ///
  /// In de, this message translates to:
  /// **'Abgabe-Uhrzeit'**
  String get homeworkDialogSubmissionTimeTitle;

  /// No description provided for @homeworkDialogTitleHint.
  ///
  /// In de, this message translates to:
  /// **'Titel eingeben (z.B. AB Nr. 1 - 3)'**
  String get homeworkDialogTitleHint;

  /// No description provided for @homeworkDialogUnknownError.
  ///
  /// In de, this message translates to:
  /// **'Es gab einen unbekannten Fehler ({error}) 😖 Bitte kontaktiere den Support!'**
  String homeworkDialogUnknownError(String error);

  /// No description provided for @homeworkDialogWithSubmissionTitle.
  ///
  /// In de, this message translates to:
  /// **'Mit Abgabe'**
  String get homeworkDialogWithSubmissionTitle;

  /// No description provided for @homeworkEmptyFireDescription.
  ///
  /// In de, this message translates to:
  /// **'Du musst noch die Hausaufgaben erledigen! Also schau mich nicht weiter an und erledige die Aufgaben! Do it!'**
  String get homeworkEmptyFireDescription;

  /// No description provided for @homeworkEmptyFireTitle.
  ///
  /// In de, this message translates to:
  /// **'AUF GEHT\'S! 💥👊'**
  String get homeworkEmptyFireTitle;

  /// No description provided for @homeworkEmptyGameControllerDescription.
  ///
  /// In de, this message translates to:
  /// **'Sehr gut! Du hast keine Hausaufgaben zu erledigen'**
  String get homeworkEmptyGameControllerDescription;

  /// No description provided for @homeworkEmptyGameControllerTitle.
  ///
  /// In de, this message translates to:
  /// **'Jetzt ist Zeit für die wirklich wichtigen Dinge im Leben! 🤘💪'**
  String get homeworkEmptyGameControllerTitle;

  /// No description provided for @homeworkFabNewHomeworkTooltip.
  ///
  /// In de, this message translates to:
  /// **'Neue Hausaufgabe'**
  String get homeworkFabNewHomeworkTooltip;

  /// No description provided for @homeworkLongPressTitle.
  ///
  /// In de, this message translates to:
  /// **'Hausaufgabe: {homeworkTitle}'**
  String homeworkLongPressTitle(String homeworkTitle);

  /// No description provided for @homeworkMarkOverdueAction.
  ///
  /// In de, this message translates to:
  /// **'Überfällige Hausaufgaben abhaken'**
  String get homeworkMarkOverdueAction;

  /// No description provided for @homeworkMarkOverduePromptTitle.
  ///
  /// In de, this message translates to:
  /// **'Alle überfälligen Hausaufgaben abhaken?'**
  String get homeworkMarkOverduePromptTitle;

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

  /// No description provided for @homeworkTabArchivedUppercase.
  ///
  /// In de, this message translates to:
  /// **'ARCHIVIERT'**
  String get homeworkTabArchivedUppercase;

  /// No description provided for @homeworkTabDoneUppercase.
  ///
  /// In de, this message translates to:
  /// **'ERLEDIGT'**
  String get homeworkTabDoneUppercase;

  /// No description provided for @homeworkTabOpenUppercase.
  ///
  /// In de, this message translates to:
  /// **'OFFEN'**
  String get homeworkTabOpenUppercase;

  /// No description provided for @homeworkTeacherNoArchivedTitle.
  ///
  /// In de, this message translates to:
  /// **'Hier werden alle Hausaufgaben angezeigt, deren Fälligkeitsdatum in der Vergangenheit liegt.'**
  String get homeworkTeacherNoArchivedTitle;

  /// No description provided for @homeworkTeacherNoOpenTitle.
  ///
  /// In de, this message translates to:
  /// **'Keine Hausaufgaben für die Schüler:innen? 😮😍'**
  String get homeworkTeacherNoOpenTitle;

  /// No description provided for @homeworkTeacherNoPermissionTitle.
  ///
  /// In de, this message translates to:
  /// **'Keine Berechtigung'**
  String get homeworkTeacherNoPermissionTitle;

  /// No description provided for @homeworkTeacherViewCompletionNoPermissionContent.
  ///
  /// In de, this message translates to:
  /// **'Eine Lehrkraft darf aus Sicherheitsgründen nur mit Admin-Rechten in der jeweiligen Gruppe die Erledigt-Liste anschauen.\n\nAnsonsten könnte jeder Schüler einen neuen Account als Lehrkraft erstellen und der Gruppe beitreten, um einzusehen, welche Mitschüler die Hausaufgaben bereits erledigt haben.'**
  String get homeworkTeacherViewCompletionNoPermissionContent;

  /// No description provided for @homeworkTeacherViewSubmissionsNoPermissionContent.
  ///
  /// In de, this message translates to:
  /// **'Eine Lehrkraft darf aus Sicherheitsgründen nur mit Admin-Rechten in der jeweiligen Gruppe die Abgabe anschauen.\n\nAnsonsten könnte jeder Schüler einen neuen Account als Lehrkraft erstellen und der Gruppe beitreten, um die Abgabe der anderen Mitschüler anzuschauen.'**
  String get homeworkTeacherViewSubmissionsNoPermissionContent;

  /// No description provided for @homeworkTodoDateTime.
  ///
  /// In de, this message translates to:
  /// **'{date} - {time} Uhr'**
  String homeworkTodoDateTime(String date, String time);

  /// No description provided for @icalLinksDialogExportCreated.
  ///
  /// In de, this message translates to:
  /// **'Der Export wurde erfolgreich erstellt.'**
  String get icalLinksDialogExportCreated;

  /// No description provided for @icalLinksDialogLessonsComingSoon.
  ///
  /// In de, this message translates to:
  /// **'Diese Option ist demnächst verfügbar.'**
  String get icalLinksDialogLessonsComingSoon;

  /// No description provided for @icalLinksDialogNameHint.
  ///
  /// In de, this message translates to:
  /// **'Name eingeben (z.B. Meine Prüfungen)'**
  String get icalLinksDialogNameHint;

  /// No description provided for @icalLinksDialogNameMissingError.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib einen Namen ein'**
  String get icalLinksDialogNameMissingError;

  /// No description provided for @icalLinksDialogNameMissingErrorWithPeriod.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib einen Namen ein.'**
  String get icalLinksDialogNameMissingErrorWithPeriod;

  /// No description provided for @icalLinksDialogPrivateNote.
  ///
  /// In de, this message translates to:
  /// **'iCal Exporte sind privat und nur für dich sichtbar.'**
  String get icalLinksDialogPrivateNote;

  /// No description provided for @icalLinksDialogSourceMissingError.
  ///
  /// In de, this message translates to:
  /// **'Bitte wähle mindestens eine Quelle aus.'**
  String get icalLinksDialogSourceMissingError;

  /// No description provided for @icalLinksDialogSourcesQuestion.
  ///
  /// In de, this message translates to:
  /// **'Welche Quellen sollen in den Export aufgenommen werden?'**
  String get icalLinksDialogSourcesQuestion;

  /// No description provided for @icalLinksPageBuilding.
  ///
  /// In de, this message translates to:
  /// **'Wird erstellt...'**
  String get icalLinksPageBuilding;

  /// No description provided for @icalLinksPageCopyLink.
  ///
  /// In de, this message translates to:
  /// **'Link kopieren'**
  String get icalLinksPageCopyLink;

  /// No description provided for @icalLinksPageEmptyState.
  ///
  /// In de, this message translates to:
  /// **'Du hast noch keine iCal-Links erstellt.'**
  String get icalLinksPageEmptyState;

  /// No description provided for @icalLinksPageErrorSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Fehler: {error}'**
  String icalLinksPageErrorSubtitle(String error);

  /// No description provided for @icalLinksPageHowToAddIcalLinkToCalendarBody.
  ///
  /// In de, this message translates to:
  /// **'1. Kopiere den iCal-Link\n2. Öffne deinen Kalender (z.B. Google Kalender, Apple Kalender)\n3. Füge einen neuen Kalender hinzu\n4. Wähle \"Über URL hinzufügen\" oder \"Über das Internet hinzufügen\"\n5. Füge den iCal-Link ein\n6. Fertig! Dein Stundenplan und deine Termine werden nun in deinem Kalender angezeigt.'**
  String get icalLinksPageHowToAddIcalLinkToCalendarBody;

  /// No description provided for @icalLinksPageHowToAddIcalLinkToCalendarHeader.
  ///
  /// In de, this message translates to:
  /// **'Wie füge ich einen iCal-Link zu meinem Kalender hinzu?'**
  String get icalLinksPageHowToAddIcalLinkToCalendarHeader;

  /// No description provided for @icalLinksPageLinkCopied.
  ///
  /// In de, this message translates to:
  /// **'Link in Zwischenablage kopiert.'**
  String get icalLinksPageLinkCopied;

  /// No description provided for @icalLinksPageLinkDeleted.
  ///
  /// In de, this message translates to:
  /// **'Link gelöscht.'**
  String get icalLinksPageLinkDeleted;

  /// No description provided for @icalLinksPageLinkLoading.
  ///
  /// In de, this message translates to:
  /// **'Link wird geladen...'**
  String get icalLinksPageLinkLoading;

  /// No description provided for @icalLinksPageLocked.
  ///
  /// In de, this message translates to:
  /// **'Gesperrt'**
  String get icalLinksPageLocked;

  /// No description provided for @icalLinksPageNewLink.
  ///
  /// In de, this message translates to:
  /// **'Neuer Link'**
  String get icalLinksPageNewLink;

  /// No description provided for @icalLinksPageTitle.
  ///
  /// In de, this message translates to:
  /// **'iCal-Links'**
  String get icalLinksPageTitle;

  /// No description provided for @icalLinksPageWhatIsAnIcalLinkHeader.
  ///
  /// In de, this message translates to:
  /// **'Was ist ein iCal Link?'**
  String get icalLinksPageWhatIsAnIcalLinkHeader;

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

  /// No description provided for @loginCreateAccount.
  ///
  /// In de, this message translates to:
  /// **'Neues Konto erstellen'**
  String get loginCreateAccount;

  /// No description provided for @loginEmailLabel.
  ///
  /// In de, this message translates to:
  /// **'E-Mail'**
  String get loginEmailLabel;

  /// No description provided for @loginHidePasswordTooltip.
  ///
  /// In de, this message translates to:
  /// **'Passwort verstecken'**
  String get loginHidePasswordTooltip;

  /// No description provided for @loginPasswordFieldSemanticsLabel.
  ///
  /// In de, this message translates to:
  /// **'Passwortfeld'**
  String get loginPasswordFieldSemanticsLabel;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In de, this message translates to:
  /// **'Passwort'**
  String get loginPasswordLabel;

  /// No description provided for @loginResetPasswordButton.
  ///
  /// In de, this message translates to:
  /// **'Passwort zurücksetzen'**
  String get loginResetPasswordButton;

  /// No description provided for @loginShowPasswordTooltip.
  ///
  /// In de, this message translates to:
  /// **'Passwort anzeigen'**
  String get loginShowPasswordTooltip;

  /// No description provided for @loginSubmitTooltip.
  ///
  /// In de, this message translates to:
  /// **'Einloggen'**
  String get loginSubmitTooltip;

  /// No description provided for @loginWithAppleButton.
  ///
  /// In de, this message translates to:
  /// **'Über Apple anmelden'**
  String get loginWithAppleButton;

  /// No description provided for @loginWithGoogleButton.
  ///
  /// In de, this message translates to:
  /// **'Über Google einloggen'**
  String get loginWithGoogleButton;

  /// No description provided for @loginWithQrCodeButton.
  ///
  /// In de, this message translates to:
  /// **'Über einen QR-Code einloggen'**
  String get loginWithQrCodeButton;

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

  /// No description provided for @mobileWelcomeBackgroundImageSemanticsLabel.
  ///
  /// In de, this message translates to:
  /// **'Hintergrundbild der Willkommens-Seite mit 5 Handys, die die Sharezone-App zeigen.'**
  String get mobileWelcomeBackgroundImageSemanticsLabel;

  /// No description provided for @mobileWelcomeHeadline.
  ///
  /// In de, this message translates to:
  /// **'Gemeinsam den\nSchulalltag organisieren 🚀'**
  String get mobileWelcomeHeadline;

  /// No description provided for @mobileWelcomeNewAtSharezoneButton.
  ///
  /// In de, this message translates to:
  /// **'Ich bin neu bei Sharezone 👋'**
  String get mobileWelcomeNewAtSharezoneButton;

  /// No description provided for @mobileWelcomeSignInButton.
  ///
  /// In de, this message translates to:
  /// **'Anmelden'**
  String get mobileWelcomeSignInButton;

  /// No description provided for @mobileWelcomeSignInWithExistingAccount.
  ///
  /// In de, this message translates to:
  /// **'Mit existierendem Konto anmelden'**
  String get mobileWelcomeSignInWithExistingAccount;

  /// No description provided for @mobileWelcomeSubHeadline.
  ///
  /// In de, this message translates to:
  /// **'Optional kannst du Sharezone auch komplett alleine verwenden.'**
  String get mobileWelcomeSubHeadline;

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

  /// No description provided for @navigationExtendableBnbSemantics.
  ///
  /// In de, this message translates to:
  /// **'{action} die erweiterte Navigationsleiste'**
  String navigationExtendableBnbSemantics(String action);

  /// No description provided for @navigationItemAccountPage.
  ///
  /// In de, this message translates to:
  /// **'Profil'**
  String get navigationItemAccountPage;

  /// No description provided for @navigationItemBlackboard.
  ///
  /// In de, this message translates to:
  /// **'Infozettel'**
  String get navigationItemBlackboard;

  /// No description provided for @navigationItemEvents.
  ///
  /// In de, this message translates to:
  /// **'Termine'**
  String get navigationItemEvents;

  /// No description provided for @navigationItemFeedbackBox.
  ///
  /// In de, this message translates to:
  /// **'Feedback'**
  String get navigationItemFeedbackBox;

  /// No description provided for @navigationItemFilesharing.
  ///
  /// In de, this message translates to:
  /// **'Dateien'**
  String get navigationItemFilesharing;

  /// No description provided for @navigationItemGrades.
  ///
  /// In de, this message translates to:
  /// **'Noten'**
  String get navigationItemGrades;

  /// No description provided for @navigationItemGroup.
  ///
  /// In de, this message translates to:
  /// **'Gruppen'**
  String get navigationItemGroup;

  /// No description provided for @navigationItemHomework.
  ///
  /// In de, this message translates to:
  /// **'Hausaufgaben'**
  String get navigationItemHomework;

  /// No description provided for @navigationItemMore.
  ///
  /// In de, this message translates to:
  /// **'Mehr'**
  String get navigationItemMore;

  /// No description provided for @navigationItemOverview.
  ///
  /// In de, this message translates to:
  /// **'Übersicht'**
  String get navigationItemOverview;

  /// No description provided for @navigationItemSettings.
  ///
  /// In de, this message translates to:
  /// **'Einstellungen'**
  String get navigationItemSettings;

  /// No description provided for @navigationItemSharezonePlus.
  ///
  /// In de, this message translates to:
  /// **'Sharezone Plus'**
  String get navigationItemSharezonePlus;

  /// No description provided for @navigationItemTimetable.
  ///
  /// In de, this message translates to:
  /// **'Stundenplan'**
  String get navigationItemTimetable;

  /// No description provided for @navigationSemanticsClose.
  ///
  /// In de, this message translates to:
  /// **'Schließt'**
  String get navigationSemanticsClose;

  /// No description provided for @navigationSemanticsOpen.
  ///
  /// In de, this message translates to:
  /// **'Öffnet'**
  String get navigationSemanticsOpen;

  /// No description provided for @notificationPageBlackboardDescription.
  ///
  /// In de, this message translates to:
  /// **'Der Ersteller eines Infozettels kann regulieren, ob die Kursmitglieder darüber benachrichtigt werden sollen, dass ein neuer Infozettel erstellt wurde, bzw. es eine Änderung gab. Mit dieser Option kannst du diese Benachrichtigungen an- und ausschalten.'**
  String get notificationPageBlackboardDescription;

  /// No description provided for @notificationPageBlackboardHeadline.
  ///
  /// In de, this message translates to:
  /// **'Infozettel'**
  String get notificationPageBlackboardHeadline;

  /// No description provided for @notificationPageBlackboardTitle.
  ///
  /// In de, this message translates to:
  /// **'Benachrichtigungen für Infozettel'**
  String get notificationPageBlackboardTitle;

  /// No description provided for @notificationPageCommentsDescription.
  ///
  /// In de, this message translates to:
  /// **'Erhalte eine Push-Nachricht, sobald ein neuer Nutzer einen neuen Kommentar unter einer Hausaufgabe oder einem Infozettel verfasst hat.'**
  String get notificationPageCommentsDescription;

  /// No description provided for @notificationPageCommentsHeadline.
  ///
  /// In de, this message translates to:
  /// **'Kommentare'**
  String get notificationPageCommentsHeadline;

  /// No description provided for @notificationPageCommentsTitle.
  ///
  /// In de, this message translates to:
  /// **'Benachrichtigungen für Kommentare'**
  String get notificationPageCommentsTitle;

  /// No description provided for @notificationPageHomeworkHeadline.
  ///
  /// In de, this message translates to:
  /// **'Offene Hausaufgaben'**
  String get notificationPageHomeworkHeadline;

  /// No description provided for @notificationPageHomeworkReminderTitle.
  ///
  /// In de, this message translates to:
  /// **'Erinnerungen für offene Hausaufgaben'**
  String get notificationPageHomeworkReminderTitle;

  /// No description provided for @notificationPageInvalidHomeworkReminderTime.
  ///
  /// In de, this message translates to:
  /// **'Nur volle und halbe Stunden sind erlaubt, z.B. 18:00 oder 18:30.'**
  String get notificationPageInvalidHomeworkReminderTime;

  /// No description provided for @notificationPagePlusDialogDescription.
  ///
  /// In de, this message translates to:
  /// **'Mit Sharezone Plus kannst du die Erinnerung für die Hausaufgaben individuell im 30-Minuten-Tack einstellen, z.B. 15:00 oder 15:30 Uhr.'**
  String get notificationPagePlusDialogDescription;

  /// No description provided for @notificationPagePlusDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Uhrzeit für Erinnerung am Vortag'**
  String get notificationPagePlusDialogTitle;

  /// No description provided for @notificationPageTimeTitle.
  ///
  /// In de, this message translates to:
  /// **'Uhrzeit'**
  String get notificationPageTimeTitle;

  /// No description provided for @notificationPageTimeValue.
  ///
  /// In de, this message translates to:
  /// **'{time} Uhr'**
  String notificationPageTimeValue(String time);

  /// No description provided for @notificationPageTitle.
  ///
  /// In de, this message translates to:
  /// **'Benachrichtigungen'**
  String get notificationPageTitle;

  /// No description provided for @notificationsDialogReplyAction.
  ///
  /// In de, this message translates to:
  /// **'Antworten'**
  String get notificationsDialogReplyAction;

  /// No description provided for @notificationsErrorDialogMoreInfo.
  ///
  /// In de, this message translates to:
  /// **'Mehr Infos.'**
  String get notificationsErrorDialogMoreInfo;

  /// No description provided for @notificationsErrorDialogShortDescription.
  ///
  /// In de, this message translates to:
  /// **'Beim tippen auf die Benachrichtigung hätte jetzt etwas anderes passieren sollen.'**
  String get notificationsErrorDialogShortDescription;

  /// No description provided for @onboardingNotificationsConfirmBody.
  ///
  /// In de, this message translates to:
  /// **'Bist du dir sicher, dass du keine Benachrichtigungen erhalten möchtest?\n\nSollte jemand einen Infozettel eintragen, einen Kommentar zu einer Hausaufgabe hinzufügen oder dir eine Nachricht schreiben, würdest du keine Push-Nachrichten erhalten.'**
  String get onboardingNotificationsConfirmBody;

  /// No description provided for @onboardingNotificationsConfirmTitle.
  ///
  /// In de, this message translates to:
  /// **'Keine Push-Nachrichten? 🤨'**
  String get onboardingNotificationsConfirmTitle;

  /// No description provided for @onboardingNotificationsDescriptionGeneral.
  ///
  /// In de, this message translates to:
  /// **'Wenn jemand einen neuen Infozettel einträgt oder dir eine Nachricht schreibt, erhältst du eine Benachrichtigung. Somit bleibst du immer auf dem aktuellen Stand 💪'**
  String get onboardingNotificationsDescriptionGeneral;

  /// No description provided for @onboardingNotificationsDescriptionStudent.
  ///
  /// In de, this message translates to:
  /// **'Wir können dich an offene Hausaufgaben erinnern 😉 Zudem kannst du eine Benachrichtigung erhalten, wenn jemand einen neuen Infozettel einträgt oder dir eine Nachricht schreibt.'**
  String get onboardingNotificationsDescriptionStudent;

  /// No description provided for @onboardingNotificationsEnable.
  ///
  /// In de, this message translates to:
  /// **'Aktivieren'**
  String get onboardingNotificationsEnable;

  /// No description provided for @onboardingNotificationsTitle.
  ///
  /// In de, this message translates to:
  /// **'Erinnerungen und Benachrichtigungen erhalten'**
  String get onboardingNotificationsTitle;

  /// No description provided for @pastCalendricalEventsDummyTitleExam2.
  ///
  /// In de, this message translates to:
  /// **'Klausur Nr. 2'**
  String get pastCalendricalEventsDummyTitleExam2;

  /// No description provided for @pastCalendricalEventsDummyTitleExam3.
  ///
  /// In de, this message translates to:
  /// **'Klausur Nr. 3'**
  String get pastCalendricalEventsDummyTitleExam3;

  /// No description provided for @pastCalendricalEventsDummyTitleExam4.
  ///
  /// In de, this message translates to:
  /// **'Klausur Nr. 4'**
  String get pastCalendricalEventsDummyTitleExam4;

  /// No description provided for @pastCalendricalEventsDummyTitleExam5.
  ///
  /// In de, this message translates to:
  /// **'Klausur Nr. 5'**
  String get pastCalendricalEventsDummyTitleExam5;

  /// No description provided for @pastCalendricalEventsDummyTitleNoSchool.
  ///
  /// In de, this message translates to:
  /// **'Schulfrei'**
  String get pastCalendricalEventsDummyTitleNoSchool;

  /// No description provided for @pastCalendricalEventsDummyTitleParentTeacherDay.
  ///
  /// In de, this message translates to:
  /// **'Elternsprechtag'**
  String get pastCalendricalEventsDummyTitleParentTeacherDay;

  /// No description provided for @pastCalendricalEventsDummyTitleSportsFestival.
  ///
  /// In de, this message translates to:
  /// **'Sportfest'**
  String get pastCalendricalEventsDummyTitleSportsFestival;

  /// No description provided for @pastCalendricalEventsDummyTitleTest6.
  ///
  /// In de, this message translates to:
  /// **'Test Nr. 6'**
  String get pastCalendricalEventsDummyTitleTest6;

  /// No description provided for @pastCalendricalEventsPageEmpty.
  ///
  /// In de, this message translates to:
  /// **'Keine vergangenen Termine'**
  String get pastCalendricalEventsPageEmpty;

  /// No description provided for @pastCalendricalEventsPageError.
  ///
  /// In de, this message translates to:
  /// **'Fehler beim Laden der vergangenen Termine: {error}'**
  String pastCalendricalEventsPageError(String error);

  /// No description provided for @pastCalendricalEventsPagePlusDescription.
  ///
  /// In de, this message translates to:
  /// **'Erwerbe Sharezone Plus, um alle vergangenen Termine einzusehen.'**
  String get pastCalendricalEventsPagePlusDescription;

  /// No description provided for @pastCalendricalEventsPageSortAscending.
  ///
  /// In de, this message translates to:
  /// **'Aufsteigend'**
  String get pastCalendricalEventsPageSortAscending;

  /// No description provided for @pastCalendricalEventsPageSortAscendingSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Älteste Termine zuerst'**
  String get pastCalendricalEventsPageSortAscendingSubtitle;

  /// No description provided for @pastCalendricalEventsPageSortDescending.
  ///
  /// In de, this message translates to:
  /// **'Absteigend'**
  String get pastCalendricalEventsPageSortDescending;

  /// No description provided for @pastCalendricalEventsPageSortDescendingSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Neueste Termine zuerst'**
  String get pastCalendricalEventsPageSortDescendingSubtitle;

  /// No description provided for @pastCalendricalEventsPageSortOrderTooltip.
  ///
  /// In de, this message translates to:
  /// **'Sortierreihenfolge'**
  String get pastCalendricalEventsPageSortOrderTooltip;

  /// No description provided for @pastCalendricalEventsPageTitle.
  ///
  /// In de, this message translates to:
  /// **'Vergangene Termine'**
  String get pastCalendricalEventsPageTitle;

  /// No description provided for @periodsEditAddLesson.
  ///
  /// In de, this message translates to:
  /// **'Stunde hinzufügen'**
  String get periodsEditAddLesson;

  /// No description provided for @periodsEditSaved.
  ///
  /// In de, this message translates to:
  /// **'Die Stundenzeiten wurden erfolgreich geändert.'**
  String get periodsEditSaved;

  /// No description provided for @periodsEditTimetableStart.
  ///
  /// In de, this message translates to:
  /// **'Stundenplanbeginn'**
  String get periodsEditTimetableStart;

  /// No description provided for @predefinedGradeTypesOralParticipation.
  ///
  /// In de, this message translates to:
  /// **'Mündliche Beteiligung'**
  String get predefinedGradeTypesOralParticipation;

  /// No description provided for @predefinedGradeTypesOther.
  ///
  /// In de, this message translates to:
  /// **'Sonstiges'**
  String get predefinedGradeTypesOther;

  /// No description provided for @predefinedGradeTypesPresentation.
  ///
  /// In de, this message translates to:
  /// **'Präsentation'**
  String get predefinedGradeTypesPresentation;

  /// No description provided for @predefinedGradeTypesSchoolReportGrade.
  ///
  /// In de, this message translates to:
  /// **'Zeugnisnote'**
  String get predefinedGradeTypesSchoolReportGrade;

  /// No description provided for @predefinedGradeTypesVocabularyTest.
  ///
  /// In de, this message translates to:
  /// **'Vokabeltest'**
  String get predefinedGradeTypesVocabularyTest;

  /// No description provided for @predefinedGradeTypesWrittenExam.
  ///
  /// In de, this message translates to:
  /// **'Schriftliche Prüfung'**
  String get predefinedGradeTypesWrittenExam;

  /// No description provided for @privacyDisplaySettingsDensityComfortable.
  ///
  /// In de, this message translates to:
  /// **'Komfortabel'**
  String get privacyDisplaySettingsDensityComfortable;

  /// No description provided for @privacyDisplaySettingsDensityCompact.
  ///
  /// In de, this message translates to:
  /// **'Kompakt'**
  String get privacyDisplaySettingsDensityCompact;

  /// No description provided for @privacyDisplaySettingsDensityStandard.
  ///
  /// In de, this message translates to:
  /// **'Standard'**
  String get privacyDisplaySettingsDensityStandard;

  /// No description provided for @privacyDisplaySettingsShowReadIndicator.
  ///
  /// In de, this message translates to:
  /// **'\"Am Lesen\"-Indikator anzeigen'**
  String get privacyDisplaySettingsShowReadIndicator;

  /// No description provided for @privacyDisplaySettingsTextScalingFactor.
  ///
  /// In de, this message translates to:
  /// **'Textskalierungsfaktor'**
  String get privacyDisplaySettingsTextScalingFactor;

  /// No description provided for @privacyDisplaySettingsThemeMode.
  ///
  /// In de, this message translates to:
  /// **'Dunkel-/Hellmodus'**
  String get privacyDisplaySettingsThemeMode;

  /// No description provided for @privacyDisplaySettingsThemeModeAutomatic.
  ///
  /// In de, this message translates to:
  /// **'Automatisch'**
  String get privacyDisplaySettingsThemeModeAutomatic;

  /// No description provided for @privacyDisplaySettingsThemeModeDark.
  ///
  /// In de, this message translates to:
  /// **'Dunkler Modus'**
  String get privacyDisplaySettingsThemeModeDark;

  /// No description provided for @privacyDisplaySettingsThemeModeLight.
  ///
  /// In de, this message translates to:
  /// **'Heller Modus'**
  String get privacyDisplaySettingsThemeModeLight;

  /// No description provided for @privacyDisplaySettingsTitle.
  ///
  /// In de, this message translates to:
  /// **'Anzeigeeinstellungen'**
  String get privacyDisplaySettingsTitle;

  /// No description provided for @privacyDisplaySettingsVisualDensity.
  ///
  /// In de, this message translates to:
  /// **'Visuelle Kompaktheit'**
  String get privacyDisplaySettingsVisualDensity;

  /// No description provided for @privacyPolicyChangeAppearance.
  ///
  /// In de, this message translates to:
  /// **'Darstellung ändern'**
  String get privacyPolicyChangeAppearance;

  /// No description provided for @privacyPolicyDownloadPdf.
  ///
  /// In de, this message translates to:
  /// **'Als PDF herunterladen'**
  String get privacyPolicyDownloadPdf;

  /// No description provided for @privacyPolicyPageTitle.
  ///
  /// In de, this message translates to:
  /// **'Datenschutzerklärung'**
  String get privacyPolicyPageTitle;

  /// No description provided for @privacyPolicyPageUpdatedEffectiveDatePrefix.
  ///
  /// In de, this message translates to:
  /// **'Diese aktualisierte Datenschutzerklärung tritt am'**
  String get privacyPolicyPageUpdatedEffectiveDatePrefix;

  /// No description provided for @privacyPolicyPageUpdatedEffectiveDateSuffix.
  ///
  /// In de, this message translates to:
  /// **'in Kraft.'**
  String get privacyPolicyPageUpdatedEffectiveDateSuffix;

  /// No description provided for @privacyPolicyTableOfContents.
  ///
  /// In de, this message translates to:
  /// **'Inhaltsverzeichnis'**
  String get privacyPolicyTableOfContents;

  /// No description provided for @profileAvatarTooltip.
  ///
  /// In de, this message translates to:
  /// **'Mein Profil'**
  String get profileAvatarTooltip;

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

  /// No description provided for @resetPasswordEmailFieldLabel.
  ///
  /// In de, this message translates to:
  /// **'E-Mail Adresse deines Kontos'**
  String get resetPasswordEmailFieldLabel;

  /// No description provided for @resetPasswordErrorMessage.
  ///
  /// In de, this message translates to:
  /// **'E-Mail konnte nicht gesendet werden. Überprüfe deine eingegebene E-Mail-Adresse!'**
  String get resetPasswordErrorMessage;

  /// No description provided for @resetPasswordSentDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'E-Mail wurde verschickt'**
  String get resetPasswordSentDialogTitle;

  /// No description provided for @resetPasswordSuccessMessage.
  ///
  /// In de, this message translates to:
  /// **'E-Mail zum Passwort-Zurücksetzen wurde gesendet.'**
  String get resetPasswordSuccessMessage;

  /// No description provided for @schoolClassActionsDeleteUppercase.
  ///
  /// In de, this message translates to:
  /// **'KLASSE LÖSCHEN'**
  String get schoolClassActionsDeleteUppercase;

  /// No description provided for @schoolClassActionsKickUppercase.
  ///
  /// In de, this message translates to:
  /// **'AUS DER SCHULKLASSE KICKEN'**
  String get schoolClassActionsKickUppercase;

  /// No description provided for @schoolClassActionsLeaveUppercase.
  ///
  /// In de, this message translates to:
  /// **'KLASSE VERLASSEN'**
  String get schoolClassActionsLeaveUppercase;

  /// No description provided for @schoolClassAllowJoinExplanation.
  ///
  /// In de, this message translates to:
  /// **'Über diese Einstellungen kannst du regulieren, ob neue Mitglieder dem Kurs beitreten dürfen.\n\nDie Einstellung wird direkt auf alle Kurse übertragen, die mit der Schulklasse verbunden sind.'**
  String get schoolClassAllowJoinExplanation;

  /// No description provided for @schoolClassCoursesAddExisting.
  ///
  /// In de, this message translates to:
  /// **'Existierenden Kurs hinzufügen'**
  String get schoolClassCoursesAddExisting;

  /// No description provided for @schoolClassCoursesAddNew.
  ///
  /// In de, this message translates to:
  /// **'Neuen Kurs hinzufügen'**
  String get schoolClassCoursesAddNew;

  /// No description provided for @schoolClassCoursesEmptyDescription.
  ///
  /// In de, this message translates to:
  /// **'Es wurden noch keine Kurse zu dieser Klasse hinzugefügt.\n\nErstelle jetzt einen Kurs, der mit der Klasse verknüpft ist.'**
  String get schoolClassCoursesEmptyDescription;

  /// No description provided for @schoolClassCoursesSelectCourseDialogHint.
  ///
  /// In de, this message translates to:
  /// **'Du kannst nur Kurse hinzufügen, in denen du auch Administrator bist.'**
  String get schoolClassCoursesSelectCourseDialogHint;

  /// No description provided for @schoolClassCoursesSelectCourseDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Wähle einen Kurs aus'**
  String get schoolClassCoursesSelectCourseDialogTitle;

  /// No description provided for @schoolClassCoursesTitle.
  ///
  /// In de, this message translates to:
  /// **'Kurse'**
  String get schoolClassCoursesTitle;

  /// No description provided for @schoolClassCreateTitle.
  ///
  /// In de, this message translates to:
  /// **'Schulklasse erstellen'**
  String get schoolClassCreateTitle;

  /// No description provided for @schoolClassEditSuccess.
  ///
  /// In de, this message translates to:
  /// **'Die Schulklasse wurde erfolgreich bearbeitet!'**
  String get schoolClassEditSuccess;

  /// No description provided for @schoolClassEditTitle.
  ///
  /// In de, this message translates to:
  /// **'Schulklasse bearbeiten'**
  String get schoolClassEditTitle;

  /// No description provided for @schoolClassLeaveConfirmationQuestion.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du wirklich die Schulklasse verlassen?'**
  String get schoolClassLeaveConfirmationQuestion;

  /// No description provided for @schoolClassLeaveDialogDeleteWithCourses.
  ///
  /// In de, this message translates to:
  /// **'Mit Kursen löschen'**
  String get schoolClassLeaveDialogDeleteWithCourses;

  /// No description provided for @schoolClassLeaveDialogDeleteWithoutCourses.
  ///
  /// In de, this message translates to:
  /// **'Ohne Kurse löschen'**
  String get schoolClassLeaveDialogDeleteWithoutCourses;

  /// No description provided for @schoolClassLeaveDialogDescription.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du wirklich die Klasse verlassen?\n\nDu hast noch die Option, die Kurse der Schulklasse ebenfalls zu löschen oder diese zu behalten. Werden die Kurse der Schulklasse nicht gelöscht, bleiben diese weiterhin bestehen.'**
  String get schoolClassLeaveDialogDescription;

  /// No description provided for @schoolClassLeaveDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Klasse verlassen'**
  String get schoolClassLeaveDialogTitle;

  /// No description provided for @schoolClassLoadError.
  ///
  /// In de, this message translates to:
  /// **'Es ist ein Fehler beim Laden aufgetreten...'**
  String get schoolClassLoadError;

  /// No description provided for @schoolClassLongPressTitle.
  ///
  /// In de, this message translates to:
  /// **'Klasse: {schoolClassName}'**
  String schoolClassLongPressTitle(String schoolClassName);

  /// No description provided for @schoolClassMemberOptionsAloneHint.
  ///
  /// In de, this message translates to:
  /// **'Da du der einzige in der Schulklasse bist, kannst du deine Rolle nicht bearbeiten.'**
  String get schoolClassMemberOptionsAloneHint;

  /// No description provided for @schoolClassMemberOptionsOnlyAdminHint.
  ///
  /// In de, this message translates to:
  /// **'Du bist der einzige Admin in dieser Schulklasse. Daher kannst du dir keine Rechte entziehen.'**
  String get schoolClassMemberOptionsOnlyAdminHint;

  /// No description provided for @schoolClassWritePermissionsAnnotation.
  ///
  /// In de, this message translates to:
  /// **'Die Einstellung wird direkt auf alle Kurse übertragen, die mit der Schulklasse verbunden sind.'**
  String get schoolClassWritePermissionsAnnotation;

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

  /// No description provided for @settingsLegalLicensesTitle.
  ///
  /// In de, this message translates to:
  /// **'Lizenzen'**
  String get settingsLegalLicensesTitle;

  /// No description provided for @settingsLegalTermsTitle.
  ///
  /// In de, this message translates to:
  /// **'Allgemeine Nutzungsbedingungen (ANB)'**
  String get settingsLegalTermsTitle;

  /// No description provided for @settingsOptionMyAccount.
  ///
  /// In de, this message translates to:
  /// **'Mein Konto'**
  String get settingsOptionMyAccount;

  /// No description provided for @settingsOptionSourceCode.
  ///
  /// In de, this message translates to:
  /// **'Quellcode'**
  String get settingsOptionSourceCode;

  /// No description provided for @settingsOptionWebApp.
  ///
  /// In de, this message translates to:
  /// **'Web-App'**
  String get settingsOptionWebApp;

  /// No description provided for @settingsPrivacyPolicyLinkText.
  ///
  /// In de, this message translates to:
  /// **'Datenschutzerklärung'**
  String get settingsPrivacyPolicyLinkText;

  /// No description provided for @settingsPrivacyPolicySentencePrefix.
  ///
  /// In de, this message translates to:
  /// **'Mehr Informationen erhältst du in unserer '**
  String get settingsPrivacyPolicySentencePrefix;

  /// No description provided for @settingsPrivacyPolicySentenceSuffix.
  ///
  /// In de, this message translates to:
  /// **'.'**
  String get settingsPrivacyPolicySentenceSuffix;

  /// No description provided for @settingsSectionAppSettings.
  ///
  /// In de, this message translates to:
  /// **'App-Einstellungen'**
  String get settingsSectionAppSettings;

  /// No description provided for @settingsSectionLegal.
  ///
  /// In de, this message translates to:
  /// **'Rechtliches'**
  String get settingsSectionLegal;

  /// No description provided for @settingsSectionMore.
  ///
  /// In de, this message translates to:
  /// **'Mehr'**
  String get settingsSectionMore;

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

  /// No description provided for @sharezoneV2DialogAnbAcceptanceCheckbox.
  ///
  /// In de, this message translates to:
  /// **'Ich habe [die ANB](anb) gelesen und akzeptiere diese.'**
  String get sharezoneV2DialogAnbAcceptanceCheckbox;

  /// No description provided for @sharezoneV2DialogChangedLegalFormHeader.
  ///
  /// In de, this message translates to:
  /// **'Geänderte Rechtsform'**
  String get sharezoneV2DialogChangedLegalFormHeader;

  /// No description provided for @sharezoneV2DialogPrivacyPolicyRevisionHeader.
  ///
  /// In de, this message translates to:
  /// **'Überarbeitung der Datenschutzerklärung'**
  String get sharezoneV2DialogPrivacyPolicyRevisionHeader;

  /// No description provided for @sharezoneV2DialogSubmitError.
  ///
  /// In de, this message translates to:
  /// **'Es ist ein Fehler aufgetreten: {value}. Falls dieser bestehen bleibt, dann schreibe uns unter support@sharezone.net'**
  String sharezoneV2DialogSubmitError(Object value);

  /// No description provided for @sharezoneV2DialogTermsHeader.
  ///
  /// In de, this message translates to:
  /// **'Allgemeine Nutzungsbedingungen (ANB)'**
  String get sharezoneV2DialogTermsHeader;

  /// No description provided for @sharezoneV2DialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Sharezone v2.0'**
  String get sharezoneV2DialogTitle;

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

  /// No description provided for @signInWithQrCodeLoadingMessage.
  ///
  /// In de, this message translates to:
  /// **'Die Erstellung des QR-Codes kann einige Sekunden dauern...'**
  String get signInWithQrCodeLoadingMessage;

  /// No description provided for @signInWithQrCodeStep1.
  ///
  /// In de, this message translates to:
  /// **'Öffne Sharezone auf deinem Handy / Tablet'**
  String get signInWithQrCodeStep1;

  /// No description provided for @signInWithQrCodeStep2.
  ///
  /// In de, this message translates to:
  /// **'Öffne die Einstellungen über die seitliche Navigation'**
  String get signInWithQrCodeStep2;

  /// No description provided for @signInWithQrCodeStep3.
  ///
  /// In de, this message translates to:
  /// **'Tippe auf \"Web-App\"'**
  String get signInWithQrCodeStep3;

  /// No description provided for @signInWithQrCodeStep4.
  ///
  /// In de, this message translates to:
  /// **'Tippe auf \"QR-Code scannen\" und richte die Kamera auf deinen Bildschirm'**
  String get signInWithQrCodeStep4;

  /// No description provided for @signInWithQrCodeTitle.
  ///
  /// In de, this message translates to:
  /// **'So meldest du dich über einen QR-Code an:'**
  String get signInWithQrCodeTitle;

  /// No description provided for @signOutDialogConfirmation.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du dich wirklich abmelden?'**
  String get signOutDialogConfirmation;

  /// No description provided for @signUpAdvantageAllInOne.
  ///
  /// In de, this message translates to:
  /// **'All-In-One-App für die Schule'**
  String get signUpAdvantageAllInOne;

  /// No description provided for @signUpAdvantageCloud.
  ///
  /// In de, this message translates to:
  /// **'Schulplaner über die Cloud mit der Klasse teilen'**
  String get signUpAdvantageCloud;

  /// No description provided for @signUpAdvantageHomeworkReminder.
  ///
  /// In de, this message translates to:
  /// **'Erinnerungen an offene Hausaufgaben'**
  String get signUpAdvantageHomeworkReminder;

  /// No description provided for @signUpAdvantageSaveTime.
  ///
  /// In de, this message translates to:
  /// **'Große Zeitersparnis durch gemeinsames Organisieren'**
  String get signUpAdvantageSaveTime;

  /// No description provided for @signUpAdvantagesTitle.
  ///
  /// In de, this message translates to:
  /// **'Vorteile von Sharezone'**
  String get signUpAdvantagesTitle;

  /// No description provided for @signUpAlreadyHaveAccount.
  ///
  /// In de, this message translates to:
  /// **'Du hast bereits ein Konto? Klicke hier, um dich einzuloggen.'**
  String get signUpAlreadyHaveAccount;

  /// No description provided for @signUpChooseTypeTitle.
  ///
  /// In de, this message translates to:
  /// **'Ich bin...'**
  String get signUpChooseTypeTitle;

  /// No description provided for @signUpDataProtectionAesTitle.
  ///
  /// In de, this message translates to:
  /// **'AES 256-Bit serverseitige Verschlüsselung'**
  String get signUpDataProtectionAesTitle;

  /// No description provided for @signUpDataProtectionAnonymousSignInSubtitle.
  ///
  /// In de, this message translates to:
  /// **'IP-Adresse wird zwangsläufig temporär gespeichert'**
  String get signUpDataProtectionAnonymousSignInSubtitle;

  /// No description provided for @signUpDataProtectionAnonymousSignInTitle.
  ///
  /// In de, this message translates to:
  /// **'Anmeldung ohne personenbezogene Daten'**
  String get signUpDataProtectionAnonymousSignInTitle;

  /// No description provided for @signUpDataProtectionDeleteDataTitle.
  ///
  /// In de, this message translates to:
  /// **'Einfaches Löschen der Daten'**
  String get signUpDataProtectionDeleteDataTitle;

  /// No description provided for @signUpDataProtectionIsoTitle.
  ///
  /// In de, this message translates to:
  /// **'ISO27001, ISO27012 & ISO27018 zertifiziert*'**
  String get signUpDataProtectionIsoTitle;

  /// No description provided for @signUpDataProtectionServerLocationSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Mit Ausnahme des Authentifizierungs-Server'**
  String get signUpDataProtectionServerLocationSubtitle;

  /// No description provided for @signUpDataProtectionServerLocationTitle.
  ///
  /// In de, this message translates to:
  /// **'Standort der Server: Frankfurt (Deutschland)'**
  String get signUpDataProtectionServerLocationTitle;

  /// No description provided for @signUpDataProtectionSocSubtitle.
  ///
  /// In de, this message translates to:
  /// **'* Zertifizierung von unserem Hosting-Anbieter'**
  String get signUpDataProtectionSocSubtitle;

  /// No description provided for @signUpDataProtectionSocTitle.
  ///
  /// In de, this message translates to:
  /// **'SOC1, SOC2, & SOC3 zertifiziert*'**
  String get signUpDataProtectionSocTitle;

  /// No description provided for @signUpDataProtectionTitle.
  ///
  /// In de, this message translates to:
  /// **'Datenschutz'**
  String get signUpDataProtectionTitle;

  /// No description provided for @signUpDataProtectionTlsTitle.
  ///
  /// In de, this message translates to:
  /// **'TLS-Verschlüsselung bei der Übertragung'**
  String get signUpDataProtectionTlsTitle;

  /// No description provided for @signUpLegalConsentMarkdown.
  ///
  /// In de, this message translates to:
  /// **'Mit Nutzung unserer Plattform stimmst du den [ANBs](https://sharezone.net/terms-of-service) zu. Wir verarbeiten deine Daten gemäß unserer [Datenschutzerklärung](https://sharezone.net/privacy-policy).'**
  String get signUpLegalConsentMarkdown;

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

  /// No description provided for @supportPageBody.
  ///
  /// In de, this message translates to:
  /// **'Du hast einen Fehler gefunden, hast Feedback oder einfach eine Frage über Sharezone? Kontaktiere uns und wir helfen dir weiter!'**
  String get supportPageBody;

  /// No description provided for @supportPageDiscordIconSemanticsLabel.
  ///
  /// In de, this message translates to:
  /// **'Discord Icon'**
  String get supportPageDiscordIconSemanticsLabel;

  /// No description provided for @supportPageDiscordPrivacyContent.
  ///
  /// In de, this message translates to:
  /// **'Bitte beachte, dass bei der Nutzung von Discord dessen [Datenschutzbestimmungen](https://discord.com/privacy) gelten.'**
  String get supportPageDiscordPrivacyContent;

  /// No description provided for @supportPageDiscordPrivacyTitle.
  ///
  /// In de, this message translates to:
  /// **'Discord Datenschutz'**
  String get supportPageDiscordPrivacyTitle;

  /// No description provided for @supportPageDiscordSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Community-Support'**
  String get supportPageDiscordSubtitle;

  /// No description provided for @supportPageDiscordTitle.
  ///
  /// In de, this message translates to:
  /// **'Discord'**
  String get supportPageDiscordTitle;

  /// No description provided for @supportPageEmailAddress.
  ///
  /// In de, this message translates to:
  /// **'E-Mail: {email}'**
  String supportPageEmailAddress(String email);

  /// No description provided for @supportPageEmailIconSemanticsLabel.
  ///
  /// In de, this message translates to:
  /// **'E-Mail Icon'**
  String get supportPageEmailIconSemanticsLabel;

  /// No description provided for @supportPageEmailTitle.
  ///
  /// In de, this message translates to:
  /// **'E-Mail'**
  String get supportPageEmailTitle;

  /// No description provided for @supportPageFreeSupportSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Bitte beachte, dass die Wartezeit beim kostenfreien Support bis zu 2 Wochen betragen kann.'**
  String get supportPageFreeSupportSubtitle;

  /// No description provided for @supportPageFreeSupportTitle.
  ///
  /// In de, this message translates to:
  /// **'Kostenfreier Support'**
  String get supportPageFreeSupportTitle;

  /// No description provided for @supportPageHeadline.
  ///
  /// In de, this message translates to:
  /// **'Du brauchst Hilfe?'**
  String get supportPageHeadline;

  /// No description provided for @supportPagePlusAdvertisingBulletOne.
  ///
  /// In de, this message translates to:
  /// **'Innerhalb von wenigen Stunden eine Rückmeldung per E-Mail (anstatt bis zu 2 Wochen)'**
  String get supportPagePlusAdvertisingBulletOne;

  /// No description provided for @supportPagePlusAdvertisingBulletTwo.
  ///
  /// In de, this message translates to:
  /// **'Videocall-Support nach Terminvereinbarung (ermöglicht das Teilen des Bildschirms)'**
  String get supportPagePlusAdvertisingBulletTwo;

  /// No description provided for @supportPagePlusEmailSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Erhalte eine Rückmeldung innerhalb von wenigen Stunden.'**
  String get supportPagePlusEmailSubtitle;

  /// No description provided for @supportPagePlusSupportSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Als Sharezone Plus Nutzer hast du Zugriff auf unseren Premium Support.'**
  String get supportPagePlusSupportSubtitle;

  /// No description provided for @supportPagePlusSupportTitle.
  ///
  /// In de, this message translates to:
  /// **'Plus Support'**
  String get supportPagePlusSupportTitle;

  /// No description provided for @supportPageTitle.
  ///
  /// In de, this message translates to:
  /// **'Support'**
  String get supportPageTitle;

  /// No description provided for @supportPageVideoCallRequiresSignIn.
  ///
  /// In de, this message translates to:
  /// **'Du musst angemeldet sein, um einen Videocall zu vereinbaren.'**
  String get supportPageVideoCallRequiresSignIn;

  /// No description provided for @supportPageVideoCallSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Nach Terminvereinbarung, bei Bedarf kann ebenfalls der Bildschirm geteilt werden.'**
  String get supportPageVideoCallSubtitle;

  /// No description provided for @supportPageVideoCallTitle.
  ///
  /// In de, this message translates to:
  /// **'Videocall-Support'**
  String get supportPageVideoCallTitle;

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

  /// No description provided for @themeNavigationOptionTitle.
  ///
  /// In de, this message translates to:
  /// **'Option {number}: {optionName}'**
  String themeNavigationOptionTitle(int number, String optionName);

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

  /// No description provided for @timetableAddAbWeeksPrefix.
  ///
  /// In de, this message translates to:
  /// **' A/B Wochen kannst du in den '**
  String get timetableAddAbWeeksPrefix;

  /// No description provided for @timetableAddAbWeeksSettings.
  ///
  /// In de, this message translates to:
  /// **'Einstellungen'**
  String get timetableAddAbWeeksSettings;

  /// No description provided for @timetableAddAbWeeksSuffix.
  ///
  /// In de, this message translates to:
  /// **' aktivieren.'**
  String get timetableAddAbWeeksSuffix;

  /// No description provided for @timetableAddAlternativeSelectPeriod.
  ///
  /// In de, this message translates to:
  /// **'Alternativ kannst du auch eine Stunde auswählen'**
  String get timetableAddAlternativeSelectPeriod;

  /// No description provided for @timetableAddAlternativeSetIndividualTime.
  ///
  /// In de, this message translates to:
  /// **'Alternativ kannst du auch individuell die Uhrzeit festlegen'**
  String get timetableAddAlternativeSetIndividualTime;

  /// No description provided for @timetableAddAutoRecurringInfo.
  ///
  /// In de, this message translates to:
  /// **'Schulstunden werden automatisch auch für die nächsten Wochen eingetragen.'**
  String get timetableAddAutoRecurringInfo;

  /// No description provided for @timetableAddChangeTimesInSettingsInfo.
  ///
  /// In de, this message translates to:
  /// **'Du kannst die Stundenzeiten in den Einstellungen vom Stundenplan ändern.'**
  String get timetableAddChangeTimesInSettingsInfo;

  /// No description provided for @timetableAddEarlyStartTimeHint.
  ///
  /// In de, this message translates to:
  /// **'Bitte bedenke, dass erst die Schulstunden ab 7 Uhr angezeigt werden.'**
  String get timetableAddEarlyStartTimeHint;

  /// No description provided for @timetableAddJoinCourseAction.
  ///
  /// In de, this message translates to:
  /// **'Kurs beitreten'**
  String get timetableAddJoinCourseAction;

  /// No description provided for @timetableAddLessonTitle.
  ///
  /// In de, this message translates to:
  /// **'Schulstunde hinzufügen'**
  String get timetableAddLessonTitle;

  /// No description provided for @timetableAddNoCourseMembershipHint.
  ///
  /// In de, this message translates to:
  /// **'Du bist noch in keinem Kurs Mitglied 😔\nErstelle einen neuen Kurs oder tritt einem bei 😃'**
  String get timetableAddNoCourseMembershipHint;

  /// No description provided for @timetableAddRoomAndTeacherOptionalTitle.
  ///
  /// In de, this message translates to:
  /// **'Gib einen Raum & eine Lehrkraft an (optional)'**
  String get timetableAddRoomAndTeacherOptionalTitle;

  /// No description provided for @timetableAddSelectCourseTitle.
  ///
  /// In de, this message translates to:
  /// **'Wähle einen Kurs aus'**
  String get timetableAddSelectCourseTitle;

  /// No description provided for @timetableAddSelectPeriodQuestion.
  ///
  /// In de, this message translates to:
  /// **'In der wievielten Stunde findet die neue Schulstunde statt?'**
  String get timetableAddSelectPeriodQuestion;

  /// No description provided for @timetableAddSelectWeekTypeTitle.
  ///
  /// In de, this message translates to:
  /// **'Wähle einen Wochentypen aus'**
  String get timetableAddSelectWeekTypeTitle;

  /// No description provided for @timetableAddSelectWeekdayTitle.
  ///
  /// In de, this message translates to:
  /// **'Wähle einen Wochentag aus'**
  String get timetableAddSelectWeekdayTitle;

  /// No description provided for @timetableAddUnknownError.
  ///
  /// In de, this message translates to:
  /// **'Es ist ein unbekannter Fehler aufgetreten. Bitte kontaktiere den Support!'**
  String get timetableAddUnknownError;

  /// Countdown label for the delete action in the delete all lessons dialog.
  ///
  /// In de, this message translates to:
  /// **'Löschen ({seconds})'**
  String timetableDeleteAllDialogDeleteCountdown(int seconds);

  /// Overlay action to open timetable settings.
  ///
  /// In de, this message translates to:
  /// **'Stundenplan löschen'**
  String get timetableDeleteAllSuggestionAction;

  /// Overlay body suggesting the delete all lessons feature.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du deinen gesamten Stundenplan löschen? Klicke hier, um die Funktion zu nutzen.'**
  String get timetableDeleteAllSuggestionBody;

  /// Overlay title suggesting deleting the entire timetable.
  ///
  /// In de, this message translates to:
  /// **'Gesamten Stundenplan löschen?'**
  String get timetableDeleteAllSuggestionTitle;

  /// No description provided for @timetableEditCourseLocked.
  ///
  /// In de, this message translates to:
  /// **'Der Kurs kann nicht mehr nachträglich geändert werden.'**
  String get timetableEditCourseLocked;

  /// No description provided for @timetableEditEndTime.
  ///
  /// In de, this message translates to:
  /// **'Endzeit'**
  String get timetableEditEndTime;

  /// No description provided for @timetableEditEventTitle.
  ///
  /// In de, this message translates to:
  /// **'{eventType} bearbeiten'**
  String timetableEditEventTitle(String eventType);

  /// No description provided for @timetableEditLessonTitle.
  ///
  /// In de, this message translates to:
  /// **'Schulstunde bearbeiten'**
  String get timetableEditLessonTitle;

  /// No description provided for @timetableEditNoPeriodSelected.
  ///
  /// In de, this message translates to:
  /// **'Keine Stunde ausgewählt'**
  String get timetableEditNoPeriodSelected;

  /// No description provided for @timetableEditPeriodSelected.
  ///
  /// In de, this message translates to:
  /// **'{number}. Stunde'**
  String timetableEditPeriodSelected(int number);

  /// No description provided for @timetableEditSelectTime.
  ///
  /// In de, this message translates to:
  /// **'Wähle eine Uhrzeit'**
  String get timetableEditSelectTime;

  /// No description provided for @timetableEditSelectTimeForPeriod.
  ///
  /// In de, this message translates to:
  /// **'Wähle eine Uhrzeit ({number}. Stunde)'**
  String timetableEditSelectTimeForPeriod(int number);

  /// No description provided for @timetableEditStartTime.
  ///
  /// In de, this message translates to:
  /// **'Startzeit'**
  String get timetableEditStartTime;

  /// No description provided for @timetableEditTeacherHint.
  ///
  /// In de, this message translates to:
  /// **'z.B. Frau Stark'**
  String get timetableEditTeacherHint;

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

  /// No description provided for @timetableEventCardChangeColorAction.
  ///
  /// In de, this message translates to:
  /// **'Farbe ändern'**
  String get timetableEventCardChangeColorAction;

  /// No description provided for @timetableEventCardEventTitle.
  ///
  /// In de, this message translates to:
  /// **'Termin: {value}'**
  String timetableEventCardEventTitle(Object value);

  /// No description provided for @timetableEventCardExamTitle.
  ///
  /// In de, this message translates to:
  /// **'Prüfung: {value}'**
  String timetableEventCardExamTitle(Object value);

  /// No description provided for @timetableEventDetailsAddToCalendarButton.
  ///
  /// In de, this message translates to:
  /// **'IN KALENDER EINTRAGEN'**
  String get timetableEventDetailsAddToCalendarButton;

  /// No description provided for @timetableEventDetailsAddToCalendarPlusDescription.
  ///
  /// In de, this message translates to:
  /// **'Mit Sharezone Plus kannst du kinderleicht die Termine aus Sharezone in deinen lokalen Kalender (z.B. Apple oder Google Kalender) übertragen.'**
  String get timetableEventDetailsAddToCalendarPlusDescription;

  /// No description provided for @timetableEventDetailsAddToCalendarTitle.
  ///
  /// In de, this message translates to:
  /// **'Termin zum Kalender hinzufügen'**
  String get timetableEventDetailsAddToCalendarTitle;

  /// No description provided for @timetableEventDetailsDeleteDialog.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du wirklich diesen Termin löschen?'**
  String get timetableEventDetailsDeleteDialog;

  /// No description provided for @timetableEventDetailsDeletedConfirmation.
  ///
  /// In de, this message translates to:
  /// **'Termin wurde gelöscht'**
  String get timetableEventDetailsDeletedConfirmation;

  /// No description provided for @timetableEventDetailsEditedConfirmation.
  ///
  /// In de, this message translates to:
  /// **'Termin wurde erfolgreich bearbeitet'**
  String get timetableEventDetailsEditedConfirmation;

  /// No description provided for @timetableEventDetailsExamTopics.
  ///
  /// In de, this message translates to:
  /// **'Themen der Prüfung'**
  String get timetableEventDetailsExamTopics;

  /// No description provided for @timetableEventDetailsLabel.
  ///
  /// In de, this message translates to:
  /// **'Details'**
  String get timetableEventDetailsLabel;

  /// No description provided for @timetableEventDetailsReport.
  ///
  /// In de, this message translates to:
  /// **'{itemType} melden'**
  String timetableEventDetailsReport(String itemType);

  /// No description provided for @timetableEventDetailsRoom.
  ///
  /// In de, this message translates to:
  /// **'Raum: {room}'**
  String timetableEventDetailsRoom(String room);

  /// No description provided for @timetableEventDialogDateSelectionNotPossible.
  ///
  /// In de, this message translates to:
  /// **'Auswahl nicht möglich'**
  String get timetableEventDialogDateSelectionNotPossible;

  /// No description provided for @timetableEventDialogDateSelectionNotPossibleContent.
  ///
  /// In de, this message translates to:
  /// **'Aktuell ist nicht möglich, einen Termin oder eine Klausur über mehrere Tage hinweg zu haben.'**
  String get timetableEventDialogDateSelectionNotPossibleContent;

  /// No description provided for @timetableEventDialogDescriptionHintEvent.
  ///
  /// In de, this message translates to:
  /// **'Zusatzinformationen'**
  String get timetableEventDialogDescriptionHintEvent;

  /// No description provided for @timetableEventDialogDescriptionHintExam.
  ///
  /// In de, this message translates to:
  /// **'Themen der Prüfung'**
  String get timetableEventDialogDescriptionHintExam;

  /// No description provided for @timetableEventDialogEmptyCourse.
  ///
  /// In de, this message translates to:
  /// **'Keinen Kurs ausgewählt'**
  String get timetableEventDialogEmptyCourse;

  /// Error message shown when no course is selected in the add event dialog.
  ///
  /// In de, this message translates to:
  /// **'Bitte wähle einen Kurs aus.'**
  String get timetableEventDialogEmptyCourseError;

  /// Error message shown when no title is entered in the add event dialog.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib einen Titel ein.'**
  String get timetableEventDialogEmptyTitleError;

  /// Error message shown when the end time is not after the start time in the add event dialog.
  ///
  /// In de, this message translates to:
  /// **'Die Endzeit muss nach der Startzeit liegen.'**
  String get timetableEventDialogEndTimeAfterStartTimeError;

  /// No description provided for @timetableEventDialogNotifyCourseMembersEvent.
  ///
  /// In de, this message translates to:
  /// **'Kursmitglieder über neuen Termin benachrichtigen.'**
  String get timetableEventDialogNotifyCourseMembersEvent;

  /// No description provided for @timetableEventDialogNotifyCourseMembersExam.
  ///
  /// In de, this message translates to:
  /// **'Kursmitglieder über neue Klausur benachrichtigen.'**
  String get timetableEventDialogNotifyCourseMembersExam;

  /// No description provided for @timetableEventDialogNotifyCourseMembersTitle.
  ///
  /// In de, this message translates to:
  /// **'Kursmitglieder benachrichtigen'**
  String get timetableEventDialogNotifyCourseMembersTitle;

  /// No description provided for @timetableEventDialogSaveEventTooltip.
  ///
  /// In de, this message translates to:
  /// **'Termin speichern'**
  String get timetableEventDialogSaveEventTooltip;

  /// No description provided for @timetableEventDialogSaveExamTooltip.
  ///
  /// In de, this message translates to:
  /// **'Klausur speichern'**
  String get timetableEventDialogSaveExamTooltip;

  /// No description provided for @timetableEventDialogTitleHintEvent.
  ///
  /// In de, this message translates to:
  /// **'Titel eingeben (z.B. Sportfest)'**
  String get timetableEventDialogTitleHintEvent;

  /// No description provided for @timetableEventDialogTitleHintExam.
  ///
  /// In de, this message translates to:
  /// **'Titel (z.B. Statistik-Klausur)'**
  String get timetableEventDialogTitleHintExam;

  /// No description provided for @timetableFabAddTooltip.
  ///
  /// In de, this message translates to:
  /// **'Stunde/Termin hinzufügen'**
  String get timetableFabAddTooltip;

  /// No description provided for @timetableFabLessonAddedConfirmation.
  ///
  /// In de, this message translates to:
  /// **'Die Schulstunde wurde erfolgreich hinzugefügt'**
  String get timetableFabLessonAddedConfirmation;

  /// No description provided for @timetableFabOptionEvent.
  ///
  /// In de, this message translates to:
  /// **'Termin'**
  String get timetableFabOptionEvent;

  /// No description provided for @timetableFabOptionExam.
  ///
  /// In de, this message translates to:
  /// **'Prüfung'**
  String get timetableFabOptionExam;

  /// No description provided for @timetableFabOptionLesson.
  ///
  /// In de, this message translates to:
  /// **'Schulstunde'**
  String get timetableFabOptionLesson;

  /// No description provided for @timetableFabOptionSubstitutions.
  ///
  /// In de, this message translates to:
  /// **'Vertretungsplan'**
  String get timetableFabOptionSubstitutions;

  /// No description provided for @timetableFabSectionCalendar.
  ///
  /// In de, this message translates to:
  /// **'Kalender'**
  String get timetableFabSectionCalendar;

  /// No description provided for @timetableFabSectionTimetable.
  ///
  /// In de, this message translates to:
  /// **'Stundenplan'**
  String get timetableFabSectionTimetable;

  /// No description provided for @timetableFabSubstitutionsDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Vertretungsplan'**
  String get timetableFabSubstitutionsDialogTitle;

  /// No description provided for @timetableFabSubstitutionsStepOne.
  ///
  /// In de, this message translates to:
  /// **'1. Navigiere zu der betroffenen Schulstunde.'**
  String get timetableFabSubstitutionsStepOne;

  /// No description provided for @timetableFabSubstitutionsStepThree.
  ///
  /// In de, this message translates to:
  /// **'3. Wähle die Art der Vertretung aus.'**
  String get timetableFabSubstitutionsStepThree;

  /// No description provided for @timetableFabSubstitutionsStepTwo.
  ///
  /// In de, this message translates to:
  /// **'2. Klicke auf die Schulstunde.'**
  String get timetableFabSubstitutionsStepTwo;

  /// No description provided for @timetableLessonDetailsAddHomeworkTooltip.
  ///
  /// In de, this message translates to:
  /// **'Hausaufgabe hinzufügen'**
  String get timetableLessonDetailsAddHomeworkTooltip;

  /// No description provided for @timetableLessonDetailsArrowLocation.
  ///
  /// In de, this message translates to:
  /// **'-> {location}'**
  String timetableLessonDetailsArrowLocation(String location);

  /// No description provided for @timetableLessonDetailsChangeColor.
  ///
  /// In de, this message translates to:
  /// **'Farbe ändern'**
  String get timetableLessonDetailsChangeColor;

  /// No description provided for @timetableLessonDetailsCourseName.
  ///
  /// In de, this message translates to:
  /// **'Kursname: '**
  String get timetableLessonDetailsCourseName;

  /// No description provided for @timetableLessonDetailsDeleteDialogConfirm.
  ///
  /// In de, this message translates to:
  /// **'Mir ist bewusst, dass die Stunde für alle Teilnehmer aus dem Kurs gelöscht wird.'**
  String get timetableLessonDetailsDeleteDialogConfirm;

  /// No description provided for @timetableLessonDetailsDeleteDialogMessage.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du wirklich die Schulstunde für den gesamten Kurs löschen?'**
  String get timetableLessonDetailsDeleteDialogMessage;

  /// No description provided for @timetableLessonDetailsDeleteTitle.
  ///
  /// In de, this message translates to:
  /// **'Stunde löschen'**
  String get timetableLessonDetailsDeleteTitle;

  /// No description provided for @timetableLessonDetailsDeletedConfirmation.
  ///
  /// In de, this message translates to:
  /// **'Schulstunde wurde gelöscht'**
  String get timetableLessonDetailsDeletedConfirmation;

  /// No description provided for @timetableLessonDetailsEditedConfirmation.
  ///
  /// In de, this message translates to:
  /// **'Schulstunde wurde erfolgreich bearbeitet'**
  String get timetableLessonDetailsEditedConfirmation;

  /// No description provided for @timetableLessonDetailsRoom.
  ///
  /// In de, this message translates to:
  /// **'Raum: '**
  String get timetableLessonDetailsRoom;

  /// No description provided for @timetableLessonDetailsSubstitutionPlusDescription.
  ///
  /// In de, this message translates to:
  /// **'Schalte mit Sharezone Plus den Vertretungsplan frei, um z.B. den Entfall einer Schulstunden zu markieren.\n\nSogar Kursmitglieder ohne Sharezone Plus können den Vertretungsplan einsehen (jedoch nicht ändern).'**
  String get timetableLessonDetailsSubstitutionPlusDescription;

  /// No description provided for @timetableLessonDetailsTeacher.
  ///
  /// In de, this message translates to:
  /// **'Lehrkraft: '**
  String get timetableLessonDetailsTeacher;

  /// No description provided for @timetableLessonDetailsTeacherInTimetableDescription.
  ///
  /// In de, this message translates to:
  /// **'Mit Sharezone Plus kannst du die Lehrkraft zur jeweiligen Schulstunde im Stundenplan eintragen. Für Kursmitglieder ohne Sharezone Plus wird die Lehrkraft ebenfalls angezeigt.'**
  String get timetableLessonDetailsTeacherInTimetableDescription;

  /// No description provided for @timetableLessonDetailsTeacherInTimetableTitle.
  ///
  /// In de, this message translates to:
  /// **'Lehrkraft im Stundenplan'**
  String get timetableLessonDetailsTeacherInTimetableTitle;

  /// No description provided for @timetableLessonDetailsTimeRange.
  ///
  /// In de, this message translates to:
  /// **'{startTime} - {endTime}'**
  String timetableLessonDetailsTimeRange(String endTime, String startTime);

  /// No description provided for @timetableLessonDetailsWeekType.
  ///
  /// In de, this message translates to:
  /// **'Wochentyp: {weekType}'**
  String timetableLessonDetailsWeekType(String weekType);

  /// No description provided for @timetableLessonDetailsWeekday.
  ///
  /// In de, this message translates to:
  /// **'Wochentag: {weekday}'**
  String timetableLessonDetailsWeekday(String weekday);

  /// No description provided for @timetablePageSettingsTooltip.
  ///
  /// In de, this message translates to:
  /// **'Stundenplan-Einstellungen'**
  String get timetablePageSettingsTooltip;

  /// No description provided for @timetableQuickCreateEmptyTitle.
  ///
  /// In de, this message translates to:
  /// **'Du bist noch keinem Kurs, bzw. keiner Klasse beigetreten!'**
  String get timetableQuickCreateEmptyTitle;

  /// No description provided for @timetableQuickCreateTitle.
  ///
  /// In de, this message translates to:
  /// **'Stunde hinzufügen'**
  String get timetableQuickCreateTitle;

  /// No description provided for @timetableSchoolClassFilterAllClasses.
  ///
  /// In de, this message translates to:
  /// **'Alle Schulklassen'**
  String get timetableSchoolClassFilterAllClasses;

  /// No description provided for @timetableSchoolClassFilterAllShort.
  ///
  /// In de, this message translates to:
  /// **'Alle'**
  String get timetableSchoolClassFilterAllShort;

  /// No description provided for @timetableSchoolClassFilterLabel.
  ///
  /// In de, this message translates to:
  /// **'Schulklasse: {value}'**
  String timetableSchoolClassFilterLabel(Object value);

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

  /// Snackbar confirmation after deleting all lessons.
  ///
  /// In de, this message translates to:
  /// **'Stunden wurden gelöscht.'**
  String get timetableSettingsDeleteAllLessonsConfirmation;

  /// Confirmation dialog body for deleting all lessons.
  ///
  /// In de, this message translates to:
  /// **'Damit werden {count} Stunden aus Gruppen gelöscht, für die du Schreibrechte hast. Diese Stunden werden auch für deine Gruppenmitglieder gelöscht. Das kann nicht rückgängig gemacht werden.'**
  String timetableSettingsDeleteAllLessonsDialogBody(int count);

  /// Confirmation dialog title for deleting all lessons.
  ///
  /// In de, this message translates to:
  /// **'Alle Stunden löschen?'**
  String get timetableSettingsDeleteAllLessonsDialogTitle;

  /// Subtitle when the user cannot delete any lessons.
  ///
  /// In de, this message translates to:
  /// **'Keine Stunden mit Schreibrechten.'**
  String get timetableSettingsDeleteAllLessonsSubtitleNoAccess;

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

  /// Title of the timetable settings page.
  ///
  /// In de, this message translates to:
  /// **'Stundenplan'**
  String get timetableSettingsTitle;

  /// No description provided for @timetableSubstitutionCancelDialogAction.
  ///
  /// In de, this message translates to:
  /// **'Entfallen lassen'**
  String get timetableSubstitutionCancelDialogAction;

  /// No description provided for @timetableSubstitutionCancelDialogDescription.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du wirklich die Schulstunde für den gesamten Kurs entfallen lassen?'**
  String get timetableSubstitutionCancelDialogDescription;

  /// No description provided for @timetableSubstitutionCancelDialogNotify.
  ///
  /// In de, this message translates to:
  /// **'Informiere deine Kursmitglieder, dass die Stunde entfällt.'**
  String get timetableSubstitutionCancelDialogNotify;

  /// No description provided for @timetableSubstitutionCancelDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Stunde entfallen lassen'**
  String get timetableSubstitutionCancelDialogTitle;

  /// No description provided for @timetableSubstitutionCancelLesson.
  ///
  /// In de, this message translates to:
  /// **'Stunde entfallen lassen'**
  String get timetableSubstitutionCancelLesson;

  /// No description provided for @timetableSubstitutionCancelRestored.
  ///
  /// In de, this message translates to:
  /// **'Entfallene Stunde wiederhergestellt'**
  String get timetableSubstitutionCancelRestored;

  /// No description provided for @timetableSubstitutionCancelSaved.
  ///
  /// In de, this message translates to:
  /// **'Stunde als \"Entfällt\" markiert'**
  String get timetableSubstitutionCancelSaved;

  /// No description provided for @timetableSubstitutionCanceledTitle.
  ///
  /// In de, this message translates to:
  /// **'Stunde entfällt'**
  String get timetableSubstitutionCanceledTitle;

  /// No description provided for @timetableSubstitutionChangeRoom.
  ///
  /// In de, this message translates to:
  /// **'Raumänderung'**
  String get timetableSubstitutionChangeRoom;

  /// No description provided for @timetableSubstitutionChangeRoomDialogAction.
  ///
  /// In de, this message translates to:
  /// **'Raumänderung speichern'**
  String get timetableSubstitutionChangeRoomDialogAction;

  /// No description provided for @timetableSubstitutionChangeRoomDialogDescription.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du wirklich den Raum für die Stunde ändern?'**
  String get timetableSubstitutionChangeRoomDialogDescription;

  /// No description provided for @timetableSubstitutionChangeRoomDialogNotify.
  ///
  /// In de, this message translates to:
  /// **'Informiere deine Kursmitglieder über die Raumänderung.'**
  String get timetableSubstitutionChangeRoomDialogNotify;

  /// No description provided for @timetableSubstitutionChangeRoomDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Raumänderung'**
  String get timetableSubstitutionChangeRoomDialogTitle;

  /// No description provided for @timetableSubstitutionChangeTeacher.
  ///
  /// In de, this message translates to:
  /// **'Lehrkraft ändern'**
  String get timetableSubstitutionChangeTeacher;

  /// No description provided for @timetableSubstitutionChangeTeacherDialogAction.
  ///
  /// In de, this message translates to:
  /// **'Lehrkraft speichern'**
  String get timetableSubstitutionChangeTeacherDialogAction;

  /// No description provided for @timetableSubstitutionChangeTeacherDialogDescription.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du wirklich die Vertretungslehrkraft ändern?'**
  String get timetableSubstitutionChangeTeacherDialogDescription;

  /// No description provided for @timetableSubstitutionChangeTeacherDialogNotify.
  ///
  /// In de, this message translates to:
  /// **'Informiere deine Kursmitglieder über die Lehrkraftänderung.'**
  String get timetableSubstitutionChangeTeacherDialogNotify;

  /// No description provided for @timetableSubstitutionChangeTeacherDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Vertretungslehrkraft ändern'**
  String get timetableSubstitutionChangeTeacherDialogTitle;

  /// No description provided for @timetableSubstitutionEditRoomTooltip.
  ///
  /// In de, this message translates to:
  /// **'Raum ändern'**
  String get timetableSubstitutionEditRoomTooltip;

  /// No description provided for @timetableSubstitutionEditTeacherTooltip.
  ///
  /// In de, this message translates to:
  /// **'Lehrkraft ändern'**
  String get timetableSubstitutionEditTeacherTooltip;

  /// No description provided for @timetableSubstitutionEnteredBy.
  ///
  /// In de, this message translates to:
  /// **'Eingetragen von: {name}'**
  String timetableSubstitutionEnteredBy(String name);

  /// No description provided for @timetableSubstitutionNewRoomHint.
  ///
  /// In de, this message translates to:
  /// **'z.B. D203'**
  String get timetableSubstitutionNewRoomHint;

  /// No description provided for @timetableSubstitutionNewRoomLabel.
  ///
  /// In de, this message translates to:
  /// **'Neuer Raum'**
  String get timetableSubstitutionNewRoomLabel;

  /// No description provided for @timetableSubstitutionNoPermissionSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Bitte wende dich an deinen Kurs-Administrator.'**
  String get timetableSubstitutionNoPermissionSubtitle;

  /// No description provided for @timetableSubstitutionNoPermissionTitle.
  ///
  /// In de, this message translates to:
  /// **'Du hast keine Berechtigung, den Vertretungsplan zu ändern.'**
  String get timetableSubstitutionNoPermissionTitle;

  /// No description provided for @timetableSubstitutionRemoveAction.
  ///
  /// In de, this message translates to:
  /// **'Entfernen'**
  String get timetableSubstitutionRemoveAction;

  /// No description provided for @timetableSubstitutionRemoveRoomDialogDescription.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du wirklich die Raumänderung für die Stunde entfernen?'**
  String get timetableSubstitutionRemoveRoomDialogDescription;

  /// No description provided for @timetableSubstitutionRemoveRoomDialogNotify.
  ///
  /// In de, this message translates to:
  /// **'Informiere deine Kursmitglieder über die Entfernung.'**
  String get timetableSubstitutionRemoveRoomDialogNotify;

  /// No description provided for @timetableSubstitutionRemoveRoomDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Raumänderung entfernen'**
  String get timetableSubstitutionRemoveRoomDialogTitle;

  /// No description provided for @timetableSubstitutionRemoveTeacherDialogDescription.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du wirklich die Vertretungslehrkraft für die Stunde entfernen?'**
  String get timetableSubstitutionRemoveTeacherDialogDescription;

  /// No description provided for @timetableSubstitutionRemoveTeacherDialogNotify.
  ///
  /// In de, this message translates to:
  /// **'Informiere deine Kursmitglieder über die Entfernung.'**
  String get timetableSubstitutionRemoveTeacherDialogNotify;

  /// No description provided for @timetableSubstitutionRemoveTeacherDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Vertretungslehrkraft entfernen'**
  String get timetableSubstitutionRemoveTeacherDialogTitle;

  /// No description provided for @timetableSubstitutionReplacement.
  ///
  /// In de, this message translates to:
  /// **'Vertretung: {teacher}'**
  String timetableSubstitutionReplacement(String teacher);

  /// No description provided for @timetableSubstitutionRestoreDialogAction.
  ///
  /// In de, this message translates to:
  /// **'Wiederherstellen'**
  String get timetableSubstitutionRestoreDialogAction;

  /// No description provided for @timetableSubstitutionRestoreDialogDescription.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du wirklich die Stunde wieder stattfinden lassen?'**
  String get timetableSubstitutionRestoreDialogDescription;

  /// No description provided for @timetableSubstitutionRestoreDialogNotify.
  ///
  /// In de, this message translates to:
  /// **'Informiere deine Kursmitglieder, dass die Stunde stattfindet.'**
  String get timetableSubstitutionRestoreDialogNotify;

  /// No description provided for @timetableSubstitutionRestoreDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Entfallene Stunde wiederherstellen'**
  String get timetableSubstitutionRestoreDialogTitle;

  /// No description provided for @timetableSubstitutionRoomChanged.
  ///
  /// In de, this message translates to:
  /// **'Raumänderung: {room}'**
  String timetableSubstitutionRoomChanged(String room);

  /// No description provided for @timetableSubstitutionRoomRemoved.
  ///
  /// In de, this message translates to:
  /// **'Raumänderung entfernt'**
  String get timetableSubstitutionRoomRemoved;

  /// No description provided for @timetableSubstitutionRoomSaved.
  ///
  /// In de, this message translates to:
  /// **'Raumänderung eingetragen'**
  String get timetableSubstitutionRoomSaved;

  /// No description provided for @timetableSubstitutionSectionForDate.
  ///
  /// In de, this message translates to:
  /// **'Für {date}'**
  String timetableSubstitutionSectionForDate(String date);

  /// No description provided for @timetableSubstitutionSectionTitle.
  ///
  /// In de, this message translates to:
  /// **'Vertretungsplan'**
  String get timetableSubstitutionSectionTitle;

  /// No description provided for @timetableSubstitutionTeacherRemoved.
  ///
  /// In de, this message translates to:
  /// **'Vertretungslehrkraft entfernt'**
  String get timetableSubstitutionTeacherRemoved;

  /// No description provided for @timetableSubstitutionTeacherSaved.
  ///
  /// In de, this message translates to:
  /// **'Vertretungslehrkraft eingetragen'**
  String get timetableSubstitutionTeacherSaved;

  /// No description provided for @timetableSubstitutionUndoTooltip.
  ///
  /// In de, this message translates to:
  /// **'Rückgängig machen'**
  String get timetableSubstitutionUndoTooltip;

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

  /// No description provided for @userCommentFieldEmptyError.
  ///
  /// In de, this message translates to:
  /// **'Der Kommentar hat doch gar keinen Text! 🧐'**
  String get userCommentFieldEmptyError;

  /// No description provided for @userCommentFieldHint.
  ///
  /// In de, this message translates to:
  /// **'Gib deinen Senf ab...'**
  String get userCommentFieldHint;

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

  /// No description provided for @webAppSettingsDescription.
  ///
  /// In de, this message translates to:
  /// **'Besuche für weitere Informationen einfach https://web.sharezone.net.'**
  String get webAppSettingsDescription;

  /// No description provided for @webAppSettingsHeadline.
  ///
  /// In de, this message translates to:
  /// **'Sharezone für\'s Web!'**
  String get webAppSettingsHeadline;

  /// No description provided for @webAppSettingsQrCodeHint.
  ///
  /// In de, this message translates to:
  /// **'Mithilfe der Anmeldung über einen QR-Code kannst du dich in der Web-App anmelden, ohne ein Passwort einzugeben. Besonders hilfreich ist das bei der Nutzung eines öffentlichen PCs.'**
  String get webAppSettingsQrCodeHint;

  /// No description provided for @webAppSettingsScanQrCodeDescription.
  ///
  /// In de, this message translates to:
  /// **'Geh auf web.sharezone.net und scanne den QR-Code.'**
  String get webAppSettingsScanQrCodeDescription;

  /// No description provided for @webAppSettingsScanQrCodeTitle.
  ///
  /// In de, this message translates to:
  /// **'QR-Code scannen'**
  String get webAppSettingsScanQrCodeTitle;

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

  /// No description provided for @weekdaysEditSaved.
  ///
  /// In de, this message translates to:
  /// **'Die aktivierten Wochentage wurden erfolgreich geändert.'**
  String get weekdaysEditSaved;

  /// No description provided for @weekdaysEditTitle.
  ///
  /// In de, this message translates to:
  /// **'Schultage'**
  String get weekdaysEditTitle;

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
