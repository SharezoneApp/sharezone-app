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

/// The translations for English (`en`).
class SharezoneLocalizationsEn extends SharezoneLocalizations {
  SharezoneLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String aboutEmailCopiedConfirmation(String email_address) {
    return 'Email: $email_address';
  }

  @override
  String get aboutFollowUsSubtitle =>
      'Follow us on our channels to stay up to date.';

  @override
  String get aboutFollowUsTitle => 'Follow us';

  @override
  String get aboutHeaderSubtitle => 'The connected school planner';

  @override
  String get aboutHeaderTitle => 'Sharezone';

  @override
  String get aboutLoadingVersion => 'Loading version...';

  @override
  String get aboutSectionDescription =>
      'Sharezone is a connected school planner that catapults the organization of students, teachers, and parents from the Stone Age into the digital age. The homework diary, the schedule, the file storage, and much more are shared directly with the entire class. No school registration or teacher management is required, so you can get started right away and organize your school day easily and conveniently.';

  @override
  String get aboutSectionTitle => 'What is Sharezone?';

  @override
  String get aboutSectionVisitWebsite =>
      'For more information, simply visit https://www.sharezone.net.';

  @override
  String get aboutTeamSectionTitle => 'About Us';

  @override
  String get aboutTitle => 'About us';

  @override
  String aboutVersion(String? buildNumber, String? version) {
    return 'Version: $version ($buildNumber)';
  }

  @override
  String get appName => 'Sharezone';

  @override
  String get changeEmailAddressCurrentEmailTextfieldLabel => 'Current';

  @override
  String get changeEmailAddressNewEmailTextfieldLabel => 'New';

  @override
  String get changeEmailAddressNoteOnAutomaticSignOutSignIn =>
      'Note: If your email is changed, you\'ll be automatically signed out and back in - so don\'t be surprised 😉';

  @override
  String get changeEmailAddressPasswordTextfieldLabel => 'Password';

  @override
  String get changeEmailAddressTitle => 'Change Email';

  @override
  String get changeEmailAddressWhyWeNeedTheEmailInfoContent =>
      'You need your email to log in. If you happen to forget your password, we can send you a link to reset your password to this email address. Your email address is only visible to you, and no one else.';

  @override
  String get changeEmailAddressWhyWeNeedTheEmailInfoTitle =>
      'Why do we need your email?';

  @override
  String get changePasswordCurrentPasswordTextfieldLabel => 'Current Password';

  @override
  String get changePasswordLoadingSnackbarText =>
      'New password is sent to the head office...';

  @override
  String get changePasswordNewPasswordTextfieldLabel => 'New Password';

  @override
  String get changePasswordResetCurrentPasswordButton =>
      'Forgot current password?';

  @override
  String get changePasswordResetCurrentPasswordDialogContent =>
      'Should we send you an email to reset your password?';

  @override
  String get changePasswordResetCurrentPasswordDialogTitle => 'Reset Password';

  @override
  String get changePasswordResetCurrentPasswordEmailSentConfirmation =>
      'We\'ve sent you an email to reset your password.';

  @override
  String get changePasswordResetCurrentPasswordLoading =>
      'Preparing to send email...';

  @override
  String get changePasswordTitle => 'Change Password';

  @override
  String get changeStateErrorChangingState => 'Error changing your state! :(';

  @override
  String get changeStateErrorLoadingState =>
      'Error displaying the states. If the error persists, please contact us.';

  @override
  String get changeStateTitle => 'Change State';

  @override
  String get changeStateWhyWeNeedTheStateInfoContent =>
      'With the help of the state, we can calculate the remaining days until the next holidays. If you do not want to provide this information, please select \"Remain anonymous\" for the state.';

  @override
  String get changeStateWhyWeNeedTheStateInfoTitle =>
      'Why do we need your state?';

