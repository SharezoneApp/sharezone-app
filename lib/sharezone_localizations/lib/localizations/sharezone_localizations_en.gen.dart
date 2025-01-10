// Copyright (c) 2025 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:intl/intl.dart' as intl;

import 'sharezone_localizations.gen.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SharezoneLocalizationsEn extends SharezoneLocalizations {
  SharezoneLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Sharezone';

  @override
  String get commonActionsCancel => 'Cancel';

  @override
  String get commonActionsConfirm => 'Confirm';

  @override
  String get commonActionsSave => 'Speichern';

  @override
  String get commonActionsClose => 'Schließen';

  @override
  String get commonActionsOk => 'Ok';

  @override
  String get commonActionsYes => 'Ok';

  @override
  String get commonActionsAlright => 'Alles klar';

  @override
  String get commonActionsDelete => 'Löschen';

  @override
  String get commonActionsContactSupport => 'Support kontaktieren';

  @override
  String commonDisplayError(String? error) {
    return 'Fehler: $error';
  }

  @override
  String get instagram => 'Instagram';

  @override
  String get twitter => 'Twitter';

  @override
  String get linkedIn => 'LinkedIn';

  @override
  String get discord => 'Discord';

  @override
  String get email => 'Email';

  @override
  String get gitHub => 'GitHub';

  @override
  String get contactSupportButton => 'Support kontaktieren';

  @override
  String get languagePageTitle => 'Langauge';

  @override
  String get languageSystemName => 'System';

  @override
  String get languageDeName => 'German';

  @override
  String get languageEnName => 'English';

  @override
  String get imprintPageTitle => 'Imprint';

  @override
  String get aboutPageTitle => 'About us';

  @override
  String get aboutPageHeaderTitle => 'Sharezone';

  @override
  String get aboutPageHeaderSubtitle => 'The connected school planner';

  @override
  String aboutPageVersion(String? version, String? buildNumber) {
    return 'Version: $version ($buildNumber)';
  }

  @override
  String get aboutPageLoadingVersion => 'Version wird geladen...';

  @override
  String get aboutPageFollowUsTitle => 'Follow us';

  @override
  String get aboutPageFollowUsSubtitle =>
      'Folge uns auf unseren Kanälen, um immer auf dem neusten Stand zu bleiben.';

  @override
  String get aboutPageAboutSectionTitle => 'Was ist Sharezone?';

  @override
  String get aboutPageAboutSectionDescription =>
      'Sharezone ist ein vernetzter Schulplaner, welcher die Organisation von Schülern, Lehrkräften und Eltern aus der Steinzeit in das digitale Zeitalter katapultiert. Das Hausaufgabenheft, der Terminplaner, die Dateiablage und vieles weitere wird direkt mit der kompletten Klasse geteilt. Dabei ist keine Registrierung der Schule und die Leitung einer Lehrkraft notwendig, so dass du direkt durchstarten und deinen Schulalltag bequem und einfach gestalten kannst.';

  @override
  String get aboutPageAboutSectionVisitWebsite =>
      'Besuche für weitere Informationen einfach https://www.sharezone.net.';

  @override
  String aboutPageEmailCopiedConfirmation(String email_address) {
    return 'E-Mail: $email_address';
  }

  @override
  String get aboutPageTeamSectionTitle => 'Über uns';

  @override
  String get changeTypeOfUserPageTitle => 'Account-Type ändern';

  @override
  String get changeTypeOfUserPageErrorDialogTitle => 'Fehler';

  @override
  String changeTypeOfUserPageErrorDialogContentUnknown(Object? error) {
    return 'Fehler: $error. Bitte kontaktiere den Support.';
  }

  @override
  String get changeTypeOfUserPageErrorDialogContentNoTypeOfUserSelected =>
      'Es wurde kein Account-Typ ausgewählt.';

  @override
  String get changeTypeOfUserPageErrorDialogContentTypeOfUserHasNotChanged =>
      'Der Account-Typ hat sich nicht geändert.';

  @override
  String changeTypeOfUserPageErrorDialogContentChangedTypeOfUserTooOften(
      DateTime blockedUntil) {
    final intl.DateFormat blockedUntilDateFormat =
        intl.DateFormat.yMd(localeName);
    final String blockedUntilString =
        blockedUntilDateFormat.format(blockedUntil);

    return 'Du kannst nur alle 14 Tage 2x den Account-Typ ändern. Diese Limit wurde erreicht. Bitte warte bis $blockedUntilString.';
  }

  @override
  String get changeTypeOfUserPagePermissionNote =>
      'Beachte die folgende Hinweise:\n* Innerhalb von 14 Tagen kannst du nur 2x den Account-Typ ändern.\n* Durch das Ändern der Nutzer erhältst du keine weiteren Berechtigungen in den Gruppen. Ausschlaggebend sind die Gruppenberechtigungen (\"Administrator\", \"Aktives Mitglied\", \"Passives Mitglied\").';

  @override
  String get changeTypeOfUserPageRestartAppDialogTitle =>
      'Neustart erforderlich';

  @override
  String get changeTypeOfUserPageRestartAppDialogContent =>
      'Die Änderung deines Account-Typs war erfolgreich. Jedoch muss die App muss neu gestartet werden, damit die Änderung wirksam wird.';

  @override
  String get changePasswordPageTitle => 'Passwort ändern';

  @override
  String get changePasswordPageCurrentPasswordTextfieldLabel =>
      'Aktuelles Passwort';

  @override
  String get changePasswordPageNewPasswordTextfieldLabel => 'Neues Passwort';

  @override
  String get changePasswordPageResetCurrentPasswordButton =>
      'Aktuelles Passwort vergessen?';

  @override
  String get changePasswordPageResetCurrentPasswordDialogTitle =>
      'Passwort zurücksetzen';

  @override
  String get changePasswordPageResetCurrentPasswordDialogContent =>
      'Sollen wir dir eine E-Mail schicken, mit der du dein Passwort zurücksetzen kannst?';

  @override
  String get changePasswordPageResetCurrentPasswordLoading =>
      'Verschicken der E-Mail wird vorbereitet...';

  @override
  String get changePasswordPageResetCurrentPasswordEmailSentConfirmation =>
      'Wir haben eine E-Mail zum Zurücksetzen deines Passworts verschickt.';

  @override
  String get changeEmailAddressPageTitle => 'E-Mail ändern';

  @override
  String get changeEmailAddressPageCurrentEmailTextfieldLabel => 'Aktuell';

  @override
  String get changeEmailAddressPageNewEmailTextfieldLabel => 'Neu';

  @override
  String get changeEmailAddressPagePasswordTextfieldLabel => 'Passwort';

  @override
  String get changeEmailAddressPageNoteOnAutomaticSignOutSignIn =>
      'Hinweis: Wenn deine E-Mail geändert wurde, wirst du automatisch kurz ab- und sofort wieder angemeldet - also nicht wundern 😉';

  @override
  String get changeEmailAddressPageWhyWeNeedTheEmailInfoTitle =>
      'Wozu brauchen wir deine E-Mail?';

  @override
  String get changeEmailAddressPageWhyWeNeedTheEmailInfoContent =>
      'Die E-Mail benötigst du um dich anzumelden. Solltest du zufällig mal dein Passwort vergessen haben, können wir dir an diese E-Mail-Adresse einen Link zum Zurücksetzen des Passworts schicken. Deine E-Mail Adresse ist nur für dich sichtbar, und sonst niemanden.';

  @override
  String get changeStatePageTitle => 'Bundesland ändern';

  @override
  String get changeStatePageErrorLoadingState =>
      'Error beim Anzeigen der Bundesländer. Falls der Fehler besteht kontaktiere uns bitte.';

  @override
  String get changeStatePageErrorChangingState =>
      'Fehler beim Ändern deines Bundeslandes! :(';

  @override
  String get changeStatePageWhyWeNeedTheStateInfoTitle =>
      'Wozu brauchen wir dein Bundesland?';

  @override
  String get changeStatePageWhyWeNeedTheStateInfoContent =>
      'Mithilfe des Bundeslandes können wir die restlichen Tage bis zu den nächsten Ferien berechnen. Wenn du diese Angabe nicht machen möchtest, dann wähle beim Bundesland bitte einfach den Eintrag \"Anonym bleiben.\" aus.';

  @override
  String get stateBadenWuerttemberg => 'Baden-Württemberg';

  @override
  String get stateBayern => 'Bayern';

  @override
  String get stateBerlin => 'Berlin';

  @override
  String get stateBrandenburg => 'Brandenburg';

  @override
  String get stateBremen => 'Bremen';

  @override
  String get stateHamburg => 'Hamburg';

  @override
  String get stateHessen => 'Hessen';

  @override
  String get stateMecklenburgVorpommern => 'Mecklenburg-Vorpommern';

  @override
  String get stateNiedersachsen => 'Niedersachsen';

  @override
  String get stateNordrheinWestfalen => 'Nordrhein-Westfalen';

  @override
  String get stateRheinlandPfalz => 'Rheinland Pfalz';

  @override
  String get stateSaarland => 'Saarland';

  @override
  String get stateSachsen => 'Sachsen';

  @override
  String get stateSachsenAnhalt => 'Sachsen-Anhalt';

  @override
  String get stateSchleswigHolstein => 'Schleswig-Holstein';

  @override
  String get stateThueringen => 'Thüringen';

  @override
  String get stateNotFromGermany => 'Nicht aus Deutschland';

  @override
  String get stateAnonymous => 'Anonym bleiben';

  @override
  String get stateNotSelected => 'Nicht ausgewählt';

  @override
  String get myProfilePageTitle => 'Mein Konto';

  @override
  String get myProfilePageNameTile => 'Name';

  @override
  String get myProfilePageActivationCodeTile => 'Aktivierungscode eingeben';

  @override
  String get myProfilePageEmailTile => 'E-Mail';

  @override
  String get myProfilePageEmailNotChangeable =>
      'Dein Account ist mit einem Google-Konto verbunden. Aus diesem Grund kannst du deine E-Mail nicht ändern.';

  @override
  String get myProfilePageEmailAccountTypeTitle => 'Account-Typ';

  @override
  String get myProfilePageChangePasswordTile => 'Passwort ändern';

  @override
  String get myProfilePageChangedPasswordConfirmation =>
      'Das Passwort wurde erfolgreich geändert.';

  @override
  String get myProfilePageStateTile => 'Bundesland';

  @override
  String get myProfilePageSignInMethodTile => 'Anmeldemethode';

  @override
  String get myProfilePageSignInMethodChangeNotPossibleDialogTitle =>
      'Anmeldemethode ändern nicht möglich';

  @override
  String get myProfilePageSignInMethodChangeNotPossibleDialogContent =>
      'Die Anmeldemethode kann aktuell nur bei der Registrierung gesetzt werden. Später kann diese nicht mehr geändert werden.';

  @override
  String get myProfilePageSupportTeamTile => 'Entwickler unterstützen';

  @override
  String get myProfilePageSupportTeamDescription =>
      'Durch das Teilen von anonymen Nutzerdaten hilfst du uns, die App noch einfacher und benutzerfreundlicher zu machen.';

  @override
  String get myProfilePageCopyUserIdTile => 'User ID';

  @override
  String get myProfilePageCopyUserIdConfirmation => 'User ID wurde kopiert.';

  @override
  String get myProfilePageSignOutButton => 'Abmelden';

  @override
  String get myProfilePageDeleteAccountButton => 'Konto löschen';

  @override
  String get myProfilePageDeleteAccountDialogTitle =>
      'Sollte dein Account gelöscht werden, werden alle deine Daten gelöscht. Dieser Vorgang lässt sich nicht wieder rückgängig machen.';

  @override
  String get myProfilePageDeleteAccountDialogContent =>
      'Möchtest du deinen Account wirklich löschen?';

  @override
  String get myProfilePageDeleteAccountDialogPleaseEnterYourPassword =>
      'Bitte gib dein Passwort ein, um deinen Account zu löschen.';

  @override
  String get myProfilePageDeleteAccountDialogPasswordTextfieldLabel =>
      'Passwort';

  @override
  String get themePageTitle => 'Erscheinungsbild';

  @override
  String get themePageLightDarkModeSectionTitle => 'Heller & Dunkler Modus';

  @override
  String get themePageDarkMode => 'Dunkler Modus';

  @override
  String get themePageLightMode => 'Heller Modus';

  @override
  String get themePageSystemMode => 'System';

  @override
  String get themePageRateOurAppCardTitle => 'Gefällt dir Sharezone?';

  @override
  String get themePageRateOurAppCardContent =>
      'Falls dir Sharezone gefällt, würden wir uns über eine Bewertung sehr freuen! 🙏  Dir gefällt etwas nicht? Kontaktiere einfach den Support 👍';

  @override
  String get themePageRateOurAppCardRatingsNotAvailableOnWebDialogTitle =>
      'App-Bewertung nur über iOS & Android möglich!';

  @override
  String get themePageRateOurAppCardRatingsNotAvailableOnWebDialogContent =>
      'Über die Web-App kann die App nicht bewertet werden. Nimm dafür einfach dein Handy 👍';

  @override
  String get themePageRateOurAppCardRateButton => 'Bewerten';

  @override
  String get themePageNavigationExperimentSectionTitle =>
      'Experiment: Neue Navigation';

  @override
  String get themePageNavigationExperimentSectionContent =>
      'Wir testen aktuell eine neue Navigation. Bitte gib über die Feedback-Box oder unseren Discord-Server eine kurze Rückmeldung, wie du die jeweiligen Optionen findest.';

  @override
  String themePageNavigationExperimentOptionTile(int number, String name) {
    return 'Option $number: $name';
  }

  @override
  String get navigationExperimentOptionDrawerAndBnb => 'Aktuelle Navigation';

  @override
  String get navigationExperimentOptionExtendableBnb =>
      'Neue Navigation - Ohne Mehr-Button';

  @override
  String get navigationExperimentOptionExtendableBnbWithMoreButton =>
      'Neue Navigation - Mit Mehr-Button';

  @override
  String get timetableSettingsPageTitle => 'Stundenplan';

  @override
  String get timetableSettingsPagePeriodsFieldTileTitle => 'Stundenzeiten';

  @override
  String get timetableSettingsPagePeriodsFieldTileSubtitle =>
      'Stundenplanbeginn, Stundenlänge, etc.';

  @override
  String get timetableSettingsPageIcalLinksTitleTitle =>
      'Termine, Prüfungen, Stundenplan exportieren (iCal)';

  @override
  String get timetableSettingsPageIcalLinksTitleSubtitle =>
      'Synchronisierung mit Google Kalender, Apple Kalender usw.';

  @override
  String get timetableSettingsPageIcalLinksPlusDialogContent =>
      'Mit einem iCal-Link kannst du deinen Stundenplan und deine Termine in andere Kalender-Apps (wie z.B. Google Kalender, Apple Kalender) einbinden. Sobald sich dein Stundenplan oder deine Termine ändern, werden diese auch in deinen anderen Kalender Apps aktualisiert.\n\nAnders als beim \"Zum Kalender hinzufügen\" Button, musst du dich nicht darum kümmern, den Termin in deiner Kalender App zu aktualisieren, wenn sich etwas in Sharezone ändert.\n\niCal-Links ist nur für dich sichtbar und können nicht von anderen Personen eingesehen werden.\n\nBitte beachte, dass aktuell nur Termine und Prüfungen exportiert werden können. Die Schulstunden können noch nicht exportiert werden.';

  @override
  String get timetableSettingsPageEnabledWeekDaysTileTitle =>
      'Aktivierte Wochentage';

  @override
  String get timetableSettingsPageLessonLengthTileTile => 'Länge einer Stunde';

  @override
  String get timetableSettingsPageLessonLengthTileSubtile =>
      'Länge einer Stunde';

  @override
  String timetableSettingsPageLessonLengthTileTrailing(int length) {
    return '$length Min.';
  }

  @override
  String get timetableSettingsPageLessonLengthSavedConfirmation =>
      'Länge einer Stunde wurde gespeichert.';

  @override
  String get timetableSettingsPageLessonLengthEditDialog =>
      'Wähle die Länge der Stunde in Minuten aus.';

  @override
  String get timetableSettingsPageIsFiveMinutesIntervalActiveTileTitle =>
      'Fünf-Minuten-Intervall beim Time-Picker';

  @override
  String get timetableSettingsPageShowLessonsAbbreviation =>
      'Kürzel im Stundenplan anzeigen';

  @override
  String get timetableSettingsPageABWeekTileTitle => 'A/B Wochen';

  @override
  String get timetableSettingsPageAWeeksAreEvenSwitch =>
      'A-Wochen sind gerade Kalenderwochen';

  @override
  String timetableSettingsPageThisWeekIs(
      Object calendar_week, Object even_or_odd_week, Object is_a_week_even) {
    return 'Diese Woche ist Kalenderwoche $calendar_week. A-Wochen sind $is_a_week_even Kalenderwochen und somit ist aktuell eine $even_or_odd_week';
  }
}
