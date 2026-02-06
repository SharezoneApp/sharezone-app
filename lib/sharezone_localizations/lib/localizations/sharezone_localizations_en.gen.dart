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
  String get appName => 'Sharezone';

  @override
  String authAnonymousDisplayName(Object animalName) {
    return 'Anonymous $animalName';
  }

  @override
  String get authProviderAnonymous => 'Anonymous sign in';

  @override
  String get authProviderApple => 'Apple Sign In';

  @override
  String get authProviderEmailAndPassword => 'Email and password';

  @override
  String get authProviderGoogle => 'Google Sign In';

  @override
  String get authValidationInvalidEmail => 'Please enter a valid email';

  @override
  String get authValidationInvalidName => 'Invalid name';

  @override
  String get authValidationInvalidPasswordTooShort =>
      'Invalid password, please enter more than 8 characters';

  @override
  String get blackboardErrorCourseMissing => 'Please select a course.';

  @override
  String get blackboardErrorTitleMissing =>
      'Please enter a title for the entry.';

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
  String get commonActionBack => 'Back';

  @override
  String get commonActionChange => 'Change';

  @override
  String get commonActionsAlright => 'Alright';

  @override
  String get commonActionsCancel => 'Cancel';

  @override
  String get commonActionsCancelUppercase => 'CANCEL';

  @override
  String get commonActionsClose => 'Close';

  @override
  String get commonActionsCloseUppercase => 'CLOSE';

  @override
  String get commonActionsConfirm => 'Confirm';

  @override
  String get commonActionsContactSupport => 'Contact support';

  @override
  String get commonActionsContinue => 'Continue';

  @override
  String get commonActionsDelete => 'Delete';

  @override
  String get commonActionsDeleteUppercase => 'DELETE';

  @override
  String get commonActionsLeave => 'Leave';

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
  String get commonErrorCourseSubjectMissing => 'Please enter a subject.';

  @override
  String get commonErrorCredentialAlreadyInUse =>
      'An account with this sign-in method already exists!';

  @override
  String get commonErrorDateMissing => 'Please enter a date!';

  @override
  String get commonErrorEmailAlreadyInUse =>
      'This email address is already used by another user.';

  @override
  String get commonErrorEmailInvalidFormat =>
      'The email address has an invalid format.';

  @override
  String get commonErrorEmailMissing => 'Please enter your email.';

  @override
  String get commonErrorIncorrectData => 'Please enter the data correctly!';

  @override
  String get commonErrorIncorrectSharecode => 'Invalid share code!';

  @override
  String get commonErrorInvalidInput => 'Please check your input!';

  @override
  String get commonErrorKeychainSignInFailed =>
      'There was an error signing in. To fix this, choose \'Always Allow\' in the macOS Keychain password dialog.';

  @override
  String get commonErrorNameMissing => 'Please enter a name!';

  @override
  String get commonErrorNameTooShort =>
      'Please enter a name with more than one character.';

  @override
  String get commonErrorNameUnchanged => 'That\'s the same name as before 😅';

  @override
  String get commonErrorNetworkRequestFailed =>
      'A network error occurred because there is no stable internet connection.';

  @override
  String get commonErrorNewPasswordMissing =>
      'Oops, you forgot to enter your new password 😬';

  @override
  String get commonErrorNoGoogleAccountSelected => 'Please select an account.';

  @override
  String get commonErrorNoInternetAccess =>
      'Your device has no internet access...';

  @override
  String get commonErrorPasswordMissing => 'Please enter your password.';

  @override
  String get commonErrorSameNameAsBefore =>
      'That\'s the same name as before 🙈';

  @override
  String get commonErrorTitleMissing => 'Please enter a title!';

  @override
  String get commonErrorTooManyRequests =>
      'We have blocked requests from this device due to unusual activity. Please try again later.';

  @override
  String commonErrorUnknown(Object error) {
    return 'An unknown error occurred ($error)! Please contact support.';
  }

  @override
  String get commonErrorUserDisabled =>
      'This account has been disabled by an administrator.';

  @override
  String get commonErrorUserNotFound =>
      'No user was found with this email address... Inactive users are deleted after 2 years.';

  @override
  String get commonErrorWeakPassword =>
      'This password is too weak. Please choose a stronger password.';

  @override
  String get commonErrorWrongPassword =>
      'The password you entered is incorrect.';

  @override
  String get commonLoadingPleaseWait => 'Please wait...';

  @override
  String get commonStatusFailed => 'Failed';

  @override
  String get commonStatusNoInternetDescription =>
      'Please check the internet connection.';

  @override
  String get commonStatusNoInternetTitle => 'Error: No internet connection';

  @override
  String get commonStatusSuccessful => 'Successful';

  @override
  String get commonStatusUnknownErrorDescription =>
      'An unknown error occurred! 😭';

  @override
  String get commonStatusUnknownErrorTitle => 'Unknown error';

  @override
  String get commonTitleNote => 'Note';

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
  String get dateWeekTypeA => 'Week A';

  @override
  String get dateWeekTypeAlways => 'Every week';

  @override
  String get dateWeekTypeB => 'Week B';

  @override
  String get dateWeekdayFriday => 'Friday';

  @override
  String get dateWeekdayMonday => 'Monday';

  @override
  String get dateWeekdaySaturday => 'Saturday';

  @override
  String get dateWeekdaySunday => 'Sunday';

  @override
  String get dateWeekdayThursday => 'Thursday';

  @override
  String get dateWeekdayTuesday => 'Tuesday';

  @override
  String get dateWeekdayWednesday => 'Wednesday';

  @override
  String get dateYesterday => 'Yesterday';

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
  String get homeworkSectionDayAfterTomorrow => 'Day after tomorrow';

  @override
  String get homeworkSectionLater => 'Later';

  @override
  String get homeworkSectionOverdue => 'Overdue';

  @override
  String get homeworkSectionToday => 'Today';

  @override
  String get homeworkSectionTomorrow => 'Tomorrow';

  @override
  String homeworkTodoDateTime(String date, String time) {
    return '$date - $time';
  }

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
  String get legalChangeAppearance => 'Change appearance';

  @override
  String get legalDownloadAsPdf => 'Download as PDF';

  @override
  String legalMetadataLastUpdated(String date) {
    return 'Last updated: $date';
  }

  @override
  String get legalMetadataTitle => 'Metadata';

  @override
  String legalMetadataVersion(String version) {
    return 'Version: v$version';
  }

  @override
  String get legalMoreOptions => 'More options';

  @override
  String legalPrivacyPolicyEffectiveDate(String date) {
    return 'This updated privacy policy takes effect on $date.';
  }

  @override
  String get legalPrivacyPolicyTitle => 'Privacy Policy';

  @override
  String get legalTableOfContents => 'Table of contents';

  @override
  String get legalTermsOfServiceTitle => 'Terms of Service';

  @override
  String get memberRoleAdmin => 'Admin';

  @override
  String get memberRoleCreator => 'Active Member (Write and read permissions)';

  @override
  String get memberRoleNone => 'None';

  @override
  String get memberRoleOwner => 'Owner';

  @override
  String get memberRoleStandard => 'Passive Member (Read-only permissions)';

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
  String selectStateDialogConfirmationSnackBar(Object region) {
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
  String get sharezonePlusAdvantageAddToCalendarDescription =>
      'Add an event to your local calendar with a single tap (e.g., Apple or Google Calendar).\n\nNote that the feature is only available on Android & iOS. The event in your calendar does not automatically update when it is changed in Sharezone.';

  @override
  String get sharezonePlusAdvantageAddToCalendarTitle =>
      'Add events to local calendar';

  @override
  String get sharezonePlusAdvantageDiscordDescription =>
      'Get the Discord Sharezone Plus role on our [Discord server](https://sharezone.net/discord). This role shows that you have Sharezone Plus and gives you access to an exclusive channel for Sharezone Plus users.';

  @override
  String get sharezonePlusAdvantageDiscordTitle =>
      'Discord Sharezone Plus role';

  @override
  String get sharezonePlusAdvantageGradesDescription =>
      'Store your school grades with Sharezone Plus and keep track of your performance. Written exams, oral participation, term grades — all in one place.';

  @override
  String get sharezonePlusAdvantageGradesTitle => 'Grades';

  @override
  String get sharezonePlusAdvantageHomeworkReminderDescription =>
      'With Sharezone Plus you can set the day-before homework reminder in 30-minute increments, e.g., 15:00 or 15:30. This feature is only available for students.';

  @override
  String get sharezonePlusAdvantageHomeworkReminderTitle =>
      'Custom homework reminder time';

  @override
  String get sharezonePlusAdvantageIcalDescription =>
      'With an iCal link, you can integrate your timetable and events into other calendar apps (such as Google Calendar or Apple Calendar). As soon as your timetable or events change, they are also updated in your other calendar apps.\n\nUnlike the \"Add to calendar\" button, you don\'t have to update the event in your calendar app when something changes in Sharezone.\n\niCal links are only visible to you and cannot be viewed by others.\n\nPlease note that currently only events and exams can be exported. Lessons cannot be exported yet.';

  @override
  String get sharezonePlusAdvantageIcalTitle => 'Export timetable (iCal)';

  @override
  String get sharezonePlusAdvantageMoreColorsDescription =>
      'Sharezone Plus gives you over 200 (instead of 19) colors for your groups. If you set a group color with Sharezone Plus, your group members can see it as well.';

  @override
  String get sharezonePlusAdvantageMoreColorsTitle => 'More colors for groups';

  @override
  String get sharezonePlusAdvantageOpenSourceDescription =>
      'Sharezone is open source on the frontend. That means anyone can view and even improve Sharezone\'s source code. We believe open source is the future and want Sharezone to become a showcase project.\n\nGitHub: [https://github.com/SharezoneApp/sharezone-app](https://sharezone.net/github)';

  @override
  String get sharezonePlusAdvantageOpenSourceTitle => 'Support open source';

  @override
  String get sharezonePlusAdvantagePastEventsDescription =>
      'With Sharezone Plus you can view all past events, such as exams.';

  @override
  String get sharezonePlusAdvantagePastEventsTitle => 'View past events';

  @override
  String get sharezonePlusAdvantagePremiumSupportDescription =>
      'With Sharezone Plus you get access to our premium support:\n- A response by email within a few hours (instead of up to 2 weeks)\n- Video-call support by appointment (allows screen sharing)';

  @override
  String get sharezonePlusAdvantagePremiumSupportTitle => 'Premium support';

  @override
  String get sharezonePlusAdvantageQuickDueDateDescription =>
      'With Sharezone Plus you can set a homework due date with a single tap to the next school day or any future period.';

  @override
  String get sharezonePlusAdvantageQuickDueDateTitle =>
      'Quick due-date selection';

  @override
  String get sharezonePlusAdvantageReadByDescription =>
      'Get a list of all group members and their read status for each information sheet, ensuring important information has reached everyone.';

  @override
  String get sharezonePlusAdvantageReadByTitle =>
      'Read status for information sheets';

  @override
  String get sharezonePlusAdvantageRemoveAdsDescription =>
      'Enjoy Sharezone completely ad-free.\n\nNote: We are currently testing ads. It\'s possible that we remove ads for all users again in the future.';

  @override
  String get sharezonePlusAdvantageRemoveAdsTitle => 'Remove ads';

  @override
  String get sharezonePlusAdvantageStorageDescription =>
      'With Sharezone Plus you get 30 GB of storage (instead of 100 MB) for your files & attachments (homework & information sheets). This corresponds to about 15,000 photos (2 MB per image).\n\nThe limit does not apply to files uploaded as homework submissions.';

  @override
  String get sharezonePlusAdvantageStorageTitle => '30 GB storage';

  @override
  String get sharezonePlusAdvantageSubstitutionsDescription =>
      'Unlock the substitution schedule with Sharezone Plus:\n* Mark cancelled lessons\n* Room changes\n\nEven course members without Sharezone Plus can view the substitution schedule (but not edit it). Course members can also be informed about changes with a single click.\n\nNote that the substitution schedule has to be entered manually and is not imported automatically.';

  @override
  String get sharezonePlusAdvantageSubstitutionsTitle =>
      'Substitution schedule';

  @override
  String get sharezonePlusAdvantageTeacherTimetableDescription =>
      'Enter the teacher\'s name for each lesson in the timetable. For course members without Sharezone Plus, the teacher is shown as well.';

  @override
  String get sharezonePlusAdvantageTeacherTimetableTitle =>
      'Teacher in timetable';

  @override
  String get sharezonePlusAdvantageTimetableByClassDescription =>
      'In multiple classes? With Sharezone Plus you can choose a timetable for each class individually, so you always see the correct timetable.';

  @override
  String get sharezonePlusAdvantageTimetableByClassTitle =>
      'Select timetable by class';

  @override
  String get sharezonePlusBuyAction => 'Buy';

  @override
  String get sharezonePlusBuyingDisabledContent =>
      'The purchase of Sharezone Plus is currently disabled. Please try again later.\n\nWe will keep you updated on our [Discord](https://sharezone.net/discord).';

  @override
  String get sharezonePlusBuyingDisabledTitle => 'Purchasing disabled';

  @override
  String sharezonePlusBuyingFailedContent(String error) {
    return 'The purchase of Sharezone Plus failed. Please try again later.\n\nError: $error\n\nIf you have questions, contact [plus@sharezone.net](mailto:plus@sharezone.net).';
  }

  @override
  String get sharezonePlusBuyingFailedTitle => 'Purchase failed';

  @override
  String get sharezonePlusCancelAction => 'Cancel';

  @override
  String get sharezonePlusCancelConfirmAction => 'Cancel';

  @override
  String get sharezonePlusCancelConfirmationContent =>
      'If you cancel your Sharezone Plus subscription, you will lose access to all Plus features.\n\nAre you sure you want to cancel?';

  @override
  String get sharezonePlusCancelConfirmationTitle => 'Are you sure?';

  @override
  String sharezonePlusCancelFailedContent(String error) {
    return 'An error occurred. Please try again later.\n\nError: $error';
  }

  @override
  String get sharezonePlusCancelFailedTitle => 'Cancellation failed';

  @override
  String get sharezonePlusCanceledSubscriptionNote =>
      'You have canceled your Sharezone Plus subscription. You can still use your benefits until the end of the current billing period. If you change your mind, you can subscribe to Sharezone Plus again at any time.';

  @override
  String get sharezonePlusFaqContentCreatorContent =>
      'Yes, as a content creator you can receive Sharezone Plus (lifetime) for free.\n\nHere\'s how it works:\n1. Create a creative TikTok, YouTube Short, or Instagram Reel where you mention or present Sharezone.\n2. Make sure your video gets more than 10,000 views.\n3. Send us the link to your video at plus@sharezone.net.\n\nThere are no limits to your creativity. Please read our conditions for the content creator program: https://sharezone.net/content-creator-programm.';

  @override
  String get sharezonePlusFaqContentCreatorTitle =>
      'Is there a content creator program?';

  @override
  String sharezonePlusFaqEmailSnackBar(String email) {
    return 'Email: $email';
  }

  @override
  String get sharezonePlusFaqFamilyLicenseContent =>
      'Yes, for families with multiple children we offer special conditions. Just send us an email at [plus@sharezone.net](mailto:plus@sharezone.net) to learn more.';

  @override
  String get sharezonePlusFaqFamilyLicenseTitle =>
      'Are there special offers for families?';

  @override
  String get sharezonePlusFaqGroupMembersContent =>
      'If you subscribe to Sharezone Plus, only your account gets Sharezone Plus. Your group members do not receive Sharezone Plus.\n\nHowever, there are individual features from which your group members also benefit. For example, if you change a group\'s course color to a color that is only available with Sharezone Plus, this color will also be used for your group members.';

  @override
  String get sharezonePlusFaqGroupMembersTitle =>
      'Do group members also get Sharezone Plus?';

  @override
  String get sharezonePlusFaqOpenSourceContent =>
      'Yes, Sharezone is open source on the frontend. You can view the source code on GitHub:';

  @override
  String get sharezonePlusFaqOpenSourceTitle =>
      'Is Sharezone\'s source code public?';

  @override
  String get sharezonePlusFaqSchoolLicenseContent =>
      'Interested in a license for your entire class? Just send us an email at [plus@sharezone.net](mailto:plus@sharezone.net).';

  @override
  String get sharezonePlusFaqSchoolLicenseTitle =>
      'Are there special offers for school classes?';

  @override
  String get sharezonePlusFaqStorageContent =>
      'No, the 30 GB of storage with Sharezone Plus only applies to your account and applies across all your courses.\n\nFor example, you could upload 5 GB in the German course, 15 GB in the math course, and would still have another 10 GB available across all courses.\n\nYour group members do not receive additional storage.';

  @override
  String get sharezonePlusFaqStorageTitle =>
      'Does the whole course get 30 GB of storage?';

  @override
  String get sharezonePlusFaqWhoIsBehindContent =>
      'Sharezone is currently developed by Jonas and Nils. The idea for Sharezone emerged from our personal frustration with organizing everyday school life during our school days. Our vision is to make school life easier and more organized for everyone.';

  @override
  String get sharezonePlusFaqWhoIsBehindTitle => 'Who is behind Sharezone?';

  @override
  String get sharezonePlusFeatureUnavailable =>
      'This feature is only available with \"Sharezone Plus\".';

  @override
  String sharezonePlusLegalTextLifetime(String price) {
    return 'One-time payment of $price (no subscription). By purchasing, you confirm that you have read the [Terms](https://sharezone.net/terms-of-service). We process your data in accordance with our [Privacy Policy](https://sharezone.net/privacy-policy)';
  }

  @override
  String sharezonePlusLegalTextMonthlyAndroid(String price) {
    return 'Your subscription ($price/month) can be canceled monthly. It will automatically renew unless you cancel at least 24 hours before the end of the current billing period via Google Play. By purchasing, you confirm that you have read the [Terms](https://sharezone.net/terms-of-service). We process your data in accordance with our [Privacy Policy](https://sharezone.net/privacy-policy)';
  }

  @override
  String sharezonePlusLegalTextMonthlyApple(String price) {
    return 'Your subscription ($price/month) can be canceled monthly. It will automatically renew unless you cancel at least 24 hours before the end of the current billing period via the App Store. By purchasing, you confirm that you have read the [Terms](https://sharezone.net/terms-of-service). We process your data in accordance with our [Privacy Policy](https://sharezone.net/privacy-policy)';
  }

  @override
  String sharezonePlusLegalTextMonthlyOther(String price) {
    return 'Your subscription ($price/month) can be canceled monthly. It will automatically renew unless you cancel before the end of the current billing period via the app. By purchasing, you confirm that you have read the [Terms](https://sharezone.net/terms-of-service). We process your data in accordance with our [Privacy Policy](https://sharezone.net/privacy-policy)';
  }

  @override
  String get sharezonePlusLetParentsBuyAction => 'Let parents pay';

  @override
  String get sharezonePlusLetParentsBuyContent =>
      'You can send your parents a link so they can buy Sharezone Plus for you.\n\nThe link is only valid for you and contains the connection to your account.';

  @override
  String get sharezonePlusLetParentsBuyTitle => 'Let parents pay';

  @override
  String get sharezonePlusLinkCopiedToClipboard => 'Link copied to clipboard.';

  @override
  String get sharezonePlusLinkTokenLoadFailed =>
      'The token for the link could not be loaded.';

  @override
  String get sharezonePlusPurchasePeriodLifetime =>
      'Lifetime (one-time purchase)';

  @override
  String get sharezonePlusPurchasePeriodMonthly => 'Monthly';

  @override
  String get sharezonePlusShareLinkAction => 'Share link';

  @override
  String get sharezonePlusSubscribeAction => 'Subscribe';

  @override
  String get sharezonePlusTestFlightContent =>
      'You installed Sharezone via TestFlight. Apple does not allow in-app purchases via TestFlight.\n\nTo buy Sharezone Plus, please download the app from the App Store. There you can purchase Sharezone Plus.\n\nAfterwards, you can reinstall the app via TestFlight.';

  @override
  String get sharezonePlusTestFlightTitle => 'TestFlight';

  @override
  String get sharezonePlusUnsubscribeActiveText =>
      'You currently have a Sharezone Plus subscription. If you\'re not satisfied, we\'d love to hear your [feedback](#feedback)! Of course, you can cancel the subscription at any time.';

  @override
  String get sharezonePlusUnsubscribeLifetimeText =>
      'You have Sharezone Plus for life. If you\'re not satisfied, we\'d love to hear your [feedback](#feedback)!';

  @override
  String get sharezoneWidgetsCenteredErrorMessage =>
      'Unfortunately, an error occurred while loading 😖\nPlease try again later.';

  @override
  String get sharezoneWidgetsCourseTileNoCourseSelected => 'No course selected';

  @override
  String get sharezoneWidgetsCourseTileTitle => 'Course';

  @override
  String get sharezoneWidgetsDatePickerSelectDate => 'Select date';

  @override
  String get sharezoneWidgetsErrorCardContactSupport => 'CONTACT SUPPORT';

  @override
  String get sharezoneWidgetsErrorCardRetry => 'TRY AGAIN';

  @override
  String get sharezoneWidgetsErrorCardTitle => 'An error occurred!';

  @override
  String get sharezoneWidgetsLeaveFormConfirm => 'YES, LEAVE!';

  @override
  String get sharezoneWidgetsLeaveFormPromptFull =>
      'Do you really want to end the input? The data will not be saved!';

  @override
  String get sharezoneWidgetsLeaveFormPromptNot => 'not';

  @override
  String get sharezoneWidgetsLeaveFormPromptPrefix =>
      'Do you really want to end the input? The data will ';

  @override
  String get sharezoneWidgetsLeaveFormPromptSuffix => ' be saved!';

  @override
  String get sharezoneWidgetsLeaveFormStay => 'NO!';

  @override
  String get sharezoneWidgetsLeaveFormTitle => 'Leave input?';

  @override
  String get sharezoneWidgetsLeaveOrSaveFormPrompt =>
      'Do you want to leave or save the input? If you leave the input, the data will not be saved';

  @override
  String get sharezoneWidgetsLeaveOrSaveFormTitle => 'Leave or save?';

  @override
  String get sharezoneWidgetsLoadingEncryptedTransfer =>
      'Data is being transferred in encrypted form...';

  @override
  String get sharezoneWidgetsLocationHint => 'Location/Room';

  @override
  String get sharezoneWidgetsLogoSemanticsLabel =>
      'Sharezone logo: A blue notebook icon with a cloud, with Sharezone written to the right.';

  @override
  String get sharezoneWidgetsMarkdownSupportBold => '**bold**';

  @override
  String get sharezoneWidgetsMarkdownSupportItalic => '*italic*';

  @override
  String get sharezoneWidgetsMarkdownSupportLabel => 'Markdown: ';

  @override
  String get sharezoneWidgetsMarkdownSupportSeparator => ', ';

  @override
  String sharezoneWidgetsNotAllowedCharactersError(String characters) {
    return 'The following characters are not allowed: $characters';
  }

  @override
  String get sharezoneWidgetsOverlayCardCloseSemantics => 'Close the card';

  @override
  String get sharezoneWidgetsSnackbarComingSoon =>
      'This feature will be available soon! 😊';

  @override
  String get sharezoneWidgetsSnackbarDataArrivalConfirmed =>
      'Data arrival confirmed';

  @override
  String get sharezoneWidgetsSnackbarLoginDataEncrypted =>
      'Login data is being transferred in encrypted form...';

  @override
  String get sharezoneWidgetsSnackbarPatience =>
      'Please wait! Data is still loading...';

  @override
  String get sharezoneWidgetsSnackbarSaved =>
      'Changes have been saved successfully';

  @override
  String get sharezoneWidgetsSnackbarSendingDataToFrankfurt =>
      'Data is being transported to Frankfurt...';

  @override
  String get sharezoneWidgetsTextFieldCannotBeEmptyError =>
      'The text field must not be empty!';

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
  String get submissionsCreateAddFile => 'Add file';

  @override
  String get submissionsCreateAfterDeadlineContent =>
      'You can still submit now, but the teacher will decide how to handle it ;)';

  @override
  String get submissionsCreateAfterDeadlineTitle =>
      'Missed the deadline? You can still submit!';

  @override
  String get submissionsCreateEmptyStateTitle =>
      'Upload files that you want to submit for the homework!';

  @override
  String submissionsCreateFileInvalidDialogContent(String message) {
    return '$message\nPlease contact support at support@sharezone.net!';
  }

  @override
  String get submissionsCreateFileInvalidDialogTitle => 'Error';

  @override
  String submissionsCreateFileInvalidMultiple(String fileNames) {
    return 'The selected files \"$fileNames\" seem to be invalid.';
  }

  @override
  String submissionsCreateFileInvalidSingle(String fileName) {
    return 'The selected file \"$fileName\" seems to be invalid.';
  }

  @override
  String get submissionsCreateLeaveAction => 'Leave';

  @override
  String get submissionsCreateNotSubmittedContent =>
      'Your teacher won\'t see your submission until you submit it.\n\nYour uploaded files will still stay saved for you.';

  @override
  String get submissionsCreateNotSubmittedTitle => 'Submission not sent!';

  @override
  String submissionsCreateRemoveFileContent(String fileName) {
    return 'Do you really want to remove the file \"$fileName\"?';
  }

  @override
  String get submissionsCreateRemoveFileTitle => 'Remove file';

  @override
  String get submissionsCreateRemoveFileTooltip => 'Remove file';

  @override
  String get submissionsCreateRenameActionUppercase => 'RENAME';

  @override
  String get submissionsCreateRenameDialogTitle => 'Rename file';

  @override
  String get submissionsCreateRenameErrorAlreadyExists =>
      'This file name already exists!';

  @override
  String get submissionsCreateRenameErrorEmpty => 'The name must not be empty!';

  @override
  String get submissionsCreateRenameErrorTooLong => 'The name is too long!';

  @override
  String get submissionsCreateRenameTooltip => 'Rename';

  @override
  String get submissionsCreateSubmitAction => 'Submit';

  @override
  String get submissionsCreateSubmitDialogContent =>
      'After submitting, you can no longer delete files. You can still add new files and rename existing ones.';

  @override
  String get submissionsCreateSubmitDialogTitle => 'Really submit?';

  @override
  String get submissionsCreateSubmittedTitle => 'Submission sent successfully!';

  @override
  String get submissionsCreateUploadInProgressContent =>
      'If you leave this dialog, uploads for files that haven\'t finished will be cancelled.';

  @override
  String get submissionsCreateUploadInProgressTitle => 'Files are uploading!';

  @override
  String get submissionsListAfterDeadlineSection => 'Submitted late 🕐';

  @override
  String get submissionsListEditedSuffix => ' (edited afterwards)';

  @override
  String get submissionsListMissingSection => 'Not submitted 😭';

  @override
  String get submissionsListNoMembersPlaceholder =>
      'Forgot to invite participants to the course?';

  @override
  String get submissionsListTitle => 'Submissions';

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
  String get timetableErrorEndTimeBeforeNextLessonStart =>
      'The end time is before the start time of the next lesson!';

  @override
  String get timetableErrorEndTimeBeforePreviousLessonEnd =>
      'The end time is before the end time of the previous lesson!';

  @override
  String get timetableErrorEndTimeBeforeStartTime =>
      'The lesson\'s end time is before the start time!';

  @override
  String get timetableErrorEndTimeMissing => 'Please enter an end time!';

  @override
  String get timetableErrorInvalidPeriodsOverlap =>
      'Please enter valid times. Lessons must not overlap!';

  @override
  String get timetableErrorStartTimeBeforeNextLessonStart =>
      'The start time is before the start time of the next lesson!';

  @override
  String get timetableErrorStartTimeBeforePreviousLessonEnd =>
      'The start time is before the end time of the previous lesson!';

  @override
  String get timetableErrorStartTimeEqualsEndTime =>
      'Start time and end time must not be the same!';

  @override
  String get timetableErrorStartTimeMissing => 'Please enter a start time!';

  @override
  String get timetableErrorWeekdayMissing => 'Please select a weekday!';

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
  String get websiteLanguageSelectorTooltip => 'Select language';

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
  String get websiteUspCommunityButton => 'Go to the Sharezone community';

  @override
  String get websiteUspHeadline => 'Truly helpful.';

  @override
  String get websiteUspSublineDetails =>
      'We know which solutions are needed and what really helps to make everyday school life easier.\nWhere we don\'t know yet, we work with agile methods and the Sharezone community to find the best solution.';

  @override
  String get websiteUspSublineIntro =>
      'Sharezone was born from real classroom problems.';

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
  String get writePermissionEveryone => 'Everyone';

  @override
  String get writePermissionOnlyAdmins => 'Only admins';
}
