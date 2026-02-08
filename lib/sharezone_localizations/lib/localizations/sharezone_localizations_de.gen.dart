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
  String get activationCodeErrorInvalidDescription =>
      'Entweder wurde dieser Code schon aufgebracht oder er ist außerhalb des Gültigkeitszeitraumes.';

  @override
  String get activationCodeErrorInvalidTitle =>
      'Ein Fehler ist aufgetreten: Dieser Code ist nicht gültig 🤨';

  @override
  String get activationCodeErrorNoInternetDescription =>
      'Wir konnten nicht versuchen, den Code einzulösen, da wir keine Internetverbindung herstellen konnten. Bitte überprüfe dein WLAN bzw. deine Mobilfunkdaten.';

  @override
  String get activationCodeErrorNoInternetTitle =>
      'Ein Fehler ist aufgetreten: Keine Internetverbindung ☠️';

  @override
  String get activationCodeErrorNotFoundDescription =>
      'Wir konnten den eingegebenen Aktivierungscode nicht finden. Bitte überprüfe die Groß- und Kleinschreibung und ob dieser Aktivierungscode noch gültig ist.';

  @override
  String get activationCodeErrorNotFoundTitle =>
      'Ein Fehler ist aufgetreten: Aktivierungscode nicht gefunden ❌';

  @override
  String get activationCodeErrorUnknownDescription =>
      'Dies könnte eventuell an deiner Internetverbindung liegen. Bitte überprüfe diese!';

  @override
  String get activationCodeErrorUnknownTitle =>
      'Ein unbekannter Fehler ist aufgetreten 😭';

  @override
  String get activationCodeFeatureAdsLabel => 'Ads';

  @override
  String get activationCodeFeatureL10nLabel => 'l10n';

  @override
  String get activationCodeFieldHint => 'z.B. NavigationV2';

  @override
  String get activationCodeFieldLabel => 'Aktivierungscode';

  @override
  String get activationCodeResultDoneAction => 'Fertig';

  @override
  String activationCodeSuccessTitle(Object value) {
    return 'Erfolgreich aktiviert: $value 🎉';
  }

  @override
  String get activationCodeToggleDisabled => 'deaktiviert';

  @override
  String get activationCodeToggleEnabled => 'aktiviert';

  @override
  String activationCodeToggleResult(String feature, String state) {
    return '$feature wurde $state. Starte die App neu, um die Änderungen zu sehen.';
  }

  @override
  String get adInfoDialogBodyPrefix =>
      'Innerhalb der nächsten Wochen führen wir ein Experiment mit Werbung in Sharezone durch. Wenn du keine Werbung sehen möchten, kannst du ';

  @override
  String get adInfoDialogBodySuffix => ' erwerben.';

  @override
  String get adInfoDialogTitle => 'Werbung in Sharezone';

  @override
  String get adsLoading => 'Anzeige lädt...';

  @override
  String get appName => 'Sharezone';

  @override
  String get attachFileCameraPermissionError =>
      'Die App hat leider keinen Zugang zur Kamera...';

  @override
  String get attachFileDocumentTitle => 'Dokument';

  @override
  String authAnonymousDisplayName(Object animalName) {
    return 'Anonymer $animalName';
  }

  @override
  String get authEmailAndPasswordLinkFillFormComplete =>
      'Füll das Formular komplett aus! 😉';

  @override
  String get authEmailAndPasswordLinkNicknameHint =>
      'Dieser Nickname ist nur für deine Gruppenmitglieder sichtbar und sollte ein Pseudonym sein.';

  @override
  String get authEmailAndPasswordLinkNicknameLabel => 'Nickname';

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
  String get blackboardCardAttachmentTooltip => 'Enthält Anhänge';

  @override
  String get blackboardCardMyEntryTooltip => 'Mein Eintrag';

  @override
  String get blackboardComposeMessageHint => 'Nachricht verfassen';

  @override
  String get blackboardCustomImageUnavailableMessage =>
      'Bisher können keine eigenen Bilder aufgenommen/hochgeladen werden 😔\n\nDiese Funktion wird sehr bald verfügbar sein!';

  @override
  String get blackboardDeleteAttachmentsDialogDescription =>
      'Sollen die Anhänge des Eintrags aus der Dateiablage gelöscht oder die Verknüpfung zwischen beiden aufgehoben werden?';

  @override
  String get blackboardDeleteDialogDescription =>
      'Möchtest du wirklich diesen Eintrag für den kompletten Kurs löschen?';

  @override
  String get blackboardDeleteDialogTitle => 'Eintrag löschen?';

  @override
  String blackboardDetailsAttachmentsCount(Object value) {
    return 'Anhänge: $value';
  }

  @override
  String get blackboardDetailsTitle => 'Details';

  @override
  String get blackboardDialogSaveTooltip => 'Eintrag speichern';

  @override
  String get blackboardDialogTitleHint => 'Titel eingeben';

  @override
  String get blackboardEntryDeleted => 'Eintrag wurde gelöscht.';

  @override
  String get blackboardErrorCourseMissing => 'Bitte gib einen Kurs an!';

  @override
  String get blackboardErrorTitleMissing =>
      'Bitte gib einen Titel für den Eintrag an!';

  @override
  String get blackboardMarkAsRead => 'Als gelesen markieren';

  @override
  String get blackboardMarkAsUnread => 'Als ungelesen markieren';

  @override
  String get blackboardPageAddInfoSheet => 'Infozettel hinzufügen';

  @override
  String get blackboardPageEmptyDescription =>
      'Hier können wichtige Ankündigungen in Form eines digitalen Zettels an Schüler, Lehrkräfte und Eltern ausgeteilt werden. Ideal für beispielsweise den Elternsprechtag, den Wandertag, das Sportfest, usw.';

  @override
  String get blackboardPageEmptyTitle => 'Du hast alle Infozettel gelesen 👍';

  @override
  String get blackboardPageFabTooltip => 'Neuen Infozettel';

  @override
  String get blackboardReadByUsersPlusDescription =>
      'Erwerbe Sharezone Plus, um nachzuvollziehen, wer den Infozettel bereits gelesen hat.';

  @override
  String get blackboardReadByUsersTitle => 'Gelesen von';

  @override
  String get blackboardRemoveAttachment => 'Anhang entfernen';

  @override
  String get blackboardSelectCoverImage => 'Titelbild auswählen';

  @override
  String get blackboardSendNotificationDescription =>
      'Sende eine Benachrichtigung an deine Kursmitglieder, dass du einen neuen Eintrag erstellt hast.';

  @override
  String get bnbTutorialDescription =>
      'Ziehe die untere Navigationsleiste nach oben, um auf weitere Funktionen zuzugreifen.';

  @override
  String get calendricalEventsAddEvent => 'Termin eintragen';

  @override
  String get calendricalEventsAddExam => 'Prüfung eintragen';

  @override
  String get calendricalEventsCreateEventTooltip => 'Neuen Termin erstellen';

  @override
  String get calendricalEventsCreateExamTooltip => 'Neue Prüfung erstellen';

  @override
  String get calendricalEventsCreateNew => 'Neu erstellen';

  @override
  String get calendricalEventsEmptyTitle =>
      'Es stehen keine Termine und Prüfungen in der Zukunft an.';

  @override
  String get calendricalEventsFabTooltip => 'Neue Prüfung oder Termin';

  @override
  String get calendricalEventsSwitchToGrid => 'Auf Kacheln umschalten';

  @override
  String get calendricalEventsSwitchToList => 'Auf Liste umschalten';

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
  String get changeEmailReauthenticationDialogBody =>
      'Nach der Änderung der E-Mail-Adresse musst du abgemeldet und wieder angemeldet werden. Danach kannst du die App wie gewohnt weiter nutzen.\n\nKlicke auf \"Weiter\" um eine Abmeldung und eine Anmeldung von Sharezone durchzuführen.\n\nEs kann sein, dass die Anmeldung nicht funktioniert (z.B. weil die E-Mail-Adresse noch nicht bestätigt wurde). Führe in diesem Fall die Anmeldung selbständig durch.';

  @override
  String get changeEmailReauthenticationDialogTitle => 'Re-Authentifizierung';

  @override
  String get changeEmailVerifyDialogAfterWord => 'Nachdem';

  @override
  String get changeEmailVerifyDialogBodyPrefix =>
      'Wir haben dir einen Link geschickt. Bitte klicke jetzt auf den Link, um deine E-Mail zu bestätigen. Prüfe auch deinen Spam-Ordner.\n\n';

  @override
  String get changeEmailVerifyDialogBodySuffix =>
      ' du die neue E-Mail-Adresse bestätigt hast, klicke auf \"Weiter\".';

  @override
  String get changeEmailVerifyDialogTitle => 'Neue E-Mail Adresse bestätigen';

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
  String get changelogPageTitle => 'Was ist neu?';

  @override
  String get changelogSectionBugFixes => 'Fehlerbehebungen:';

  @override
  String get changelogSectionImprovements => 'Verbesserungen:';

  @override
  String get changelogSectionNewFeatures => 'Neue Funktionen:';

  @override
  String changelogUpdatePromptStore(String store) {
    return 'Wir haben bemerkt, dass du eine veraltete Version der App installiert hast. Lade dir deswegen jetzt die Version im $store herunter! 👍';
  }

  @override
  String get changelogUpdatePromptTitle => 'Neues Update verfügbar!';

  @override
  String get changelogUpdatePromptWeb =>
      'Wir haben bemerkt, dass du eine veraltete Version der App verwendest. Lade die Seite neu, um die neuste Version zu erhalten! 👍';

  @override
  String get commentActionsCopyText => 'Text kopieren';

  @override
  String get commentActionsReport => 'Kommentar melden';

  @override
  String get commentDeletedConfirmation => 'Kommentar wurde gelöscht.';

  @override
  String commentsSectionTitle(Object value) {
    return 'Kommentare: $value';
  }

  @override
  String get commonActionBack => 'Zurück';

  @override
  String get commonActionChange => 'Ändern';

  @override
  String get commonActionRename => 'Umbenennen';

  @override
  String get commonActionsAdd => 'Hinzufügen';

  @override
  String get commonActionsAlright => 'Alles klar';

  @override
  String get commonActionsBack => 'Zurück';

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
  String get commonActionsCreate => 'Erstellen';

  @override
  String get commonActionsCreateUppercase => 'ERSTELLEN';

  @override
  String get commonActionsDelete => 'Löschen';

  @override
  String get commonActionsDeleteUppercase => 'LÖSCHEN';

  @override
  String get commonActionsDone => 'Fertig';

  @override
  String get commonActionsEdit => 'Bearbeiten';

  @override
  String get commonActionsHelp => 'Hilfe';

  @override
  String get commonActionsJoin => 'Beitreten';

  @override
  String get commonActionsLeave => 'Verlassen';

  @override
  String get commonActionsNo => 'Nein';

  @override
  String get commonActionsNotNow => 'Nicht jetzt';

  @override
  String get commonActionsOk => 'Ok';

  @override
  String get commonActionsReport => 'Melden';

  @override
  String get commonActionsSave => 'Speichern';

  @override
  String get commonActionsSend => 'Senden';

  @override
  String get commonActionsShare => 'Teilen';

  @override
  String get commonActionsSignOut => 'Abmelden';

  @override
  String get commonActionsSignOutUppercase => 'ABMELDEN';

  @override
  String get commonActionsSkip => 'Überspringen';

  @override
  String get commonActionsYes => 'Ja';

  @override
  String get commonDate => 'Datum';

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
  String get commonErrorGeneric => 'Es ist ein Fehler aufgetreten.';

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
  String get commonErrorTitle => 'Fehler';

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
  String get commonFieldName => 'Name';

  @override
  String get commonLoadingPleaseWait => 'Bitte warten...';

  @override
  String get commonPleaseWaitMoment => 'Bitte warte einen kurzen Augenblick.';

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
  String get commonTextCopiedToClipboard =>
      'Text wurde in die Zwischenablage kopiert';

  @override
  String get commonTitle => 'Titel';

  @override
  String get commonTitleNote => 'Hinweis';

  @override
  String get commonUnknownError => 'Es ist ein Fehler aufgetreten.';

  @override
  String get contactSupportButton => 'Support kontaktieren';

  @override
  String get countryAustria => 'Österreich';

  @override
  String get countryGermany => 'Deutschland';

  @override
  String get countrySwitzerland => 'Schweiz';

  @override
  String get courseActionsDeleteUppercase => 'KURS LÖSCHEN';

  @override
  String get courseActionsKickUppercase => 'AUS DEM KURS KICKEN';

  @override
  String get courseActionsLeaveUppercase => 'KURS VERLASSEN';

  @override
  String get courseAllowJoinExplanation =>
      'Über diese Einstellungen kannst du regulieren, ob neue Mitglieder dem Kurs beitreten dürfen.';

  @override
  String get courseCreateAbbreviationHint => 'z.B. M';

  @override
  String get courseCreateAbbreviationLabel => 'Kürzel des Kurses';

  @override
  String get courseCreateNameDescription =>
      'Der Kursname dient hauptsächlich für die Lehrkräfte, damit diese Kurse mit dem gleichen Fach unterscheiden können (z.B. \'Mathematik Klasse 8A\' und \'Mathematik Klasse 8B\').';

  @override
  String get courseCreateNameHint => 'z.B. Mathematik GK Q2';

  @override
  String get courseCreateSubjectHint => 'z.B. Mathematik';

  @override
  String get courseCreateSubjectRequiredLabel =>
      'Fach des Kurses (erforderlich)';

  @override
  String get courseCreateTitle => 'Kurs erstellen';

  @override
  String courseDeleteDialogDescription(String courseName) {
    return 'Möchtest du den Kurs \"$courseName\" wirklich endgültig löschen?\n\nEs werden alle Stunden & Termine aus dem Stundenplan, Hausaufgaben und Infozettel gelöscht.\n\nAuf den Kurs kann von niemandem mehr zugegriffen werden!';
  }

  @override
  String get courseDeleteDialogTitle => 'Kurs löschen?';

  @override
  String get courseDeleteSuccess => 'Du hast erfolgreich den Kurs gelöscht.';

  @override
  String get courseDesignColorChangeFailed =>
      'Farbe konnte nicht geändert werden.';

  @override
  String get courseDesignCourseColorChanged =>
      'Farbe wurde erfolgreich für den gesamten Kurs geändert.';

  @override
  String get courseDesignPersonalColorRemoved =>
      'Persönliche Farbe wurde entfernt.';

  @override
  String get courseDesignPersonalColorSet => 'Persönliche Farbe wurde gesetzt.';

  @override
  String get courseDesignPlusColorsHint =>
      'Nicht genug Farben? Schalte mit Sharezone Plus +200 zusätzliche Farben frei.';

  @override
  String get courseDesignRemovePersonalColor => 'Persönliche Farbe entfernen';

  @override
  String get courseDesignTypeCourseSubtitle =>
      'Farbe gilt für den gesamten Kurs';

  @override
  String get courseDesignTypeCourseTitle => 'Kurs';

  @override
  String get courseDesignTypePersonalSubtitle =>
      'Gilt nur für dich und liegt über der Kursfarbe';

  @override
  String get courseDesignTypePersonalTitle => 'Persönlich';

  @override
  String get courseEditSuccess => 'Der Kurs wurde erfolgreich bearbeitet!';

  @override
  String get courseEditTitle => 'Kurs bearbeiten';

  @override
  String get courseFieldsAbbreviationLabel => 'Kürzel des Fachs';

  @override
  String get courseFieldsNameLabel => 'Name des Kurses';

  @override
  String get courseFieldsSubjectLabel => 'Fach';

  @override
  String get courseLeaveAndDeleteDialogDescription =>
      'Möchtest du den Kurs wirklich verlassen? Da du der letzte Teilnehmer im Kurs bist, wird der Kurs gelöscht.';

  @override
  String get courseLeaveAndDeleteDialogTitle => 'Kurs verlassen und löschen?';

  @override
  String get courseLeaveDialogDescription =>
      'Möchtest du den Kurs wirklich verlassen?';

  @override
  String get courseLeaveDialogTitle => 'Kurs verlassen?';

  @override
  String get courseLeaveSuccess => 'Du hast erfolgreich den Kurs verlassen.';

  @override
  String courseLongPressTitle(String courseName) {
    return 'Kurs: $courseName';
  }

  @override
  String get courseMemberOptionsAloneHint =>
      'Da du der einzige im Kurs bist, kannst du deine Rolle nicht bearbeiten.';

  @override
  String get courseMemberOptionsOnlyAdminHint =>
      'Du bist der einzige Admin in diesem Kurs. Daher kannst du dir keine Rechte entziehen.';

  @override
  String get courseSelectColorsTooltip => 'Farben auswählen';

  @override
  String courseTemplateAlreadyExistsDescription(String subject) {
    return 'Du hast bereits einen Kurs für das Fach $subject erstellt. Möchtest du einen weiteren Kurs erstellen?';
  }

  @override
  String get courseTemplateAlreadyExistsTitle => 'Kurs bereits vorhanden';

  @override
  String courseTemplateCourseCreated(String courseName) {
    return 'Kurs \"$courseName\" wurde erstellt.';
  }

  @override
  String get courseTemplateCreateCustomCourseUppercase =>
      'EIGENEN KURS ERSTELLEN';

  @override
  String get courseTemplateCustomCourseMissingPrompt =>
      'Dein Kurs ist nicht dabei?';

  @override
  String get courseTemplateDeletedCourse => 'Kurs wurde gelöscht.';

  @override
  String get courseTemplateDeletingCourse => 'Kurs wird wieder gelöscht...';

  @override
  String get courseTemplateSchoolClassSelectionDescription =>
      'Du bist in einer oder mehreren Schulklasse(n) Administrator. Wähle eine Schulklasse aus, um festzulegen, zu welcher Schulklasse die Kurse verknüpft werden sollen.';

  @override
  String courseTemplateSchoolClassSelectionInfo(String name) {
    return 'Kurse, die ab jetzt erstellt werden, werden mit der Schulklasse \"$name\" verknüpft.';
  }

  @override
  String get courseTemplateSchoolClassSelectionNoneInfo =>
      'Kurse, die ab jetzt erstellt werden, werden mit keiner Schulklasse verknüpft.';

  @override
  String get courseTemplateSchoolClassSelectionNoneOption =>
      'Mit keiner Schulklasse verknüpfen';

  @override
  String get courseTemplateSchoolClassSelectionTitle => 'Schulklasse auswählen';

  @override
  String get courseTemplateTitle => 'Vorlagen';

  @override
  String get courseTemplateUndoUppercase => 'RÜCKGÄNGIG MACHEN';

  @override
  String get dashboardAdSectionAcquireSuffix => ' erwerben.';

  @override
  String get dashboardAdSectionSharezonePlusLabel => 'Sharezone Plus';

  @override
  String get dashboardDebugClearCache => '[DEBUG] Cache löschen';

  @override
  String get dashboardDebugOpenV2Dialog => 'V2 Dialog öffnen';

  @override
  String get dashboardFabAddBlackboardTitle => 'Infozettel';

  @override
  String get dashboardFabAddHomeworkTitle => 'Hausaufgabe';

  @override
  String get dashboardFabCreateHomeworkTooltip => 'Neue Hausaufgabe erstellen';

  @override
  String get dashboardFabCreateLessonTooltip => 'Neue Schulstunde erstellen';

  @override
  String get dashboardFabTooltip => 'Neue Elemente hinzufügen';

  @override
  String get dashboardHolidayCountdownDayUnitDay => 'Tag';

  @override
  String get dashboardHolidayCountdownDayUnitDays => 'Tage';

  @override
  String get dashboardHolidayCountdownDisplayError =>
      'Es gab einen Fehler beim Anzeigen von den Ferien.\nFalls dieser Fehler öfter auftaucht, kontaktiere uns bitte.';

  @override
  String get dashboardHolidayCountdownGeneralError =>
      '💣 Boooomm.... Etwas ist kaputt gegangen. Starte am besten die App einmal neu 👍';

  @override
  String dashboardHolidayCountdownHolidayLine(String text, String title) {
    return '$title: $text';
  }

  @override
  String dashboardHolidayCountdownInDays(int days, String emoji) {
    return 'In $days Tagen $emoji';
  }

  @override
  String get dashboardHolidayCountdownLastDay => 'Letzter Tag 😱';

  @override
  String dashboardHolidayCountdownNow(String emoji) {
    return 'JETZT, WOOOOOOO! $emoji';
  }

  @override
  String dashboardHolidayCountdownRemaining(
    String dayUnit,
    int days,
    String emoji,
  ) {
    return 'Noch $days $dayUnit $emoji';
  }

  @override
  String get dashboardHolidayCountdownSelectStateHint =>
      'Durch das Auswählen deiner Region können wir berechnen, wie lange du dich noch in der Schule quälen musst, bis endlich die Ferien sind 😉';

  @override
  String get dashboardHolidayCountdownTitle => 'Ferien-Countdown';

  @override
  String get dashboardHolidayCountdownTomorrow => 'Morgen 😱🎉';

  @override
  String get dashboardHolidayCountdownUnsupportedStateError =>
      'Ferien können für dein ausgewähltes Bundesland nicht angezeigt werden! 😫\nDu kannst das Bundesland in den Einstellungen ändern.';

  @override
  String get dashboardHolidayCountdownUnsupportedStateShortError =>
      'Ferien konnten für dein Bundesland nicht angezeigt werden';

  @override
  String get dashboardRateOurAppActionTitle => 'App bewerten';

  @override
  String get dashboardRateOurAppText =>
      'Wir wären dir unglaublich dankbar, wenn du uns eine Bewertung im App-/PlayStore hinterlassen könntest 🐵';

  @override
  String get dashboardRateOurAppTitle => 'Gefällt dir Sharezone?';

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
  String get drawerAboutTooltip => 'Über uns';

  @override
  String get drawerNavigationTooltip => 'Navigation';

  @override
  String get drawerOpenSemanticsLabel => 'Navigation öffnen';

  @override
  String get drawerProfileTooltip => 'Profile';

  @override
  String feedbackBoxCooldownError(Object coolDown) {
    return 'Error! Dein Cool Down ($coolDown) ist noch nicht abgelaufen.';
  }

  @override
  String get feedbackBoxDislikeLabel => 'Was gefällt Dir nicht?';

  @override
  String get feedbackBoxEmptyError =>
      'Du musst auch schon was reinschreiben 😉';

  @override
  String get feedbackBoxGeneralRatingLabel => 'Allgemeine Bewertung:';

  @override
  String get feedbackBoxGenericError =>
      'Error! Versuche es nochmal oder schicke uns dein Feedback gerne auch per E-Mail! :)';

  @override
  String get feedbackBoxHeardFromLabel => 'Wie hast Du von Sharezone erfahren?';

  @override
  String get feedbackBoxLikeMostLabel => 'Was gefällt Dir am besten?';

  @override
  String get feedbackBoxMissingLabel => 'Was fehlt Dir noch?';

  @override
  String get feedbackBoxPageTitle => 'Feedback-Box';

  @override
  String get feedbackBoxSubmitUppercase => 'ABSCHICKEN';

  @override
  String get feedbackBoxWhyWeNeedFeedbackDescription =>
      'Wir möchten die beste App zum Organisieren des Schulalltags entwickeln! Damit wir das schaffen, brauchen wir Dich! Fülle einfach das Formular aus und schick es ab.\n\nAlle Fragen sind selbstverständlich freiwillig.';

  @override
  String get feedbackBoxWhyWeNeedFeedbackTitle =>
      'Warum wir Dein Feedback brauchen:';

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
  String get feedbackHistoryPageEmpty =>
      'Du hast bisher kein Feedback gegeben 😢';

  @override
  String get feedbackHistoryPageTitle => 'Meine Feedbacks';

  @override
  String get feedbackNewLineHint => 'Shift + Enter für neue Zeile';

  @override
  String get feedbackSendTooltip => 'Senden (Enter)';

  @override
  String get feedbackThankYouRatePromptPrefix =>
      'Dir gefällt unsere App? Dann würden wir uns über eine Bewertung im ';

  @override
  String get feedbackThankYouRatePromptSuffix => ' riesig freuen! 😄';

  @override
  String get feedbackThankYouTitle => 'Vielen Dank für dein Feedback!';

  @override
  String get fileSharingCourseFoldersHeadline => 'Kursordner';

  @override
  String fileSharingDeleteFolderDescription(Object value) {
    return 'Möchtest du wirklich den Ordner mit dem Namen \"$value\" löschen?';
  }

  @override
  String get fileSharingDeleteFolderTitle => 'Ordner löschen?';

  @override
  String fileSharingDownloadError(Object value) {
    return 'Fehler: $value';
  }

  @override
  String get fileSharingDownloadingFileMessage =>
      'Datei wird heruntergeladen...';

  @override
  String get fileSharingFabCameraTitle => 'Kamera';

  @override
  String get fileSharingFabCameraTooltip => 'Kamera öffnen';

  @override
  String get fileSharingFabCreateFolderTitle => 'Ordner erstellen';

  @override
  String get fileSharingFabCreateFolderTooltip => 'Neuen Ordner erstellen';

  @override
  String get fileSharingFabCreateNewTitle => 'Neu erstellen';

  @override
  String get fileSharingFabCreateNewTooltip => 'Neu erstellen';

  @override
  String get fileSharingFabFilesTitle => 'Dateien';

  @override
  String get fileSharingFabFilesTooltip => 'Dateien';

  @override
  String get fileSharingFabFolderNameHint => 'Ordnername';

  @override
  String get fileSharingFabFolderTitle => 'Ordner';

  @override
  String get fileSharingFabImagesTitle => 'Bilder';

  @override
  String get fileSharingFabImagesTooltip => 'Bilder';

  @override
  String get fileSharingFabMissingCameraPermission =>
      'Oh! Die Berechtigung für die Kamera fehlt!';

  @override
  String get fileSharingFabUploadTitle => 'Hochladen';

  @override
  String get fileSharingFabUploadTooltip => 'Neue Datei hochladen';

  @override
  String get fileSharingFabVideosTitle => 'Videos';

  @override
  String get fileSharingFabVideosTooltip => 'Videos';

  @override
  String get fileSharingFoldersHeadline => 'Ordner';

  @override
  String get fileSharingMoveEmptyFoldersMessage =>
      'Es befinden sich an diesem Ort keine weiteren Ordner... Navigiere zwischen den Ordnern über die Leiste oben.';

  @override
  String get fileSharingNewNameHint => 'Neuer Name';

  @override
  String get fileSharingNoCourseFoldersFoundDescription =>
      'Es wurden keine Ordner gefunden, da du noch keinen Kursen beigetreten bist. Trete einfach einem Kurs bei oder erstelle einen eigenen Kurs.';

  @override
  String get fileSharingNoFilesFoundDescription =>
      'Lade jetzt einfach eine Datei hoch, um diese mit deinem Kurs zu teilen 👍';

  @override
  String get fileSharingNoFilesFoundTitle => 'Keine Dateien gefunden 😶';

  @override
  String get fileSharingNoFoldersFoundTitle => 'Keine Ordner gefunden! 😬';

  @override
  String get fileSharingPreparingDownloadMessage =>
      'Die Datei wird auf dein Gerät gebeamt...';

  @override
  String get fileSharingRenameActionUppercase => 'UMBENENNEN';

  @override
  String get fileSharingRenameFolderTitle => 'Ordner umbenennen';

  @override
  String get filesAddAttachment => 'Anhang hinzufügen';

  @override
  String filesCreator(Object value) {
    return 'von $value';
  }

  @override
  String filesDeleteDialogDescription(String fileName) {
    return 'Möchtest du wirklich die Datei mit dem Namen \"$fileName\" löschen?';
  }

  @override
  String get filesDeleteDialogTitle => 'Datei löschen?';

  @override
  String get filesDisplayErrorTitle => 'Anzeigefehler';

  @override
  String get filesDownloadBrokenFileError =>
      'Die Datei ist beschädigt und kann nicht heruntergeladen werden.';

  @override
  String get filesDownloadStarted => 'Download wurde gestartet...';

  @override
  String get filesLoading => 'Laden...';

  @override
  String filesMoveTo(Object value) {
    return 'Verschieben nach $value';
  }

  @override
  String get filesMoveUppercase => 'VERSCHIEBEN';

  @override
  String get filesRenameDialogHint => 'Neuer Name';

  @override
  String get filesRenameDialogTitle => 'Datei umbenennen';

  @override
  String get filesSelectCourseTitle => 'Wähle einen Kurs aus';

  @override
  String get gradesCommonName => 'Name';

  @override
  String get gradesCreateTermCurrentTerm => 'Aktuelles Halbjahr';

  @override
  String get gradesCreateTermGradingSystemInfo =>
      'Nur Noten von dem Notensystem, welches für das Halbjahr festlegt wurde, können für den Schnitt des Halbjahres berücksichtigt werden. Solltest du beispielsweise für das Halbjahr das Notensystem \"1 - 6\" festlegen und eine Note mit dem Notensystem \"15 - 0\" eintragen, kann diese Note für den Halbjahresschnitt nicht berücksichtigt werden.';

  @override
  String get gradesCreateTermInvalidNameError =>
      'Bitte gib einen gültigen Namen ein.';

  @override
  String gradesCreateTermSaveFailedError(Object error) {
    return 'Das Halbjahr konnte nicht gespeichert werden: $error';
  }

  @override
  String get gradesCreateTermSaved => 'Halbjahr gespeichert.';

  @override
  String get gradesDetailsDeletePrompt =>
      'Möchtest du diese Note wirklich löschen?';

  @override
  String get gradesDetailsDeleteTitle => 'Note löschen';

  @override
  String get gradesDetailsDeleteTooltip => 'Note löschen';

  @override
  String get gradesDetailsDeleted => 'Note gelöscht.';

  @override
  String get gradesDetailsDummyDetails => 'This is a test grade for algebra.';

  @override
  String get gradesDetailsDummyTopic => 'Algebra';

  @override
  String get gradesDetailsEditTooltip => 'Note bearbeiten';

  @override
  String get gradesDialogCreateTerm => 'Halbjahr erstellen';

  @override
  String get gradesDialogCustomGradeType => 'Benutzerdefinierter Notentyp';

  @override
  String get gradesDialogDateHelpDescription =>
      'Das Datum stellt das Datum dar, an dem du die Note erhalten hast. Falls du das Datum nicht mehr genau weißt, kannst du einfach ein ungefähres Datum von dem Tag angeben, an dem du die Note erhalten hast.';

  @override
  String get gradesDialogDateHelpTitle => 'Wozu dient das Datum?';

  @override
  String get gradesDialogDifferentGradingSystemInfo =>
      'Das Notensystem, welches du ausgewählt hast, ist nicht dasselbe wie das Notensystem deines Halbjahres. Du kannst die Note weiterhin eintragen, aber sie wird nicht in den Schnitt deines Halbjahres einfließen.';

  @override
  String get gradesDialogEditSubjectDescription =>
      'Du kannst das Fach von bereits erstellten Noten nicht nachträglich ändern.\n\nLösche diese Note und erstelle sie erneut, um ein anderes Fach auszuwählen.';

  @override
  String get gradesDialogEditSubjectTitle => 'Fach ändern';

  @override
  String get gradesDialogEditTermDescription =>
      'Du kannst das Halbjahr von bereits erstellten Noten nicht nachträglich ändern.\n\nLösche diese Note und erstelle sie erneut, um ein anderes Halbjahr auszuwählen.';

  @override
  String get gradesDialogEditTermTitle => 'Halbjahr ändern';

  @override
  String get gradesDialogGoToSharezonePlus => 'Zu Sharezone Plus';

  @override
  String get gradesDialogGradeLabel => 'Note';

  @override
  String get gradesDialogGradeTypeLabel => 'Notentyp';

  @override
  String get gradesDialogGradingSystemLabel => 'Notensystem';

  @override
  String get gradesDialogHintFifteenZero => 'z.B. 15.0';

  @override
  String get gradesDialogHintOnePlus => 'z.B. 1+';

  @override
  String get gradesDialogHintOneThree => 'z.B. 1.3';

  @override
  String get gradesDialogHintSeventyEightEight => 'z.B. 78.8';

  @override
  String get gradesDialogHintSixZero => 'z.B. 6.0';

  @override
  String get gradesDialogIncludeGradeInAverage => 'Note in Schnitt einbringen';

  @override
  String gradesDialogInvalidFieldsCombined(Object fieldMessages) {
    return 'Folgende Felder fehlen oder sind ungültig: $fieldMessages.';
  }

  @override
  String get gradesDialogInvalidGradeField =>
      'Die Note fehlt oder ist ungültig.';

  @override
  String get gradesDialogInvalidSubjectField =>
      'Bitte gib ein Fach für die Note an.';

  @override
  String get gradesDialogInvalidTermField =>
      'Bitte gib ein Halbjahr für die Note an.';

  @override
  String get gradesDialogInvalidTitleField =>
      'Der Titel fehlt oder ist ungültig.';

  @override
  String get gradesDialogNoGradeSelected => 'Keine Note ausgewählt';

  @override
  String get gradesDialogNoSubjectSelected => 'Kein Fach ausgewählt';

  @override
  String get gradesDialogNoTermSelected => 'Kein Halbjahr ausgewählt';

  @override
  String get gradesDialogNoTermsYetInfo =>
      'Bisher hast du keine Halbjahre erstellt. Bitte erstelle ein Halbjahr, um eine Note einzutragen.';

  @override
  String get gradesDialogNotesLabel => 'Notizen';

  @override
  String get gradesDialogPlusSubjectsLimitInfo =>
      'Du kannst zum Testen der Notenfunktion maximal 3 Fächer benutzen. Um alle Fächer zu benutzen, kaufe Sharezone Plus.';

  @override
  String get gradesDialogRequestAdditionalGradingSystem =>
      'Weiteres Notensystem anfragen';

  @override
  String get gradesDialogRequestAdditionalGradingSystemSubtitle =>
      'Notensystem nicht dabei? Schreib uns, welches Notensystem du gerne hättest!';

  @override
  String get gradesDialogSavedSnackBar => 'Note gespeichert';

  @override
  String get gradesDialogSelectGrade => 'Note auswählen';

  @override
  String get gradesDialogSelectGradeType => 'Notentyp auswählen';

  @override
  String get gradesDialogSelectGradingSystem => 'Notensystem auswählen';

  @override
  String get gradesDialogSelectGradingSystemHint =>
      'Der erste Wert entspricht der besten Noten, z.B. bei dem Notensystem \"1 - 6\" ist \"1\" die beste Note.';

  @override
  String get gradesDialogSelectSubject => 'Fach auswählen';

  @override
  String get gradesDialogSelectTerm => 'Halbjahr auswählen';

  @override
  String get gradesDialogSubjectLabel => 'Fach';

  @override
  String get gradesDialogTermLabel => 'Halbjahr';

  @override
  String get gradesDialogTitleHelpDescription =>
      'Falls die Note beispielsweise zu einer Klausur gehört, kannst du das Thema / den Titel der Klausur angeben, um die Note später besser zuordnen zu können.';

  @override
  String get gradesDialogTitleHelpTitle => 'Wozu dient der Titel?';

  @override
  String get gradesDialogTitleHint => 'z.B. Lineare Funktionen';

  @override
  String get gradesDialogTitleLabel => 'Titel';

  @override
  String get gradesDialogUnknownCustomGradeType => 'Unbekannt/Eigener Notentyp';

  @override
  String gradesDialogUnknownError(Object error) {
    return 'Unbekannter Fehler: $error';
  }

  @override
  String get gradesDialogZeroWeightGradeTypeInfo =>
      'Der ausgewählte Notentyp hat aktuell eine Gewichtung von 0. Du kannst die Note weiterhin eintragen, aber sie wird den Schnitt der Fachnote nicht beeinflussen. Du kannst die Gewichtung nach Speichern der Note im Fach oder im Halbjahr anpassen, damit die Note in den Schnitt einfließt.';

  @override
  String get gradesFinalGradeTypeHelpDialogText =>
      'Die Endnote ist die abschließende Note, die du in einem Fach bekommst, zum Beispiel die Note auf deinem Zeugnis. Manchmal berücksichtigt deine Lehrkraft zusätzliche Faktoren, die von der üblichen Berechnungsformel abweichen können – etwa 50% Prüfungen und 50% mündliche Beteiligung. In solchen Fällen kannst du die in Sharezone automatisch berechnete Note durch diese finale Note ersetzen.\n\nDiese Einstellung kann entweder für alle Fächer eines Halbjahres gleichzeitig festgelegt oder für jedes Fach individuell angepasst werden. So hast du die Flexibilität, je nach Bedarf spezifische Anpassungen vorzunehmen.';

  @override
  String get gradesFinalGradeTypeHelpDialogTitle =>
      'Was ist die Endnote eines Faches?';

  @override
  String get gradesFinalGradeTypeHelpTooltip => 'Was ist die Endnote?';

  @override
  String get gradesFinalGradeTypeSubtitle =>
      'Die berechnete Fachnote kann von einem Notentyp überschrieben werden.';

  @override
  String get gradesFinalGradeTypeTitle => 'Endnote eines Faches';

  @override
  String get gradesPageAddGrade => 'Note eintragen';

  @override
  String get gradesPageCurrentGradesLabel => 'Aktuelle Noten';

  @override
  String get gradesPagePastTermTitle => 'Vergangenes Halbjahr';

  @override
  String get gradesSettingsPageTitle => 'Noten-Einstellungen';

  @override
  String get gradesSettingsSubjectsSubtitle =>
      'Verwalte Fächer und verbundene Kurse';

  @override
  String get gradesSettingsSubjectsTitle => 'Fächer';

  @override
  String gradesSubjectSettingsPageTitle(Object subjectDisplayName) {
    return 'Einstellungen: $subjectDisplayName';
  }

  @override
  String get gradesSubjectsPageCourseNotAssigned =>
      'Dieser Kurs ist noch keinem Notenfach zugeordnet.';

  @override
  String gradesSubjectsPageCoursesLabel(Object courseNames) {
    return 'Kurse: $courseNames';
  }

  @override
  String get gradesSubjectsPageCoursesWithoutSubject => 'Kurse ohne Notenfach';

  @override
  String get gradesSubjectsPageDeleteDescription =>
      'Beim Löschen werden alle zugehörigen Noten dauerhaft entfernt.';

  @override
  String gradesSubjectsPageDeleteFailure(Object error) {
    return 'Fach konnte nicht gelöscht werden: $error';
  }

  @override
  String get gradesSubjectsPageDeleteSuccess =>
      'Fach und zugehörige Noten gelöscht.';

  @override
  String gradesSubjectsPageDeleteTitle(Object subjectName) {
    return '$subjectName löschen';
  }

  @override
  String get gradesSubjectsPageDeleteTooltip => 'Fach löschen';

  @override
  String get gradesSubjectsPageGradeSubjects => 'Notenfächer';

  @override
  String get gradesSubjectsPageInfoBody =>
      'In Sharezone werden alle Inhalte (wie Hausaufgaben oder Prüfungen) einem Kurs zugeordnet. Deine Noten werden jedoch in Notenfächern gespeichert - nicht in Kursen. So bleiben sie erhalten, auch wenn du einen Kurs verlässt.\n\nDas hat noch einen Vorteil: Du kannst deine Noten nach Fächern sortieren und später deine Entwicklung in einem Fach über mehrere Jahre hinweg verfolgen (diese Funktion ist bald verfügbar).\n\nSharezone legt automatisch ein Notenfach an, sobald du eine Note in einem Kurs erstellst.';

  @override
  String get gradesSubjectsPageInfoHeader => 'Notenfächer vs Kurse';

  @override
  String gradesSubjectsPageMultipleGrades(Object count) {
    return '$count Noten';
  }

  @override
  String get gradesSubjectsPageNoGrades => 'Keine Noten';

  @override
  String get gradesSubjectsPageNoGradesRecorded =>
      'Für dieses Fach wurden noch keine Noten erfasst.';

  @override
  String get gradesSubjectsPageSingleGrade => '1 Note';

  @override
  String get gradesTermDetailsDeleteDescription =>
      'Möchtest du das Halbjahr inkl. aller Noten wirklich löschen?\n\nDiese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get gradesTermDetailsDeleteTitle => 'Halbjahr löschen';

  @override
  String get gradesTermDetailsDeleteTooltip => 'Halbjahr löschen';

  @override
  String get gradesTermDetailsEditSubjectTooltip => 'Fachnote bearbeiten';

  @override
  String get gradesTermDetailsPageTitle => 'Halbjahresdetails';

  @override
  String get gradesTermDialogNameLabel => 'Name des Halbjahres';

  @override
  String get gradesTermSettingsCourseWeightingDescription =>
      'Solltest du Kurse haben, die doppelt gewichtet werden, kannst du bei diesen eine 2.0 eintragen.';

  @override
  String get gradesTermSettingsCourseWeightingTitle =>
      'Gewichtung der Kurse für Notenschnitt vom Halbjahr';

  @override
  String get gradesTermSettingsEditNameDescription =>
      'Der Name beschreibt das Halbjahr, z.B. \'10/2\' für das zweite Halbjahr der 10. Klasse.';

  @override
  String get gradesTermSettingsEditNameTitle => 'Name ändern';

  @override
  String get gradesTermSettingsEditWeightDescription =>
      'Die Gewichtung beschreibt, wie stark die Note des Kurses in den Halbjahresschnitt einfließt.';

  @override
  String get gradesTermSettingsEditWeightTitle => 'Gewichtung ändern';

  @override
  String get gradesTermSettingsNameHint => 'z.B. 10/2';

  @override
  String get gradesTermSettingsNameRequired => 'Bitte gib einen Namen ein.';

  @override
  String get gradesTermSettingsNoSubjectsYet =>
      'Du hast bisher noch keine Fächer erstellt.';

  @override
  String gradesTermSettingsTitle(Object name) {
    return 'Einstellung: $name';
  }

  @override
  String get gradesTermSettingsWeightDisplayTypeFactor => 'Faktor';

  @override
  String get gradesTermSettingsWeightDisplayTypePercent => 'Prozent';

  @override
  String get gradesTermSettingsWeightDisplayTypeTitle => 'Gewichtungssystem';

  @override
  String get gradesTermSettingsWeightHint => 'z.B. 1.0';

  @override
  String get gradesTermSettingsWeightInvalid => 'Bitte gib eine Zahl ein.';

  @override
  String get gradesTermSettingsWeightLabel => 'Gewichtung';

  @override
  String get gradesTermTileEditTooltip => 'Bearbeiten des Schnitts';

  @override
  String get gradesWeightSettingsAddWeight => 'Neue Gewichtung hinzufügen';

  @override
  String get gradesWeightSettingsHelpDialogText =>
      'In Sharezone kannst du genau bestimmen, wie die Note für jedes Fach berechnet wird, indem du die Gewichtung der verschiedenen Notentypen festlegst. Zum Beispiel kannst du einstellen, dass die Gesamtnote aus 50% schriftlichen Prüfungen und 50% mündlicher Beteiligung zusammengesetzt wird.\n\nDiese Flexibilität ermöglicht es dir, die Bewertungskriterien deiner Schule genau abzubilden und sicherzustellen, dass jede Art von Leistung angemessen berücksichtigt wird.';

  @override
  String get gradesWeightSettingsHelpDialogTitle =>
      'Wie wird die Note eines Fachs berechnet?';

  @override
  String get gradesWeightSettingsHelpTooltip => 'Wie wird die Note berechnet?';

  @override
  String get gradesWeightSettingsInvalidWeightInput =>
      'Bitte gebe eine gültige Zahl (>= 0) ein.';

  @override
  String get gradesWeightSettingsPercentHint => 'z.B. 56.5';

  @override
  String get gradesWeightSettingsPercentLabel => 'Gewichtung in %';

  @override
  String get gradesWeightSettingsRemoveTooltip => 'Entfernen';

  @override
  String get gradesWeightSettingsSubtitle =>
      'Lege die Gewichtung der Notentypen für die Berechnung der Fachnote fest.';

  @override
  String get gradesWeightSettingsTitle => 'Berechnung der Fachnote';

  @override
  String get groupHelpDifferenceDescription =>
      'Kurs: Spiegelt ein Schulfach wieder.\n\nSchulklasse: Besteht aus mehreren Kursen und ermöglicht das Beitreten all dieser Kurse mit nur einem Sharecode.\n\nGruppe: Ist der Oberbegriff für einen Kurs und eine Schulklasse.';

  @override
  String get groupHelpDifferenceTitle =>
      'Was ist der Unterschied zwischen einer Gruppe, einem Kurs und einer Schulklasse?';

  @override
  String get groupHelpHowToJoinOverview =>
      'Um einer Gruppe von deinen Mitschülern oder Lehrern beizutreten, gibt es zwei Möglichkeiten:\n\n1. Sharecode über einen QR-Code scannen\n2. Händisch den Sharecode eingeben';

  @override
  String get groupHelpHowToJoinTitle => 'Wie trete ich einer Gruppe bei?';

  @override
  String get groupHelpRolesDescription =>
      'Administrator:\nEin Admin verwaltet eine Gruppe. Das bedeutet, dass er diese bearbeiten, löschen und Teilnehmer rauswerfen kann. Zudem kann ein Admin alle weiteren Einstellungen für die Gruppe treffen, wie z.B. das Beitreten aktivieren/deaktivieren.\n\nAktives Mitglied:\nEin aktives Mitglied in einer Gruppe darf Inhalte erstellen und bearbeiten, sprich Hausaufgaben eintragen, Termine eintragen, Schulstunden bearbeiten, etc. Er hat somit Schreib- und Leserechte.\n\nPassives Mitglied:\nEin passives Mitglied in einer Gruppe hat ausschließlich Leserechte. Somit dürfen keine Inhalte erstellt oder bearbeitet werden.';

  @override
  String get groupHelpRolesTitle =>
      'Gruppenrollen erklärt: Was ist ein passives Mitglied, aktives Mitglied, Administrator?';

  @override
  String get groupHelpScanQrCodeDescription =>
      '1. Eine Person, die sich schon in diesem Kurs befindet, klickt unter der Seite \"Gruppe\" auf den gewünschten Kurs.\n2. Diese Person klickt nun auf den Button \"QR-Code anzeigen\".\n3. Nun öffnet sich unten eine neue Anzeige mit einem QR-Code.\n4. Die Person, die dem Kurs beitreten möchte, klickt unten auf der Seite \"Gruppen\" auf den roten Button.\n5. Als nächstes wählt die Person \"Kurs/Klasse beitreten\".\n6. Jetzt öffnet sich ein Fenster - dort klickt der Nutzer auf die blaue Grafik, um den QR-Code zu scannen.\n7. Abschließend nur noch die Kamera auf den QR-Code der anderen Person halten.';

  @override
  String get groupHelpScanQrCodeTitle => 'Sharecode mit einem QR-Code scannen';

  @override
  String get groupHelpTitle => 'Hilfe: Gruppen';

  @override
  String get groupHelpTypeSharecodeDescription =>
      '1. Eine Person, die sich schon in diesem Kurs befindet, klickt unter der Seite \"Gruppen\" auf den gewünschten Kurs.\n2. Auf dieser Seite wird nun direkt unter dem Kursnamen der Sharecode angezeigt.\n3. Die Person, die dem Kurs beitreten möchte, klickt unten auf der Seite \"Gruppen\" auf den roten Button.\n4. Als nächstes wählt die Person \"Kurs/Klasse beitreten\".\n5. Jetzt öffnet sich ein Fenster - dort muss dann nur noch der Sharecode von der anderen Person in das Textfeld unten eingeben werden.';

  @override
  String get groupHelpTypeSharecodeTitle => 'Händisch den Sharecode eingeben';

  @override
  String get groupHelpWhatIsSharecodeDescription =>
      'Der Sharecode ist ein Zugangsschlüssel für einen Kurs. Mit diesem können Mitschüler und Lehrer dem Kurs beitreten.\n\nDank des Sharecodes braucht es kein Austauschen persönlicher Daten, wie z.B. der E-Mail Adresse oder der privaten Handynummer, unter den Kursmitgliedern - anders als es z.B. bei WhatsApp-Gruppen oder den meisten E-Mail Verteilern der Fall ist.\n\nEin Kursmitglied sieht nur den Namen (kann auch ein Pseudonym sein) der anderen Kursmitglieder.';

  @override
  String get groupHelpWhatIsSharecodeTitle => 'Was ist ein Sharecode?';

  @override
  String get groupHelpWhyDifferentSharecodesDescription =>
      'Jeder Teilnehmer aus einem Kurs hat einen individuellen Sharecode.\n\nDas hat den Grund, dass getrackt werden kann, welcher Nutzer wen eingeladen hat.\n\nDank dieser Funktion zählen auch Weiterempfehlungen ohne die Verwendung eines Empfehlunglinks.';

  @override
  String get groupHelpWhyDifferentSharecodesTitle =>
      'Warum hat jeder Teilnehmer aus einer Gruppe einen anderen Sharecode?';

  @override
  String get groupJoinCourseSelectionParentHint =>
      'Falls dein Kind in Wahlfächern (z.B. Französisch) ist, solltest du diese Kurse aus der Auswahl aufheben.';

  @override
  String get groupJoinCourseSelectionStudentHint =>
      'Falls du in Wahlfächern (z.B. Französisch) bist, solltest du diese Kurse aus der Auswahl aufheben.';

  @override
  String get groupJoinCourseSelectionTeacherHint =>
      'Wähle die Kurse aus, in denen du unterrichtest.';

  @override
  String groupJoinCourseSelectionTitle(String groupName) {
    return 'Beizutretende Kurse der $groupName';
  }

  @override
  String get groupJoinErrorAlreadyMemberDescription =>
      'Du bist bereits Mitglied in dieser Gruppe, daher musst du dieser nicht mehr beitreten.';

  @override
  String get groupJoinErrorAlreadyMemberTitle =>
      'Ein Fehler ist aufgetreten: Bereits Mitglied 🤨';

  @override
  String get groupJoinErrorNoInternetDescription =>
      'Wir konnten nicht versuchen, der Gruppe beizutreten, da wir keine Internetverbindung herstellen konnten. Bitte überprüfe dein WLAN bzw. deine Mobilfunkdaten.';

  @override
  String get groupJoinErrorNoInternetTitle =>
      'Ein Fehler ist aufgetreten: Keine Internetverbindung ☠️';

  @override
  String get groupJoinErrorNotPublicDescription =>
      'Die Gruppe erlaubt aktuell kein Beitreten. Dies ist in den Gruppeneinstellungen deaktiviert. Bitte wende dich an einen Admin dieser Gruppe.';

  @override
  String get groupJoinErrorNotPublicTitle =>
      'Ein Fehler ist aufgetreten: Beitreten verboten ⛔️';

  @override
  String get groupJoinErrorSharecodeNotFoundDescription =>
      'Wir konnten den eingegebenen Sharecode nicht finden. Bitte überprüfe die Groß- und Kleinschreibung und ob dieser Sharecode noch gültig ist.';

  @override
  String get groupJoinErrorSharecodeNotFoundTitle =>
      'Ein Fehler ist aufgetreten: Sharecode nicht gefunden ❌';

  @override
  String get groupJoinErrorUnknownDescription =>
      'Dies könnte eventuell an deiner Internetverbindung liegen. Bitte überprüfe diese!';

  @override
  String get groupJoinErrorUnknownTitle =>
      'Ein unbekannter Fehler ist aufgetreten 😭';

  @override
  String groupJoinPasteSharecodeDescription(String sharecode) {
    return 'Möchtest du den Sharecode \"$sharecode\" aus deiner Zwischenablage übernehmen?';
  }

  @override
  String get groupJoinPasteSharecodeTitle => 'Sharecode einfügen';

  @override
  String get groupJoinRequireCourseSelectionDescription =>
      'Du musst zum Beitreten die Kurse auswählen, in welchen du bist.';

  @override
  String groupJoinRequireCourseSelectionTitle(String groupName) {
    return 'Klasse gefunden: $groupName';
  }

  @override
  String get groupJoinResultJoinMoreAction => 'Mehr beitreten';

  @override
  String get groupJoinResultRetryAction => 'Nochmal versuchen';

  @override
  String get groupJoinResultSelectCoursesAction => 'Kurse auswählen';

  @override
  String get groupJoinScanQrCodeDescription =>
      'Scanne einen QR-Code, um einer Gruppe beizutreten.';

  @override
  String get groupJoinScanQrCodeTooltip => 'QR-Code scannen';

  @override
  String get groupJoinSharecodeHint => 'z.B. Qb32vF';

  @override
  String get groupJoinSharecodeLabel => 'Sharecode';

  @override
  String groupJoinSuccessDescription(String groupName) {
    return '$groupName wurde erfolgreich hinzugefügt. Du bist nun Mitglied.';
  }

  @override
  String get groupJoinSuccessTitle => 'Erfolgreich beigetreten 🎉';

  @override
  String get groupOnboardingCreateNewGroupsAction =>
      'Nein, ich möchte neue Gruppen erstellen';

  @override
  String get groupOnboardingFirstPersonHint =>
      'Wenn ein Mitschüler schon Sharezone verwendet, kann dir dieser einen Sharecode geben, damit du seiner Klasse beitreten kannst.';

  @override
  String get groupOnboardingFirstPersonParentTitle =>
      'Wurden bereits Gruppen von Schülern oder Lehrkräften erstellt?';

  @override
  String get groupOnboardingFirstPersonStudentTitle =>
      'Haben Mitschüler oder dein Lehrer / deine Lehrerin schon einen Kurs, eine Klasse oder Stufe erstellt? 💪';

  @override
  String get groupOnboardingFirstPersonTeacherTitle =>
      'Wurden bereits Gruppen von einer anderen Person erstellt? 💪';

  @override
  String get groupOnboardingIsClassTeacherCreateClassAction =>
      'Ja, ich möchte eine Klasse erstellen';

  @override
  String get groupOnboardingIsClassTeacherCreateCoursesOnlyAction =>
      'Nein, ich möchte nur Kurse erstellen';

  @override
  String get groupOnboardingIsClassTeacherTitle =>
      'Leitest du eine Klasse? (Klassenlehrer)';

  @override
  String get groupOnboardingJoinMultipleGroupsAction =>
      'Ja, ich möchte diesen Gruppen beitreten';

  @override
  String get groupOnboardingJoinSingleGroupAction =>
      'Ja, ich möchte dieser Gruppe beitreten';

  @override
  String get groupOnboardingSchoolClassHint => 'z.B. 10A';

  @override
  String get groupParticipantsEmpty =>
      'Es befinden sich keine Teilnehmer in dieser Gruppe 😭';

  @override
  String get groupsAllowJoinTitle => 'Beitreten erlauben';

  @override
  String get groupsContactSupportLinkText => 'Support';

  @override
  String get groupsContactSupportPrefix =>
      'Du brauchst Hilfe? Dann kontaktiere einfach unseren ';

  @override
  String get groupsContactSupportSuffix => ' 😉';

  @override
  String get groupsCreateCourseDescription =>
      'Einen Kurs kannst du dir wie ein Schulfach vorstellen. Jedes Fach wird mit einem Kurs abgebildet.';

  @override
  String get groupsCreateSchoolClassDescription =>
      'Eine Klasse besteht aus mehreren Kursen. Jedes Mitglied tritt beim Betreten der Klasse automatisch allen dazugehörigen Kursen bei.';

  @override
  String get groupsEmptyTitle =>
      'Du bist noch keinem Kurs, bzw. keiner Klasse beigetreten!';

  @override
  String get groupsFabJoinOrCreateTooltip => 'Gruppe beitreten/erstellen';

  @override
  String get groupsInviteParticipants => 'Teilnehmer einladen';

  @override
  String get groupsJoinCourseOrClassDescription =>
      'Falls einer deiner Mitschüler schon eine Klasse oder einen Kurs erstellt hat, kannst du diesem einfach beitreten.';

  @override
  String get groupsJoinCourseOrClassTitle => 'Kurs/Klasse beitreten';

  @override
  String get groupsJoinTitle => 'Beitreten';

  @override
  String get groupsLinkCopied => 'Link wurde kopiert';

  @override
  String groupsMemberCount(Object value) {
    return 'Anzahl der Teilnehmer: $value';
  }

  @override
  String get groupsMemberOptionsNoAdminRightsHint =>
      'Da du kein Admin bist, hast du keine Rechte, um andere Mitglieder zu verwalten.';

  @override
  String get groupsMemberYou => 'Du';

  @override
  String get groupsMembersActiveMemberTitle =>
      'Aktives Mitglied (Schreib- und Leserechte)';

  @override
  String get groupsMembersAdminsTitle => 'Administratoren';

  @override
  String get groupsMembersLegendTitle => 'Legenden';

  @override
  String get groupsMembersPassiveMemberTitle =>
      'Passives Mitglied (nur Leserechte)';

  @override
  String get groupsPageMyCourses => 'Meine Kurse:';

  @override
  String get groupsPageMySchoolClass => 'Meine Klasse:';

  @override
  String get groupsPageMySchoolClasses => 'Meine Klassen:';

  @override
  String get groupsPageTitle => 'Gruppen';

  @override
  String get groupsQrCodeSubtitle => 'anzeigen';

  @override
  String get groupsQrCodeTitle => 'QR-Code';

  @override
  String get groupsRoleActiveMemberDescription => 'Schreib- und Leserechte';

  @override
  String get groupsRoleAdminDescription =>
      'Schreib- und Leserechte & Verwaltung';

  @override
  String get groupsRoleReadOnlyDescription => 'Leserechte';

  @override
  String get groupsSharecodeCopied => 'Sharecode wurde kopiert';

  @override
  String get groupsSharecodeCopiedToClipboard =>
      'Sharecode wurde in die Zwischenablage kopiert.';

  @override
  String get groupsSharecodeLoading => 'Sharecode wird geladen...';

  @override
  String groupsSharecodeLowercaseCharacter(String character) {
    return 'kleines $character';
  }

  @override
  String get groupsSharecodePrefix => 'Sharecode: ';

  @override
  String groupsSharecodeSemanticsLabel(String sharecode) {
    return 'Sharecode: $sharecode';
  }

  @override
  String groupsSharecodeText(String sharecode) {
    return 'Sharecode: $sharecode';
  }

  @override
  String groupsSharecodeUppercaseCharacter(String character) {
    return 'großes $character';
  }

  @override
  String get groupsWritePermissionsEveryoneDescription =>
      'Jeder erhält die Rolle ”aktives Mitglied (Lese- und Schreibrechte)\"';

  @override
  String get groupsWritePermissionsExplanation =>
      'Mit dieser Einstellung kann reguliert werden, welche Nutzergruppen Schreibrechte erhalten.';

  @override
  String get groupsWritePermissionsOnlyAdminsDescription =>
      'Alle, außer die Admins, erhalten die Rolle \"passives Mitglied (Nur Leserechte)\"';

  @override
  String get groupsWritePermissionsSheetQuestion =>
      'Wer ist dazu berechtigt, neue Einträge, neue Hausaufgaben, neue Dateien, etc. zu erstellen, bzw. hochzuladen?';

  @override
  String get groupsWritePermissionsTitle => 'Schreibrechte';

  @override
  String get homeworkAddAction => 'Hausaufgabe eintragen';

  @override
  String get homeworkBottomBarMoreIdeas => 'Noch Ideen?';

  @override
  String get homeworkCardViewCompletedByTooltip => '\"Erledigt von\" anzeigen';

  @override
  String get homeworkCardViewSubmissionsTooltip => 'Abgaben anzeigen';

  @override
  String get homeworkCompletionPlusDescription =>
      'Erwerbe Sharezone Plus, um nachzuvollziehen, wer bereits die Hausaufgabe als erledigt markiert hat.';

  @override
  String get homeworkCompletionReadByTitle => 'Erledigt von';

  @override
  String get homeworkDeleteAttachmentsDialogDescription =>
      'Sollen die Anhänge der Hausaufgabe aus der Dateiablage gelöscht oder die Verknüpfung zwischen beiden aufgehoben werden?';

  @override
  String get homeworkDeleteAttachmentsDialogTitle =>
      'Anhänge ebenfalls löschen?';

  @override
  String get homeworkDeleteAttachmentsUnlink => 'Entknüpfen';

  @override
  String get homeworkDeleteScopeDialogDescription =>
      'Soll die Hausaufgabe nur für dich oder für den gesamten Kurs gelöscht werden?';

  @override
  String get homeworkDeleteScopeDialogTitle => 'Für alle löschen?';

  @override
  String get homeworkDeleteScopeOnlyMe => 'Nur für mich';

  @override
  String get homeworkDeleteScopeWholeCourse => 'Für gesamten Kurs';

  @override
  String get homeworkDetailsAdditionalInfo => 'Zusatzinformationen';

  @override
  String homeworkDetailsAttachmentsCount(int count) {
    return 'Anhänge: $count';
  }

  @override
  String get homeworkDetailsChangeAccountTypeContent =>
      'Wenn du eine Hausaufgabe abgeben möchtest, musst dein Account als Schüler registriert sein. Der Support kann deinen Account in einen Schüler-Account umwandeln, damit du Hausaufgaben abgeben darfst.';

  @override
  String get homeworkDetailsChangeAccountTypeEmailBody =>
      'Liebes Sharezone-Team, bitte ändert meinen Account-Typ zum Schüler ab.';

  @override
  String homeworkDetailsChangeAccountTypeEmailSubject(String uid) {
    return 'Typ des Accounts zu Schüler ändern [$uid]';
  }

  @override
  String get homeworkDetailsChangeAccountTypeTitle => 'Account-Typ ändern?';

  @override
  String get homeworkDetailsCourseTitle => 'Kurs';

  @override
  String get homeworkDetailsCreatedBy => 'Erstellt von:';

  @override
  String homeworkDetailsDoneByStudentsCount(int count) {
    return 'Von $count SuS erledigt';
  }

  @override
  String get homeworkDetailsMarkAsDone => 'Als erledigt markieren';

  @override
  String get homeworkDetailsMarkAsUndone => 'Als unerledigt markieren';

  @override
  String get homeworkDetailsMarkDoneAction => 'Abhaken';

  @override
  String get homeworkDetailsMySubmission => 'Meine Abgabe';

  @override
  String get homeworkDetailsNoPermissionTitle => 'Keine Berechtigung';

  @override
  String get homeworkDetailsNoSubmissionContent =>
      'Du hast bisher keine Abgabe gemacht. Möchtest du wirklich die Hausaufgabe ohne Abgabe als erledigt markieren?';

  @override
  String get homeworkDetailsNoSubmissionTitle => 'Keine Abgabe bisher';

  @override
  String get homeworkDetailsNoSubmissionYet =>
      'Keine Abgabe bisher eingereicht';

  @override
  String get homeworkDetailsParentsCannotSubmit =>
      'Eltern dürfen keine Hausaufgaben abgeben';

  @override
  String get homeworkDetailsPrivateSubtitle =>
      'Diese Hausaufgabe wird nicht mit dem Kurs geteilt.';

  @override
  String get homeworkDetailsPrivateTitle => 'Privat';

  @override
  String homeworkDetailsSubmissionsCount(int count) {
    return '$count Abgaben';
  }

  @override
  String get homeworkDetailsViewCompletionNoPermissionContent =>
      'Eine Lehrkraft darf aus Sicherheitsgründen nur mit Admin-Rechten in der jeweiligen Gruppe die Erledigt-Liste anschauen.\n\nAnsonsten könnte jeder Schüler einen neuen Account als Lehrkraft erstellen und der Gruppe beitreten, um einzusehen, welche Mitschüler die Hausaufgaben bereits erledigt haben.';

  @override
  String get homeworkDetailsViewSubmissionsNoPermissionContent =>
      'Eine Lehrkraft darf aus Sicherheitsgründen nur mit Admin-Rechten in der jeweiligen Gruppe die Abgabe anschauen.\n\nAnsonsten könnte jeder Schüler einen neuen Account als Lehrkraft erstellen und der Gruppe beitreten, um die Abgabe der anderen Mitschüler anzuschauen.';

  @override
  String get homeworkDialogCourseChangeDisabled =>
      'Der Kurs kann nachträglich nicht mehr geändert werden. Bitte lösche die Hausaufgabe und erstelle eine neue, falls du den Kurs ändern möchtest.';

  @override
  String get homeworkDialogDescriptionHint => 'Zusatzinformationen eingeben';

  @override
  String get homeworkDialogDueDateAfterNextLesson => 'Übernächste Stunde';

  @override
  String get homeworkDialogDueDateChipsPlusDescription =>
      'Mit Sharezone Plus kannst du Hausaufgaben mit nur einem Fingertipp auf den nächsten Schultag oder eine beliebige Stunde in der Zukunft setzen.';

  @override
  String get homeworkDialogDueDateInXHours => 'In X Stunden';

  @override
  String homeworkDialogDueDateInXLessons(int count) {
    return '$count.-nächste Stunde';
  }

  @override
  String get homeworkDialogDueDateNextLesson => 'Nächste Stunde';

  @override
  String get homeworkDialogDueDateNextSchoolday => 'Nächster Schultag';

  @override
  String get homeworkDialogEmptyTitleError =>
      'Bitte gib einen Titel für die Hausaufgabe an!';

  @override
  String get homeworkDialogNextLessonSuffix => '.-nächste Stunde';

  @override
  String get homeworkDialogNoCourseSelected => 'Keinen Kurs ausgewählt';

  @override
  String get homeworkDialogNotifyCourseMembers =>
      'Kursmitglieder benachrichtigen';

  @override
  String get homeworkDialogNotifyCourseMembersDescription =>
      'Kursmitglieder über neue Hausaufgabe benachrichtigen.';

  @override
  String get homeworkDialogNotifyCourseMembersEditing =>
      'Kursmitglieder über die Änderungen benachrichtigen';

  @override
  String get homeworkDialogPrivateSubtitle =>
      'Hausaufgabe nicht mit dem Kurs teilen.';

  @override
  String get homeworkDialogPrivateTitle => 'Privat';

  @override
  String get homeworkDialogRequiredFieldsMissing =>
      'Bitte fülle alle erforderlichen Felder aus!';

  @override
  String get homeworkDialogSaveTooltip => 'Hausaufgabe speichern';

  @override
  String homeworkDialogSavingFailed(String error) {
    return 'Hausaufgabe konnte nicht gespeichert werden.\n\n$error\n\nFalls der Fehler weiterhin auftritt, kontaktiere bitte den Support.';
  }

  @override
  String get homeworkDialogSelectLessonOffsetDescription =>
      'Wähle aus, in wie vielen Stunden die Hausaufgabe fällig ist.';

  @override
  String get homeworkDialogSelectLessonOffsetTitle => 'Stundenzeit auswählen';

  @override
  String get homeworkDialogSubmissionTimeTitle => 'Abgabe-Uhrzeit';

  @override
  String get homeworkDialogTitleHint => 'Titel eingeben (z.B. AB Nr. 1 - 3)';

  @override
  String homeworkDialogUnknownError(String error) {
    return 'Es gab einen unbekannten Fehler ($error) 😖 Bitte kontaktiere den Support!';
  }

  @override
  String get homeworkDialogWithSubmissionTitle => 'Mit Abgabe';

  @override
  String get homeworkEmptyFireDescription =>
      'Du musst noch die Hausaufgaben erledigen! Also schau mich nicht weiter an und erledige die Aufgaben! Do it!';

  @override
  String get homeworkEmptyFireTitle => 'AUF GEHT\'S! 💥👊';

  @override
  String get homeworkEmptyGameControllerDescription =>
      'Sehr gut! Du hast keine Hausaufgaben zu erledigen';

  @override
  String get homeworkEmptyGameControllerTitle =>
      'Jetzt ist Zeit für die wirklich wichtigen Dinge im Leben! 🤘💪';

  @override
  String get homeworkFabNewHomeworkTooltip => 'Neue Hausaufgabe';

  @override
  String homeworkLongPressTitle(String homeworkTitle) {
    return 'Hausaufgabe: $homeworkTitle';
  }

  @override
  String get homeworkMarkOverdueAction => 'Überfällige Hausaufgaben abhaken';

  @override
  String get homeworkMarkOverduePromptTitle =>
      'Alle überfälligen Hausaufgaben abhaken?';

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
  String get homeworkTabArchivedUppercase => 'ARCHIVIERT';

  @override
  String get homeworkTabDoneUppercase => 'ERLEDIGT';

  @override
  String get homeworkTabOpenUppercase => 'OFFEN';

  @override
  String get homeworkTeacherNoArchivedTitle =>
      'Hier werden alle Hausaufgaben angezeigt, deren Fälligkeitsdatum in der Vergangenheit liegt.';

  @override
  String get homeworkTeacherNoOpenTitle =>
      'Keine Hausaufgaben für die Schüler:innen? 😮😍';

  @override
  String get homeworkTeacherNoPermissionTitle => 'Keine Berechtigung';

  @override
  String get homeworkTeacherViewCompletionNoPermissionContent =>
      'Eine Lehrkraft darf aus Sicherheitsgründen nur mit Admin-Rechten in der jeweiligen Gruppe die Erledigt-Liste anschauen.\n\nAnsonsten könnte jeder Schüler einen neuen Account als Lehrkraft erstellen und der Gruppe beitreten, um einzusehen, welche Mitschüler die Hausaufgaben bereits erledigt haben.';

  @override
  String get homeworkTeacherViewSubmissionsNoPermissionContent =>
      'Eine Lehrkraft darf aus Sicherheitsgründen nur mit Admin-Rechten in der jeweiligen Gruppe die Abgabe anschauen.\n\nAnsonsten könnte jeder Schüler einen neuen Account als Lehrkraft erstellen und der Gruppe beitreten, um die Abgabe der anderen Mitschüler anzuschauen.';

  @override
  String homeworkTodoDateTime(String date, String time) {
    return '$date - $time Uhr';
  }

  @override
  String get icalLinksDialogExportCreated =>
      'Der Export wurde erfolgreich erstellt.';

  @override
  String get icalLinksDialogNameHint => 'Name eingeben (z.B. Meine Prüfungen)';

  @override
  String get icalLinksDialogNameMissingError => 'Bitte gib einen Namen ein';

  @override
  String get icalLinksDialogNameMissingErrorWithPeriod =>
      'Bitte gib einen Namen ein.';

  @override
  String get icalLinksDialogPrivateNote =>
      'iCal Exporte sind privat und nur für dich sichtbar.';

  @override
  String get icalLinksDialogSourceMissingError =>
      'Bitte wähle mindestens eine Quelle aus.';

  @override
  String get icalLinksDialogSourcesQuestion =>
      'Welche Quellen sollen in den Export aufgenommen werden?';

  @override
  String get icalLinksPageBuilding => 'Wird erstellt...';

  @override
  String get icalLinksPageCopyLink => 'Link kopieren';

  @override
  String get icalLinksPageEmptyState =>
      'Du hast noch keine iCal-Links erstellt.';

  @override
  String icalLinksPageErrorSubtitle(String error) {
    return 'Fehler: $error';
  }

  @override
  String get icalLinksPageHowToAddIcalLinkToCalendarBody =>
      '1. Kopiere den iCal-Link\n2. Öffne deinen Kalender (z.B. Google Kalender, Apple Kalender)\n3. Füge einen neuen Kalender hinzu\n4. Wähle \"Über URL hinzufügen\" oder \"Über das Internet hinzufügen\"\n5. Füge den iCal-Link ein\n6. Fertig! Dein Stundenplan und deine Termine werden nun in deinem Kalender angezeigt.';

  @override
  String get icalLinksPageHowToAddIcalLinkToCalendarHeader =>
      'Wie füge ich einen iCal-Link zu meinem Kalender hinzu?';

  @override
  String get icalLinksPageLinkCopied => 'Link in Zwischenablage kopiert.';

  @override
  String get icalLinksPageLinkDeleted => 'Link gelöscht.';

  @override
  String get icalLinksPageLinkLoading => 'Link wird geladen...';

  @override
  String get icalLinksPageLocked => 'Gesperrt';

  @override
  String get icalLinksPageNewLink => 'Neuer Link';

  @override
  String get icalLinksPageTitle => 'iCal-Links';

  @override
  String get icalLinksPageWhatIsAnIcalLinkHeader => 'Was ist ein iCal Link?';

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
  String get loginCreateAccount => 'Neues Konto erstellen';

  @override
  String get loginEmailLabel => 'E-Mail';

  @override
  String get loginHidePasswordTooltip => 'Passwort verstecken';

  @override
  String get loginPasswordFieldSemanticsLabel => 'Passwortfeld';

  @override
  String get loginPasswordLabel => 'Passwort';

  @override
  String get loginResetPasswordButton => 'Passwort zurücksetzen';

  @override
  String get loginShowPasswordTooltip => 'Passwort anzeigen';

  @override
  String get loginSubmitTooltip => 'Einloggen';

  @override
  String get loginWithAppleButton => 'Über Apple anmelden';

  @override
  String get loginWithGoogleButton => 'Über Google einloggen';

  @override
  String get loginWithQrCodeButton => 'Über einen QR-Code einloggen';

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
  String get mobileWelcomeBackgroundImageSemanticsLabel =>
      'Hintergrundbild der Willkommens-Seite mit 5 Handys, die die Sharezone-App zeigen.';

  @override
  String get mobileWelcomeHeadline =>
      'Gemeinsam den\nSchulalltag organisieren 🚀';

  @override
  String get mobileWelcomeNewAtSharezoneButton =>
      'Ich bin neu bei Sharezone 👋';

  @override
  String get mobileWelcomeSignInButton => 'Anmelden';

  @override
  String get mobileWelcomeSignInWithExistingAccount =>
      'Mit existierendem Konto anmelden';

  @override
  String get mobileWelcomeSubHeadline =>
      'Optional kannst du Sharezone auch komplett alleine verwenden.';

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
  String get notificationPageBlackboardDescription =>
      'Der Ersteller eines Infozettels kann regulieren, ob die Kursmitglieder darüber benachrichtigt werden sollen, dass ein neuer Infozettel erstellt wurde, bzw. es eine Änderung gab. Mit dieser Option kannst du diese Benachrichtigungen an- und ausschalten.';

  @override
  String get notificationPageBlackboardHeadline => 'Infozettel';

  @override
  String get notificationPageBlackboardTitle =>
      'Benachrichtigungen für Infozettel';

  @override
  String get notificationPageCommentsDescription =>
      'Erhalte eine Push-Nachricht, sobald ein neuer Nutzer einen neuen Kommentar unter einer Hausaufgabe oder einem Infozettel verfasst hat.';

  @override
  String get notificationPageCommentsHeadline => 'Kommentare';

  @override
  String get notificationPageCommentsTitle =>
      'Benachrichtigungen für Kommentare';

  @override
  String get notificationPageHomeworkHeadline => 'Offene Hausaufgaben';

  @override
  String get notificationPageHomeworkReminderTitle =>
      'Erinnerungen für offene Hausaufgaben';

  @override
  String get notificationPageInvalidHomeworkReminderTime =>
      'Nur volle und halbe Stunden sind erlaubt, z.B. 18:00 oder 18:30.';

  @override
  String get notificationPagePlusDialogDescription =>
      'Mit Sharezone Plus kannst du die Erinnerung für die Hausaufgaben individuell im 30-Minuten-Tack einstellen, z.B. 15:00 oder 15:30 Uhr.';

  @override
  String get notificationPagePlusDialogTitle =>
      'Uhrzeit für Erinnerung am Vortag';

  @override
  String get notificationPageTimeTitle => 'Uhrzeit';

  @override
  String notificationPageTimeValue(String time) {
    return '$time Uhr';
  }

  @override
  String get notificationPageTitle => 'Benachrichtigungen';

  @override
  String get notificationsDialogReplyAction => 'Antworten';

  @override
  String get notificationsErrorDialogMoreInfo => 'Mehr Infos.';

  @override
  String get notificationsErrorDialogShortDescription =>
      'Beim tippen auf die Benachrichtigung hätte jetzt etwas anderes passieren sollen.';

  @override
  String get onboardingNotificationsConfirmBody =>
      'Bist du dir sicher, dass du keine Benachrichtigungen erhalten möchtest?\n\nSollte jemand einen Infozettel eintragen, einen Kommentar zu einer Hausaufgabe hinzufügen oder dir eine Nachricht schreiben, würdest du keine Push-Nachrichten erhalten.';

  @override
  String get onboardingNotificationsConfirmTitle =>
      'Keine Push-Nachrichten? 🤨';

  @override
  String get onboardingNotificationsDescriptionGeneral =>
      'Wenn jemand einen neuen Infozettel einträgt oder dir eine Nachricht schreibt, erhältst du eine Benachrichtigung. Somit bleibst du immer auf dem aktuellen Stand 💪';

  @override
  String get onboardingNotificationsDescriptionStudent =>
      'Wir können dich an offene Hausaufgaben erinnern 😉 Zudem kannst du eine Benachrichtigung erhalten, wenn jemand einen neuen Infozettel einträgt oder dir eine Nachricht schreibt.';

  @override
  String get onboardingNotificationsEnable => 'Aktivieren';

  @override
  String get onboardingNotificationsTitle =>
      'Erinnerungen und Benachrichtigungen erhalten';

  @override
  String get pastCalendricalEventsDummyTitleExam2 => 'Klausur Nr. 2';

  @override
  String get pastCalendricalEventsDummyTitleExam3 => 'Klausur Nr. 3';

  @override
  String get pastCalendricalEventsDummyTitleExam4 => 'Klausur Nr. 4';

  @override
  String get pastCalendricalEventsDummyTitleExam5 => 'Klausur Nr. 5';

  @override
  String get pastCalendricalEventsDummyTitleNoSchool => 'Schulfrei';

  @override
  String get pastCalendricalEventsDummyTitleParentTeacherDay =>
      'Elternsprechtag';

  @override
  String get pastCalendricalEventsDummyTitleSportsFestival => 'Sportfest';

  @override
  String get pastCalendricalEventsDummyTitleTest6 => 'Test Nr. 6';

  @override
  String get pastCalendricalEventsPageEmpty => 'Keine vergangenen Termine';

  @override
  String pastCalendricalEventsPageError(String error) {
    return 'Fehler beim Laden der vergangenen Termine: $error';
  }

  @override
  String get pastCalendricalEventsPagePlusDescription =>
      'Erwerbe Sharezone Plus, um alle vergangenen Termine einzusehen.';

  @override
  String get pastCalendricalEventsPageSortAscending => 'Aufsteigend';

  @override
  String get pastCalendricalEventsPageSortAscendingSubtitle =>
      'Älteste Termine zuerst';

  @override
  String get pastCalendricalEventsPageSortDescending => 'Absteigend';

  @override
  String get pastCalendricalEventsPageSortDescendingSubtitle =>
      'Neueste Termine zuerst';

  @override
  String get pastCalendricalEventsPageSortOrderTooltip => 'Sortierreihenfolge';

  @override
  String get pastCalendricalEventsPageTitle => 'Vergangene Termine';

  @override
  String get periodsEditAddLesson => 'Stunde hinzufügen';

  @override
  String get periodsEditSaved =>
      'Die Stundenzeiten wurden erfolgreich geändert.';

  @override
  String get periodsEditTimetableStart => 'Stundenplanbeginn';

  @override
  String get privacyDisplaySettingsDensityComfortable => 'Komfortabel';

  @override
  String get privacyDisplaySettingsDensityCompact => 'Kompakt';

  @override
  String get privacyDisplaySettingsDensityStandard => 'Standard';

  @override
  String get privacyDisplaySettingsShowReadIndicator =>
      '\"Am Lesen\"-Indikator anzeigen';

  @override
  String get privacyDisplaySettingsTextScalingFactor => 'Textskalierungsfaktor';

  @override
  String get privacyDisplaySettingsThemeMode => 'Dunkel-/Hellmodus';

  @override
  String get privacyDisplaySettingsThemeModeAutomatic => 'Automatisch';

  @override
  String get privacyDisplaySettingsThemeModeDark => 'Dunkler Modus';

  @override
  String get privacyDisplaySettingsThemeModeLight => 'Heller Modus';

  @override
  String get privacyDisplaySettingsTitle => 'Anzeigeeinstellungen';

  @override
  String get privacyDisplaySettingsVisualDensity => 'Visuelle Kompaktheit';

  @override
  String get privacyPolicyChangeAppearance => 'Darstellung ändern';

  @override
  String get privacyPolicyDownloadPdf => 'Als PDF herunterladen';

  @override
  String get privacyPolicyPageTitle => 'Datenschutzerklärung';

  @override
  String get privacyPolicyPageUpdatedEffectiveDatePrefix =>
      'Diese aktualisierte Datenschutzerklärung tritt am';

  @override
  String get privacyPolicyPageUpdatedEffectiveDateSuffix => 'in Kraft.';

  @override
  String get privacyPolicyTableOfContents => 'Inhaltsverzeichnis';

  @override
  String get profileAvatarTooltip => 'Mein Profil';

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
  String get resetPasswordEmailFieldLabel => 'E-Mail Adresse deines Kontos';

  @override
  String get resetPasswordErrorMessage =>
      'E-Mail konnte nicht gesendet werden. Überprüfe deine eingegebene E-Mail-Adresse!';

  @override
  String get resetPasswordSentDialogTitle => 'E-Mail wurde verschickt';

  @override
  String get resetPasswordSuccessMessage =>
      'E-Mail zum Passwort-Zurücksetzen wurde gesendet.';

  @override
  String get schoolClassActionsDeleteUppercase => 'KLASSE LÖSCHEN';

  @override
  String get schoolClassActionsKickUppercase => 'AUS DER SCHULKLASSE KICKEN';

  @override
  String get schoolClassActionsLeaveUppercase => 'KLASSE VERLASSEN';

  @override
  String get schoolClassAllowJoinExplanation =>
      'Über diese Einstellungen kannst du regulieren, ob neue Mitglieder dem Kurs beitreten dürfen.\n\nDie Einstellung wird direkt auf alle Kurse übertragen, die mit der Schulklasse verbunden sind.';

  @override
  String get schoolClassCoursesAddExisting => 'Existierenden Kurs hinzufügen';

  @override
  String get schoolClassCoursesAddNew => 'Neuen Kurs hinzufügen';

  @override
  String get schoolClassCoursesEmptyDescription =>
      'Es wurden noch keine Kurse zu dieser Klasse hinzugefügt.\n\nErstelle jetzt einen Kurs, der mit der Klasse verknüpft ist.';

  @override
  String get schoolClassCoursesSelectCourseDialogHint =>
      'Du kannst nur Kurse hinzufügen, in denen du auch Administrator bist.';

  @override
  String get schoolClassCoursesSelectCourseDialogTitle =>
      'Wähle einen Kurs aus';

  @override
  String get schoolClassCoursesTitle => 'Kurse';

  @override
  String get schoolClassCreateTitle => 'Schulklasse erstellen';

  @override
  String get schoolClassEditSuccess =>
      'Die Schulklasse wurde erfolgreich bearbeitet!';

  @override
  String get schoolClassEditTitle => 'Schulklasse bearbeiten';

  @override
  String get schoolClassLeaveConfirmationQuestion =>
      'Möchtest du wirklich die Schulklasse verlassen?';

  @override
  String get schoolClassLeaveDialogDeleteWithCourses => 'Mit Kursen löschen';

  @override
  String get schoolClassLeaveDialogDeleteWithoutCourses => 'Ohne Kurse löschen';

  @override
  String get schoolClassLeaveDialogDescription =>
      'Möchtest du wirklich die Klasse verlassen?\n\nDu hast noch die Option, die Kurse der Schulklasse ebenfalls zu löschen oder diese zu behalten. Werden die Kurse der Schulklasse nicht gelöscht, bleiben diese weiterhin bestehen.';

  @override
  String get schoolClassLeaveDialogTitle => 'Klasse verlassen';

  @override
  String get schoolClassLoadError =>
      'Es ist ein Fehler beim Laden aufgetreten...';

  @override
  String schoolClassLongPressTitle(String schoolClassName) {
    return 'Klasse: $schoolClassName';
  }

  @override
  String get schoolClassMemberOptionsAloneHint =>
      'Da du der einzige in der Schulklasse bist, kannst du deine Rolle nicht bearbeiten.';

  @override
  String get schoolClassMemberOptionsOnlyAdminHint =>
      'Du bist der einzige Admin in dieser Schulklasse. Daher kannst du dir keine Rechte entziehen.';

  @override
  String get schoolClassWritePermissionsAnnotation =>
      'Die Einstellung wird direkt auf alle Kurse übertragen, die mit der Schulklasse verbunden sind.';

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
  String get settingsLegalLicensesTitle => 'Lizenzen';

  @override
  String get settingsLegalTermsTitle => 'Allgemeine Nutzungsbedingungen (ANB)';

  @override
  String get settingsOptionMyAccount => 'Mein Konto';

  @override
  String get settingsOptionSourceCode => 'Quellcode';

  @override
  String get settingsOptionWebApp => 'Web-App';

  @override
  String get settingsPrivacyPolicyLinkText => 'Datenschutzerklärung';

  @override
  String get settingsPrivacyPolicySentencePrefix =>
      'Mehr Informationen erhältst du in unserer ';

  @override
  String get settingsPrivacyPolicySentenceSuffix => '.';

  @override
  String get settingsSectionAppSettings => 'App-Einstellungen';

  @override
  String get settingsSectionLegal => 'Rechtliches';

  @override
  String get settingsSectionMore => 'Mehr';

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
  String get sharezoneV2DialogAnbAcceptanceCheckbox =>
      'Ich habe [die ANB](anb) gelesen und akzeptiere diese.';

  @override
  String get sharezoneV2DialogChangedLegalFormHeader => 'Geänderte Rechtsform';

  @override
  String get sharezoneV2DialogPrivacyPolicyRevisionHeader =>
      'Überarbeitung der Datenschutzerklärung';

  @override
  String sharezoneV2DialogSubmitError(Object value) {
    return 'Es ist ein Fehler aufgetreten: $value. Falls dieser bestehen bleibt, dann schreibe uns unter support@sharezone.net';
  }

  @override
  String get sharezoneV2DialogTermsHeader =>
      'Allgemeine Nutzungsbedingungen (ANB)';

  @override
  String get sharezoneV2DialogTitle => 'Sharezone v2.0';

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
  String get signInWithQrCodeLoadingMessage =>
      'Die Erstellung des QR-Codes kann einige Sekunden dauern...';

  @override
  String get signInWithQrCodeStep1 =>
      'Öffne Sharezone auf deinem Handy / Tablet';

  @override
  String get signInWithQrCodeStep2 =>
      'Öffne die Einstellungen über die seitliche Navigation';

  @override
  String get signInWithQrCodeStep3 => 'Tippe auf \"Web-App\"';

  @override
  String get signInWithQrCodeStep4 =>
      'Tippe auf \"QR-Code scannen\" und richte die Kamera auf deinen Bildschirm';

  @override
  String get signInWithQrCodeTitle =>
      'So meldest du dich über einen QR-Code an:';

  @override
  String get signOutDialogConfirmation => 'Möchtest du dich wirklich abmelden?';

  @override
  String get signUpAdvantageAllInOne => 'All-In-One-App für die Schule';

  @override
  String get signUpAdvantageCloud =>
      'Schulplaner über die Cloud mit der Klasse teilen';

  @override
  String get signUpAdvantageHomeworkReminder =>
      'Erinnerungen an offene Hausaufgaben';

  @override
  String get signUpAdvantageSaveTime =>
      'Große Zeitersparnis durch gemeinsames Organisieren';

  @override
  String get signUpAdvantagesTitle => 'Vorteile von Sharezone';

  @override
  String get signUpDataProtectionAesTitle =>
      'AES 256-Bit serverseitige Verschlüsselung';

  @override
  String get signUpDataProtectionAnonymousSignInSubtitle =>
      'IP-Adresse wird zwangsläufig temporär gespeichert';

  @override
  String get signUpDataProtectionAnonymousSignInTitle =>
      'Anmeldung ohne personenbezogene Daten';

  @override
  String get signUpDataProtectionDeleteDataTitle =>
      'Einfaches Löschen der Daten';

  @override
  String get signUpDataProtectionIsoTitle =>
      'ISO27001, ISO27012 & ISO27018 zertifiziert*';

  @override
  String get signUpDataProtectionServerLocationSubtitle =>
      'Mit Ausnahme des Authentifizierungs-Server';

  @override
  String get signUpDataProtectionServerLocationTitle =>
      'Standort der Server: Frankfurt (Deutschland)';

  @override
  String get signUpDataProtectionSocSubtitle =>
      '* Zertifizierung von unserem Hosting-Anbieter';

  @override
  String get signUpDataProtectionSocTitle => 'SOC1, SOC2, & SOC3 zertifiziert*';

  @override
  String get signUpDataProtectionTitle => 'Datenschutz';

  @override
  String get signUpDataProtectionTlsTitle =>
      'TLS-Verschlüsselung bei der Übertragung';

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
  String get supportPageBody =>
      'Du hast einen Fehler gefunden, hast Feedback oder einfach eine Frage über Sharezone? Kontaktiere uns und wir helfen dir weiter!';

  @override
  String get supportPageDiscordIconSemanticsLabel => 'Discord Icon';

  @override
  String get supportPageDiscordPrivacyContent =>
      'Bitte beachte, dass bei der Nutzung von Discord dessen [Datenschutzbestimmungen](https://discord.com/privacy) gelten.';

  @override
  String get supportPageDiscordPrivacyTitle => 'Discord Datenschutz';

  @override
  String get supportPageDiscordSubtitle => 'Community-Support';

  @override
  String get supportPageDiscordTitle => 'Discord';

  @override
  String supportPageEmailAddress(String email) {
    return 'E-Mail: $email';
  }

  @override
  String get supportPageEmailIconSemanticsLabel => 'E-Mail Icon';

  @override
  String get supportPageEmailTitle => 'E-Mail';

  @override
  String get supportPageFreeSupportSubtitle =>
      'Bitte beachte, dass die Wartezeit beim kostenfreien Support bis zu 2 Wochen betragen kann.';

  @override
  String get supportPageFreeSupportTitle => 'Kostenfreier Support';

  @override
  String get supportPageHeadline => 'Du brauchst Hilfe?';

  @override
  String get supportPagePlusAdvertisingBulletOne =>
      'Innerhalb von wenigen Stunden eine Rückmeldung per E-Mail (anstatt bis zu 2 Wochen)';

  @override
  String get supportPagePlusAdvertisingBulletTwo =>
      'Videocall-Support nach Terminvereinbarung (ermöglicht das Teilen des Bildschirms)';

  @override
  String get supportPagePlusEmailSubtitle =>
      'Erhalte eine Rückmeldung innerhalb von wenigen Stunden.';

  @override
  String get supportPagePlusSupportSubtitle =>
      'Als Sharezone Plus Nutzer hast du Zugriff auf unseren Premium Support.';

  @override
  String get supportPagePlusSupportTitle => 'Plus Support';

  @override
  String get supportPageTitle => 'Support';

  @override
  String get supportPageVideoCallRequiresSignIn =>
      'Du musst angemeldet sein, um einen Videocall zu vereinbaren.';

  @override
  String get supportPageVideoCallSubtitle =>
      'Nach Terminvereinbarung, bei Bedarf kann ebenfalls der Bildschirm geteilt werden.';

  @override
  String get supportPageVideoCallTitle => 'Videocall-Support';

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
  String themeNavigationOptionTitle(int number, String optionName) {
    return 'Option $number: $optionName';
  }

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
  String get timetableAddAbWeeksPrefix => ' A/B Wochen kannst du in den ';

  @override
  String get timetableAddAbWeeksSettings => 'Einstellungen';

  @override
  String get timetableAddAbWeeksSuffix => ' aktivieren.';

  @override
  String get timetableAddAutoRecurringInfo =>
      'Schulstunden werden automatisch auch für die nächsten Wochen eingetragen.';

  @override
  String get timetableAddJoinCourseAction => 'Kurs beitreten';

  @override
  String get timetableAddLessonTitle => 'Schulstunde hinzufügen';

  @override
  String get timetableAddRoomAndTeacherOptionalTitle =>
      'Gib einen Raum & eine Lehrkraft an (optional)';

  @override
  String get timetableAddSelectCourseTitle => 'Wähle einen Kurs aus';

  @override
  String get timetableAddSelectWeekTypeTitle => 'Wähle einen Wochentypen aus';

  @override
  String get timetableAddSelectWeekdayTitle => 'Wähle einen Wochentag aus';

  @override
  String get timetableAddUnknownError =>
      'Es ist ein unbekannter Fehler aufgetreten. Bitte kontaktiere den Support!';

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
  String get timetableEditCourseLocked =>
      'Der Kurs kann nicht mehr nachträglich geändert werden.';

  @override
  String get timetableEditEndTime => 'Endzeit';

  @override
  String timetableEditEventTitle(String eventType) {
    return '$eventType bearbeiten';
  }

  @override
  String get timetableEditLessonTitle => 'Schulstunde bearbeiten';

  @override
  String get timetableEditNoPeriodSelected => 'Keine Stunde ausgewählt';

  @override
  String timetableEditPeriodSelected(int number) {
    return '$number. Stunde';
  }

  @override
  String get timetableEditStartTime => 'Startzeit';

  @override
  String get timetableEditTeacherHint => 'z.B. Frau Stark';

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
  String get timetableEventCardChangeColorAction => 'Farbe ändern';

  @override
  String timetableEventCardEventTitle(Object value) {
    return 'Termin: $value';
  }

  @override
  String timetableEventCardExamTitle(Object value) {
    return 'Prüfung: $value';
  }

  @override
  String get timetableEventDetailsAddToCalendarButton =>
      'IN KALENDER EINTRAGEN';

  @override
  String get timetableEventDetailsAddToCalendarPlusDescription =>
      'Mit Sharezone Plus kannst du kinderleicht die Termine aus Sharezone in deinen lokalen Kalender (z.B. Apple oder Google Kalender) übertragen.';

  @override
  String get timetableEventDetailsAddToCalendarTitle =>
      'Termin zum Kalender hinzufügen';

  @override
  String get timetableEventDetailsDeleteDialog =>
      'Möchtest du wirklich diesen Termin löschen?';

  @override
  String get timetableEventDetailsDeletedConfirmation =>
      'Termin wurde gelöscht';

  @override
  String get timetableEventDetailsEditedConfirmation =>
      'Termin wurde erfolgreich bearbeitet';

  @override
  String get timetableEventDetailsExamTopics => 'Themen der Prüfung';

  @override
  String get timetableEventDetailsLabel => 'Details';

  @override
  String timetableEventDetailsReport(String itemType) {
    return '$itemType melden';
  }

  @override
  String timetableEventDetailsRoom(String room) {
    return 'Raum: $room';
  }

  @override
  String get timetableEventDialogDateSelectionNotPossible =>
      'Auswahl nicht möglich';

  @override
  String get timetableEventDialogDateSelectionNotPossibleContent =>
      'Aktuell ist nicht möglich, einen Termin oder eine Klausur über mehrere Tage hinweg zu haben.';

  @override
  String get timetableEventDialogDescriptionHintEvent => 'Zusatzinformationen';

  @override
  String get timetableEventDialogDescriptionHintExam => 'Themen der Prüfung';

  @override
  String get timetableEventDialogEmptyCourseError =>
      'Bitte wähle einen Kurs aus.';

  @override
  String get timetableEventDialogEmptyTitleError =>
      'Bitte gib einen Titel ein.';

  @override
  String get timetableEventDialogEndTimeAfterStartTimeError =>
      'Die Endzeit muss nach der Startzeit liegen.';

  @override
  String get timetableEventDialogNotifyCourseMembersEvent =>
      'Kursmitglieder über neuen Termin benachrichtigen.';

  @override
  String get timetableEventDialogNotifyCourseMembersExam =>
      'Kursmitglieder über neue Klausur benachrichtigen.';

  @override
  String get timetableEventDialogNotifyCourseMembersTitle =>
      'Kursmitglieder benachrichtigen';

  @override
  String get timetableFabAddTooltip => 'Stunde/Termin hinzufügen';

  @override
  String get timetableFabLessonAddedConfirmation =>
      'Die Schulstunde wurde erfolgreich hinzugefügt';

  @override
  String get timetableFabOptionEvent => 'Termin';

  @override
  String get timetableFabOptionExam => 'Prüfung';

  @override
  String get timetableFabOptionLesson => 'Schulstunde';

  @override
  String get timetableFabOptionSubstitutions => 'Vertretungsplan';

  @override
  String get timetableFabSectionCalendar => 'Kalender';

  @override
  String get timetableFabSectionTimetable => 'Stundenplan';

  @override
  String get timetableFabSubstitutionsDialogTitle => 'Vertretungsplan';

  @override
  String get timetableFabSubstitutionsStepOne =>
      '1. Navigiere zu der betroffenen Schulstunde.';

  @override
  String get timetableFabSubstitutionsStepThree =>
      '3. Wähle die Art der Vertretung aus.';

  @override
  String get timetableFabSubstitutionsStepTwo =>
      '2. Klicke auf die Schulstunde.';

  @override
  String get timetableLessonDetailsAddHomeworkTooltip =>
      'Hausaufgabe hinzufügen';

  @override
  String timetableLessonDetailsArrowLocation(String location) {
    return '-> $location';
  }

  @override
  String get timetableLessonDetailsChangeColor => 'Farbe ändern';

  @override
  String get timetableLessonDetailsCourseName => 'Kursname: ';

  @override
  String get timetableLessonDetailsDeleteDialogConfirm =>
      'Mir ist bewusst, dass die Stunde für alle Teilnehmer aus dem Kurs gelöscht wird.';

  @override
  String get timetableLessonDetailsDeleteDialogMessage =>
      'Möchtest du wirklich die Schulstunde für den gesamten Kurs löschen?';

  @override
  String get timetableLessonDetailsDeleteTitle => 'Stunde löschen';

  @override
  String get timetableLessonDetailsDeletedConfirmation =>
      'Schulstunde wurde gelöscht';

  @override
  String get timetableLessonDetailsEditedConfirmation =>
      'Schulstunde wurde erfolgreich bearbeitet';

  @override
  String get timetableLessonDetailsRoom => 'Raum: ';

  @override
  String get timetableLessonDetailsSubstitutionPlusDescription =>
      'Schalte mit Sharezone Plus den Vertretungsplan frei, um z.B. den Entfall einer Schulstunden zu markieren.\n\nSogar Kursmitglieder ohne Sharezone Plus können den Vertretungsplan einsehen (jedoch nicht ändern).';

  @override
  String get timetableLessonDetailsTeacher => 'Lehrkraft: ';

  @override
  String get timetableLessonDetailsTeacherInTimetableDescription =>
      'Mit Sharezone Plus kannst du die Lehrkraft zur jeweiligen Schulstunde im Stundenplan eintragen. Für Kursmitglieder ohne Sharezone Plus wird die Lehrkraft ebenfalls angezeigt.';

  @override
  String get timetableLessonDetailsTeacherInTimetableTitle =>
      'Lehrkraft im Stundenplan';

  @override
  String timetableLessonDetailsTimeRange(String endTime, String startTime) {
    return '$startTime - $endTime';
  }

  @override
  String timetableLessonDetailsWeekType(String weekType) {
    return 'Wochentyp: $weekType';
  }

  @override
  String timetableLessonDetailsWeekday(String weekday) {
    return 'Wochentag: $weekday';
  }

  @override
  String get timetablePageSettingsTooltip => 'Stundenplan-Einstellungen';

  @override
  String get timetableQuickCreateEmptyTitle =>
      'Du bist noch keinem Kurs, bzw. keiner Klasse beigetreten!';

  @override
  String get timetableQuickCreateTitle => 'Stunde hinzufügen';

  @override
  String get timetableSchoolClassFilterAllClasses => 'Alle Schulklassen';

  @override
  String get timetableSchoolClassFilterAllShort => 'Alle';

  @override
  String timetableSchoolClassFilterLabel(Object value) {
    return 'Schulklasse: $value';
  }

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
  String get timetableSubstitutionCancelDialogAction => 'Entfallen lassen';

  @override
  String get timetableSubstitutionCancelDialogDescription =>
      'Möchtest du wirklich die Schulstunde für den gesamten Kurs entfallen lassen?';

  @override
  String get timetableSubstitutionCancelDialogNotify =>
      'Informiere deine Kursmitglieder, dass die Stunde entfällt.';

  @override
  String get timetableSubstitutionCancelDialogTitle =>
      'Stunde entfallen lassen';

  @override
  String get timetableSubstitutionCancelLesson => 'Stunde entfallen lassen';

  @override
  String get timetableSubstitutionCancelRestored =>
      'Entfallene Stunde wiederhergestellt';

  @override
  String get timetableSubstitutionCancelSaved =>
      'Stunde als \"Entfällt\" markiert';

  @override
  String get timetableSubstitutionCanceledTitle => 'Stunde entfällt';

  @override
  String get timetableSubstitutionChangeRoom => 'Raumänderung';

  @override
  String get timetableSubstitutionChangeRoomDialogAction =>
      'Raumänderung speichern';

  @override
  String get timetableSubstitutionChangeRoomDialogDescription =>
      'Möchtest du wirklich den Raum für die Stunde ändern?';

  @override
  String get timetableSubstitutionChangeRoomDialogNotify =>
      'Informiere deine Kursmitglieder über die Raumänderung.';

  @override
  String get timetableSubstitutionChangeRoomDialogTitle => 'Raumänderung';

  @override
  String get timetableSubstitutionChangeTeacher => 'Lehrkraft ändern';

  @override
  String get timetableSubstitutionChangeTeacherDialogAction =>
      'Lehrkraft speichern';

  @override
  String get timetableSubstitutionChangeTeacherDialogDescription =>
      'Möchtest du wirklich die Vertretungslehrkraft ändern?';

  @override
  String get timetableSubstitutionChangeTeacherDialogNotify =>
      'Informiere deine Kursmitglieder über die Lehrkraftänderung.';

  @override
  String get timetableSubstitutionChangeTeacherDialogTitle =>
      'Vertretungslehrkraft ändern';

  @override
  String get timetableSubstitutionEditRoomTooltip => 'Raum ändern';

  @override
  String get timetableSubstitutionEditTeacherTooltip => 'Lehrkraft ändern';

  @override
  String timetableSubstitutionEnteredBy(String name) {
    return 'Eingetragen von: $name';
  }

  @override
  String get timetableSubstitutionNewRoomHint => 'z.B. D203';

  @override
  String get timetableSubstitutionNewRoomLabel => 'Neuer Raum';

  @override
  String get timetableSubstitutionNoPermissionSubtitle =>
      'Bitte wende dich an deinen Kurs-Administrator.';

  @override
  String get timetableSubstitutionNoPermissionTitle =>
      'Du hast keine Berechtigung, den Vertretungsplan zu ändern.';

  @override
  String get timetableSubstitutionRemoveAction => 'Entfernen';

  @override
  String get timetableSubstitutionRemoveRoomDialogDescription =>
      'Möchtest du wirklich die Raumänderung für die Stunde entfernen?';

  @override
  String get timetableSubstitutionRemoveRoomDialogNotify =>
      'Informiere deine Kursmitglieder über die Entfernung.';

  @override
  String get timetableSubstitutionRemoveRoomDialogTitle =>
      'Raumänderung entfernen';

  @override
  String get timetableSubstitutionRemoveTeacherDialogDescription =>
      'Möchtest du wirklich die Vertretungslehrkraft für die Stunde entfernen?';

  @override
  String get timetableSubstitutionRemoveTeacherDialogNotify =>
      'Informiere deine Kursmitglieder über die Entfernung.';

  @override
  String get timetableSubstitutionRemoveTeacherDialogTitle =>
      'Vertretungslehrkraft entfernen';

  @override
  String timetableSubstitutionReplacement(String teacher) {
    return 'Vertretung: $teacher';
  }

  @override
  String get timetableSubstitutionRestoreDialogAction => 'Wiederherstellen';

  @override
  String get timetableSubstitutionRestoreDialogDescription =>
      'Möchtest du wirklich die Stunde wieder stattfinden lassen?';

  @override
  String get timetableSubstitutionRestoreDialogNotify =>
      'Informiere deine Kursmitglieder, dass die Stunde stattfindet.';

  @override
  String get timetableSubstitutionRestoreDialogTitle =>
      'Entfallene Stunde wiederherstellen';

  @override
  String timetableSubstitutionRoomChanged(String room) {
    return 'Raumänderung: $room';
  }

  @override
  String get timetableSubstitutionRoomRemoved => 'Raumänderung entfernt';

  @override
  String get timetableSubstitutionRoomSaved => 'Raumänderung eingetragen';

  @override
  String timetableSubstitutionSectionForDate(String date) {
    return 'Für $date';
  }

  @override
  String get timetableSubstitutionSectionTitle => 'Vertretungsplan';

  @override
  String get timetableSubstitutionTeacherRemoved =>
      'Vertretungslehrkraft entfernt';

  @override
  String get timetableSubstitutionTeacherSaved =>
      'Vertretungslehrkraft eingetragen';

  @override
  String get timetableSubstitutionUndoTooltip => 'Rückgängig machen';

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
  String get userCommentFieldEmptyError =>
      'Der Kommentar hat doch gar keinen Text! 🧐';

  @override
  String get userCommentFieldHint => 'Gib deinen Senf ab...';

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
  String get webAppSettingsDescription =>
      'Besuche für weitere Informationen einfach https://web.sharezone.net.';

  @override
  String get webAppSettingsHeadline => 'Sharezone für\'s Web!';

  @override
  String get webAppSettingsQrCodeHint =>
      'Mithilfe der Anmeldung über einen QR-Code kannst du dich in der Web-App anmelden, ohne ein Passwort einzugeben. Besonders hilfreich ist das bei der Nutzung eines öffentlichen PCs.';

  @override
  String get webAppSettingsScanQrCodeDescription =>
      'Geh auf web.sharezone.net und scanne den QR-Code.';

  @override
  String get webAppSettingsScanQrCodeTitle => 'QR-Code scannen';

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
  String get weekdaysEditSaved =>
      'Die aktivierten Wochentage wurden erfolgreich geändert.';

  @override
  String get weekdaysEditTitle => 'Schultage';

  @override
  String get writePermissionEveryone => 'Alle';

  @override
  String get writePermissionOnlyAdmins => 'Nur Admins';
}