  @override
  String changeTypeOfUserErrorDialogContentChangedTypeOfUserTooOften(
    DateTime blockedUntil,
  ) {
    final intl.DateFormat blockedUntilDateFormat =
        intl.DateFormat.yMd(localeName).add_jm();
    final String blockedUntilString = blockedUntilDateFormat.format(
      blockedUntil,
    );

    return 'You can only change your account type twice every 14 days. This limit has been reached. Please wait until $blockedUntilString.';
  }

  @override
  String get changeTypeOfUserErrorDialogContentNoTypeOfUserSelected =>
      'No account type selected.';

  @override
  String get changeTypeOfUserErrorDialogContentTypeOfUserHasNotChanged =>
      'The account type has not changed.';

  @override
  String changeTypeOfUserErrorDialogContentUnknown(Object? error) {
    return 'Error: $error. Please contact support.';
  }

  @override
  String get changeTypeOfUserErrorDialogTitle => 'Error';

  @override
  String get changeTypeOfUserPermissionNote =>
      'Please note the following:\n* You can only change your account type twice within 14 days.\n* Changing the user type does not grant you any further permissions in the groups. The group permissions (\"Administrator\", \"Active Member\", \"Passive Member\") are decisive.';

  @override
  String get changeTypeOfUserRestartAppDialogContent =>
      'Your account type has been changed successfully. However, the app must be restarted for the change to take effect.';

  @override
  String get changeTypeOfUserRestartAppDialogTitle => 'Restart Required';

  @override
  String get changeTypeOfUserTitle => 'Change Account Type';

  @override
  String get commonActionBack => 'Back';

  @override
  String get commonActionChange => 'Change';

  @override
  String get commonActionsAlright => 'Alright';

  @override
  String get commonActionsCancel => 'Cancel';

  @override
  String get commonActionsClose => 'Close';

  @override
  String get commonActionsCloseUppercase => 'CLOSE';

  @override
  String get commonActionsConfirm => 'Confirm';

  @override
  String get commonActionsContactSupport => 'Contact support';

  @override
  String get commonActionsDelete => 'Delete';

  @override
  String get commonActionsOk => 'OK';

  @override
  String get commonActionsSave => 'Save';

  @override
  String get commonActionsYes => 'Yes';

  @override
  String commonDisplayError(String? error) {
    return 'Error: $error';
  }

  @override
  String get contactSupportButton => 'Contact support';

  @override
  String get countryAustria => 'Austria';

  @override
  String get countryGermany => 'Germany';

  @override
  String get countrySwitzerland => 'Switzerland';

  @override
  String get dashboardSelectStateButton => 'Select state / canton';

  @override
  String get imprintTitle => 'Imprint';

  @override
  String get languageDeName => 'German';

  @override
  String get languageEnName => 'English';

  @override
  String get languageSystemName => 'System';

  @override
  String get languageTitle => 'Language';

  @override
  String get myProfileActivationCodeTile => 'Enter Activation Code';

  @override
  String get myProfileChangePasswordTile => 'Change Password';

  @override
  String get myProfileChangedPasswordConfirmation =>
      'Password changed successfully.';

  @override
  String get myProfileCopyUserIdConfirmation => 'User ID copied.';

  @override
  String get myProfileCopyUserIdTile => 'User ID';

  @override
  String get myProfileDeleteAccountButton => 'Delete Account';

  @override
  String get myProfileDeleteAccountDialogContent =>
      'Do you really want to delete your account?';

  @override
  String get myProfileDeleteAccountDialogPasswordTextfieldLabel => 'Password';

  @override
  String get myProfileDeleteAccountDialogPleaseEnterYourPassword =>
      'Please enter your password to delete your account.';

  @override
  String get myProfileDeleteAccountDialogTitle =>
      'If your account is deleted, all your data will be deleted. This process cannot be undone.';

  @override
  String get myProfileEmailAccountTypeTitle => 'Account Type';

  @override
  String get myProfileEmailNotChangeable =>
      'Your account is linked to a Google account. Therefore, you cannot change your email.';

