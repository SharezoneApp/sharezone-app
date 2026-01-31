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
  String get accountEditProfileTooltip => 'Edit profile';

  @override
  String get accountLinkAppleConfirmation =>
      'Your account has been linked to an Apple account.';

  @override
  String get accountLinkGoogleConfirmation =>
      'Your account has been linked to a Google account.';

  @override
  String get accountPageTitle => 'Profile';

  @override
  String get accountPageWebLoginTooltip => 'QR code login for the web app';

  @override
  String get accountStateTitle => 'State';

  @override
  String get appName => 'Sharezone';

  @override
  String get changeEmailAddressCurrentEmailTextfieldLabel => 'Current';

  @override
  String get changeEmailAddressIdenticalError =>
      'The email you entered is identical to the old one! 🙈';

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
  String get registerAccountAgeNoticeText =>
      'Sign up now and transfer your data! For data protection reasons, registration is only permitted from the age of 16.';

  @override
  String get registerAccountAnonymousInfoTitle =>
      'You\'re only signed in anonymously!';

  @override
  String get registerAccountAppleButtonLong => 'Sign in with Apple';

  @override
  String get registerAccountAppleButtonShort => 'Apple';

  @override
  String get registerAccountBenefitBackupSubtitle =>
      'Keep access to your data if you lose your smartphone.';

  @override
  String get registerAccountBenefitBackupTitle => 'Automatic backup';

  @override
  String get registerAccountBenefitMultiDeviceSubtitle =>
      'Data is synchronized across multiple devices.';

  @override
  String get registerAccountBenefitMultiDeviceTitle =>
      'Use on multiple devices';

  @override
  String get registerAccountBenefitsIntro =>
      'Transfer your account to a real one now to benefit from the following advantages:';

  @override
  String get registerAccountEmailAlreadyUsedContent =>
      'It looks like you accidentally created a second Sharezone account. Simply delete this account and sign in with your real account.\n\nIf you\'re not sure how that works, we\'ve prepared instructions for you :)';

  @override
  String get registerAccountEmailAlreadyUsedTitle =>
      'This email is already in use!';

  @override
  String get registerAccountEmailButtonLong => 'Sign in with email';

  @override
  String get registerAccountEmailButtonShort => 'Email';

  @override
  String get registerAccountEmailLinkConfirmation =>
      'Your account has been linked to an email account.';

  @override
  String get registerAccountGoogleButtonLong => 'Sign in with Google';

  @override
  String get registerAccountGoogleButtonShort => 'Google';

  @override
  String get registerAccountShowInstructionAction => 'Show instructions';

  @override
  String get reportDescriptionHelperText =>
      'Please describe why you want to report this content. Give us as much information as possible so we can process the case quickly and safely.';

  @override
  String get reportDescriptionLabel => 'Description';

  @override
  String get reportDialogContent =>
      'We will process the case as soon as possible!\n\nPlease note that repeated misuse of the report system may have consequences for you (e.g. blocking your account).';

  @override
  String get reportDialogSendAction => 'Send';

  @override
  String get reportItemTypeBlackboard => 'Blackboard post';

  @override
  String get reportItemTypeComment => 'Comment';

  @override
  String get reportItemTypeCourse => 'Course';

  @override
  String get reportItemTypeEvent => 'Event / Exam';

  @override
  String get reportItemTypeFile => 'File';

  @override
  String get reportItemTypeHomework => 'Homework';

  @override
  String get reportItemTypeLesson => 'Lesson';

  @override
  String get reportItemTypeSchoolClass => 'School class';

  @override
  String get reportItemTypeUser => 'User';

  @override
  String get reportMissingInformation =>
      'Please provide a reason and a description.';

  @override
  String reportPageTitle(String itemType) {
    return 'Report $itemType';
  }

  @override
  String get reportReasonBullying => 'Bullying';

  @override
  String get reportReasonIllegalContent => 'Illegal content';

  @override
  String get reportReasonOther => 'Other';

  @override
  String get reportReasonPornographicContent => 'Pornographic content';

  @override
  String get reportReasonSpam => 'Spam';

  @override
  String get reportReasonViolentContent => 'Violent or repulsive content';

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
  String get stateAnonymous => 'Remain anonymous';

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
  String get stateNotFromGermany => 'Not from Germany';

  @override
  String get stateNotSelected => 'Not selected';

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

  @override
  String get useAccountInstructionsAppBarTitle => 'Instructions';

  @override
  String get useAccountInstructionsHeadline =>
      'How do I use Sharezone on multiple devices?';

  @override
  String get useAccountInstructionsStep =>
      '1. Go back to your profile\n2. Sign out using the sign-out icon at the top right.\n3. Confirm that your account will be deleted in the process.\n4. Tap the button \"Already have an account? Then...\" at the bottom.\n5. Sign in.';

  @override
  String get useAccountInstructionsStepsTitle => 'Steps:';

  @override
  String get useAccountInstructionsVideoTitle => 'Video:';

  @override
  String get userEditLoadingUserSnackbar => 'Loading information! Please wait.';

  @override
  String get userEditNameChangedConfirmation =>
      'Your name has been successfully changed.';

  @override
  String get userEditPageTitle => 'Edit name';

  @override
  String get userEditSubmitFailed =>
      'The process could not be completed correctly. Please contact support!';

  @override
  String get userEditSubmittingSnackbar => 'Data is being sent to Frankfurt...';

  @override
  String get activationCodeCacheCleared =>
      'Cache cleared. You may need to restart the app to see the changes.';

  @override
  String get activationCodeFeatureAdsLabel => 'Ads';

  @override
  String get activationCodeFeatureL10nLabel => 'l10n';

  @override
  String get activationCodeToggleDisabled => 'disabled';

  @override
  String get activationCodeToggleEnabled => 'enabled';

  @override
  String activationCodeToggleResult(String feature, String state) {
    return '$feature was $state. Restart the app to see the changes.';
  }

  @override
  String get feedbackDetailsCommentsTitle => 'Comments:';

  @override
  String get feedbackDetailsLoadingHeardFrom => 'Friend';

  @override
  String get feedbackDetailsLoadingMissing => 'Great app!';

  @override
  String get feedbackDetailsPageTitle => 'Feedback details';

  @override
  String get feedbackDetailsResponseHint => 'Write a reply...';

  @override
  String feedbackDetailsSendError(String error) {
    return 'Failed to send the message: $error';
  }

  @override
  String get feedbackNewLineHint => 'Shift + Enter for a new line';

  @override
  String get feedbackSendTooltip => 'Send (Enter)';

  @override
  String websiteAllInOneFeatureImageLabel(String feature) {
    return 'An image of the $feature feature';
  }

  @override
  String get websiteAllInOneHeadline => 'Everything in one place';

  @override
  String get websiteAllPlatformsHeadline => 'Available on all devices.';

  @override
  String get websiteAllPlatformsSubline =>
      'Sharezone works on all systems, so you can access your data anytime.';

  @override
  String get websiteAppTitle => 'Sharezone - Connected school planner';

  @override
  String get websiteDataProtectionAesTitle =>
      'AES 256-bit server-side encryption';

  @override
  String get websiteDataProtectionHeadline => 'Secure & GDPR compliant';

  @override
  String get websiteDataProtectionIsoTitle =>
      'ISO27001, ISO27012 & ISO27018 certified*';

  @override
  String get websiteDataProtectionServerLocationSubtitle =>
      'Except for the authentication server\n(EU standard contractual clauses)';

  @override
  String get websiteDataProtectionServerLocationTitle =>
      'Server location: Frankfurt (Germany)';

  @override
  String get websiteDataProtectionSocSubtitle =>
      '* Certification by our hosting provider';

  @override
  String get websiteDataProtectionSocTitle => 'SOC1, SOC2, & SOC3 certified*';

  @override
  String get websiteDataProtectionTlsTitle => 'TLS encryption in transit';

  @override
  String get websiteFeatureAlwaysAvailableBulletpointMultiDevice =>
      'Use on multiple devices';

  @override
  String get websiteFeatureAlwaysAvailableBulletpointOffline =>
      'Add items offline';

  @override
  String get websiteFeatureAlwaysAvailableTitle => 'Always available';

  @override
  String get websiteFeatureEventsBulletpointAtAGlance =>
      'Exams and events at a glance';

  @override
  String get websiteFeatureEventsTitle => 'Events';

  @override
  String get websiteFeatureFileStorageBulletpointShareMaterials =>
      'Share learning materials';

  @override
  String get websiteFeatureFileStorageBulletpointUnlimitedStorage =>
      'Optional: unlimited \nstorage';

  @override
  String get websiteFeatureFileStorageTitle => 'File storage';

  @override
  String get websiteFeatureGradesBulletpointMultipleSystems =>
      'Multiple grading systems';

  @override
  String get websiteFeatureGradesBulletpointSaveGrades =>
      'Save your grades in Sharezone';

  @override
  String get websiteFeatureGradesTitle => 'Grading system';

  @override
  String get websiteFeatureNoticesBulletpointComments => 'With comments';

  @override
  String get websiteFeatureNoticesBulletpointNotifications =>
      'With notifications';

  @override
  String get websiteFeatureNoticesBulletpointReadReceipt =>
      'With read confirmation';

  @override
  String get websiteFeatureNoticesTitle => 'Notices';

  @override
  String get websiteFeatureNotificationsBulletpointAlwaysInformed =>
      'Always informed';

  @override
  String get websiteFeatureNotificationsBulletpointCustomizable =>
      'Customizable';

  @override
  String get websiteFeatureNotificationsBulletpointQuietHours =>
      'With quiet hours';

  @override
  String get websiteFeatureNotificationsTitle => 'Notifications';

  @override
  String get websiteFeatureOverviewTitle => 'Overview';

  @override
  String get websiteFeatureTasksBulletpointComments => 'With comments';

  @override
  String get websiteFeatureTasksBulletpointReminder => 'With reminders';

  @override
  String get websiteFeatureTasksBulletpointSubmissions => 'With submissions';

  @override
  String get websiteFeatureTasksTitle => 'Tasks';

  @override
  String get websiteFeatureTimetableBulletpointAbWeeks => 'With A/B weeks';

  @override
  String get websiteFeatureTimetableBulletpointWeekdays => 'Customize weekdays';

  @override
  String get websiteFeatureTimetableTitle => 'Timetable';

  @override
  String get websiteFooterCommunityDiscord => 'Discord';

  @override
  String get websiteFooterCommunitySubtitle =>
      'Join our community and bring your ideas to Sharezone.';

  @override
  String get websiteFooterCommunityTicketSystem => 'Ticket system';

  @override
  String get websiteFooterCommunityTitle => 'Sharezone community';

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
  String get websiteFooterHelpTitle => 'Help';

  @override
  String get websiteFooterHelpVideos => 'Explainer videos';

  @override
  String get websiteFooterLegalImprint => 'Imprint';

  @override
  String get websiteFooterLegalPrivacy => 'Privacy policy';

  @override
  String get websiteFooterLegalTerms => 'Terms of service';

  @override
  String get websiteFooterLegalTitle => 'Legal';

  @override
  String get websiteFooterLinksDocs => 'Documentation';

  @override
  String get websiteFooterLinksTitle => 'Links';

  @override
  String get websiteLaunchUrlFailed => 'Link could not be opened.';

  @override
  String get websiteNavDocs => 'Docs';

  @override
  String get websiteNavHome => 'Home';

  @override
  String get websiteNavPlus => 'Plus';

  @override
  String get websiteNavSupport => 'Support';

  @override
  String get websiteNavWebApp => 'Web app';

  @override
  String get websiteSharezonePlusAdvantagesTitle =>
      'Benefits of Sharezone Plus';

  @override
  String get websiteSharezonePlusCustomerPortalContent =>
      'To authenticate, please use the email address you used for the purchase.';

  @override
  String get websiteSharezonePlusCustomerPortalOpen => 'Go to customer portal';

  @override
  String get websiteSharezonePlusCustomerPortalTitle => 'Customer portal';

  @override
  String websiteSharezonePlusLoadError(String error) {
    return 'Error: $error';
  }

  @override
  String get websiteSharezonePlusLoadingName => 'Loading...';

  @override
  String get websiteSharezonePlusManageSubscriptionText =>
      'Already have a subscription? Click [here](https://billing.stripe.com/p/login/eVa7uh3DvbMfbTy144) to manage it (e.g. cancel, change payment method, etc.).';

  @override
  String get websiteSharezonePlusPurchaseDialogContent =>
      'To buy Sharezone Plus for your own account, you need to purchase Sharezone Plus through the web app.\n\nIf you want to buy Sharezone Plus as a parent for your child, open the link you received from your child.\n\nIf you have any questions, feel free to email us at [plus@sharezone.net](mailto:plus@sharezone.net).';

  @override
  String get websiteSharezonePlusPurchaseDialogTitle => 'Buy Sharezone Plus';

  @override
  String get websiteSharezonePlusPurchaseDialogToWebApp => 'Go to web app';

  @override
  String get websiteSharezonePlusPurchaseForTitle => 'Buy Sharezone Plus for';

  @override
  String get websiteSharezonePlusSuccessMessage =>
      'You successfully purchased Sharezone Plus for your child.\nThank you for your support!';

  @override
  String get websiteSharezonePlusSuccessSupport =>
      'If you have questions, you can always reach our [Support](/support).';

  @override
  String get websiteStoreAppStoreName => 'App Store';

  @override
  String get websiteStorePlayStoreName => 'Play Store';

  @override
  String websiteSupportEmailCopy(String email) {
    return 'Email: $email';
  }

  @override
  String get websiteSupportEmailLabel => 'Email';

  @override
  String get websiteSupportEmailSubject => 'I need your help! 😭';

  @override
  String get websiteSupportPageBody =>
      'Contact us through a channel of your choice and we\'ll help you as quickly as possible 😉\n\nPlease note that it can sometimes take longer for us to respond (1-2 weeks).';

  @override
  String get websiteSupportPageHeadline => 'Need help?';

  @override
  String get websiteSupportSectionButton => 'Contact support';

  @override
  String get websiteSupportSectionHeadline => 'We’ve got your back.';

  @override
  String get websiteSupportSectionSubline =>
      'Our support is available any time—no matter the hour or day.';

  @override
  String get websiteUserCounterLabel => 'registered users';

  @override
  String get websiteUserCounterSemanticLabel => 'user counter';

  @override
  String get websiteWelcomeDescription =>
      'Sharezone is a connected school planner to stay organized together. Entered content like homework is shared instantly with everyone else, saving time and nerves.';

  @override
  String get websiteWelcomeDescriptionSemanticLabel =>
      'Description of the Sharezone app';

  @override
  String get websiteWelcomeHeadline => 'Simple. Secure. Stable.';

  @override
  String get websiteWelcomeHeadlineSemanticLabel =>
      'Headline of the Sharezone app';

  @override
  String get websiteUspCommunityButton => 'Go to the Sharezone community';

  @override
  String get websiteUspHeadline => 'Truly helpful.';

  @override
  String get websiteUspSublineDetails =>
      'We know which solutions are needed and what really helps to make everyday school life easier.\nWhere we don\'t know yet, we work with agile methods and the Sharezone community to find the best solution.';

  @override
  String get websiteUspSublineIntro =>
      'Sharezone was born from real classroom problems.';
}
