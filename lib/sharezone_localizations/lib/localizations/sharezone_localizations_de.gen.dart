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
  String get appName => 'Sharezone';

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
  String get commonActionsClose => 'Schließen';

  @override
  String get commonActionsCloseUppercase => 'SCHLIESSEN';

  @override
  String get commonActionsConfirm => 'Bestätigen';

  @override
  String get commonActionsContactSupport => 'Support kontaktieren';

  @override
  String get commonActionsDelete => 'Löschen';

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
  String get timetableSettingsABWeekTileTitle => 'A/B Wochen';

  @override
  String get timetableSettingsAWeeksAreEvenSwitch =>
      'A-Wochen sind gerade Kalenderwochen';

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
}
