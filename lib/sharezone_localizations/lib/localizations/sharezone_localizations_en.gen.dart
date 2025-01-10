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
  String get commonActionsSave => 'Save';

  @override
  String get commonActionsClose => 'Close';

  @override
  String get commonActionsOk => 'OK';

  @override
  String get commonActionsYes => 'Yes';

  @override
  String get commonActionsAlright => 'Alright';

  @override
  String get commonActionsDelete => 'Delete';

  @override
  String get commonActionsContactSupport => 'Contact support';

  @override
  String commonDisplayError(String? error) {
    return 'Error: $error';
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
  String get contactSupportButton => 'Contact support';

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
  String get aboutPageLoadingVersion => 'Loading version...';

  @override
  String get aboutPageFollowUsTitle => 'Follow us';

  @override
  String get aboutPageFollowUsSubtitle =>
      'Follow us on our channels to stay up to date.';

  @override
  String get aboutPageAboutSectionTitle => 'What is Sharezone?';

  @override
  String get aboutPageAboutSectionDescription =>
      'Sharezone is a connected school planner that catapults the organization of students, teachers, and parents from the Stone Age into the digital age. The homework diary, the schedule, the file storage, and much more are shared directly with the entire class. No school registration or teacher management is required, so you can get started right away and organize your school day easily and conveniently.';

  @override
  String get aboutPageAboutSectionVisitWebsite =>
      'For more information, simply visit https://www.sharezone.net.';

  @override
  String aboutPageEmailCopiedConfirmation(String email_address) {
    return 'Email: $email_address';
  }

  @override
  String get aboutPageTeamSectionTitle => 'About Us';

  @override
  String get changeTypeOfUserPageTitle => 'Change Account Type';

  @override
  String get changeTypeOfUserPageErrorDialogTitle => 'Error';

  @override
  String changeTypeOfUserPageErrorDialogContentUnknown(Object? error) {
    return 'Error: $error. Please contact support.';
  }

  @override
  String get changeTypeOfUserPageErrorDialogContentNoTypeOfUserSelected =>
      'No account type selected.';

  @override
  String get changeTypeOfUserPageErrorDialogContentTypeOfUserHasNotChanged =>
      'The account type has not changed.';

  @override
  String changeTypeOfUserPageErrorDialogContentChangedTypeOfUserTooOften(
      DateTime blockedUntil) {
    final intl.DateFormat blockedUntilDateFormat =
        intl.DateFormat.yMd(localeName);
    final String blockedUntilString =
        blockedUntilDateFormat.format(blockedUntil);

    return 'You can only change your account type twice every 14 days. This limit has been reached. Please wait until $blockedUntilString.';
  }

  @override
  String get changeTypeOfUserPagePermissionNote =>
      'Please note the following:\n* You can only change your account type twice within 14 days.\n* Changing the user type does not grant you any further permissions in the groups. The group permissions (\"Administrator\", \"Active Member\", \"Passive Member\") are decisive.';

  @override
  String get changeTypeOfUserPageRestartAppDialogTitle => 'Restart Required';

  @override
  String get changeTypeOfUserPageRestartAppDialogContent =>
      'Your account type has been changed successfully. However, the app must be restarted for the change to take effect.';

  @override
  String get changePasswordPageTitle => 'Change Password';

  @override
  String get changePasswordPageCurrentPasswordTextfieldLabel =>
      'Current Password';

  @override
  String get changePasswordPageNewPasswordTextfieldLabel => 'New Password';

  @override
  String get changePasswordPageResetCurrentPasswordButton =>
      'Forgot current password?';

  @override
  String get changePasswordPageResetCurrentPasswordDialogTitle =>
      'Reset Password';

  @override
  String get changePasswordPageResetCurrentPasswordDialogContent =>
      'Should we send you an email to reset your password?';

  @override
  String get changePasswordPageResetCurrentPasswordLoading =>
      'Preparing to send email...';

  @override
  String get changePasswordPageResetCurrentPasswordEmailSentConfirmation =>
      'We\'ve sent you an email to reset your password.';

  @override
  String get changeEmailAddressPageTitle => 'Change Email';

  @override
  String get changeEmailAddressPageCurrentEmailTextfieldLabel => 'Current';

  @override
  String get changeEmailAddressPageNewEmailTextfieldLabel => 'New';

  @override
  String get changeEmailAddressPagePasswordTextfieldLabel => 'Password';

  @override
  String get changeEmailAddressPageNoteOnAutomaticSignOutSignIn =>
      'Note: If your email is changed, you\'ll be automatically signed out and back in - so don\'t be surprised 😉';

  @override
  String get changeEmailAddressPageWhyWeNeedTheEmailInfoTitle =>
      'Why do we need your email?';

  @override
  String get changeEmailAddressPageWhyWeNeedTheEmailInfoContent =>
      'You need your email to log in. If you happen to forget your password, we can send you a link to reset your password to this email address. Your email address is only visible to you, and no one else.';

  @override
  String get changeStatePageTitle => 'Change State';

  @override
  String get changeStatePageErrorLoadingState =>
      'Error displaying the states. If the error persists, please contact us.';

  @override
  String get changeStatePageErrorChangingState =>
      'Error changing your state! :(';

  @override
  String get changeStatePageWhyWeNeedTheStateInfoTitle =>
      'Why do we need your state?';

  @override
  String get changeStatePageWhyWeNeedTheStateInfoContent =>
      'With the help of the state, we can calculate the remaining days until the next holidays. If you do not want to provide this information, please select \"Remain anonymous\" for the state.';

  @override
  String get stateBadenWuerttemberg => 'Baden-Württemberg';

  @override
  String get stateBayern => 'Bavaria';

  @override
  String get stateBerlin => 'Berlin';

  @override
  String get stateBrandenburg => 'Brandenburg';

  @override
  String get stateBremen => 'Bremen';

  @override
  String get stateHamburg => 'Hamburg';

  @override
  String get stateHessen => 'Hesse';

  @override
  String get stateMecklenburgVorpommern => 'Mecklenburg-Vorpommern';

  @override
  String get stateNiedersachsen => 'Lower Saxony';

  @override
  String get stateNordrheinWestfalen => 'North Rhine-Westphalia';

  @override
  String get stateRheinlandPfalz => 'Rhineland-Palatinate';

  @override
  String get stateSaarland => 'Saarland';

  @override
  String get stateSachsen => 'Saxony';

  @override
  String get stateSachsenAnhalt => 'Saxony-Anhalt';

  @override
  String get stateSchleswigHolstein => 'Schleswig-Holstein';

  @override
  String get stateThueringen => 'Thuringia';

  @override
  String get stateNotFromGermany => 'Not from Germany';

  @override
  String get stateAnonymous => 'Remain anonymous';

  @override
  String get stateNotSelected => 'Not selected';

  @override
  String get myProfilePageTitle => 'My Account';

  @override
  String get myProfilePageNameTile => 'Name';

  @override
  String get myProfilePageActivationCodeTile => 'Enter Activation Code';

  @override
  String get myProfilePageEmailTile => 'Email';

  @override
  String get myProfilePageEmailNotChangeable =>
      'Your account is linked to a Google account. Therefore, you cannot change your email.';

  @override
  String get myProfilePageEmailAccountTypeTitle => 'Account Type';

  @override
  String get myProfilePageChangePasswordTile => 'Change Password';

  @override
  String get myProfilePageChangedPasswordConfirmation =>
      'Password changed successfully.';

  @override
  String get myProfilePageStateTile => 'State';

  @override
  String get myProfilePageSignInMethodTile => 'Sign-in Method';

  @override
  String get myProfilePageSignInMethodChangeNotPossibleDialogTitle =>
      'Cannot change sign-in method';

  @override
  String get myProfilePageSignInMethodChangeNotPossibleDialogContent =>
      'The sign-in method can currently only be set during registration. It cannot be changed later.';

  @override
  String get myProfilePageSupportTeamTile => 'Support the Developers';

  @override
  String get myProfilePageSupportTeamDescription =>
      'By sharing anonymous user data, you help us make the app even easier and more user-friendly.';

  @override
  String get myProfilePageCopyUserIdTile => 'User ID';

  @override
  String get myProfilePageCopyUserIdConfirmation => 'User ID copied.';

  @override
  String get myProfilePageSignOutButton => 'Sign out';

  @override
  String get myProfilePageDeleteAccountButton => 'Delete Account';

  @override
  String get myProfilePageDeleteAccountDialogTitle =>
      'If your account is deleted, all your data will be deleted. This process cannot be undone.';

  @override
  String get myProfilePageDeleteAccountDialogContent =>
      'Do you really want to delete your account?';

  @override
  String get myProfilePageDeleteAccountDialogPleaseEnterYourPassword =>
      'Please enter your password to delete your account.';

  @override
  String get myProfilePageDeleteAccountDialogPasswordTextfieldLabel =>
      'Password';

  @override
  String get themePageTitle => 'Appearance';

  @override
  String get themePageLightDarkModeSectionTitle => 'Light & Dark Mode';

  @override
  String get themePageDarkMode => 'Dark Mode';

  @override
  String get themePageLightMode => 'Light Mode';

  @override
  String get themePageSystemMode => 'System';

  @override
  String get themePageRateOurAppCardTitle => 'Do you like Sharezone?';

  @override
  String get themePageRateOurAppCardContent =>
      'If you like Sharezone, we would really appreciate a rating! 🙏 Don\'t like something? Just contact support 👍';

  @override
  String get themePageRateOurAppCardRatingsNotAvailableOnWebDialogTitle =>
      'App rating only possible via iOS & Android!';

  @override
  String get themePageRateOurAppCardRatingsNotAvailableOnWebDialogContent =>
      'The app cannot be rated via the web app. Just use your phone 👍';

  @override
  String get themePageRateOurAppCardRateButton => 'Rate';

  @override
  String get themePageNavigationExperimentSectionTitle =>
      'Experiment: New Navigation';

  @override
  String get themePageNavigationExperimentSectionContent =>
      'We are currently testing a new navigation. Please give us a short feedback via the feedback box or our Discord server on how you like the respective options.';

  @override
  String themePageNavigationExperimentOptionTile(int number, String name) {
    return 'Option $number: $name';
  }

  @override
  String get navigationExperimentOptionDrawerAndBnb => 'Current Navigation';

  @override
  String get navigationExperimentOptionExtendableBnb =>
      'New Navigation - Without More Button';

  @override
  String get navigationExperimentOptionExtendableBnbWithMoreButton =>
      'New Navigation - With More Button';

  @override
  String get timetableSettingsPageTitle => 'Timetable';

  @override
  String get timetableSettingsPagePeriodsFieldTileTitle => 'Class Times';

  @override
  String get timetableSettingsPagePeriodsFieldTileSubtitle =>
      'Timetable start, lesson length, etc.';

  @override
  String get timetableSettingsPageIcalLinksTitleTitle =>
      'Export appointments, exams, timetable (iCal)';

  @override
  String get timetableSettingsPageIcalLinksTitleSubtitle =>
      'Synchronization with Google Calendar, Apple Calendar etc.';

  @override
  String get timetableSettingsPageIcalLinksPlusDialogContent =>
      'With an iCal link you can integrate your timetable and appointments into other calendar apps (such as Google Calendar, Apple Calendar). As soon as your timetable or appointments change, they will also be updated in your other calendar apps.\n\nUnlike the \"Add to Calendar\" button, you don\'t have to worry about updating the appointment in your calendar app if something changes in Sharezone.\n\niCal links are only visible to you and cannot be viewed by other people.\n\nPlease note that currently only appointments and exams can be exported. School lessons cannot be exported yet.';

  @override
  String get timetableSettingsPageEnabledWeekDaysTileTitle =>
      'Enabled Weekdays';

  @override
  String get timetableSettingsPageLessonLengthTileTile => 'Lesson Length';

  @override
  String get timetableSettingsPageLessonLengthTileSubtile =>
      'Length of a lesson';

  @override
  String timetableSettingsPageLessonLengthTileTrailing(int length) {
    return '$length Min.';
  }

  @override
  String get timetableSettingsPageLessonLengthSavedConfirmation =>
      'Lesson length has been saved.';

  @override
  String get timetableSettingsPageLessonLengthEditDialog =>
      'Select the lesson length in minutes.';

  @override
  String get timetableSettingsPageIsFiveMinutesIntervalActiveTileTitle =>
      'Five-minute interval for the time picker';

  @override
  String get timetableSettingsPageShowLessonsAbbreviation =>
      'Show abbreviations in timetable';

  @override
  String get timetableSettingsPageABWeekTileTitle => 'A/B Weeks';

  @override
  String get timetableSettingsPageAWeeksAreEvenSwitch =>
      'A-weeks are even calendar weeks';

  @override
  String timetableSettingsPageThisWeekIs(
      int calendar_week, String is_a_week_even, String even_or_odd_week) {
    return 'This week is calendar week $calendar_week. A-weeks are $is_a_week_even calendar weeks and therefore it is currently a $even_or_odd_week';
  }
}