  @override
  String get myProfileEmailTile => 'Email';

  @override
  String get myProfileNameTile => 'Name';

  @override
  String get myProfileSignInMethodChangeNotPossibleDialogContent =>
      'The sign-in method can currently only be set during registration. It cannot be changed later.';

  @override
  String get myProfileSignInMethodChangeNotPossibleDialogTitle =>
      'Cannot change sign-in method';

  @override
  String get myProfileSignInMethodTile => 'Sign-in Method';

  @override
  String get myProfileSignOutButton => 'Sign out';

  @override
  String get myProfileStateTile => 'State';

  @override
  String get myProfileSupportTeamDescription =>
      'By sharing anonymous user data, you help us make the app even easier and more user-friendly.';

  @override
  String get myProfileSupportTeamTile => 'Support the Developers';

  @override
  String get myProfileTitle => 'My Account';

  @override
  String get navigationExperimentOptionDrawerAndBnb => 'Current Navigation';

  @override
  String get navigationExperimentOptionExtendableBnb =>
      'New Navigation - Without More Button';

  @override
  String get navigationExperimentOptionExtendableBnbWithMoreButton =>
      'New Navigation - With More Button';

  @override
  String selectStateDialogConfirmationSnackBar(String region) {
    return 'Selected $region';
  }

  @override
  String get selectStateDialogSelectBundesland => 'Select state';

  @override
  String get selectStateDialogSelectCanton => 'Select canton';

  @override
  String get selectStateDialogSelectCountryTitle => 'Select country';

  @override
  String get selectStateDialogStayAnonymous =>
      'I would like to remain anonymous';

  @override
  String get socialDiscord => 'Discord';

  @override
  String get socialEmail => 'Email';

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
  String get stateAnonymous => 'Remain anonymous';

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
  String get stateBayern => 'Bavaria';

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
  String get stateFribourg => 'Fribourg';

  @override
  String get stateGeneva => 'Geneva';

  @override
  String get stateGlarus => 'Glarus';

  @override
  String get stateGraubuenden => 'Graubünden';

  @override
  String get stateHamburg => 'Hamburg';

  @override
  String get stateHessen => 'Hesse';

  @override
  String get stateJura => 'Jura';

  @override
  String get stateKaernten => 'Carinthia';

  @override
  String get stateLuzern => 'Lucerne';

  @override
  String get stateMecklenburgVorpommern => 'Mecklenburg-Vorpommern';

  @override
  String get stateNeuchatel => 'Neuchâtel';

  @override
  String get stateNidwalden => 'Nidwalden';

  @override
  String get stateNiederoesterreich => 'Lower Austria';

  @override
  String get stateNiedersachsen => 'Lower Saxony';

  @override
  String get stateNordrheinWestfalen => 'North Rhine-Westphalia';

  @override
  String get stateNotFromGermany => 'Not from Germany';

  @override
  String get stateNotSelected => 'Not selected';

  @override
  String get stateOberoesterreich => 'Upper Austria';

  @override
  String get stateObwalden => 'Obwalden';

  @override
  String get stateRheinlandPfalz => 'Rhineland-Palatinate';

  @override
  String get stateSaarland => 'Saarland';

  @override
  String get stateSachsen => 'Saxony';

  @override
  String get stateSachsenAnhalt => 'Saxony-Anhalt';

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
  String get stateSteiermark => 'Styria';

  @override
  String get stateThueringen => 'Thuringia';

  @override
  String get stateThurgau => 'Thurgau';

  @override
  String get stateTicino => 'Ticino';

  @override
  String get stateTirol => 'Tyrol';

  @override
  String get stateUri => 'Uri';

  @override
  String get stateValais => 'Valais';

  @override
  String get stateVaud => 'Vaud';

  @override
  String get stateVorarlberg => 'Vorarlberg';

  @override
  String get stateWien => 'Vienna';

  @override
  String get stateZug => 'Zug';

