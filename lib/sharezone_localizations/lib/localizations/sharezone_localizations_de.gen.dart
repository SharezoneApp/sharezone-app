// Copyright (c) 2026 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'sharezone_localizations.gen.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class SharezoneLocalizationsDe extends SharezoneLocalizations {
  SharezoneLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String aboutEmailCopiedConfirmation(String email_address) {
    return 'E-Mail: $email_address';
  }

  @override
  String get aboutFollowUsSubtitle =>
      'Folge uns auf unseren Kanälen, um immer auf dem neusten Stand zu bleiben.';

  @override
  String get aboutFollowUsTitle => 'Folge uns';

  @override
  String get aboutHeaderSubtitle => 'Der vernetzte Schulplaner';

  @override
  String get aboutHeaderTitle => 'Sharezone';

  @override
  String get aboutLoadingVersion => 'Version wird geladen...';

  @override
  String get aboutSectionDescription =>
      'Sharezone ist ein vernetzter Schulplaner, welcher die Organisation von Schülern, Lehrkräften und Eltern aus der Steinzeit in das digitale Zeitalter katapultiert. Das Hausaufgabenheft, der Terminplaner, die Dateiablage und vieles weitere wird direkt mit der kompletten Klasse geteilt. Dabei ist keine Registrierung der Schule und die Leitung einer Lehrkraft notwendig, so dass du direkt durchstarten und deinen Schulalltag bequem und einfach gestalten kannst.';

  @override
  String get aboutSectionTitle => 'Was ist Sharezone?';

  @override
  String get aboutSectionVisitWebsite =>
      'Besuche für weitere Informationen einfach https://www.sharezone.net.';

  @override
  String get aboutTeamSectionTitle => 'Über uns';

  @override
  String get aboutTitle => 'Über uns';

  @override
  String aboutVersion(String? buildNumber, String? version) {
    return 'Version: $version ($buildNumber)';
  }

  @override
  String get accountEditProfileTooltip => 'Profil bearbeiten';

  @override
  String get accountLinkAppleConfirmation =>
      'Dein Account wurde mit einem Apple-Konto verknüpft.';

  @override
  String get accountLinkGoogleConfirmation =>
      'Dein Account wurde mit einem Google-Konto verknüpft.';

  @override
  String get accountPageTitle => 'Profil';

  @override
  String get accountPageWebLoginTooltip => 'QR-Code Login für die Web-App';

  @override
  String get accountStateTitle => 'Bundesland';

  @override
  String get activationCodeCacheCleared =>
      'Cache geleert. Möglicherweise ist ein App-Neustart notwendig, um die Änderungen zu sehen.';

  @override
  String get activationCodeFeatureAdsLabel => 'Ads';

  @override
  String get activationCodeFeatureL10nLabel => 'l10n';

  @override
  String get activationCodeToggleDisabled => 'deaktiviert';

  @override
  String get activationCodeToggleEnabled => 'aktiviert';

  @override
  String activationCodeToggleResult(String feature, String state) {
    return '$feature wurde $state. Starte die App neu, um die Änderungen zu sehen.';
  }

  @override
  String get appName => 'Sharezone';

  @override
  String authAnonymousDisplayName(Object animalName) {
    return 'Anonymer $animalName';
  }

  @override
  String get authProviderAnonymous => 'Anonyme Anmeldung';

  @override
  String get authProviderApple => 'Apple Sign In';

  @override
  String get authProviderEmailAndPassword => 'E-Mail und Passwort';

  @override
  String get authProviderGoogle => 'Google Sign In';

  @override
  String get authValidationInvalidEmail => 'Gib eine gueltige E-Mail ein';

  @override
  String get authValidationInvalidName => 'Ungueltiger Name';

  @override
  String get authValidationInvalidPasswordTooShort =>
      'Ungueltiges Passwort, bitte gib mehr als 8 Zeichen ein';

  @override
  String get blackboardErrorCourseMissing => 'Bitte gib einen Kurs an!';

  @override
  String get blackboardErrorTitleMissing =>
      'Bitte gib einen Titel für den Eintrag an!';

  @override
  String get changeEmailAddressCurrentEmailTextfieldLabel => 'Aktuell';

  @override
  String get changeEmailAddressIdenticalError =>
      'Die eingegebene E-Mail ist identisch mit der alten! 🙈';

  @override
  String get changeEmailAddressNewEmailTextfieldLabel => 'Neu';

  @override
  String get changeEmailAddressNoteOnAutomaticSignOutSignIn =>
      'Hinweis: Wenn deine E-Mail geändert wurde, wirst du automatisch kurz ab- und sofort wieder angemeldet - also nicht wundern 😉';

  @override
  String get changeEmailAddressPasswordTextfieldLabel => 'Passwort';

  @override
  String get changeEmailAddressTitle => 'E-Mail ändern';

  @override
  String get changeEmailAddressWhyWeNeedTheEmailInfoContent =>
      'Die E-Mail benötigst du um dich anzumelden. Solltest du zufällig mal dein Passwort vergessen haben, können wir dir an diese E-Mail-Adresse einen Link zum Zurücksetzen des Passworts schicken. Deine E-Mail Adresse ist nur für dich sichtbar, und sonst niemanden.';

  @override
  String get changeEmailAddressWhyWeNeedTheEmailInfoTitle =>
      'Wozu brauchen wir deine E-Mail?';

  @override
  String get changePasswordCurrentPasswordTextfieldLabel =>
      'Aktuelles Passwort';

  @override
  String get changePasswordLoadingSnackbarText =>
      'Neues Password wird an die Zentrale geschickt...';

  @override
  String get changePasswordNewPasswordTextfieldLabel => 'Neues Passwort';

  @override
  String get changePasswordResetCurrentPasswordButton =>
      'Aktuelles Passwort vergessen?';

  @override
  String get changePasswordResetCurrentPasswordDialogContent =>
      'Sollen wir dir eine E-Mail schicken, mit der du dein Passwort zurücksetzen kannst?';

  @override
  String get changePasswordResetCurrentPasswordDialogTitle =>
      'Passwort zurücksetzen';

  @override
  String get changePasswordResetCurrentPasswordEmailSentConfirmation =>
      'Wir haben eine E-Mail zum Zurücksetzen deines Passworts verschickt.';

  @override
  String get changePasswordResetCurrentPasswordLoading =>
      'Verschicken der E-Mail wird vorbereitet...';

  @override
  String get changePasswordTitle => 'Passwort ändern';

  @override
  String get changeStateErrorChangingState =>
      'Fehler beim Ändern deines Bundeslandes! :(';

  @override
  String get changeStateErrorLoadingState =>
      'Error beim Anzeigen der Bundesländer. Falls der Fehler besteht kontaktiere uns bitte.';

  @override
  String get changeStateTitle => 'Bundesland ändern';

  @override
  String get changeStateWhyWeNeedTheStateInfoContent =>
      'Mithilfe des Bundeslandes können wir die restlichen Tage bis zu den nächsten Ferien berechnen. Wenn du diese Angabe nicht machen möchtest, dann wähle beim Bundesland bitte einfach den Eintrag \"Anonym bleiben.\" aus.';

  @override
  String get changeStateWhyWeNeedTheStateInfoTitle =>
      'Wozu brauchen wir dein Bundesland?';

  @override
  String changeTypeOfUserErrorDialogContentChangedTypeOfUserTooOften(
    DateTime blockedUntil,
  ) {
    final intl.DateFormat blockedUntilDateFormat =
        intl.DateFormat.yMd(localeName).add_jm();
    final String blockedUntilString = blockedUntilDateFormat.format(
      blockedUntil,
    );

    return 'Du kannst nur alle 14 Tage 2x den Account-Typ ändern. Diese Limit wurde erreicht. Bitte warte bis $blockedUntilString.';
  }

  @override
  String get changeTypeOfUserErrorDialogContentNoTypeOfUserSelected =>
      'Es wurde kein Account-Typ ausgewählt.';

  @override
  String get changeTypeOfUserErrorDialogContentTypeOfUserHasNotChanged =>
      'Der Account-Typ hat sich nicht geändert.';

  @override
  String changeTypeOfUserErrorDialogContentUnknown(Object? error) {
    return 'Fehler: $error. Bitte kontaktiere den Support.';
  }

  @override
  String get changeTypeOfUserErrorDialogTitle => 'Fehler';

  @override
  String get changeTypeOfUserPermissionNote =>
      'Beachte die folgende Hinweise:\n* Innerhalb von 14 Tagen kannst du nur 2x den Account-Typ ändern.\n* Durch das Ändern der Nutzer erhältst du keine weiteren Berechtigungen in den Gruppen. Ausschlaggebend sind die Gruppenberechtigungen (\"Administrator\", \"Aktives Mitglied\", \"Passives Mitglied\").';

  @override
  String get changeTypeOfUserRestartAppDialogContent =>
      'Die Änderung deines Account-Typs war erfolgreich. Jedoch muss die App muss neu gestartet werden, damit die Änderung wirksam wird.';

  @override
  String get changeTypeOfUserRestartAppDialogTitle => 'Neustart erforderlich';

  @override
  String get changeTypeOfUserTitle => 'Account-Typ ändern';

  @override
  String get commonActionBack => 'Zurück';

  @override
  String get commonActionChange => 'Ändern';

  @override
  String get commonActionsAlright => 'Alles klar';

  @override
  String get commonActionsCancel => 'Abbrechen';

  @override
  String get commonActionsCancelUppercase => 'ABBRECHEN';

  @override
  String get commonActionsClose => 'Schließen';

  @override
  String get commonActionsCloseUppercase => 'SCHLIESSEN';

  @override
  String get commonActionsConfirm => 'Bestätigen';

  @override
  String get commonActionsContactSupport => 'Support kontaktieren';

  @override
  String get commonActionsContinue => 'Weiter';

  @override
  String get commonActionsDelete => 'Löschen';

  @override
  String get commonActionsDeleteUppercase => 'LÖSCHEN';

  @override
  String get commonActionsLeave => 'Verlassen';

  @override
  String get commonActionsOk => 'Ok';

  @override
  String get commonActionsSave => 'Speichern';

  @override
  String get commonActionsYes => 'Ja';

  @override
  String commonDisplayError(String? error) {
    return 'Fehler: $error';
  }

  @override
  String get commonErrorCourseSubjectMissing => 'Bitte gib ein Fach an!';

  @override
  String get commonErrorCredentialAlreadyInUse =>
      'Es existiert bereits ein Nutzer mit dieser Anmeldemethode!';

  @override
  String get commonErrorDateMissing => 'Bitte gib ein Datum an!';

  @override
  String get commonErrorEmailAlreadyInUse =>
      'Diese E-Mail Adresse wird bereits von einem anderen Nutzer verwendet.';

  @override
  String get commonErrorEmailInvalidFormat =>
      'Die E-Mail hat ein ungültiges Format.';

  @override
  String get commonErrorEmailMissing => 'Bitte gib deine E-Mail an.';

  @override
  String get commonErrorIncorrectData => 'Bitte gib die Daten korrekt an!';

  @override
  String get commonErrorIncorrectSharecode => 'Ungültiger Sharecode!';

  @override
  String get commonErrorInvalidInput => 'Bitte überprüfe deine Eingabe!';

  @override
  String get commonErrorKeychainSignInFailed =>
      'Es gab einen Fehler beim Anmelden. Um diesen zu beheben, wähle die Option \'Immer erlauben\' bei der Passworteingabe bei dem Dialog für den macOS-Schlüsselbund (Keychain) aus.';

  @override
  String get commonErrorNameMissing => 'Bitte gib einen Namen an!';

  @override
  String get commonErrorNameTooShort =>
      'Bitte gib einen Namen an, der mehr als ein Zeichen hat.';

  @override
  String get commonErrorNameUnchanged =>
      'Dieser Name ist doch der gleiche wie vorher 😅';

  @override
  String get commonErrorNetworkRequestFailed =>
      'Es gab einen Netzwerkfehler, weil keine stabile Internetverbindung besteht.';

  @override
  String get commonErrorNewPasswordMissing =>
      'Oh, du hast vergessen dein neues Passwort einzugeben 😬';

  @override
  String get commonErrorNoGoogleAccountSelected =>
      'Bitte wähle einen Account aus.';

  @override
  String get commonErrorNoInternetAccess =>
      'Dein Gerät hat leider keinen Zugang zum Internet...';

  @override
  String get commonErrorPasswordMissing => 'Bitte gib dein Passwort an.';

  @override
  String get commonErrorSameNameAsBefore =>
      'Das ist doch der selbe Name wie vorher 🙈';

  @override
  String get commonErrorTitleMissing => 'Bitte gib einen Titel an!';

  @override
  String get commonErrorTooManyRequests =>
      'Wir haben alle Anfragen von diesem Gerät aufgrund ungewöhnlicher Aktivitäten blockiert. Versuchen Sie es später noch einmal.';

  @override
  String commonErrorUnknown(Object error) {
    return 'Es ist ein unbekannter Fehler ($error) aufgetreten! Bitte kontaktiere den Support.';
  }

  @override
  String get commonErrorUserDisabled =>
      'Dieser Account wurde von einem Administrator deaktiviert';

  @override
  String get commonErrorUserNotFound =>
      'Es wurde kein Nutzer mit dieser E-Mail Adresse gefunden... Inaktive Nutzer werden nach 2 Jahren gelöscht.';

  @override
  String get commonErrorWeakPassword =>
      'Dieses Passwort ist zu schwach. Bitte wähle eine stärkeres Passwort.';

  @override
  String get commonErrorWrongPassword => 'Das eingegebene Passwort ist falsch.';

  @override
  String get commonLoadingPleaseWait => 'Bitte warten...';

  @override
  String get commonStatusFailed => 'Fehlgeschlagen';

  @override
  String get commonStatusNoInternetDescription =>
      'Bitte überprüfen Sie die Internetverbindung.';

  @override
  String get commonStatusNoInternetTitle => 'Fehler: Keine Internetverbindung';

  @override
  String get commonStatusSuccessful => 'Erfolgreich';

  @override
  String get commonStatusUnknownErrorDescription =>
      'Ein unbekannter Fehler ist aufgetreten! 😭';

  @override
  String get commonStatusUnknownErrorTitle => 'Unbekannter Fehler';

  @override
  String get commonTitleNote => 'Hinweis';

  @override
  String get contactSupportButton => 'Support kontaktieren';

  @override
  String get countryAustria => 'Österreich';

  @override
  String get countryGermany => 'Deutschland';

  @override
  String get countrySwitzerland => 'Schweiz';

  @override
  String get dashboardSelectStateButton => 'Bundesland / Kanton auswählen';

  @override
  String get dateWeekTypeA => 'A-Woche';

  @override
  String get dateWeekTypeAlways => 'Immer';

  @override
  String get dateWeekTypeB => 'B-Woche';

  @override
  String get dateWeekdayFriday => 'Freitag';

  @override
  String get dateWeekdayMonday => 'Montag';

  @override
  String get dateWeekdaySaturday => 'Samstag';

  @override
  String get dateWeekdaySunday => 'Sonntag';

  @override
  String get dateWeekdayThursday => 'Donnerstag';

  @override
  String get dateWeekdayTuesday => 'Dienstag';

  @override
  String get dateWeekdayWednesday => 'Mittwoch';

  @override
  String get dateYesterday => 'Gestern';

  @override
  String get feedbackDetailsCommentsTitle => 'Kommentare:';

  @override
  String get feedbackDetailsLoadingHeardFrom => 'Freund';

  @override
  String get feedbackDetailsLoadingMissing => 'Tolle App!';

  @override
  String get feedbackDetailsPageTitle => 'Feedback-Details';

  @override
  String get feedbackDetailsResponseHint => 'Antwort schreiben...';

  @override
  String feedbackDetailsSendError(String error) {
    return 'Fehler beim Senden der Nachricht: $error';
  }

  @override
  String get feedbackNewLineHint => 'Shift + Enter für neue Zeile';

  @override
  String get feedbackSendTooltip => 'Senden (Enter)';

  @override
  String get homeworkSectionDayAfterTomorrow => 'Übermorgen';

  @override
  String get homeworkSectionLater => 'Später';

  @override
  String get homeworkSectionOverdue => 'Überfällig';

  @override
  String get homeworkSectionToday => 'Heute';

  @override
  String get homeworkSectionTomorrow => 'Morgen';

  @override
  String homeworkTodoDateTime(String date, String time) {
    return '$date - $time Uhr';
  }

  @override
  String get imprintTitle => 'Impressum';

  @override
  String get languageDeName => 'Deutsch';

  @override
  String get languageEnName => 'Englisch';

  @override
  String get languageSystemName => 'System';

  @override
  String get languageTitle => 'Sprache';

  @override
  String get launchMarkdownLinkWithWarningActualLink => 'Tatsächliche Adresse';

  @override
  String get launchMarkdownLinkWithWarningCouldNotOpenLink =>
      'Der Link konnte nicht geöffnet werden!';

  @override
  String get launchMarkdownLinkWithWarningDialogTitle => 'Link überprüfen';

  @override
  String get launchMarkdownLinkWithWarningDisplayedText => 'Angezeigter Text';

  @override
  String get launchMarkdownLinkWithWarningDoNotAskAgain =>
      'Beim nächsten Mal nicht mehr nachfragen.';

  @override
  String get launchMarkdownLinkWithWarningLinkTextDoesNotMatch =>
      'Der Link-Text stimmt nicht mit der tatsächlichen Adresse überein.';

  @override
  String get launchMarkdownLinkWithWarningOpenLink => 'Link öffnen';

  @override
  String launchMarkdownLinkWithWarningTrustDomain(String domain) {
    return 'Domain $domain vertrauen';
  }

  @override
  String get legalChangeAppearance => 'Darstellung ändern';

  @override
  String get legalDownloadAsPdf => 'Als PDF herunterladen';

  @override
  String legalMetadataLastUpdated(String date) {
    return 'Zuletzt aktualisiert: $date';
  }

  @override
  String get legalMetadataTitle => 'Metadaten';

  @override
  String legalMetadataVersion(String version) {
    return 'Version: v$version';
  }

  @override
  String get legalMoreOptions => 'Weitere Optionen';

  @override
  String legalPrivacyPolicyEffectiveDate(String date) {
    return 'Diese aktualisierte Datenschutzerklärung tritt am $date in Kraft.';
  }

  @override
  String get legalPrivacyPolicyTitle => 'Datenschutzerklärung';

  @override
  String get legalTableOfContents => 'Inhaltsverzeichnis';

  @override
  String get legalTermsOfServiceTitle => 'Allgemeine Nutzungsbedingungen';

  @override
  String get memberRoleAdmin => 'Admin';

  @override
  String get memberRoleCreator => 'Aktives Mitglied (Schreib- und Leserechte)';

  @override
  String get memberRoleNone => 'Nichts';

  @override
  String get memberRoleOwner => 'Besitzer';

  @override
  String get memberRoleStandard => 'Passives Mitglied (Nur Leserechte)';

  @override
  String get myProfileActivationCodeTile => 'Aktivierungscode eingeben';

  @override
  String get myProfileChangePasswordTile => 'Passwort ändern';

  @override
  String get myProfileChangedPasswordConfirmation =>
      'Das Passwort wurde erfolgreich geändert.';

  @override
  String get myProfileCopyUserIdConfirmation => 'User ID wurde kopiert.';

  @override
  String get myProfileCopyUserIdTile => 'User ID';

  @override
  String get myProfileDeleteAccountButton => 'Konto löschen';

  @override
  String get myProfileDeleteAccountDialogContent =>
      'Möchtest du deinen Account wirklich löschen?';

  @override
  String get myProfileDeleteAccountDialogPasswordTextfieldLabel => 'Passwort';

  @override
  String get myProfileDeleteAccountDialogPleaseEnterYourPassword =>
      'Bitte gib dein Passwort ein, um deinen Account zu löschen.';

  @override
  String get myProfileDeleteAccountDialogTitle =>
      'Sollte dein Account gelöscht werden, werden alle deine Daten gelöscht. Dieser Vorgang lässt sich nicht wieder rückgängig machen.';

  @override
  String get myProfileEmailAccountTypeTitle => 'Account-Typ';

  @override
  String get myProfileEmailNotChangeable =>
      'Dein Account ist mit einem Google-Konto verbunden. Aus diesem Grund kannst du deine E-Mail nicht ändern.';

  @override
  String get myProfileEmailTile => 'E-Mail';

  @override
  String get myProfileNameTile => 'Name';

  @override
  String get myProfileSignInMethodChangeNotPossibleDialogContent =>
      'Die Anmeldemethode kann aktuell nur bei der Registrierung gesetzt werden. Später kann diese nicht mehr geändert werden.';

  @override
  String get myProfileSignInMethodChangeNotPossibleDialogTitle =>
      'Anmeldemethode ändern nicht möglich';

  @override
  String get myProfileSignInMethodTile => 'Anmeldemethode';

  @override
  String get myProfileSignOutButton => 'Abmelden';

  @override
  String get myProfileStateTile => 'Bundesland';

  @override
  String get myProfileSupportTeamDescription =>
      'Durch das Teilen von anonymen Nutzerdaten hilfst du uns, die App noch einfacher und benutzerfreundlicher zu machen.';

  @override
  String get myProfileSupportTeamTile => 'Entwickler unterstützen';

  @override
  String get myProfileTitle => 'Mein Konto';

  @override
  String get navigationExperimentOptionDrawerAndBnb => 'Aktuelle Navigation';

  @override
  String get navigationExperimentOptionExtendableBnb =>
      'Neue Navigation - Ohne Mehr-Button';

  @override
  String get navigationExperimentOptionExtendableBnbWithMoreButton =>
      'Neue Navigation - Mit Mehr-Button';

  @override
  String get registerAccountAgeNoticeText =>
      'Melde dich jetzt an und übertrage deine Daten! Die Anmeldung ist aus datenschutzrechtlichen Gründen erst ab 16 Jahren erlaubt.';

  @override
  String get registerAccountAnonymousInfoTitle =>
      'Du bist nur anonym angemeldet!';

  @override
  String get registerAccountAppleButtonLong => 'Mit Apple anmelden';

  @override
  String get registerAccountAppleButtonShort => 'Apple';

  @override
  String get registerAccountBenefitBackupSubtitle =>
      'Weiterhin Zugriff auf die Daten bei Verlust des Smartphones';

  @override
  String get registerAccountBenefitBackupTitle => 'Automatisches Backup';

  @override
  String get registerAccountBenefitMultiDeviceSubtitle =>
      'Daten werden zwischen mehreren Geräten synchronisiert';

  @override
  String get registerAccountBenefitMultiDeviceTitle =>
      'Nutzung auf mehreren Geräten';

  @override
  String get registerAccountBenefitsIntro =>
      'Übertrage jetzt deinen Account auf ein richtiges Konto, um von folgenden Vorteilen zu profitieren:';

  @override
  String get registerAccountEmailAlreadyUsedContent =>
      'So wie es aussieht, hast du versehentlich einen zweiten Sharezone-Account erstellt. Lösche einfach diesen Account und melde dich mit deinem richtigen Account an.\n\nFür den Fall, dass du nicht genau weißt, wie das funktioniert, haben wir für dich eine Anleitung vorbereitet :)';

  @override
  String get registerAccountEmailAlreadyUsedTitle =>
      'Diese E-Mail wird schon verwendet!';

  @override
  String get registerAccountEmailButtonLong => 'Mit E-Mail anmelden';

  @override
  String get registerAccountEmailButtonShort => 'E-Mail';

  @override
  String get registerAccountEmailLinkConfirmation =>
      'Dein Account wurde mit einem E-Mail-Konto verknüpft.';

  @override
  String get registerAccountGoogleButtonLong => 'Mit Google anmelden';

  @override
  String get registerAccountGoogleButtonShort => 'Google';

  @override
  String get registerAccountShowInstructionAction => 'Anleitung zeigen';

  @override
  String get reportDescriptionHelperText =>
      'Bitte beschreibe uns, warum du diesen Inhalt melden möchtest. Gib uns dabei möglichst viele Informationen, damit wir den Fall schnell und sicher bearbeiten können.';

  @override
  String get reportDescriptionLabel => 'Beschreibung';

  @override
  String get reportDialogContent =>
      'Wir werden den Fall schnellstmöglich bearbeiten!\n\nBitte beachte, dass ein mehrfacher Missbrauch des Report-Systems Konsequenzen für dich haben kann (z.B. Sperrung deines Accounts).';

  @override
  String get reportDialogSendAction => 'Senden';

  @override
  String get reportItemTypeBlackboard => 'Infozettel';

  @override
  String get reportItemTypeComment => 'Kommentar';

  @override
  String get reportItemTypeCourse => 'Kurs';

  @override
  String get reportItemTypeEvent => 'Termin / Prüfung';

  @override
  String get reportItemTypeFile => 'Datei';

  @override
  String get reportItemTypeHomework => 'Hausaufgabe';

  @override
  String get reportItemTypeLesson => 'Stunde';

  @override
  String get reportItemTypeSchoolClass => 'Schulklasse';

  @override
  String get reportItemTypeUser => 'Nutzer';

  @override
  String get reportMissingInformation =>
      'Bitte einen Grund und eine Beschreibung an.';

  @override
  String reportPageTitle(String itemType) {
    return '$itemType melden';
  }

  @override
  String get reportReasonBullying => 'Mobbing';

  @override
  String get reportReasonIllegalContent => 'Rechtswidrige Inhalte';

  @override
  String get reportReasonOther => 'Sonstiges';

  @override
  String get reportReasonPornographicContent => 'Pornografische Inhalte';

  @override
  String get reportReasonSpam => 'Spam';

  @override
  String get reportReasonViolentContent => 'Gewaltsame oder abstoßende Inhalte';

  @override
  String selectStateDialogConfirmationSnackBar(Object region) {
    return 'Region $region ausgewählt';
  }

  @override
  String get selectStateDialogSelectBundesland => 'Bundesland auswählen';

  @override
  String get selectStateDialogSelectCanton => 'Kanton auswählen';

  @override
  String get selectStateDialogSelectCountryTitle => 'Land auswählen';

  @override
  String get selectStateDialogStayAnonymous => 'Ich möchte anonym bleiben';

  @override
  String get sharezonePlusAdvantageAddToCalendarDescription =>
      'Füge mit nur einem Klick einen Termin zu deinem lokalen Kalender hinzu (z.B. Apple oder Google Kalender).\n\nBeachte, dass die Funktion nur auf Android & iOS verfügbar ist. Zudem aktualisiert sich der Termin in deinem Kalender nicht automatisch, wenn dieser in Sharezone geändert wird.';

  @override
  String get sharezonePlusAdvantageAddToCalendarTitle =>
      'Termine zum lokalen Kalender hinzufügen';

  @override
  String get sharezonePlusAdvantageDiscordDescription =>
      'Erhalte den Discord Sharezone Plus Rang auf unserem [Discord-Server](https://sharezone.net/discord). Dieser Rang zeigt, dass du Sharezone Plus hast und gibt dir Zugriff auf einen exklusive Channel nur für Sharezone Plus Nutzer.';

  @override
  String get sharezonePlusAdvantageDiscordTitle =>
      'Discord Sharezone Plus Rang';

  @override
  String get sharezonePlusAdvantageGradesDescription =>
      'Speichere deine Schulnoten mit Sharezone Plus und behalte den Überblick über deine Leistungen. Schriftliche Prüfungen, mündliche Mitarbeit, Halbjahresnoten - alles an einem Ort.';

  @override
  String get sharezonePlusAdvantageGradesTitle => 'Noten';

  @override
  String get sharezonePlusAdvantageHomeworkReminderDescription =>
      'Mit Sharezone Plus kannst du die Erinnerung am Vortag für die Hausaufgaben individuell im 30-Minuten-Tack einstellen, z.B. 15:00 oder 15:30 Uhr. Dieses Feature ist nur für Schüler*innen verfügbar.';

  @override
  String get sharezonePlusAdvantageHomeworkReminderTitle =>
      'Individuelle Uhrzeit für Hausaufgaben-Erinnerungen';

  @override
  String get sharezonePlusAdvantageIcalDescription =>
      'Mit einem iCal-Link kannst du deinen Stundenplan und deine Termine in andere Kalender-Apps (wie z.B. Google Kalender, Apple Kalender) einbinden. Sobald sich dein Stundenplan oder deine Termine ändern, werden diese auch in deinen anderen Kalender Apps aktualisiert.\n\nAnders als beim \"Zum Kalender hinzufügen\" Button, musst du dich nicht darum kümmern, den Termin in deiner Kalender App zu aktualisieren, wenn sich etwas in Sharezone ändert.\n\niCal-Links ist nur für dich sichtbar und können nicht von anderen Personen eingesehen werden.\n\nBitte beachte, dass aktuell nur Termine und Prüfungen exportiert werden können. Die Schulstunden können noch nicht exportiert werden.';

  @override
  String get sharezonePlusAdvantageIcalTitle =>
      'Stundenplan exportieren (iCal)';

  @override
  String get sharezonePlusAdvantageMoreColorsDescription =>
      'Sharezone Plus bietet dir über 200 (statt 19) Farben für deine Gruppen. Setzt du mit Sharezone Plus eine Farbe für deine Gruppe, so können auch deine Gruppenmitglieder diese Farbe sehen.';

  @override
  String get sharezonePlusAdvantageMoreColorsTitle =>
      'Mehr Farben für die Gruppen';

  @override
  String get sharezonePlusAdvantageOpenSourceDescription =>
      'Sharezone ist Open-Source im Frontend. Das bedeutet, dass jeder den Quellcode von Sharezone einsehen und sogar verbessern kann. Wir glauben, dass Open-Source die Zukunft ist und wollen Sharezone zu einem Vorzeigeprojekt machen.\n\nGitHub: [https://github.com/SharezoneApp/sharezone-app](https://sharezone.net/github)';

  @override
  String get sharezonePlusAdvantageOpenSourceTitle =>
      'Unterstützung von Open-Source';

  @override
  String get sharezonePlusAdvantagePastEventsDescription =>
      'Mit Sharezone Plus kannst du alle vergangenen Termine, wie z.B. Prüfungen, einsehen.';

  @override
  String get sharezonePlusAdvantagePastEventsTitle =>
      'Vergangene Termine einsehen';

  @override
  String get sharezonePlusAdvantagePremiumSupportDescription =>
      'Mit Sharezone Plus erhältst du Zugriff auf unseren Premium Support:\n- Innerhalb von wenigen Stunden eine Rückmeldung per E-Mail (anstatt bis zu 2 Wochen)\n- Videocall-Support nach Terminvereinbarung (ermöglicht das Teilen des Bildschirms)';

  @override
  String get sharezonePlusAdvantagePremiumSupportTitle => 'Premium Support';

  @override
  String get sharezonePlusAdvantageQuickDueDateDescription =>
      'Mit Sharezone Plus kannst du das Fälligkeitsdatum einer Hausaufgaben mit nur einem Fingertipp auf den nächsten Schultag oder eine beliebige Stunde in der Zukunft setzen.';

  @override
  String get sharezonePlusAdvantageQuickDueDateTitle =>
      'Schnellauswahl für Fälligkeitsdatum';

  @override
  String get sharezonePlusAdvantageReadByDescription =>
      'Erhalte eine Liste mit allen Gruppenmitgliedern samt Lesestatus für jeden Infozettel - und stelle somit sicher, dass wichtige Informationen bei allen Mitgliedern angekommen sind.';

  @override
  String get sharezonePlusAdvantageReadByTitle =>
      'Gelesen-Status bei Infozetteln';

  @override
  String get sharezonePlusAdvantageRemoveAdsDescription =>
      'Genieße Sharezone komplett werbefrei.\n\nHinweis: Wir testen derzeit die Anzeige von Werbung. Es ist möglich, dass wir in Zukunft die Werbung wieder für alle Nutzer entfernen.';

  @override
  String get sharezonePlusAdvantageRemoveAdsTitle => 'Werbung entfernen';

  @override
  String get sharezonePlusAdvantageStorageDescription =>
      'Mit Sharezone Plus erhältst du 30 GB Speicherplatz (statt 100 MB) für deine Dateien & Anhänge (bei Hausaufgaben & Infozetteln). Dies entspricht ca. 15.000 Fotos (2 MB pro Bild).\n\nDie Begrenzung gilt nicht für Dateien, die als Abgabe bei Hausaufgaben hochgeladen wird.';

  @override
  String get sharezonePlusAdvantageStorageTitle => '30 GB Speicherplatz';

  @override
  String get sharezonePlusAdvantageSubstitutionsDescription =>
      'Schalte mit Sharezone Plus den Vertretungsplan frei:\n* Entfall einer Schulstunden markieren\n* Raumänderungen\n\nSogar Kursmitglieder ohne Sharezone Plus können den Vertretungsplan einsehen (jedoch nicht ändern). Ebenfalls können Kursmitglieder mit nur einem 1-Klick über die Änderung informiert werden. \n\nBeachte, dass der Vertretungsplan manuell eingetragen werden muss und nicht automatisch importiert wird.';

  @override
  String get sharezonePlusAdvantageSubstitutionsTitle => 'Vertretungsplan';

  @override
  String get sharezonePlusAdvantageTeacherTimetableDescription =>
      'Trage den Name der Lehrkraft zur jeweiligen Schulstunde im Stundenplan ein. Für Kursmitglieder ohne Sharezone Plus wird die Lehrkraft ebenfalls angezeigt.';

  @override
  String get sharezonePlusAdvantageTeacherTimetableTitle =>
      'Lehrkraft im Stundenplan';

  @override
  String get sharezonePlusAdvantageTimetableByClassDescription =>
      'Du bist in mehreren Klassen? Mit Sharezone Plus kannst du den Stundenplan für jede Klasse einzeln auswählen. So siehst du immer den richtigen Stundenplan.';

  @override
  String get sharezonePlusAdvantageTimetableByClassTitle =>
      'Stundenplan nach Klasse auswählen';

  @override
  String get sharezonePlusBuyAction => 'Kaufen';

  @override
  String get sharezonePlusBuyingDisabledContent =>
      'Der Kauf von Sharezone Plus ist aktuell deaktiviert. Bitte versuche es später erneut.\n\nAuf unserem [Discord](https://sharezone.net/discord) halten wir dich auf dem Laufenden.';

  @override
  String get sharezonePlusBuyingDisabledTitle => 'Kaufen deaktiviert';

  @override
  String sharezonePlusBuyingFailedContent(String error) {
    return 'Der Kauf von Sharezone Plus ist fehlgeschlagen. Bitte versuche es später erneut.\n\nFehler: $error\n\nBei Fragen wende dich an [plus@sharezone.net](mailto:plus@sharezone.net).';
  }

  @override
  String get sharezonePlusBuyingFailedTitle => 'Kaufen fehlgeschlagen';

  @override
  String get sharezonePlusCancelAction => 'Kündigen';

  @override
  String get sharezonePlusCancelConfirmAction => 'Kündigen';

  @override
  String get sharezonePlusCancelConfirmationContent =>
      'Wenn du dein Sharezone-Plus Abo kündigst, verlierst du den Zugriff auf alle Plus-Funktionen.\n\nBist du sicher, dass du kündigen möchtest?';

  @override
  String get sharezonePlusCancelConfirmationTitle => 'Bist du dir sicher?';

  @override
  String sharezonePlusCancelFailedContent(String error) {
    return 'Es ist ein Fehler aufgetreten. Bitte versuche es später erneut.\n\nFehler: $error';
  }

  @override
  String get sharezonePlusCancelFailedTitle => 'Kündigung fehlgeschlagen';

  @override
  String get sharezonePlusCanceledSubscriptionNote =>
      'Du hast dein Sharezone-Plus Abo gekündigt. Du kannst deine Vorteile noch bis zum Ende des aktuellen Abrechnungszeitraums nutzen. Solltest du es dir anders überlegen, kannst du es jederzeit wieder erneut Sharezone-Plus abonnieren.';

  @override
  String get sharezonePlusFaqContentCreatorContent =>
      'Ja, als Content Creator kannst du Sharezone Plus (Lifetime) kostenlos erhalten.\n\nSo funktioniert es:\n1. Erstelle ein kreatives TikTok, YouTube Short oder Instagram Reel, in dem du Sharezone erwähnst oder vorstellst.\n2. Sorge dafür, dass dein Video mehr als 10.000 Aufrufe erzielt.\n3. Schick uns den Link zu deinem Video an plus@sharezone.net.\n\nDeiner Kreativität sind keine Grenzen gesetzt. Bitte beachte unsere Bedingungen für das Content Creator Programm: https://sharezone.net/content-creator-programm.';

  @override
  String get sharezonePlusFaqContentCreatorTitle =>
      'Gibt es ein Content Creator Programm?';

  @override
  String sharezonePlusFaqEmailSnackBar(String email) {
    return 'E-Mail: $email';
  }

  @override
  String get sharezonePlusFaqFamilyLicenseContent =>
      'Ja, für Familien mit mehreren Kindern bieten wir besondere Konditionen an. Schreib uns einfach eine E-Mail an [plus@sharezone.net](mailto:plus@sharezone.net), um mehr zu erfahren.';

  @override
  String get sharezonePlusFaqFamilyLicenseTitle =>
      'Gibt es spezielle Angebote für Familien?';

  @override
  String get sharezonePlusFaqGroupMembersContent =>
      'Wenn du Sharezone Plus abonnierst, erhält nur dein Account Sharezone Plus. Deine Gruppenmitglieder erhalten Sharezone Plus nicht.\n\nJedoch gibt es einzelne Features, von denen auch deine Gruppenmitglieder profitieren. Solltest du beispielsweise eine die Kursfarbe von einer Gruppe zu einer Farbe ändern, die nur mit Sharezone Plus verfügbar ist, so wird diese Farbe auch für deine Gruppenmitglieder verwendet.';

  @override
  String get sharezonePlusFaqGroupMembersTitle =>
      'Erhalten auch Gruppenmitglieder Sharezone Plus?';

  @override
  String get sharezonePlusFaqOpenSourceContent =>
      'Ja, Sharezone ist Open-Source im Frontend. Du kannst den Quellcode auf GitHub einsehen:';

  @override
  String get sharezonePlusFaqOpenSourceTitle =>
      'Ist der Quellcode von Sharezone öffentlich?';

  @override
  String get sharezonePlusFaqSchoolLicenseContent =>
      'Du bist interessiert an einer Lizenz für deine gesamte Klasse? Schreib uns einfach eine E-Mail an [plus@sharezone.net](mailto:plus@sharezone.net).';

  @override
  String get sharezonePlusFaqSchoolLicenseTitle =>
      'Gibt es spezielle Angebote für Schulklassen?';

  @override
  String get sharezonePlusFaqStorageContent =>
      'Nein, der Speicherplatz von 30 GB mit Sharezone Plus gilt nur für deinen Account und gilt über alle deine Kurse hinweg.\n\nDu könntest beispielsweise 5 GB in den Deutsch-Kurs hochladen, 15 GB in den Mathe-Kurs und hättest noch weitere 10 GB für alle Kurse zur Verfügung.\n\nDeine Gruppenmitglieder erhalten keinen zusätzlichen Speicherplatz.';

  @override
  String get sharezonePlusFaqStorageTitle =>
      'Erhält der gesamte Kurs 30 GB Speicherplatz?';

  @override
  String get sharezonePlusFaqWhoIsBehindContent =>
      'Sharezone wird aktuell von Jonas und Nils entwickelt. Aus unserer persönlichen Frustration über die Organisation des Schulalltags während der Schulzeit entstand die Idee für Sharezone. Es ist unsere Vision, den Schulalltag für alle einfacher und übersichtlicher zu gestalten.';

  @override
  String get sharezonePlusFaqWhoIsBehindTitle => 'Wer steht hinter Sharezone?';

  @override
  String get sharezonePlusFeatureUnavailable =>
      'Dieses Feature ist nur mit \"Sharezone Plus\" verfügbar.';

  @override
  String sharezonePlusLegalTextLifetime(String price) {
    return 'Einmalige Zahlung von $price (kein Abo o. ä.). Durch den Kauf bestätigst du, dass du die [ANBs](https://sharezone.net/terms-of-service) gelesen hast. Wir verarbeiten deine Daten gemäß unserer [Datenschutzerklärung](https://sharezone.net/privacy-policy)';
  }

  @override
  String sharezonePlusLegalTextMonthlyAndroid(String price) {
    return 'Dein Abo ($price/Monat) ist monatlich kündbar. Es wird automatisch verlängert, wenn du es nicht mindestens 24 Stunden vor Ablauf der aktuellen Zahlungsperiode über Google Play kündigst. Durch den Kauf bestätigst du, dass du die [ANBs](https://sharezone.net/terms-of-service) gelesen hast. Wir verarbeiten deine Daten gemäß unserer [Datenschutzerklärung](https://sharezone.net/privacy-policy)';
  }

  @override
  String sharezonePlusLegalTextMonthlyApple(String price) {
    return 'Dein Abo ($price/Monat) ist monatlich kündbar. Es wird automatisch verlängert, wenn du es nicht mindestens 24 Stunden vor Ablauf der aktuellen Zahlungsperiode über den App Store kündigst. Durch den Kauf bestätigst du, dass du die [ANBs](https://sharezone.net/terms-of-service) gelesen hast. Wir verarbeiten deine Daten gemäß unserer [Datenschutzerklärung](https://sharezone.net/privacy-policy)';
  }

  @override
  String sharezonePlusLegalTextMonthlyOther(String price) {
    return 'Dein Abo ($price/Monat) ist monatlich kündbar. Es wird automatisch verlängert, wenn du es nicht vor Ablauf der aktuellen Zahlungsperiode über die App kündigst. Durch den Kauf bestätigst du, dass du die [ANBs](https://sharezone.net/terms-of-service) gelesen hast. Wir verarbeiten deine Daten gemäß unserer [Datenschutzerklärung](https://sharezone.net/privacy-policy)';
  }

  @override
  String get sharezonePlusLetParentsBuyAction => 'Eltern bezahlen lassen';

  @override
  String get sharezonePlusLetParentsBuyContent =>
      'Du kannst deinen Eltern einen Link schicken, damit sie Sharezone-Plus für dich kaufen können.\n\nDer Link ist nur für dich gültig und enthält die Verbindung zu deinem Account.';

  @override
  String get sharezonePlusLetParentsBuyTitle => 'Eltern bezahlen lassen';

  @override
  String get sharezonePlusLinkCopiedToClipboard =>
      'Link in die Zwischenablage kopiert.';

  @override
  String get sharezonePlusLinkTokenLoadFailed =>
      'Der Token für den Link konnte nicht geladen werden.';

  @override
  String get sharezonePlusPurchasePeriodLifetime =>
      'Lebenslang (einmaliger Kauf)';

  @override
  String get sharezonePlusPurchasePeriodMonthly => 'Monatlich';

  @override
  String get sharezonePlusShareLinkAction => 'Link teilen';

  @override
  String get sharezonePlusSubscribeAction => 'Abonnieren';

  @override
  String get sharezonePlusTestFlightContent =>
      'Du hast Sharezone über TestFlight installiert. Apple erlaubt keine In-App-Käufe über TestFlight.\n\nUm Sharezone-Plus zu kaufen, lade bitte die App aus dem App Store herunter. Dort kannst du Sharezone-Plus kaufen.\n\nDanach kannst du die App wieder über TestFlight installieren.';

  @override
  String get sharezonePlusTestFlightTitle => 'TestFlight';

  @override
  String get sharezonePlusUnsubscribeActiveText =>
      'Du hast aktuell das Sharezone-Plus Abo. Solltest du nicht zufrieden sein, würden wir uns über ein [Feedback](#feedback) freuen! Natürlich kannst du dich jederzeit dafür entscheiden, das Abo zu kündigen.';

  @override
  String get sharezonePlusUnsubscribeLifetimeText =>
      'Du hast Sharezone-Plus auf Lebenszeit. Solltest du nicht zufrieden sein, würden wir uns über ein [Feedback](#feedback) freuen!';

  @override
  String get sharezoneWidgetsCenteredErrorMessage =>
      'Es gab leider einen Fehler beim Laden 😖\nVersuche es später einfach nochmal.';

  @override
  String get sharezoneWidgetsCourseTileNoCourseSelected =>
      'Keinen Kurs ausgewählt';

  @override
  String get sharezoneWidgetsCourseTileTitle => 'Kurs';

  @override
  String get sharezoneWidgetsDatePickerSelectDate => 'Datum auswählen';

  @override
  String get sharezoneWidgetsErrorCardContactSupport => 'SUPPORT KONTAKTIEREN';

  @override
  String get sharezoneWidgetsErrorCardRetry => 'ERNEUT VERSUCHEN';

  @override
  String get sharezoneWidgetsErrorCardTitle => 'Es ist ein Fehler aufgetreten!';

  @override
  String get sharezoneWidgetsLeaveFormConfirm => 'JA, VERLASSEN!';

  @override
  String get sharezoneWidgetsLeaveFormPromptFull =>
      'Möchtest du die Eingabe wirklich beenden? Die Daten werden nicht gespeichert!';

  @override
  String get sharezoneWidgetsLeaveFormPromptNot => 'nicht';

  @override
  String get sharezoneWidgetsLeaveFormPromptPrefix =>
      'Möchtest du die Eingabe wirklich beenden? Die Daten werden ';

  @override
  String get sharezoneWidgetsLeaveFormPromptSuffix => ' gespeichert!';

  @override
  String get sharezoneWidgetsLeaveFormStay => 'NEIN!';

  @override
  String get sharezoneWidgetsLeaveFormTitle => 'Eingabe verlassen?';

  @override
  String get sharezoneWidgetsLeaveOrSaveFormPrompt =>
      'Möchtest du die Eingabe verlassen oder speichern? Verlässt du die Eingabe, werden die Daten nicht gespeichert';

  @override
  String get sharezoneWidgetsLeaveOrSaveFormTitle =>
      'Verlassen oder Speichern?';

  @override
  String get sharezoneWidgetsLoadingEncryptedTransfer =>
      'Daten werden verschlüsselt übertragen...';

  @override
  String get sharezoneWidgetsLocationHint => 'Ort/Raum';

  @override
  String get sharezoneWidgetsLogoSemanticsLabel =>
      'Logo von Sharezone: Ein blaues Heft-Icon mit einer Wolke, rechts daneben steht Sharezone.';

  @override
  String get sharezoneWidgetsMarkdownSupportBold => '**fett**';

  @override
  String get sharezoneWidgetsMarkdownSupportItalic => '*kursiv*';

  @override
  String get sharezoneWidgetsMarkdownSupportLabel => 'Markdown: ';

  @override
  String get sharezoneWidgetsMarkdownSupportSeparator => ', ';

  @override
  String sharezoneWidgetsNotAllowedCharactersError(String characters) {
    return 'Folgende Zeichen sind nicht erlaubt: $characters';
  }

  @override
  String get sharezoneWidgetsOverlayCardCloseSemantics => 'Schließe die Karte';

  @override
  String get sharezoneWidgetsSnackbarComingSoon =>
      'Diese Funktion ist bald verfügbar! 😊';

  @override
  String get sharezoneWidgetsSnackbarDataArrivalConfirmed =>
      'Ankunft der Daten bestätigt';

  @override
  String get sharezoneWidgetsSnackbarLoginDataEncrypted =>
      'Anmeldedaten werden verschlüsselt übertragen...';

  @override
  String get sharezoneWidgetsSnackbarPatience =>
      'Geduld! Daten werden noch geladen...';

  @override
  String get sharezoneWidgetsSnackbarSaved =>
      'Änderung wurde erfolgreich gespeichert';

  @override
  String get sharezoneWidgetsSnackbarSendingDataToFrankfurt =>
      'Daten werden nach Frankfurt transportiert...';

  @override
  String get sharezoneWidgetsTextFieldCannotBeEmptyError =>
      'Das Textfeld darf nicht leer sein!';

  @override
  String get socialDiscord => 'Discord';

  @override
  String get socialEmail => 'E-Mail';

  @override
  String get socialGitHub => 'GitHub';

  @override
  String get socialInstagram => 'Instagram';

  @override
  String get socialLinkedIn => 'LinkedIn';

  @override
  String get socialTwitter => 'Twitter';

  @override
  String get stateAargau => 'Aargau';

  @override
  String get stateAnonymous => 'Anonym bleiben';

  @override
  String get stateAppenzellAusserrhoden => 'Appenzell Ausserrhoden';

  @override
  String get stateAppenzellInnerrhoden => 'Appenzell Innerrhoden';

  @override
  String get stateBadenWuerttemberg => 'Baden-Württemberg';

  @override
  String get stateBaselLandschaft => 'Basel-Landschaft';

  @override
  String get stateBaselStadt => 'Basel-Stadt';

  @override
  String get stateBayern => 'Bayern';

  @override
  String get stateBerlin => 'Berlin';

  @override
  String get stateBern => 'Bern';

  @override
  String get stateBrandenburg => 'Brandenburg';

  @override
  String get stateBremen => 'Bremen';

  @override
  String get stateBurgenland => 'Burgenland';

  @override
  String get stateFribourg => 'Freiburg';

  @override
  String get stateGeneva => 'Genf';

  @override
  String get stateGlarus => 'Glarus';

  @override
  String get stateGraubuenden => 'Graubünden';

  @override
  String get stateHamburg => 'Hamburg';

  @override
  String get stateHessen => 'Hessen';

  @override
  String get stateJura => 'Jura';

  @override
  String get stateKaernten => 'Kärnten';

  @override
  String get stateLuzern => 'Luzern';

  @override
  String get stateMecklenburgVorpommern => 'Mecklenburg-Vorpommern';

  @override
  String get stateNeuchatel => 'Neuenburg';

  @override
  String get stateNidwalden => 'Nidwalden';

  @override
  String get stateNiederoesterreich => 'Niederösterreich';

  @override
  String get stateNiedersachsen => 'Niedersachsen';

  @override
  String get stateNordrheinWestfalen => 'Nordrhein-Westfalen';

  @override
  String get stateNotFromGermany => 'Nicht aus Deutschland';

  @override
  String get stateNotSelected => 'Nicht ausgewählt';

  @override
  String get stateOberoesterreich => 'Oberösterreich';

  @override
  String get stateObwalden => 'Obwalden';

  @override
  String get stateRheinlandPfalz => 'Rheinland-Pfalz';

  @override
  String get stateSaarland => 'Saarland';

  @override
  String get stateSachsen => 'Sachsen';

  @override
  String get stateSachsenAnhalt => 'Sachsen-Anhalt';

  @override
  String get stateSalzburg => 'Salzburg';

  @override
  String get stateSchaffhausen => 'Schaffhausen';

  @override
  String get stateSchleswigHolstein => 'Schleswig-Holstein';

  @override
  String get stateSchwyz => 'Schwyz';

  @override
  String get stateSolothurn => 'Solothurn';

  @override
  String get stateStGallen => 'St. Gallen';

  @override
  String get stateSteiermark => 'Steiermark';

  @override
  String get stateThueringen => 'Thüringen';

  @override
  String get stateThurgau => 'Thurgau';

  @override
  String get stateTicino => 'Tessin';

  @override
  String get stateTirol => 'Tirol';

  @override
  String get stateUri => 'Uri';

  @override
  String get stateValais => 'Wallis';

  @override
  String get stateVaud => 'Waadt';

  @override
  String get stateVorarlberg => 'Vorarlberg';

  @override
  String get stateWien => 'Wien';

  @override
  String get stateZug => 'Zug';

  @override
  String get stateZurich => 'Zürich';

  @override
  String get submissionsCreateAddFile => 'Datei hinzufügen';

  @override
  String get submissionsCreateAfterDeadlineContent =>
      'Du kannst jetzt trotzdem noch abgeben, aber die Lehrkraft muss entscheiden wie sie damit umgeht ;)';

  @override
  String get submissionsCreateAfterDeadlineTitle =>
      'Abgabefrist verpasst? Du kannst trotzdem abgeben!';

  @override
  String get submissionsCreateEmptyStateTitle =>
      'Lade jetzt Dateien hoch, die du für die Hausaufgabe abgeben willst!';

  @override
  String submissionsCreateFileInvalidDialogContent(String message) {
    return '$message\nBitte kontaktiere den Support unter support@sharezone.net!';
  }

  @override
  String get submissionsCreateFileInvalidDialogTitle => 'Fehler';

  @override
  String submissionsCreateFileInvalidMultiple(String fileNames) {
    return 'Die gewählten Dateien \"$fileNames\" scheinen invalide zu sein.';
  }

  @override
  String submissionsCreateFileInvalidSingle(String fileName) {
    return 'Die gewählte Datei \"$fileName\" scheint invalide zu sein.';
  }

  @override
  String get submissionsCreateLeaveAction => 'Verlassen';

  @override
  String get submissionsCreateNotSubmittedContent =>
      'Dein Lehrer wird deine Abgabe nicht sehen können, bis du diese abgibst.\n\nDeine bisher hochgeladenen Dateien bleiben trotzdem für dich gespeichert.';

  @override
  String get submissionsCreateNotSubmittedTitle => 'Abgabe nicht abgegeben!';

  @override
  String submissionsCreateRemoveFileContent(String fileName) {
    return 'Möchtest du die Datei \"$fileName\" wirklich entfernen?';
  }

  @override
  String get submissionsCreateRemoveFileTitle => 'Datei entfernen';

  @override
  String get submissionsCreateRemoveFileTooltip => 'Datei entfernen';

  @override
  String get submissionsCreateRenameActionUppercase => 'UMBENENNEN';

  @override
  String get submissionsCreateRenameDialogTitle => 'Datei umbenennen';

  @override
  String get submissionsCreateRenameErrorAlreadyExists =>
      'Dieser Dateiname existiert bereits!';

  @override
  String get submissionsCreateRenameErrorEmpty =>
      'Der Name darf nicht leer sein!';

  @override
  String get submissionsCreateRenameErrorTooLong => 'Der Name ist zu lang!';

  @override
  String get submissionsCreateRenameTooltip => 'Umbenennen';

  @override
  String get submissionsCreateSubmitAction => 'Abgeben';

  @override
  String get submissionsCreateSubmitDialogContent =>
      'Nach der Abgabe kannst du keine Datei mehr löschen. Du kannst aber noch neue Dateien hinzufügen und alte Dateien umbenennen.';

  @override
  String get submissionsCreateSubmitDialogTitle => 'Wirklich Abgeben?';

  @override
  String get submissionsCreateSubmittedTitle => 'Abgabe erfolgreich abgegeben!';

  @override
  String get submissionsCreateUploadInProgressContent =>
      'Wenn du den Dialog verlässt wird der Hochladevorgang für noch nicht hochgeladene Dateien abgebrochen.';

  @override
  String get submissionsCreateUploadInProgressTitle => 'Dateien am hochladen!';

  @override
  String get submissionsListAfterDeadlineSection => 'Zu spät abgegeben 🕐';

  @override
  String get submissionsListEditedSuffix => ' (nachträglich bearbeitet)';

  @override
  String get submissionsListMissingSection => 'Nicht abgegeben 😭';

  @override
  String get submissionsListNoMembersPlaceholder =>
      'Vergessen Teilnehmer in den Kurs einzuladen?';

  @override
  String get submissionsListTitle => 'Abgaben';

  @override
  String get themeDarkMode => 'Dunkler Modus';

  @override
  String get themeLightDarkModeSectionTitle => 'Heller & Dunkler Modus';

  @override
  String get themeLightMode => 'Heller Modus';

  @override
  String themeNavigationExperimentOptionTile(String name, int number) {
    return 'Option $number: $name';
  }

  @override
  String get themeNavigationExperimentSectionContent =>
      'Wir testen aktuell eine neue Navigation. Bitte gib über die Feedback-Box oder unseren Discord-Server eine kurze Rückmeldung, wie du die jeweiligen Optionen findest.';

  @override
  String get themeNavigationExperimentSectionTitle =>
      'Experiment: Neue Navigation';

  @override
  String get themeRateOurAppCardContent =>
      'Falls dir Sharezone gefällt, würden wir uns über eine Bewertung sehr freuen! 🙏  Dir gefällt etwas nicht? Kontaktiere einfach den Support 👍';

  @override
  String get themeRateOurAppCardRateButton => 'Bewerten';

  @override
  String get themeRateOurAppCardRatingsNotAvailableOnWebDialogContent =>
      'Über die Web-App kann die App nicht bewertet werden. Nimm dafür einfach dein Handy 👍';

  @override
  String get themeRateOurAppCardRatingsNotAvailableOnWebDialogTitle =>
      'App-Bewertung nur über iOS & Android möglich!';

  @override
  String get themeRateOurAppCardTitle => 'Gefällt dir Sharezone?';

  @override
  String get themeSystemMode => 'System';

  @override
  String get themeTitle => 'Erscheinungsbild';

  @override
  String timetableDeleteAllDialogDeleteCountdown(int seconds) {
    return 'Löschen ($seconds)';
  }

  @override
  String get timetableDeleteAllSuggestionAction => 'Stundenplan löschen';

  @override
  String get timetableDeleteAllSuggestionBody =>
      'Möchtest du deinen gesamten Stundenplan löschen? Klicke hier, um die Funktion zu nutzen.';

  @override
  String get timetableDeleteAllSuggestionTitle =>
      'Gesamten Stundenplan löschen?';

  @override
  String get timetableErrorEndTimeBeforeNextLessonStart =>
      'Die Endzeit ist vor der Startzeit der nächsten Stunde!';

  @override
  String get timetableErrorEndTimeBeforePreviousLessonEnd =>
      'Die Endzeit ist vor der Endzeit der vorherigen Stunde!';

  @override
  String get timetableErrorEndTimeBeforeStartTime =>
      'Die Endzeit der Stunde ist vor der Startzeit!';

  @override
  String get timetableErrorEndTimeMissing => 'Bitte gibt eine Endzeit an!';

  @override
  String get timetableErrorInvalidPeriodsOverlap =>
      'Bitte gib korrekte Zeiten. Die Stunden dürfen sich nicht überschneiden!';

  @override
  String get timetableErrorStartTimeBeforeNextLessonStart =>
      'Die Startzeit ist vor der Startzeit der nächsten Stunde!';

  @override
  String get timetableErrorStartTimeBeforePreviousLessonEnd =>
      'Die Startzeit ist vor der Endzeit der vorherigen Stunde!';

  @override
  String get timetableErrorStartTimeEqualsEndTime =>
      'Die Startzeit und die Endzeit darf nicht gleich sein!';

  @override
  String get timetableErrorStartTimeMissing => 'Bitte gibt eine Startzeit an!';

  @override
  String get timetableErrorWeekdayMissing => 'Bitte gib einen Wochentag an!';

  @override
  String get timetableSettingsABWeekTileTitle => 'A/B Wochen';

  @override
  String get timetableSettingsAWeeksAreEvenSwitch =>
      'A-Wochen sind gerade Kalenderwochen';

  @override
  String get timetableSettingsDeleteAllLessonsConfirmation =>
      'Stunden wurden gelöscht.';

  @override
  String timetableSettingsDeleteAllLessonsDialogBody(int count) {
    return 'Damit werden $count Stunden aus Gruppen gelöscht, für die du Schreibrechte hast. Diese Stunden werden auch für deine Gruppenmitglieder gelöscht. Das kann nicht rückgängig gemacht werden.';
  }

  @override
  String get timetableSettingsDeleteAllLessonsDialogTitle =>
      'Alle Stunden löschen?';

  @override
  String get timetableSettingsDeleteAllLessonsSubtitleNoAccess =>
      'Keine Stunden mit Schreibrechten.';

  @override
  String get timetableSettingsEnabledWeekDaysTileTitle =>
      'Aktivierte Wochentage';

  @override
  String get timetableSettingsIcalLinksPlusDialogContent =>
      'Mit einem iCal-Link kannst du deinen Stundenplan und deine Termine in andere Kalender-Apps (wie z.B. Google Kalender, Apple Kalender) einbinden. Sobald sich dein Stundenplan oder deine Termine ändern, werden diese auch in deinen anderen Kalender Apps aktualisiert.\n\nAnders als beim \"Zum Kalender hinzufügen\" Button, musst du dich nicht darum kümmern, den Termin in deiner Kalender App zu aktualisieren, wenn sich etwas in Sharezone ändert.\n\niCal-Links ist nur für dich sichtbar und können nicht von anderen Personen eingesehen werden.\n\nBitte beachte, dass aktuell nur Termine und Prüfungen exportiert werden können. Die Schulstunden können noch nicht exportiert werden.';

  @override
  String get timetableSettingsIcalLinksTitleSubtitle =>
      'Synchronisierung mit Google Kalender, Apple Kalender usw.';

  @override
  String get timetableSettingsIcalLinksTitleTitle =>
      'Termine, Prüfungen, Stundenplan exportieren (iCal)';

  @override
  String get timetableSettingsIsFiveMinutesIntervalActiveTileTitle =>
      'Fünf-Minuten-Intervall beim Time-Picker';

  @override
  String get timetableSettingsLessonLengthEditDialog =>
      'Wähle die Länge der Stunde in Minuten aus.';

  @override
  String get timetableSettingsLessonLengthSavedConfirmation =>
      'Länge einer Stunde wurde gespeichert.';

  @override
  String get timetableSettingsLessonLengthTileSubtitle => 'Länge einer Stunde';

  @override
  String get timetableSettingsLessonLengthTileTitle => 'Länge einer Stunde';

  @override
  String timetableSettingsLessonLengthTileTrailing(int length) {
    return '$length Min.';
  }

  @override
  String get timetableSettingsOpenUpcomingWeekOnNonSchoolDaysSubtitle =>
      'Wenn in dieser Woche keine aktivierten Wochentage mehr übrig sind, öffnet der Stundenplan die kommende Woche.';

  @override
  String get timetableSettingsOpenUpcomingWeekOnNonSchoolDaysTitle =>
      'Kommende Woche an schulfreien Tagen öffnen';

  @override
  String get timetableSettingsPeriodsFieldTileSubtitle =>
      'Stundenplanbeginn, Stundenlänge, etc.';

  @override
  String get timetableSettingsPeriodsFieldTileTitle => 'Stundenzeiten';

  @override
  String get timetableSettingsShowLessonsAbbreviation =>
      'Kürzel im Stundenplan anzeigen';

  @override
  String timetableSettingsThisWeekIs(
    int calendar_week,
    String even_or_odd_week,
    String is_a_week_even,
  ) {
    return 'Diese Woche ist Kalenderwoche $calendar_week. A-Wochen sind $is_a_week_even Kalenderwochen und somit ist aktuell eine $even_or_odd_week';
  }

  @override
  String get timetableSettingsTitle => 'Stundenplan';

  @override
  String get typeOfUserParent => 'Elternteil';

  @override
  String get typeOfUserStudent => 'Schüler*in';

  @override
  String get typeOfUserTeacher => 'Lehrkraft';

  @override
  String get typeOfUserUnknown => 'Unbekannt';

  @override
  String get useAccountInstructionsAppBarTitle => 'Anleitung';

  @override
  String get useAccountInstructionsHeadline =>
      'Wie nutze ich Sharezone auf mehreren Geräten?';

  @override
  String get useAccountInstructionsStep =>
      '1. Gehe zurück zu deinem Profil\n2. Melde dich über das Sign-Out-Icon rechts oben ab.\n3. Bestätige, dass dabei dein Konto gelöscht wird.\n4. Klicke unten auf den Button \"Du hast schon ein Konto? Dann...\"\n5. Melde dich an.';

  @override
  String get useAccountInstructionsStepsTitle => 'Schritte:';

  @override
  String get useAccountInstructionsVideoTitle => 'Video:';

  @override
  String get userEditLoadingUserSnackbar =>
      'Informationen werden geladen! Warte kurz.';

  @override
  String get userEditNameChangedConfirmation =>
      'Dein Name wurde erfolgreich umbenannt.';

  @override
  String get userEditPageTitle => 'Name bearbeiten';

  @override
  String get userEditSubmitFailed =>
      'Der Vorgang konnte nicht korrekt abgeschlossen werden. Bitte kontaktiere den Support!';

  @override
  String get userEditSubmittingSnackbar =>
      'Daten werden nach Frankfurt transportiert...';

  @override
  String websiteAllInOneFeatureImageLabel(String feature) {
    return 'Ein Bild der Funktion $feature';
  }

  @override
  String get websiteAllInOneHeadline => 'Alles an einem Ort';

  @override
  String get websiteAllPlatformsHeadline => 'Auf allen Geräten verfügbar.';

  @override
  String get websiteAllPlatformsSubline =>
      'Sharezone funktioniert auf allen Systemen. Somit kannst Du jederzeit auf deine Daten zugreifen.';

  @override
  String get websiteAppTitle => 'Sharezone - Vernetzter Schulplaner';

  @override
  String get websiteDataProtectionAesTitle =>
      'AES 256-Bit serverseitige Verschlüsselung';

  @override
  String get websiteDataProtectionHeadline => 'Sicher & DSGVO-konform';

  @override
  String get websiteDataProtectionIsoTitle =>
      'ISO27001, ISO27012 & ISO27018 zertifiziert*';

  @override
  String get websiteDataProtectionServerLocationSubtitle =>
      'Mit Ausnahme des Authentifizierungsserver\n(EU-Standardvertragsklauseln)';

  @override
  String get websiteDataProtectionServerLocationTitle =>
      'Standort der Server: Frankfurt (Deutschland)';

  @override
  String get websiteDataProtectionSocSubtitle =>
      '* Zertifizierung von unserem Hosting-Anbieter';

  @override
  String get websiteDataProtectionSocTitle =>
      'SOC1, SOC2, & SOC3 zertifiziert*';

  @override
  String get websiteDataProtectionTlsTitle =>
      'TLS-Verschlüsselung bei der Übertragung';

  @override
  String get websiteFeatureAlwaysAvailableBulletpointMultiDevice =>
      'Mit mehreren Geräten nutzbar';

  @override
  String get websiteFeatureAlwaysAvailableBulletpointOffline =>
      'Offline Inhalte eintragen';

  @override
  String get websiteFeatureAlwaysAvailableTitle => 'Immer verfügbar';

  @override
  String get websiteFeatureEventsBulletpointAtAGlance =>
      'Prüfungen und Termine auf einen Blick';

  @override
  String get websiteFeatureEventsTitle => 'Termine';

  @override
  String get websiteFeatureFileStorageBulletpointShareMaterials =>
      'Arbeitsmaterialien teilen';

  @override
  String get websiteFeatureFileStorageBulletpointUnlimitedStorage =>
      'Optional: Unbegrenzter \nSpeicherplatz';

  @override
  String get websiteFeatureFileStorageTitle => 'Dateiablage';

  @override
  String get websiteFeatureGradesBulletpointMultipleSystems =>
      'Verschiedene Notensysteme';

  @override
  String get websiteFeatureGradesBulletpointSaveGrades =>
      'Speichere deine Noten in Sharezone';

  @override
  String get websiteFeatureGradesTitle => 'Notensystem';

  @override
  String get websiteFeatureNoticesBulletpointComments =>
      'Mit Kommentarfunktion';

  @override
  String get websiteFeatureNoticesBulletpointNotifications =>
      'Mit Notifications';

  @override
  String get websiteFeatureNoticesBulletpointReadReceipt =>
      'Mit Lesebestätigung';

  @override
  String get websiteFeatureNoticesTitle => 'Infozettel';

  @override
  String get websiteFeatureNotificationsBulletpointAlwaysInformed =>
      'Immer informiert';

  @override
  String get websiteFeatureNotificationsBulletpointCustomizable =>
      'Individuell einstellbar';

  @override
  String get websiteFeatureNotificationsBulletpointQuietHours =>
      'Mit Ruhemodus';

  @override
  String get websiteFeatureNotificationsTitle => 'Notifications';

  @override
  String get websiteFeatureOverviewTitle => 'Übersicht';

  @override
  String get websiteFeatureTasksBulletpointComments => 'Mit Kommentarfunktion';

  @override
  String get websiteFeatureTasksBulletpointReminder =>
      'Mit Erinnerungsfunktion';

  @override
  String get websiteFeatureTasksBulletpointSubmissions => 'Mit Abgabefunktion';

  @override
  String get websiteFeatureTasksTitle => 'Aufgaben';

  @override
  String get websiteFeatureTimetableBulletpointAbWeeks => 'Mit A/B Wochen';

  @override
  String get websiteFeatureTimetableBulletpointWeekdays =>
      'Wochentage individuell einstellbar';

  @override
  String get websiteFeatureTimetableTitle => 'Stundenplan';

  @override
  String get websiteFooterCommunityDiscord => 'Discord';

  @override
  String get websiteFooterCommunitySubtitle =>
      'Werde jetzt ein Teil unserer Community und bringe deine eigenen Ideen bei Sharezone ein.';

  @override
  String get websiteFooterCommunityTicketSystem => 'Ticketsystem';

  @override
  String get websiteFooterCommunityTitle => 'Sharezone-Community';

  @override
  String get websiteFooterDownloadAndroid => 'Android';

  @override
  String get websiteFooterDownloadIos => 'iOS';

  @override
  String get websiteFooterDownloadMacos => 'macOS';

  @override
  String get websiteFooterDownloadTitle => 'Downloads';

  @override
  String get websiteFooterHelpSupport => 'Support';

  @override
  String get websiteFooterHelpTitle => 'Hilfe';

  @override
  String get websiteFooterHelpVideos => 'Erklärvideos';

  @override
  String get websiteFooterLegalImprint => 'Impressum';

  @override
  String get websiteFooterLegalPrivacy => 'Datenschutzerklärung';

  @override
  String get websiteFooterLegalTerms => 'Allgemeine Nutzungsbedingungen (ANB)';

  @override
  String get websiteFooterLegalTitle => 'Rechtliches';

  @override
  String get websiteFooterLinksDocs => 'Dokumentation';

  @override
  String get websiteFooterLinksTitle => 'Links';

  @override
  String get websiteLanguageSelectorTooltip => 'Sprache auswählen';

  @override
  String get websiteLaunchUrlFailed => 'Link konnte nicht geöffnet werden!';

  @override
  String get websiteNavDocs => 'Docs';

  @override
  String get websiteNavHome => 'Hauptseite';

  @override
  String get websiteNavPlus => 'Plus';

  @override
  String get websiteNavSupport => 'Support';

  @override
  String get websiteNavWebApp => 'Web-App';

  @override
  String get websiteSharezonePlusAdvantagesTitle =>
      'Vorteile von Sharezone Plus';

  @override
  String get websiteSharezonePlusCustomerPortalContent =>
      'Um dich zu authentifizieren, nutze bitte die E-Mail-Adresse, die du bei der Bestellung verwendet hast.';

  @override
  String get websiteSharezonePlusCustomerPortalOpen => 'Zum Kundenportal';

  @override
  String get websiteSharezonePlusCustomerPortalTitle => 'Kundenportal';

  @override
  String websiteSharezonePlusLoadError(String error) {
    return 'Error: $error';
  }

  @override
  String get websiteSharezonePlusLoadingName => 'Lädt...';

  @override
  String get websiteSharezonePlusManageSubscriptionText =>
      'Du hast bereits ein Abo? Klicke [hier](https://billing.stripe.com/p/login/eVa7uh3DvbMfbTy144) um es zu verwalten (z.B. Kündigen, Zahlungsmethode ändern, etc.).';

  @override
  String get websiteSharezonePlusPurchaseDialogContent =>
      'Um Sharezone Plus für deinen eigenen Account zu erwerben, musst du Sharezone Plus über die Web-App kaufen.\n\nFalls du Sharezone Plus als Elternteil für dein Kind kaufen möchtest, musst du den Link öffnen, den du von deinem Kind erhalten hast.\n\nSolltest du Fragen haben, kannst du uns gerne eine E-Mail an [plus@sharezone.net](mailto:plus@sharezone.net) schreiben.';

  @override
  String get websiteSharezonePlusPurchaseDialogTitle => 'Sharezone Plus kaufen';

  @override
  String get websiteSharezonePlusPurchaseDialogToWebApp => 'Zur Web-App';

  @override
  String get websiteSharezonePlusPurchaseForTitle =>
      'Sharezone Plus kaufen für';

  @override
  String get websiteSharezonePlusSuccessMessage =>
      'Du hast Sharezone Plus erfolgreich für dein Kind erworben.\nVielen Dank für deine Unterstützung!';

  @override
  String get websiteSharezonePlusSuccessSupport =>
      'Solltest du Fragen haben, kannst du dich jederzeit an unseren [Support](/support) wenden.';

  @override
  String get websiteStoreAppStoreName => 'AppStore';

  @override
  String get websiteStorePlayStoreName => 'PlayStore';

  @override
  String websiteSupportEmailCopy(String email) {
    return 'E-Mail: $email';
  }

  @override
  String get websiteSupportEmailLabel => 'E-Mail';

  @override
  String get websiteSupportEmailSubject => 'Ich brauche eure Hilfe! 😭';

  @override
  String get websiteSupportPageBody =>
      'Kontaktiere uns einfach über einen Kanal deiner Wahl und wir werden dir schnellstmöglich weiterhelfen 😉\n\nBitte beachte, dass es manchmal länger dauern kann, bis wir antworten (1-2 Wochen).';

  @override
  String get websiteSupportPageHeadline => 'Du brauchst Hilfe?';

  @override
  String get websiteSupportSectionButton => 'Support kontaktieren';

  @override
  String get websiteSupportSectionHeadline => 'Nie im Stich gelassen.';

  @override
  String get websiteSupportSectionSubline =>
      'Unser Support ist für Dich jederzeit erreichbar. Egal welche Uhrzeit. Egal welcher Wochentag.';

  @override
  String get websiteUserCounterLabel => 'registrierte Nutzer';

  @override
  String get websiteUserCounterSemanticLabel => 'user counter';

  @override
  String get websiteUspCommunityButton => 'Zur Sharezone-Community';

  @override
  String get websiteUspHeadline => 'Wirklich hilfreich.';

  @override
  String get websiteUspSublineDetails =>
      'Wir wissen, was für Lösungen nötig sind und was wirklich hilft, um den Schulalltag einfach zu machen.\nWo wir es nicht wissen, versuchen wir, mit agiler Arbeit und der Sharezone-Community die beste Lösung zu finden.';

  @override
  String get websiteUspSublineIntro =>
      'Sharezone ist aus den realen Problemen des Unterrichts entstanden.';

  @override
  String get websiteWelcomeDescription =>
      'Sharezone ist ein vernetzter Schulplaner, um sich gemeinsam zu organisieren. Eingetragene Inhalte, wie z.B. Hausaufgaben, werden blitzschnell mit allen anderen geteilt. So bleiben viele Nerven und viel Zeit erspart.';

  @override
  String get websiteWelcomeDescriptionSemanticLabel =>
      'Beschreibung der Sharezone App';

  @override
  String get websiteWelcomeHeadline => 'Simpel. Sicher. Stabil.';

  @override
  String get websiteWelcomeHeadlineSemanticLabel =>
      'Überschrift der Sharezone App';

  @override
  String get writePermissionEveryone => 'Alle';

  @override
  String get writePermissionOnlyAdmins => 'Nur Admins';
}