  @override
  String get stateZurich => 'Zurich';

  @override
  String get themeDarkMode => 'Dark Mode';

  @override
  String get themeLightDarkModeSectionTitle => 'Light & Dark Mode';

  @override
  String get themeLightMode => 'Light Mode';

  @override
  String themeNavigationExperimentOptionTile(String name, int number) {
    return 'Option $number: $name';
  }

  @override
  String get themeNavigationExperimentSectionContent =>
      'We are currently testing a new navigation. Please give us a short feedback via the feedback box or our Discord server on how you like the respective options.';

  @override
  String get themeNavigationExperimentSectionTitle =>
      'Experiment: New Navigation';

  @override
  String get themeRateOurAppCardContent =>
      'If you like Sharezone, we would really appreciate a rating! 🙏 Don\'t like something? Just contact support 👍';

  @override
  String get themeRateOurAppCardRateButton => 'Rate';

  @override
  String get themeRateOurAppCardRatingsNotAvailableOnWebDialogContent =>
      'The app cannot be rated via the web app. Just use your phone 👍';

  @override
  String get themeRateOurAppCardRatingsNotAvailableOnWebDialogTitle =>
      'App rating only possible via iOS & Android!';

  @override
  String get themeRateOurAppCardTitle => 'Do you like Sharezone?';

  @override
  String get themeSystemMode => 'System';

  @override
  String get themeTitle => 'Appearance';

  @override
  String get timetableSettingsABWeekTileTitle => 'A/B Weeks';

  @override
  String get timetableSettingsAWeeksAreEvenSwitch =>
      'A-weeks are even calendar weeks';

  @override
  String get timetableSettingsEnabledWeekDaysTileTitle => 'Enabled Weekdays';

  @override
  String get timetableSettingsIcalLinksPlusDialogContent =>
      'With an iCal link you can integrate your timetable and appointments into other calendar apps (such as Google Calendar, Apple Calendar). As soon as your timetable or appointments change, they will also be updated in your other calendar apps.\n\nUnlike the \"Add to Calendar\" button, you don\'t have to worry about updating the appointment in your calendar app if something changes in Sharezone.\n\niCal links are only visible to you and cannot be viewed by other people.\n\nPlease note that currently only appointments and exams can be exported. School lessons cannot be exported yet.';

  @override
  String get timetableSettingsIcalLinksTitleSubtitle =>
      'Synchronization with Google Calendar, Apple Calendar etc.';

  @override
  String get timetableSettingsIcalLinksTitleTitle =>
      'Export appointments, exams, timetable (iCal)';

  @override
  String get timetableSettingsIsFiveMinutesIntervalActiveTileTitle =>
      'Five-minute interval for the time picker';

  @override
  String get timetableSettingsLessonLengthEditDialog =>
      'Select the lesson length in minutes.';

  @override
  String get timetableSettingsLessonLengthSavedConfirmation =>
      'Lesson length has been saved.';

  @override
  String get timetableSettingsLessonLengthTileSubtitle => 'Length of a lesson';

  @override
  String get timetableSettingsLessonLengthTileTitle => 'Lesson Length';

  @override
  String timetableSettingsLessonLengthTileTrailing(int length) {
    return '$length Min.';
  }

  @override
  String get timetableSettingsPeriodsFieldTileSubtitle =>
      'Timetable start, lesson length, etc.';

  @override
  String get timetableSettingsPeriodsFieldTileTitle => 'Class Times';

  @override
  String get timetableSettingsShowLessonsAbbreviation =>
      'Show abbreviations in timetable';

  @override
  String timetableSettingsThisWeekIs(
    int calendar_week,
    String even_or_odd_week,
    String is_a_week_even,
  ) {
    return 'This week is calendar week $calendar_week. A-weeks are $is_a_week_even calendar weeks and therefore it is currently a $even_or_odd_week';
  }

  @override
  String get timetableSettingsTitle => 'Timetable';
}
