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
  String get activationCodeErrorInvalidDescription =>
      'Either this code has already been redeemed or it is outside the validity period.';

  @override
  String get activationCodeErrorInvalidTitle =>
      'An error occurred: This code is invalid 🤨';

  @override
  String get activationCodeErrorNoInternetDescription =>
      'We could not redeem the code because no internet connection could be established. Please check your Wi-Fi or mobile data.';

  @override
  String get activationCodeErrorNoInternetTitle =>
      'An error occurred: No internet connection ☠️';

  @override
  String get activationCodeErrorNotFoundDescription =>
      'We could not find the entered activation code. Please check upper/lower case and whether this activation code is still valid.';

  @override
  String get activationCodeErrorNotFoundTitle =>
      'An error occurred: Activation code not found ❌';

  @override
  String get activationCodeErrorUnknownDescription =>
      'This might be due to your internet connection. Please check it.';

  @override
  String get activationCodeErrorUnknownTitle => 'An unknown error occurred 😭';

  @override
  String get activationCodeFeatureAdsLabel => 'Ads';

  @override
  String get activationCodeFeatureL10nLabel => 'l10n';

  @override
  String get activationCodeFieldHint => 'e.g. NavigationV2';

  @override
  String get activationCodeFieldLabel => 'Activation code';

  @override
  String get activationCodeInfoDescription =>
      'With the activation code, features that are still in development can be enabled and tested early. The activation code is provided by us and is intended for testing purposes only.\n\nIf you have a sharecode and want to join a group, enter it on the \"Groups\" page.';

  @override
  String get activationCodeInfoTitle => 'What is the activation code?';

  @override
  String get activationCodeResultDoneAction => 'Done';

  @override
  String activationCodeSuccessTitle(Object value) {
    return 'Successfully activated: $value 🎉';
  }

  @override
  String get activationCodeToggleDisabled => 'disabled';

  @override
  String get activationCodeToggleEnabled => 'enabled';

  @override
  String activationCodeToggleResult(String feature, String state) {
    return '$feature was $state. Restart the app to see the changes.';
  }

  @override
  String get adInfoDialogBodyPrefix =>
      'Over the next weeks, we are running an ad experiment in Sharezone. If you do not want to see ads, you can buy ';

  @override
  String get adInfoDialogBodySuffix => '.';

  @override
  String get adInfoDialogTitle => 'Ads in Sharezone';

  @override
  String get adsLoading => 'Ad is loading...';

  @override
  String get appName => 'Sharezone';

  @override
  String get attachFileCameraPermissionError =>
      'The app does not have camera access...';

  @override
  String get attachFileDocumentTitle => 'Document';

  @override
  String authAnonymousDisplayName(Object animalName) {
    return 'Anonymous $animalName';
  }

  @override
  String get authEmailAndPasswordLinkFillFormComplete =>
      'Please complete the form! 😉';

  @override
  String get authEmailAndPasswordLinkNicknameHint =>
      'This nickname is only visible to your group members and should be a pseudonym.';

  @override
  String get authEmailAndPasswordLinkNicknameLabel => 'Nickname';

  @override
  String get authEmailAndPasswordLinkSubmitAction => 'Link';

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
  String get blackboardCardAttachmentTooltip => 'Contains attachments';

  @override
  String get blackboardCardMyEntryTooltip => 'My entry';

  @override
  String get blackboardComposeMessageHint => 'Compose message';

  @override
  String get blackboardCustomImageUnavailableMessage =>
      'You currently cannot take/upload custom images yet 😔\n\nThis feature will be available very soon!';

  @override
  String get blackboardDeleteAttachmentsDialogDescription =>
      'Should the entry attachments be deleted from file storage or should only the link between both be removed?';

  @override
  String get blackboardDeleteDialogDescription =>
      'Do you really want to delete this entry for the whole course?';

  @override
  String get blackboardDeleteDialogTitle => 'Delete entry?';

  @override
  String blackboardDetailsAttachmentsCount(Object value) {
    return 'Attachments: $value';
  }

  @override
  String get blackboardDetailsTitle => 'Details';

  @override
  String get blackboardDialogSaveTooltip => 'Save entry';

  @override
  String get blackboardDialogTitleHint => 'Enter title';

  @override
  String get blackboardEntryDeleted => 'Entry deleted.';

  @override
  String get blackboardErrorCourseMissing => 'Please select a course.';

  @override
  String get blackboardErrorTitleMissing =>
      'Please enter a title for the entry.';

  @override
  String get blackboardMarkAsRead => 'Mark as read';

  @override
  String get blackboardMarkAsUnread => 'Mark as unread';

  @override
  String get blackboardPageAddInfoSheet => 'Add notice';

  @override
  String get blackboardPageEmptyDescription =>
      'Important announcements can be distributed here as digital notes to students, teachers and parents.';

  @override
  String get blackboardPageEmptyTitle => 'You have read all notices 👍';

  @override
  String get blackboardPageFabTooltip => 'New notice';

  @override
  String blackboardReadByInfoVisibleForRole(String role) {
    return 'This information is visible to you as $role.';
  }

  @override
  String blackboardReadByPercent(int percent) {
    return 'Read by: $percent%';
  }

  @override
  String get blackboardReadByRoleAdmin => 'Admin';

  @override
  String get blackboardReadByRoleAuthor => 'Author';

  @override
  String get blackboardReadByUsersPlusDescription =>
      'Get Sharezone Plus to see who has already read the notice.';

  @override
  String get blackboardReadByUsersTitle => 'Read by';

  @override
  String get blackboardRemoveAttachment => 'Remove attachment';

  @override
  String get blackboardSelectCoverImage => 'Select cover image';

  @override
  String get blackboardSendNotificationDescription =>
      'Send a notification to your course members that you created a new entry.';

  @override
  String get bnbTutorialDescription =>
      'Drag the bottom navigation bar upwards to access more features.';

  @override
  String get bnbTutorialSemanticsLabel =>
      'Diagram: How the navigation bar is pulled up to show more navigation items.';

  @override
  String get calendricalEventsAddEvent => 'Add event';

  @override
  String get calendricalEventsAddExam => 'Add exam';

  @override
  String get calendricalEventsCreateEventTooltip => 'Create new event';

  @override
  String get calendricalEventsCreateExamTooltip => 'Create new exam';

  @override
  String get calendricalEventsCreateNew => 'Create new';

  @override
  String get calendricalEventsEmptyTitle => 'No upcoming events or exams.';

  @override
  String get calendricalEventsFabTooltip => 'New exam or event';

  @override
  String get calendricalEventsSwitchToGrid => 'Switch to tiles';

  @override
  String get calendricalEventsSwitchToList => 'Switch to list';

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
  String get changeEmailAddressSubmitSnackbar =>
      'New email address is being sent to headquarters...';

  @override
  String get changeEmailAddressTitle => 'Change Email';

  @override
  String get changeEmailAddressWhyWeNeedTheEmailInfoContent =>
      'You need your email to log in. If you happen to forget your password, we can send you a link to reset your password to this email address. Your email address is only visible to you, and no one else.';

  @override
  String get changeEmailAddressWhyWeNeedTheEmailInfoTitle =>
      'Why do we need your email?';

  @override
  String get changeEmailReauthenticationDialogBody =>
      'After changing the email address, you must be signed out and signed in again. After that you can continue using the app as usual.\n\nTap \"Continue\" to sign out and sign in to Sharezone.\n\nIt may happen that the sign-in does not work (e.g. because the email address has not yet been confirmed). In that case, sign in manually.';

  @override
  String get changeEmailReauthenticationDialogTitle => 'Re-authentication';

  @override
  String get changeEmailVerifyDialogAfterWord => 'After';

  @override
  String get changeEmailVerifyDialogBodyPrefix =>
      'We sent you a link. Please click the link now to confirm your email address. Also check your spam folder.\n\n';

  @override
  String get changeEmailVerifyDialogBodySuffix =>
      ' you have confirmed the new email address, tap \"Continue\".';

  @override
  String get changeEmailVerifyDialogTitle => 'Confirm new email address';

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
  String get changelogPageTitle => 'What\'s new?';

  @override
  String get changelogSectionBugFixes => 'Bug fixes:';

  @override
  String get changelogSectionImprovements => 'Improvements:';

  @override
  String get changelogSectionNewFeatures => 'New features:';

  @override
  String changelogUpdatePromptStore(String store) {
    return 'We noticed that you have an outdated app version installed. Please download the latest version from the $store now! 👍';
  }

  @override
  String get changelogUpdatePromptTitle => 'New update available!';

  @override
  String get changelogUpdatePromptWeb =>
      'We noticed that you are using an outdated app version. Reload the page to get the latest version! 👍';

  @override
  String get commentActionsCopyText => 'Copy text';

  @override
  String get commentActionsReport => 'Report comment';

  @override
  String get commentDeletePrompt =>
      'Do you really want to delete the comment for everyone?';

  @override
  String get commentDeletedConfirmation => 'Comment deleted.';

  @override
  String get commentSectionReplyPrompt => 'Ask a follow-up question...';

  @override
  String commentsSectionTitle(Object value) {
    return 'Comments: $value';
  }

  @override
  String get commonActionBack => 'Back';

  @override
  String get commonActionChange => 'Change';

  @override
  String get commonActionRename => 'Rename';

  @override
  String get commonActionsAdd => 'Add';

  @override
  String get commonActionsAlright => 'Alright';

  @override
  String get commonActionsBack => 'Back';

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
  String get commonActionsCreate => 'Create';

  @override
  String get commonActionsCreateUppercase => 'CREATE';

  @override
  String get commonActionsDelete => 'Delete';

  @override
  String get commonActionsDeleteUppercase => 'DELETE';

  @override
  String get commonActionsDone => 'Done';

  @override
  String get commonActionsEdit => 'Edit';

  @override
  String get commonActionsHelp => 'Help';

  @override
  String get commonActionsJoin => 'Join';

  @override
  String get commonActionsLeave => 'Leave';

  @override
  String get commonActionsNo => 'No';

  @override
  String get commonActionsNotNow => 'Not now';

  @override
  String get commonActionsOk => 'OK';

  @override
  String get commonActionsReport => 'Report';

  @override
  String get commonActionsSave => 'Save';

  @override
  String get commonActionsSend => 'Send';

  @override
  String get commonActionsShare => 'Share';

  @override
  String get commonActionsSignOut => 'Sign out';

  @override
  String get commonActionsSignOutUppercase => 'SIGN OUT';

  @override
  String get commonActionsSkip => 'Skip';

  @override
  String get commonActionsYes => 'Yes';

  @override
  String get commonDate => 'Date';

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
  String get commonErrorGeneric => 'An error occurred.';

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
  String get commonErrorTitle => 'Error';

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
  String get commonFieldName => 'Name';

  @override
  String get commonLoadingPleaseWait => 'Please wait...';

  @override
  String get commonPleaseWaitMoment => 'Please wait a moment.';

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
  String get commonTextCopiedToClipboard => 'Text copied to clipboard';

  @override
  String get commonTitle => 'Title';

  @override
  String get commonTitleNote => 'Note';

  @override
  String get commonUnknownError => 'An error occurred.';

  @override
  String get contactSupportButton => 'Contact support';

  @override
  String get countryAustria => 'Austria';

  @override
  String get countryGermany => 'Germany';

  @override
  String get countrySwitzerland => 'Switzerland';

  @override
  String get courseActionsDeleteUppercase => 'DELETE COURSE';

  @override
  String get courseActionsKickUppercase => 'KICK FROM COURSE';

  @override
  String get courseActionsLeaveUppercase => 'LEAVE COURSE';

  @override
  String get courseAllowJoinExplanation =>
      'Use this setting to control whether new members can join the course.';

  @override
  String get courseCreateAbbreviationHint => 'e.g. M';

  @override
  String get courseCreateAbbreviationLabel => 'Course abbreviation';

  @override
  String get courseCreateNameDescription =>
      'The course name is mainly for teachers so they can distinguish courses with the same subject (e.g. \'Math class 8A\' and \'Math class 8B\').';

  @override
  String get courseCreateNameHint => 'e.g. Math advanced course Q2';

  @override
  String get courseCreateSubjectHint => 'e.g. Mathematics';

  @override
  String get courseCreateSubjectRequiredLabel => 'Course subject (required)';

  @override
  String get courseCreateTitle => 'Create course';

  @override
  String courseDeleteDialogDescription(String courseName) {
    return 'Do you really want to permanently delete the course \"$courseName\"?\n\nAll lessons & events in the timetable, homework and blackboard entries will be deleted.\n\nNobody will be able to access this course anymore!';
  }

  @override
  String get courseDeleteDialogTitle => 'Delete course?';

  @override
  String get courseDeleteSuccess => 'You successfully deleted the course.';

  @override
  String get courseDesignColorChangeFailed => 'Color could not be changed.';

  @override
  String get courseDesignCourseColorChanged =>
      'Color was successfully changed for the whole course.';

  @override
  String get courseDesignPersonalColorRemoved => 'Personal color removed.';

  @override
  String get courseDesignPersonalColorSet => 'Personal color set.';

  @override
  String get courseDesignPlusColorsHint =>
      'Not enough colors? Unlock 200+ extra colors with Sharezone Plus.';

  @override
  String get courseDesignRemovePersonalColor => 'Remove personal color';

  @override
  String get courseDesignTypeCourseSubtitle =>
      'Color applies to the whole course';

  @override
  String get courseDesignTypeCourseTitle => 'Course';

  @override
  String get courseDesignTypePersonalSubtitle =>
      'Applies only to you and overrides the course color';

  @override
  String get courseDesignTypePersonalTitle => 'Personal';

  @override
  String get courseEditSuccess => 'The course was edited successfully!';

  @override
  String get courseEditTitle => 'Edit course';

  @override
  String get courseFieldsAbbreviationLabel => 'Subject abbreviation';

  @override
  String get courseFieldsNameLabel => 'Course name';

  @override
  String get courseFieldsSubjectLabel => 'Subject';

  @override
  String get courseJoinNotificationAlreadyMember =>
      'You already joined this group';

  @override
  String get courseJoinNotificationGroupNotFound => 'Group not found';

  @override
  String get courseJoinNotificationJoinForbidden =>
      'Joining is forbidden. Contact the group admin.';

  @override
  String courseJoinNotificationJoinedClass(Object groupName) {
    return 'You joined class \"$groupName\"';
  }

  @override
  String courseJoinNotificationJoinedCourse(Object groupName) {
    return 'You joined course \"$groupName\"';
  }

  @override
  String courseJoinNotificationLoading(Object sharecode) {
    return 'Joining $sharecode...';
  }

  @override
  String get courseJoinNotificationNoInternet => 'No internet connection';

  @override
  String get courseJoinNotificationUnknownError =>
      'An error occurred. Please contact support.';

  @override
  String courseJoinNotificationUnknownErrorWithReason(Object reason) {
    return 'An error occurred: $reason. Please contact support.';
  }

  @override
  String get courseLeaveAndDeleteDialogDescription =>
      'Do you really want to leave the course? Since you are the last member, the course will be deleted.';

  @override
  String get courseLeaveAndDeleteDialogTitle => 'Leave and delete course?';

  @override
  String get courseLeaveDialogDescription =>
      'Do you really want to leave the course?';

  @override
  String get courseLeaveDialogTitle => 'Leave course?';

  @override
  String get courseLeaveSuccess => 'You successfully left the course.';

  @override
  String courseLongPressTitle(String courseName) {
    return 'Course: $courseName';
  }

  @override
  String get courseMemberOptionsAloneHint =>
      'Since you are the only one in this course, you cannot edit your role.';

  @override
  String get courseMemberOptionsOnlyAdminHint =>
      'You are the only admin in this course. Therefore, you cannot remove your own rights.';

  @override
  String get courseSelectColorsTooltip => 'Select colors';

  @override
  String courseTemplateAlreadyExistsDescription(String subject) {
    return 'You already created a course for the subject $subject. Do you want to create another one?';
  }

  @override
  String get courseTemplateAlreadyExistsTitle => 'Course already exists';

  @override
  String courseTemplateCourseCreated(String courseName) {
    return 'Course \"$courseName\" was created.';
  }

  @override
  String get courseTemplateCreateCustomCourseUppercase =>
      'CREATE CUSTOM COURSE';

  @override
  String get courseTemplateCustomCourseMissingPrompt =>
      'Your course is missing?';

  @override
  String get courseTemplateDeletedCourse => 'Course was deleted.';

  @override
  String get courseTemplateDeletingCourse => 'Course is being deleted again...';

  @override
  String get courseTemplateSchoolClassSelectionDescription =>
      'You are admin of one or more school classes. Select one to link newly created courses to that school class.';

  @override
  String courseTemplateSchoolClassSelectionInfo(String name) {
    return 'Courses created from now on will be linked to school class \"$name\".';
  }

  @override
  String get courseTemplateSchoolClassSelectionNoneInfo =>
      'Courses created from now on will not be linked to any school class.';

  @override
  String get courseTemplateSchoolClassSelectionNoneOption =>
      'Do not link to any school class';

  @override
  String get courseTemplateSchoolClassSelectionTitle => 'Select school class';

  @override
  String get courseTemplateSubjectArt => 'Art';

  @override
  String get courseTemplateSubjectBiology => 'Biology';

  @override
  String get courseTemplateSubjectCatholicReligion => 'Catholic religion';

  @override
  String get courseTemplateSubjectChemistry => 'Chemistry';

  @override
  String get courseTemplateSubjectComputerScience => 'Computer science';

  @override
  String get courseTemplateSubjectEconomics => 'Economics';

  @override
  String get courseTemplateSubjectEnglish => 'English';

  @override
  String get courseTemplateSubjectEthics => 'Ethics';

  @override
  String get courseTemplateSubjectFrench => 'French';

  @override
  String get courseTemplateSubjectGeography => 'Geography';

  @override
  String get courseTemplateSubjectGeographyErdkunde => 'Geography';

  @override
  String get courseTemplateSubjectGerman => 'German';

  @override
  String get courseTemplateSubjectHistory => 'History';

  @override
  String get courseTemplateSubjectHomeEconomics => 'Home economics';

  @override
  String get courseTemplateSubjectLatin => 'Latin';

  @override
  String get courseTemplateSubjectMath => 'Math';

  @override
  String get courseTemplateSubjectMusic => 'Music';

  @override
  String get courseTemplateSubjectNaturalSciences => 'Natural sciences';

  @override
  String get courseTemplateSubjectPedagogy => 'Pedagogy';

  @override
  String get courseTemplateSubjectPhilosophy => 'Philosophy';

  @override
  String get courseTemplateSubjectPhysics => 'Physics';

  @override
  String get courseTemplateSubjectPolitics => 'Politics';

  @override
  String get courseTemplateSubjectPracticalPhilosophy => 'Practical philosophy';

  @override
  String get courseTemplateSubjectProtestantReligion => 'Protestant religion';

  @override
  String get courseTemplateSubjectSocialStudies => 'Social studies';

  @override
  String get courseTemplateSubjectSpanish => 'Spanish';

  @override
  String get courseTemplateSubjectSport => 'Sport';

  @override
  String get courseTemplateSubjectTechnology => 'Technology';

  @override
  String get courseTemplateSubjectWorkEducation => 'Work education';

  @override
  String get courseTemplateTitle => 'Templates';

  @override
  String get courseTemplateUndoUppercase => 'UNDO';

  @override
  String get dashboardAdSectionAcquireSuffix => ' purchase.';

  @override
  String get dashboardAdSectionPrefix =>
      'Sharezone is free thanks to this ad. If you don\'t want to see ads, you can ';

  @override
  String get dashboardAdSectionSharezonePlusLabel => 'Sharezone Plus';

  @override
  String get dashboardDebugClearCache => '[DEBUG] Clear cache';

  @override
  String get dashboardDebugOpenV2Dialog => 'Open V2 dialog';

  @override
  String get dashboardFabAddBlackboardTitle => 'Blackboard entry';

  @override
  String get dashboardFabAddHomeworkTitle => 'Homework';

  @override
  String get dashboardFabCreateHomeworkTooltip => 'Create new homework';

  @override
  String get dashboardFabCreateLessonTooltip => 'Create new lesson';

  @override
  String get dashboardFabTooltip => 'Add new items';

  @override
  String get dashboardHolidayCountdownDayUnitDay => 'day';

  @override
  String get dashboardHolidayCountdownDayUnitDays => 'days';

  @override
  String get dashboardHolidayCountdownDisplayError =>
      'There was an error while displaying holidays.\nIf this happens often, please contact us.';

  @override
  String get dashboardHolidayCountdownGeneralError =>
      '💣 Boom... something went wrong. Please restart the app 👍';

  @override
  String dashboardHolidayCountdownHolidayLine(String text, String title) {
    return '$title: $text';
  }

  @override
  String dashboardHolidayCountdownInDays(int days, String emoji) {
    return 'In $days days $emoji';
  }

  @override
  String get dashboardHolidayCountdownLastDay => 'Last day 😱';

  @override
  String dashboardHolidayCountdownNow(String emoji) {
    return 'NOW, WOOOOOOO! $emoji';
  }

  @override
  String dashboardHolidayCountdownRemaining(
    String dayUnit,
    int days,
    String emoji,
  ) {
    return '$days $dayUnit left $emoji';
  }

  @override
  String get dashboardHolidayCountdownSelectStateHint =>
      'By selecting your region, we can calculate how long you still have to survive school until the holidays finally start 😉';

  @override
  String get dashboardHolidayCountdownTitle => 'Holiday countdown';

  @override
  String get dashboardHolidayCountdownTomorrow => 'Tomorrow 😱🎉';

  @override
  String get dashboardHolidayCountdownUnsupportedStateError =>
      'Holidays cannot be shown for your selected state! 😫\nYou can change the state in settings.';

  @override
  String get dashboardHolidayCountdownUnsupportedStateShortError =>
      'Holidays could not be shown for your state';

  @override
  String get dashboardNoLessonsToday => 'Yeah! There are no lessons today! 😍';

  @override
  String get dashboardNoUpcomingEventsInNext14Days =>
      'No events in the next 14 days! 👻';

  @override
  String get dashboardNoUrgentHomework =>
      'No urgent homework 😅\nNow it\'s time for the important things! 😉';

  @override
  String get dashboardRateOurAppActionTitle => 'Rate app';

  @override
  String get dashboardRateOurAppText =>
      'We would be incredibly grateful if you could leave us a rating in the App/Play Store 🐵';

  @override
  String get dashboardRateOurAppTitle => 'Do you like Sharezone?';

  @override
  String get dashboardSchoolIsOver => 'Finally, school is over! 😍';

  @override
  String get dashboardSelectStateButton => 'Select state / canton';

  @override
  String get dashboardUnreadBlackboardTitle => 'Unread notices';

  @override
  String dashboardUnreadBlackboardTitleWithCount(int count) {
    return 'Unread notices ($count)';
  }

  @override
  String get dashboardUpcomingEventsTitle => 'Upcoming events';

  @override
  String dashboardUpcomingEventsTitleWithCount(int count) {
    return 'Upcoming events ($count)';
  }

  @override
  String get dashboardUrgentHomeworkTitle => 'Urgent homework';

  @override
  String dashboardUrgentHomeworkTitleWithCount(int count) {
    return 'Urgent homework ($count)';
  }

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
  String get deleteAccountConfirmationCheckbox =>
      'Ja, ich möchte mein Konto löschen.';

  @override
  String get drawerAboutTooltip => 'About us';

  @override
  String get drawerNavigationTooltip => 'Navigation';

  @override
  String get drawerOpenSemanticsLabel => 'Open navigation';

  @override
  String get drawerProfileTooltip => 'Profile';

  @override
  String dynamicLinksNewLinkNotification(Object link) {
    return 'New dynamic link:\n$link';
  }

  @override
  String feedbackBoxCooldownError(Object coolDown) {
    return 'Error! Your cool down ($coolDown) has not expired yet.';
  }

  @override
  String get feedbackBoxDislikeLabel => 'What do you dislike?';

  @override
  String get feedbackBoxEmptyError => 'Please enter some text 😉';

  @override
  String get feedbackBoxGeneralRatingLabel => 'Overall rating:';

  @override
  String get feedbackBoxGenericError =>
      'Error! Please try again or send us your feedback by email. :)';

  @override
  String get feedbackBoxHeardFromLabel => 'How did you hear about Sharezone?';

  @override
  String get feedbackBoxLikeMostLabel => 'What do you like most?';

  @override
  String get feedbackBoxMissingLabel => 'What is still missing?';

  @override
  String get feedbackBoxPageTitle => 'Feedback box';

  @override
  String get feedbackBoxSubmitUppercase => 'SUBMIT';

  @override
  String get feedbackBoxWhyWeNeedFeedbackDescription =>
      'We want to build the best app for organizing school life! To make that happen, we need you! Just fill in the form and send it.\n\nAll questions are optional, of course.';

  @override
  String get feedbackBoxWhyWeNeedFeedbackTitle => 'Why we need your feedback:';

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
  String get feedbackHistoryPageEmpty => 'You haven\'t sent feedback yet 😢';

  @override
  String get feedbackHistoryPageTitle => 'My feedback';

  @override
  String get feedbackNewLineHint => 'Shift + Enter for a new line';

  @override
  String get feedbackSendTooltip => 'Send (Enter)';

  @override
  String get feedbackThankYouRatePromptPrefix =>
      'Do you like our app? Then we\'d love a rating in the ';

  @override
  String get feedbackThankYouRatePromptSuffix => ' we\'d be thrilled! 😄';

  @override
  String get feedbackThankYouTitle => 'Thank you for your feedback!';

  @override
  String get fileSharingCourseFoldersHeadline => 'Course folders';

  @override
  String fileSharingDeleteFolderDescription(Object value) {
    return 'Do you really want to delete the folder named \"$value\"?';
  }

  @override
  String get fileSharingDeleteFolderTitle => 'Delete folder?';

  @override
  String fileSharingDownloadError(Object value) {
    return 'Error: $value';
  }

  @override
  String get fileSharingDownloadingFileMessage => 'File is downloading...';

  @override
  String get fileSharingFabCameraTitle => 'Camera';

  @override
  String get fileSharingFabCameraTooltip => 'Open camera';

  @override
  String get fileSharingFabCreateFolderTitle => 'Create folder';

  @override
  String get fileSharingFabCreateFolderTooltip => 'Create new folder';

  @override
  String get fileSharingFabCreateNewTitle => 'Create new';

  @override
  String get fileSharingFabCreateNewTooltip => 'Create new';

  @override
  String get fileSharingFabFilesTitle => 'Files';

  @override
  String get fileSharingFabFilesTooltip => 'Files';

  @override
  String get fileSharingFabFolderNameHint => 'Folder name';

  @override
  String get fileSharingFabFolderTitle => 'Folder';

  @override
  String get fileSharingFabImagesTitle => 'Images';

  @override
  String get fileSharingFabImagesTooltip => 'Images';

  @override
  String get fileSharingFabMissingCameraPermission =>
      'Oh! Camera permission is missing!';

  @override
  String get fileSharingFabUploadTitle => 'Upload';

  @override
  String get fileSharingFabUploadTooltip => 'Upload new file';

  @override
  String get fileSharingFabVideosTitle => 'Videos';

  @override
  String get fileSharingFabVideosTooltip => 'Videos';

  @override
  String get fileSharingFoldersHeadline => 'Folders';

  @override
  String get fileSharingMoveEmptyFoldersMessage =>
      'There are no other folders here... Navigate between folders using the bar at the top.';

  @override
  String get fileSharingNewNameHint => 'New name';

  @override
  String get fileSharingNoCourseFoldersFoundDescription =>
      'No folders were found because you haven\'t joined any courses yet. Just join a course or create your own course.';

  @override
  String get fileSharingNoFilesFoundDescription =>
      'Just upload a file now to share it with your course 👍';

  @override
  String get fileSharingNoFilesFoundTitle => 'No files found 😶';

  @override
  String get fileSharingNoFoldersFoundTitle => 'No folders found! 😬';

  @override
  String get fileSharingPreparingDownloadMessage =>
      'The file is being beamed to your device...';

  @override
  String get fileSharingRenameActionUppercase => 'RENAME';

  @override
  String get fileSharingRenameFolderTitle => 'Rename folder';

  @override
  String get filesAddAttachment => 'Add attachment';

  @override
  String filesCreator(Object value) {
    return 'by $value';
  }

  @override
  String filesDeleteDialogDescription(String fileName) {
    return 'Do you really want to delete the file named \"$fileName\"?';
  }

  @override
  String get filesDeleteDialogTitle => 'Delete file?';

  @override
  String get filesDisplayErrorTitle => 'Display error';

  @override
  String get filesDownloadBrokenFileError =>
      'The file is corrupted and cannot be downloaded.';

  @override
  String get filesDownloadStarted => 'Download started...';

  @override
  String get filesLoading => 'Loading...';

  @override
  String get filesMoveAcrossCoursesNotSupported =>
      'Moving to another course is currently not supported.';

  @override
  String filesMoveTo(Object value) {
    return 'Move to $value';
  }

  @override
  String get filesMoveUppercase => 'MOVE';

  @override
  String get filesNoCourseMembershipHint =>
      'You are not a member of any course yet 😔\nCreate or join a course 😃';

  @override
  String get filesPrivateVisibleOnlyToYou => 'Private (visible only to you)';

  @override
  String get filesRenameDialogHint => 'New name';

  @override
  String get filesRenameDialogTitle => 'Rename file';

  @override
  String get filesSelectCourseTitle => 'Select a course';

  @override
  String filesSizeMegabytes(String size) {
    return 'Size: $size MB';
  }

  @override
  String filesUploadError(Object error) {
    return 'An error occurred: $error';
  }

  @override
  String filesUploadProgress(Object progress) {
    return 'Uploading file to server: $progress/100';
  }

  @override
  String filesUploadedOn(String date) {
    return 'Uploaded on: $date';
  }

  @override
  String get gradesCommonName => 'Name';

  @override
  String get gradesCreateTermCurrentTerm => 'Current term';

  @override
  String get gradesCreateTermGradingSystemInfo =>
      'Only grades that use the grading system selected for the term can be included in the term average. For example, if the term uses \"1 - 6\" and you enter a grade using \"15 - 0\", that grade cannot be included in the term average.';

  @override
  String get gradesCreateTermInvalidNameError => 'Please enter a valid name.';

  @override
  String gradesCreateTermSaveFailedError(Object error) {
    return 'The term could not be saved: $error';
  }

  @override
  String get gradesCreateTermSaved => 'Term saved.';

  @override
  String get gradesDetailsDeletePrompt =>
      'Do you really want to delete this grade?';

  @override
  String get gradesDetailsDeleteTitle => 'Delete grade';

  @override
  String get gradesDetailsDeleteTooltip => 'Delete grade';

  @override
  String get gradesDetailsDeleted => 'Grade deleted.';

  @override
  String get gradesDetailsDummyDetails => 'This is a test grade for algebra.';

  @override
  String get gradesDetailsDummyTopic => 'Algebra';

  @override
  String get gradesDetailsEditTooltip => 'Edit grade';

  @override
  String get gradesDialogCreateTerm => 'Create term';

  @override
  String get gradesDialogCustomGradeType => 'Custom grade type';

  @override
  String get gradesDialogDateHelpDescription =>
      'The date is the day you received the grade. If you don\'t remember it exactly, you can enter an approximate date.';

  @override
  String get gradesDialogDateHelpTitle => 'What is the date for?';

  @override
  String get gradesDialogDifferentGradingSystemInfo =>
      'The grading system you selected is different from your term\'s grading system. You can still save the grade, but it will not be included in the term average.';

  @override
  String get gradesDialogEditSubjectDescription =>
      'You cannot change the subject of an already created grade.\n\nDelete this grade and create it again to choose another subject.';

  @override
  String get gradesDialogEditSubjectTitle => 'Change subject';

  @override
  String get gradesDialogEditTermDescription =>
      'You cannot change the term of an already created grade.\n\nDelete this grade and create it again to choose another term.';

  @override
  String get gradesDialogEditTermTitle => 'Change term';

  @override
  String get gradesDialogEnterGradeError => 'Please enter a grade.';

  @override
  String get gradesDialogEnterTitleError => 'Please enter a title.';

  @override
  String get gradesDialogGoToSharezonePlus => 'Go to Sharezone Plus';

  @override
  String get gradesDialogGradeInvalid => 'The grade is invalid.';

  @override
  String get gradesDialogGradeIsInvalidError =>
      'The input is not a valid number.';

  @override
  String get gradesDialogGradeIsOutOfRangeError =>
      'The grade is outside the valid range.';

  @override
  String get gradesDialogGradeLabel => 'Grade';

  @override
  String get gradesDialogGradeTypeLabel => 'Grade type';

  @override
  String get gradesDialogGradingSystemLabel => 'Grading system';

  @override
  String get gradesDialogHintFifteenZero => 'e.g. 15.0';

  @override
  String get gradesDialogHintOnePlus => 'e.g. 1+';

  @override
  String get gradesDialogHintOneThree => 'e.g. 1.3';

  @override
  String get gradesDialogHintSeventyEightEight => 'e.g. 78.8';

  @override
  String get gradesDialogHintSixZero => 'e.g. 6.0';

  @override
  String get gradesDialogIncludeGradeInAverage => 'Include grade in average';

  @override
  String gradesDialogInvalidFieldsCombined(Object fieldMessages) {
    return 'The following fields are missing or invalid: $fieldMessages.';
  }

  @override
  String get gradesDialogInvalidGradeField =>
      'The grade is missing or invalid.';

  @override
  String get gradesDialogInvalidSubjectField =>
      'Please select a subject for the grade.';

  @override
  String get gradesDialogInvalidTermField =>
      'Please select a term for the grade.';

  @override
  String get gradesDialogInvalidTitleField =>
      'The title is missing or invalid.';

  @override
  String get gradesDialogNoGradeSelected => 'No grade selected';

  @override
  String get gradesDialogNoSubjectSelected => 'No subject selected';

  @override
  String get gradesDialogNoTermSelected => 'No term selected';

  @override
  String get gradesDialogNoTermsYetInfo =>
      'You haven\'t created any terms yet. Please create a term to add a grade.';

  @override
  String get gradesDialogNotesLabel => 'Notes';

  @override
  String get gradesDialogPlusSubjectsLimitInfo =>
      'You can use at most 3 subjects while testing the grades feature. Buy Sharezone Plus to use all subjects.';

  @override
  String get gradesDialogRequestAdditionalGradingSystem =>
      'Request another grading system';

  @override
  String get gradesDialogRequestAdditionalGradingSystemSubtitle =>
      'Missing a grading system? Tell us which one you\'d like to use!';

  @override
  String get gradesDialogSavedSnackBar => 'Grade saved';

  @override
  String get gradesDialogSelectGrade => 'Select grade';

  @override
  String get gradesDialogSelectGradeType => 'Select grade type';

  @override
  String get gradesDialogSelectGradingSystem => 'Select grading system';

  @override
  String get gradesDialogSelectGradingSystemHint =>
      'The first value is the best grade. For example, in \"1 - 6\", \"1\" is the best grade.';

  @override
  String get gradesDialogSelectSubject => 'Select subject';

  @override
  String get gradesDialogSelectTerm => 'Select term';

  @override
  String get gradesDialogSubjectLabel => 'Subject';

  @override
  String get gradesDialogTermLabel => 'Term';

  @override
  String get gradesDialogTitleHelpDescription =>
      'If the grade belongs to an exam, you can enter the topic/title to identify it more easily later.';

  @override
  String get gradesDialogTitleHelpTitle => 'What is the title for?';

  @override
  String get gradesDialogTitleHint => 'e.g. Linear functions';

  @override
  String get gradesDialogTitleLabel => 'Title';

  @override
  String get gradesDialogUnknownCustomGradeType => 'Unknown/Custom grade type';

  @override
  String gradesDialogUnknownError(Object error) {
    return 'Unknown error: $error';
  }

  @override
  String get gradesDialogZeroWeightGradeTypeInfo =>
      'The selected grade type currently has a weight of 0. You can still save the grade, but it won\'t affect the subject average. You can adjust the weight in the subject or term settings after saving.';

  @override
  String get gradesFinalGradeTypeHelpDialogText =>
      'The final grade is the grade you ultimately receive in a subject, for example on your report card. Sometimes teachers consider additional factors that differ from the default formula (e.g. 50% exams and 50% oral participation). In those cases, you can overwrite Sharezone\'s calculated grade with the final one.\n\nYou can define this for all subjects in a term or customize it per subject.';

  @override
  String get gradesFinalGradeTypeHelpDialogTitle =>
      'What is a subject\'s final grade?';

  @override
  String get gradesFinalGradeTypeHelpTooltip => 'What is the final grade?';

  @override
  String get gradesFinalGradeTypeSubtitle =>
      'The calculated subject grade can be overridden by a grade type.';

  @override
  String get gradesFinalGradeTypeTitle => 'Subject final grade';

  @override
  String get gradesPageAddGrade => 'Add grade';

  @override
  String get gradesPageCurrentGradesLabel => 'Current grades';

  @override
  String get gradesPagePastTermTitle => 'Past term';

  @override
  String get gradesSettingsPageTitle => 'Grade settings';

  @override
  String get gradesSettingsSubjectsSubtitle =>
      'Manage subjects and linked courses';

  @override
  String get gradesSettingsSubjectsTitle => 'Subjects';

  @override
  String gradesSubjectSettingsPageTitle(Object subjectDisplayName) {
    return 'Settings: $subjectDisplayName';
  }

  @override
  String get gradesSubjectsPageCourseNotAssigned =>
      'This course is not assigned to a grade subject yet.';

  @override
  String gradesSubjectsPageCoursesLabel(Object courseNames) {
    return 'Courses: $courseNames';
  }

  @override
  String get gradesSubjectsPageCoursesWithoutSubject =>
      'Courses without grade subject';

  @override
  String get gradesSubjectsPageDeleteDescription =>
      'Deleting will permanently remove all related grades.';

  @override
  String gradesSubjectsPageDeleteFailure(Object error) {
    return 'Subject could not be deleted: $error';
  }

  @override
  String get gradesSubjectsPageDeleteSuccess =>
      'Subject and related grades deleted.';

  @override
  String gradesSubjectsPageDeleteTitle(Object subjectName) {
    return 'Delete $subjectName';
  }

  @override
  String get gradesSubjectsPageDeleteTooltip => 'Delete subject';

  @override
  String get gradesSubjectsPageGradeSubjects => 'Grade subjects';

  @override
  String get gradesSubjectsPageInfoBody =>
      'In Sharezone, all content (like homework or exams) belongs to a course. Your grades, however, are stored in grade subjects, not courses. That way, your grades stay available even if you leave a course.\n\nAnother advantage: you can sort grades by subject and later track your progress in a subject across multiple years (feature coming soon).\n\nSharezone automatically creates a grade subject as soon as you create a grade in a course.';

  @override
  String get gradesSubjectsPageInfoHeader => 'Grade subjects vs courses';

  @override
  String gradesSubjectsPageMultipleGrades(Object count) {
    return '$count grades';
  }

  @override
  String get gradesSubjectsPageNoGrades => 'No grades';

  @override
  String get gradesSubjectsPageNoGradesRecorded =>
      'No grades have been recorded for this subject yet.';

  @override
  String get gradesSubjectsPageSingleGrade => '1 grade';

  @override
  String get gradesTermDetailsDeleteDescription =>
      'Do you really want to delete this term including all grades?\n\nThis action cannot be undone.';

  @override
  String get gradesTermDetailsDeleteTitle => 'Delete term';

  @override
  String get gradesTermDetailsDeleteTooltip => 'Delete term';

  @override
  String get gradesTermDetailsEditSubjectTooltip => 'Edit subject grade';

  @override
  String get gradesTermDetailsPageTitle => 'Term details';

  @override
  String get gradesTermDialogNameLabel => 'Term name';

  @override
  String get gradesTermSettingsCourseWeightingDescription =>
      'If some courses should count double, you can set their weight to 2.0.';

  @override
  String get gradesTermSettingsCourseWeightingTitle =>
      'Course weighting for term average';

  @override
  String get gradesTermSettingsEditNameDescription =>
      'The name describes the term, e.g. \'10/2\' for the second term of grade 10.';

  @override
  String get gradesTermSettingsEditNameTitle => 'Rename';

  @override
  String get gradesTermSettingsEditWeightDescription =>
      'The weight defines how strongly the course grade affects the term average.';

  @override
  String get gradesTermSettingsEditWeightTitle => 'Edit weight';

  @override
  String get gradesTermSettingsNameHint => 'e.g. 10/2';

  @override
  String get gradesTermSettingsNameRequired => 'Please enter a name.';

  @override
  String get gradesTermSettingsNoSubjectsYet =>
      'You haven\'t created any subjects yet.';

  @override
  String gradesTermSettingsTitle(Object name) {
    return 'Settings: $name';
  }

  @override
  String get gradesTermSettingsWeightDisplayTypeFactor => 'Factor';

  @override
  String get gradesTermSettingsWeightDisplayTypePercent => 'Percent';

  @override
  String get gradesTermSettingsWeightDisplayTypeTitle => 'Weighting system';

  @override
  String get gradesTermSettingsWeightHint => 'e.g. 1.0';

  @override
  String get gradesTermSettingsWeightInvalid => 'Please enter a number.';

  @override
  String get gradesTermSettingsWeightLabel => 'Weight';

  @override
  String get gradesTermTileEditTooltip => 'Edit average';

  @override
  String get gradesWeightSettingsAddWeight => 'Add new weight';

  @override
  String get gradesWeightSettingsHelpDialogText =>
      'In Sharezone, you can define exactly how each subject grade is calculated by setting weights for each grade type. For example, you can configure the final grade to be 50% written exams and 50% oral participation.\n\nThis flexibility helps you model your school\'s grading rules accurately.';

  @override
  String get gradesWeightSettingsHelpDialogTitle =>
      'How is the subject grade calculated?';

  @override
  String get gradesWeightSettingsHelpTooltip => 'How is the grade calculated?';

  @override
  String get gradesWeightSettingsInvalidWeightInput =>
      'Please enter a valid number (>= 0).';

  @override
  String get gradesWeightSettingsPercentHint => 'e.g. 56.5';

  @override
  String get gradesWeightSettingsPercentLabel => 'Weight in %';

  @override
  String get gradesWeightSettingsRemoveTooltip => 'Remove';

  @override
  String get gradesWeightSettingsSubtitle =>
      'Define grade type weights for calculating the subject grade.';

  @override
  String get gradesWeightSettingsTitle => 'Subject grade calculation';

  @override
  String get gradingSystemAustrianBehaviouralGrades =>
      'Austrian behavioural grades';

  @override
  String get gradingSystemOneToFiveWithDecimals => '1 - 5 (with decimals)';

  @override
  String get gradingSystemOneToSixWithDecimals => '1 - 6 (with decimals)';

  @override
  String get gradingSystemOneToSixWithPlusAndMinus => '1 - 6 (+-)';

  @override
  String get gradingSystemSixToOneWithDecimals => '6 - 1 (with decimals)';

  @override
  String get gradingSystemZeroToFifteenPoints => '15 - 0 points';

  @override
  String get gradingSystemZeroToFifteenPointsWithDecimals =>
      '15 - 0 points (with decimals)';

  @override
  String get gradingSystemZeroToHundredPercentWithDecimals =>
      '100% - 0% (with decimals)';

  @override
  String get groupCourseDetailsLoadError =>
      'Es gab einen Fehler beim Laden des Kurses.\n\nMöglicherweise bist du nicht mehr ein Teilnehmer dieses Kurses.';

  @override
  String get groupDesignSelectBaseColorTitle => 'Grundfarbe auswählen';

  @override
  String get groupHelpDifferenceDescription =>
      'Course: Represents a school subject.\n\nSchool class: Consists of multiple courses and allows joining all of them with one sharecode.\n\nGroup: The umbrella term for a course and a school class.';

  @override
  String get groupHelpDifferenceTitle =>
      'What is the difference between a group, a course and a school class?';

  @override
  String get groupHelpHowToJoinOverview =>
      'There are two ways to join a group from classmates or teachers:\n\n1. Scan sharecode via QR code\n2. Enter the sharecode manually';

  @override
  String get groupHelpHowToJoinTitle => 'How do I join a group?';

  @override
  String get groupHelpRolesDescription =>
      'Administrator:\nAn admin manages a group. This means they can edit, delete and remove members. They can also configure all other group settings, such as enabling/disabling joining.\n\nActive member:\nAn active member can create and edit content in a group, such as homework, events and lessons. They have read and write permissions.\n\nPassive member:\nA passive member only has read permissions. No content may be created or edited.';

  @override
  String get groupHelpRolesTitle =>
      'Group roles explained: passive member, active member, administrator';

  @override
  String get groupHelpScanQrCodeDescription =>
      '1. A person already in the course opens the desired course from the \"Group\" page.\n2. That person taps \"Show QR code\".\n3. A sheet with a QR code opens.\n4. The person who wants to join taps the red button on the \"Groups\" page.\n5. Then they choose \"Join course/class\".\n6. A window opens - the user taps the blue graphic to scan the QR code.\n7. Finally, point the camera at the other person\'s QR code.';

  @override
  String get groupHelpScanQrCodeTitle => 'Scan sharecode with a QR code';

  @override
  String get groupHelpTitle => 'Help: Groups';

  @override
  String get groupHelpTypeSharecodeDescription =>
      '1. A person already in the course opens the desired course from the \"Groups\" page.\n2. The sharecode is shown right below the course name.\n3. The person who wants to join taps the red button on the \"Groups\" page.\n4. Then they choose \"Join course/class\".\n5. A window opens - now just type in the sharecode from the other person.';

  @override
  String get groupHelpTypeSharecodeTitle => 'Enter sharecode manually';

  @override
  String get groupHelpWhatIsSharecodeDescription =>
      'The sharecode is an access key for a course. Classmates and teachers can use it to join the course.\n\nThanks to the sharecode, members do not need to exchange personal data such as email addresses or private phone numbers - unlike many WhatsApp groups or most email distribution lists.\n\nA course member only sees the name (can also be a pseudonym) of other course members.';

  @override
  String get groupHelpWhatIsSharecodeTitle => 'What is a sharecode?';

  @override
  String get groupHelpWhyDifferentSharecodesDescription =>
      'Every course participant has an individual sharecode.\n\nThis makes it possible to track which user invited whom.\n\nThanks to this feature, referrals can be counted even without using a referral link.';

  @override
  String get groupHelpWhyDifferentSharecodesTitle =>
      'Why does each participant in a group have a different sharecode?';

  @override
  String get groupJoinCourseSelectionParentHint =>
      'If your child takes electives (e.g. French), you should deselect these courses.';

  @override
  String get groupJoinCourseSelectionStudentHint =>
      'If you take electives (e.g. French), you should deselect these courses.';

  @override
  String get groupJoinCourseSelectionTeacherHint =>
      'Select the courses you teach.';

  @override
  String groupJoinCourseSelectionTitle(String groupName) {
    return 'Courses to join from $groupName';
  }

  @override
  String get groupJoinErrorAlreadyMemberDescription =>
      'You are already a member of this group, so you do not need to join it again.';

  @override
  String get groupJoinErrorAlreadyMemberTitle =>
      'An error occurred: Already a member 🤨';

  @override
  String get groupJoinErrorNoInternetDescription =>
      'We could not try to join the group because no internet connection could be established. Please check your Wi-Fi or mobile data.';

  @override
  String get groupJoinErrorNoInternetTitle =>
      'An error occurred: No internet connection ☠️';

  @override
  String get groupJoinErrorNotPublicDescription =>
      'The group currently does not allow joining. This is disabled in the group settings. Please contact an admin of this group.';

  @override
  String get groupJoinErrorNotPublicTitle =>
      'An error occurred: Joining forbidden ⛔️';

  @override
  String get groupJoinErrorSharecodeNotFoundDescription =>
      'We could not find the entered sharecode. Please check upper/lower case and whether the sharecode is still valid.';

  @override
  String get groupJoinErrorSharecodeNotFoundTitle =>
      'An error occurred: Sharecode not found ❌';

  @override
  String get groupJoinErrorUnknownDescription =>
      'This might be due to your internet connection. Please check it.';

  @override
  String get groupJoinErrorUnknownTitle => 'An unknown error occurred 😭';

  @override
  String groupJoinPasteSharecodeDescription(String sharecode) {
    return 'Do you want to use the sharecode \"$sharecode\" from your clipboard?';
  }

  @override
  String get groupJoinPasteSharecodeTitle => 'Paste sharecode';

  @override
  String get groupJoinRequireCourseSelectionDescription =>
      'To join, you need to select the courses you are in.';

  @override
  String groupJoinRequireCourseSelectionTitle(String groupName) {
    return 'Class found: $groupName';
  }

  @override
  String get groupJoinResultJoinMoreAction => 'Join more';

  @override
  String get groupJoinResultRetryAction => 'Try again';

  @override
  String get groupJoinResultSelectCoursesAction => 'Select courses';

  @override
  String get groupJoinScanQrCodeDescription =>
      'Scan a QR code to join a group.';

  @override
  String get groupJoinScanQrCodeTooltip => 'Scan QR code';

  @override
  String get groupJoinSharecodeHint => 'e.g. Qb32vF';

  @override
  String get groupJoinSharecodeLabel => 'Sharecode';

  @override
  String groupJoinSuccessDescription(String groupName) {
    return '$groupName was added successfully. You are now a member.';
  }

  @override
  String get groupJoinSuccessTitle => 'Joined successfully 🎉';

  @override
  String get groupOnboardingChooseNameTitle =>
      'Welcher Name soll anderen Schülern, Lehrkräften und Eltern angezeigt werden?';

  @override
  String get groupOnboardingCreateCoursesTitleOther =>
      'Which courses should be linked to the class?';

  @override
  String get groupOnboardingCreateCoursesTitleTeacher =>
      'Which courses do you teach?';

  @override
  String get groupOnboardingCreateNewGroupsAction =>
      'No, I\'d like to create new groups';

  @override
  String get groupOnboardingCreateSchoolClassTitleParent =>
      'Wie heißt die Klasse deines Kindes?';

  @override
  String get groupOnboardingCreateSchoolClassTitleStudent =>
      'Wie heißt deine Klasse / Stufe?';

  @override
  String get groupOnboardingCreateSchoolClassTitleTeacher =>
      'Wie heißt die Klasse?';

  @override
  String get groupOnboardingFirstPersonHint =>
      'If a classmate already uses Sharezone, they can give you a share code so you can join their class.';

  @override
  String get groupOnboardingFirstPersonParentTitle =>
      'Have groups already been created by students or teachers?';

  @override
  String get groupOnboardingFirstPersonStudentTitle =>
      'Have classmates or your teacher already created a course, class, or grade level? 💪';

  @override
  String get groupOnboardingFirstPersonTeacherTitle =>
      'Have groups already been created by someone else? 💪';

  @override
  String get groupOnboardingIsClassTeacherCreateClassAction =>
      'Yes, I\'d like to create a class';

  @override
  String get groupOnboardingIsClassTeacherCreateCoursesOnlyAction =>
      'No, I\'d like to create courses only';

  @override
  String get groupOnboardingIsClassTeacherTitle =>
      'Do you lead a class? (class teacher)';

  @override
  String get groupOnboardingJoinMultipleGroupsAction =>
      'Yes, I\'d like to join these groups';

  @override
  String get groupOnboardingJoinSingleGroupAction =>
      'Yes, I\'d like to join this group';

  @override
  String get groupOnboardingSchoolClassHint => 'e.g. 10A';

  @override
  String get groupOnboardingSharecodeGroupTypeCourse => 'des Kurses';

  @override
  String get groupOnboardingSharecodeGroupTypeSchoolClass => 'der Schulklasse';

  @override
  String get groupOnboardingSharecodeInviteClassmatesAndTeacher =>
      'Lade jetzt deine Mitschüler und deinen Lehrer / deine Lehrerin ein!';

  @override
  String get groupOnboardingSharecodeInviteMixed =>
      'Lade jetzt andere Schüler, Eltern oder Lehrkräfte ein!';

  @override
  String get groupOnboardingSharecodeInviteStudents =>
      'Lade jetzt deine Schüler und Schülerinnen ein!';

  @override
  String get groupOnboardingSharecodeJoinHint =>
      'Mitschüler, Lehrer und Eltern können über den Sharecode der Klasse beitreten. Dadurch können Infozettel, Hausausgaben, Termine, Dateien und der Stundenplan gemeinsam organisiert werden.';

  @override
  String groupOnboardingSharecodeJoinLabel(String groupName, String groupType) {
    return 'Zum Beitreten $groupType ($groupName):';
  }

  @override
  String get groupParticipantsEmpty =>
      'There are no participants in this group 😭';

  @override
  String get groupShareActionCopy => 'copy';

  @override
  String get groupShareActionShare => 'share';

  @override
  String get groupShareInviteDescription =>
      'Simply send the join link via any app or show the QR code so your classmates and teachers can scan it 👍🚀';

  @override
  String get groupShareInviteTargetClass => 'this class';

  @override
  String get groupShareInviteTargetGroup => 'this group';

  @override
  String groupShareInviteTitle(String target) {
    return 'Invite your classmates & teachers to $target!';
  }

  @override
  String get groupShareLinkButtonTitle => 'Link';

  @override
  String get groupShareSharecodeButtonTitle => 'Sharecode';

  @override
  String get groupsAllowJoinTitle => 'Allow joining';

  @override
  String get groupsContactSupportLinkText => 'Support';

  @override
  String get groupsContactSupportPrefix => 'Need help? Just contact our ';

  @override
  String get groupsContactSupportSuffix => ' 😉';

  @override
  String get groupsCreateCourseDescription =>
      'Think of a course as a school subject. Each subject is represented by one course.';

  @override
  String get groupsCreateSchoolClassDescription =>
      'A school class consists of multiple courses. When joining the class, members automatically join all linked courses.';

  @override
  String get groupsEmptyTitle => 'You have not joined any course or class yet!';

  @override
  String get groupsFabJoinOrCreateTooltip => 'Join/create group';

  @override
  String get groupsInviteParticipants => 'Invite participants';

  @override
  String get groupsJoinCourseOrClassDescription =>
      'If one of your classmates already created a class or course, you can simply join it.';

  @override
  String get groupsJoinCourseOrClassTitle => 'Join course/class';

  @override
  String get groupsJoinTitle => 'Join';

  @override
  String get groupsLinkCopied => 'Link copied';

  @override
  String groupsMemberCount(Object value) {
    return 'Number of participants: $value';
  }

  @override
  String get groupsMemberOptionsNoAdminRightsHint =>
      'Since you are not an admin, you do not have permission to manage other members.';

  @override
  String get groupsMemberYou => 'You';

  @override
  String get groupsMembersActiveMemberTitle =>
      'Active member (read and write access)';

  @override
  String get groupsMembersAdminsTitle => 'Administrators';

  @override
  String get groupsMembersLegendTitle => 'Legend';

  @override
  String get groupsMembersPassiveMemberTitle =>
      'Passive member (read-only access)';

  @override
  String get groupsPageMyCourses => 'My courses:';

  @override
  String get groupsPageMySchoolClass => 'My class:';

  @override
  String get groupsPageMySchoolClasses => 'My classes:';

  @override
  String get groupsPageTitle => 'Groups';

  @override
  String get groupsQrCodeHelpText =>
      'Was muss ich machen?\nNun muss dein Mitschüler oder dein Lehrer den QR-Code abscannen, indem er auf der \"Meine Kurse\" Seite auf \"Kurs beitreten\" klickt.';

  @override
  String get groupsQrCodeSubtitle => 'show';

  @override
  String get groupsQrCodeTitle => 'QR code';

  @override
  String get groupsRoleActiveMemberDescription => 'Read and write permissions';

  @override
  String get groupsRoleAdminDescription =>
      'Read and write permissions & administration';

  @override
  String get groupsRoleReadOnlyDescription => 'Read permissions';

  @override
  String get groupsSharecodeCopied => 'Share code copied';

  @override
  String get groupsSharecodeCopiedToClipboard =>
      'Sharecode copied to clipboard.';

  @override
  String get groupsSharecodeLoading => 'Loading sharecode...';

  @override
  String groupsSharecodeLowercaseCharacter(String character) {
    return 'lowercase $character';
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
    return 'uppercase $character';
  }

  @override
  String get groupsWritePermissionsEveryoneDescription =>
      'Everyone gets the role \"active member (read and write permissions)\"';

  @override
  String get groupsWritePermissionsExplanation =>
      'Use this setting to control which user groups receive write permissions.';

  @override
  String get groupsWritePermissionsOnlyAdminsDescription =>
      'Everyone except admins gets the role \"passive member (read-only permissions)\"';

  @override
  String get groupsWritePermissionsSheetQuestion =>
      'Who is allowed to create or upload new entries, homework, files, etc.?';

  @override
  String get groupsWritePermissionsTitle => 'Write permissions';

  @override
  String get homeworkAddAction => 'Add homework';

  @override
  String get homeworkBottomBarMoreIdeas => 'More ideas?';

  @override
  String get homeworkCardViewCompletedByTooltip => 'Show \"Completed by\"';

  @override
  String get homeworkCardViewSubmissionsTooltip => 'Show submissions';

  @override
  String get homeworkCompletionPlusDescription =>
      'Get Sharezone Plus to see who has already marked the homework as completed.';

  @override
  String get homeworkCompletionReadByTitle => 'Completed by';

  @override
  String get homeworkDeleteAttachmentsDialogDescription =>
      'Should homework attachments be deleted from file storage or should only the link between them be removed?';

  @override
  String get homeworkDeleteAttachmentsDialogTitle => 'Delete attachments too?';

  @override
  String get homeworkDeleteAttachmentsUnlink => 'Unlink';

  @override
  String get homeworkDeleteScopeDialogDescription =>
      'Should homework be deleted only for you or for the entire course?';

  @override
  String get homeworkDeleteScopeDialogTitle => 'Delete for everyone?';

  @override
  String get homeworkDeleteScopeOnlyMe => 'Only for me';

  @override
  String get homeworkDeleteScopeWholeCourse => 'For entire course';

  @override
  String get homeworkDetailsAdditionalInfo => 'Additional information';

  @override
  String homeworkDetailsAttachmentsCount(int count) {
    return 'Attachments: $count';
  }

  @override
  String get homeworkDetailsChangeAccountTypeContent =>
      'If you want to submit homework, your account must be registered as a student. Support can convert your account to a student account so you can submit homework.';

  @override
  String get homeworkDetailsChangeAccountTypeEmailBody =>
      'Dear Sharezone team, please change my account type to student.';

  @override
  String homeworkDetailsChangeAccountTypeEmailSubject(String uid) {
    return 'Change account type to student [$uid]';
  }

  @override
  String get homeworkDetailsChangeAccountTypeTitle => 'Change account type?';

  @override
  String get homeworkDetailsCourseTitle => 'Course';

  @override
  String get homeworkDetailsCreatedBy => 'Created by:';

  @override
  String homeworkDetailsDoneByStudentsCount(int count) {
    return 'Done by $count students';
  }

  @override
  String get homeworkDetailsMarkAsDone => 'Mark as done';

  @override
  String get homeworkDetailsMarkAsUndone => 'Mark as not done';

  @override
  String get homeworkDetailsMarkDoneAction => 'Mark done';

  @override
  String get homeworkDetailsMySubmission => 'My submission';

  @override
  String get homeworkDetailsNoPermissionTitle => 'No permission';

  @override
  String get homeworkDetailsNoSubmissionContent =>
      'You haven\'t submitted anything yet. Do you really want to mark this homework as done without a submission?';

  @override
  String get homeworkDetailsNoSubmissionTitle => 'No submission yet';

  @override
  String get homeworkDetailsNoSubmissionYet => 'No submission yet';

  @override
  String get homeworkDetailsParentsCannotSubmit =>
      'Parents cannot submit homework';

  @override
  String get homeworkDetailsPrivateSubtitle =>
      'This homework is not shared with the course.';

  @override
  String get homeworkDetailsPrivateTitle => 'Private';

  @override
  String homeworkDetailsSubmissionsCount(int count) {
    return '$count submissions';
  }

  @override
  String get homeworkDetailsViewCompletionNoPermissionContent =>
      'For security reasons, a teacher may only view the completion list with admin rights in the respective group.\n\nOtherwise, any student could create a new account as a teacher, join the group and see which students have already completed the homework.';

  @override
  String get homeworkDetailsViewSubmissionsNoPermissionContent =>
      'For security reasons, a teacher may only view submissions with admin rights in the respective group.\n\nOtherwise, any student could create a new account as a teacher, join the group and view other students\' submissions.';

  @override
  String get homeworkDialogCourseChangeDisabled =>
      'The course cannot be changed afterwards. Please delete the homework and create a new one if you want to change the course.';

  @override
  String get homeworkDialogDescriptionHint => 'Enter additional information';

  @override
  String get homeworkDialogDueDateAfterNextLesson => 'Lesson after next';

  @override
  String get homeworkDialogDueDateChipsPlusDescription =>
      'With Sharezone Plus you can set homework due dates to the next school day or a lesson in the future with one tap.';

  @override
  String get homeworkDialogDueDateInXHours => 'In X lessons';

  @override
  String homeworkDialogDueDateInXLessons(int count) {
    return '$count.-next lesson';
  }

  @override
  String get homeworkDialogDueDateNextLesson => 'Next lesson';

  @override
  String get homeworkDialogDueDateNextSchoolday => 'Next school day';

  @override
  String get homeworkDialogEmptyTitleError =>
      'Please enter a title for the homework!';

  @override
  String get homeworkDialogNextLessonSuffix => '.-next lesson';

  @override
  String get homeworkDialogNoCourseSelected => 'No course selected';

  @override
  String get homeworkDialogNotifyCourseMembers => 'Notify course members';

  @override
  String get homeworkDialogNotifyCourseMembersDescription =>
      'Notify course members about new homework.';

  @override
  String get homeworkDialogNotifyCourseMembersEditing =>
      'Notify course members about changes';

  @override
  String get homeworkDialogPrivateSubtitle =>
      'Do not share homework with the course.';

  @override
  String get homeworkDialogPrivateTitle => 'Private';

  @override
  String get homeworkDialogRequiredFieldsMissing =>
      'Please fill in all required fields!';

  @override
  String get homeworkDialogSaveTooltip => 'Save homework';

  @override
  String homeworkDialogSavingFailed(String error) {
    return 'Homework could not be saved.\n\n$error\n\nIf the error persists, please contact support.';
  }

  @override
  String get homeworkDialogSelectLessonOffsetDescription =>
      'Choose in how many lessons the homework is due.';

  @override
  String get homeworkDialogSelectLessonOffsetTitle => 'Select lesson offset';

  @override
  String get homeworkDialogSubmissionTimeTitle => 'Submission time';

  @override
  String get homeworkDialogTitleHint =>
      'Enter title (e.g. worksheet no. 1 - 3)';

  @override
  String homeworkDialogUnknownError(String error) {
    return 'An unknown error occurred ($error) 😖 Please contact support!';
  }

  @override
  String get homeworkDialogWithSubmissionTitle => 'With submission';

  @override
  String get homeworkEmptyFireDescription =>
      'You still have homework to do! So stop looking at me and get it done! Do it!';

  @override
  String get homeworkEmptyFireTitle => 'LET\'S GO! 💥👊';

  @override
  String get homeworkEmptyGameControllerDescription =>
      'Great! You don\'t have any homework to do.';

  @override
  String get homeworkEmptyGameControllerTitle =>
      'Now it\'s time for the really important things in life! 🤘💪';

  @override
  String get homeworkFabNewHomeworkTooltip => 'New homework';

  @override
  String homeworkLongPressTitle(String homeworkTitle) {
    return 'Homework: $homeworkTitle';
  }

  @override
  String get homeworkMarkOverdueAction => 'Check off overdue homework';

  @override
  String get homeworkMarkOverduePromptTitle =>
      'Check off all overdue homework?';

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
  String get homeworkTabArchivedUppercase => 'ARCHIVED';

  @override
  String get homeworkTabDoneUppercase => 'DONE';

  @override
  String get homeworkTabOpenUppercase => 'OPEN';

  @override
  String get homeworkTeacherNoArchivedTitle =>
      'All homework with due dates in the past is shown here.';

  @override
  String get homeworkTeacherNoOpenTitle => 'No homework for the students? 😮😍';

  @override
  String get homeworkTeacherNoPermissionTitle => 'No permission';

  @override
  String get homeworkTeacherViewCompletionNoPermissionContent =>
      'For security reasons, a teacher may only view the completed list in the respective group with admin rights.\n\nOtherwise any student could create a new account as a teacher and join the group to see which classmates have already completed the homework.';

  @override
  String get homeworkTeacherViewSubmissionsNoPermissionContent =>
      'For security reasons, a teacher may only view submissions in the respective group with admin rights.\n\nOtherwise any student could create a new account as a teacher and join the group to view other classmates\' submissions.';

  @override
  String homeworkTodoDateTime(String date, String time) {
    return '$date - $time';
  }

  @override
  String get icalLinksDialogExportCreated =>
      'The export was created successfully.';

  @override
  String get icalLinksDialogLessonsComingSoon =>
      'Diese Option ist demnächst verfügbar.';

  @override
  String get icalLinksDialogNameHint => 'Enter a name (e.g. My exams)';

  @override
  String get icalLinksDialogNameMissingError => 'Please enter a name';

  @override
  String get icalLinksDialogNameMissingErrorWithPeriod =>
      'Please enter a name.';

  @override
  String get icalLinksDialogPrivateNote =>
      'iCal exports are private and only visible to you.';

  @override
  String get icalLinksDialogSourceMissingError =>
      'Please select at least one source.';

  @override
  String get icalLinksDialogSourcesQuestion =>
      'Which sources should be included in the export?';

  @override
  String get icalLinksPageBuilding => 'Creating...';

  @override
  String get icalLinksPageCopyLink => 'Copy link';

  @override
  String get icalLinksPageEmptyState =>
      'You haven\'t created any iCal links yet.';

  @override
  String icalLinksPageErrorSubtitle(String error) {
    return 'Error: $error';
  }

  @override
  String get icalLinksPageHowToAddIcalLinkToCalendarBody =>
      '1. Copy the iCal link\n2. Open your calendar (e.g. Google Calendar, Apple Calendar)\n3. Add a new calendar\n4. Choose \"Add via URL\" or \"Add via Internet\"\n5. Paste the iCal link\n6. Done! Your timetable and events will now appear in your calendar.';

  @override
  String get icalLinksPageHowToAddIcalLinkToCalendarHeader =>
      'How do I add an iCal link to my calendar?';

  @override
  String get icalLinksPageLinkCopied => 'Link copied to clipboard.';

  @override
  String get icalLinksPageLinkDeleted => 'Link deleted.';

  @override
  String get icalLinksPageLinkLoading => 'Loading link...';

  @override
  String get icalLinksPageLocked => 'Locked';

  @override
  String get icalLinksPageNewLink => 'New link';

  @override
  String get icalLinksPageTitle => 'iCal links';

  @override
  String get icalLinksPageWhatIsAnIcalLinkHeader => 'What is an iCal link?';

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
  String get loginCreateAccount => 'Create new account';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginHidePasswordTooltip => 'Hide password';

  @override
  String get loginPasswordFieldSemanticsLabel => 'Password field';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginResetPasswordButton => 'Reset password';

  @override
  String get loginShowPasswordTooltip => 'Show password';

  @override
  String get loginSubmitTooltip => 'Sign in';

  @override
  String get loginWithAppleButton => 'Sign in with Apple';

  @override
  String get loginWithGoogleButton => 'Sign in with Google';

  @override
  String get loginWithQrCodeButton => 'Sign in with QR code';

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
  String get mobileWelcomeBackgroundImageSemanticsLabel =>
      'Background image of the welcome page with 5 phones showing the Sharezone app.';

  @override
  String get mobileWelcomeHeadline =>
      'Organize everyday school life\ntogether 🚀';

  @override
  String get mobileWelcomeNewAtSharezoneButton => 'I\'m new to Sharezone 👋';

  @override
  String get mobileWelcomeSignInButton => 'Sign in';

  @override
  String get mobileWelcomeSignInWithExistingAccount =>
      'Sign in with existing account';

  @override
  String get mobileWelcomeSubHeadline =>
      'Optionally, you can also use Sharezone completely on your own.';

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
  String navigationExtendableBnbSemantics(String action) {
    return '$action die erweiterte Navigationsleiste';
  }

  @override
  String get navigationItemAccountPage => 'Profile';

  @override
  String get navigationItemBlackboard => 'Blackboard';

  @override
  String get navigationItemEvents => 'Events';

  @override
  String get navigationItemFeedbackBox => 'Feedback';

  @override
  String get navigationItemFilesharing => 'Files';

  @override
  String get navigationItemGrades => 'Grades';

  @override
  String get navigationItemGroup => 'Groups';

  @override
  String get navigationItemHomework => 'Homework';

  @override
  String get navigationItemMore => 'More';

  @override
  String get navigationItemOverview => 'Overview';

  @override
  String get navigationItemSettings => 'Settings';

  @override
  String get navigationItemSharezonePlus => 'Sharezone Plus';

  @override
  String get navigationItemTimetable => 'Timetable';

  @override
  String get navigationSemanticsClose => 'Schließt';

  @override
  String get navigationSemanticsOpen => 'Öffnet';

  @override
  String get notificationPageBlackboardDescription =>
      'The creator of a notice can control whether course members are notified about a new notice or changes. Use this option to enable or disable those notifications.';

  @override
  String get notificationPageBlackboardHeadline => 'Notices';

  @override
  String get notificationPageBlackboardTitle => 'Notifications for notices';

  @override
  String get notificationPageCommentsDescription =>
      'Receive a push notification when someone posts a new comment under homework or a notice.';

  @override
  String get notificationPageCommentsHeadline => 'Comments';

  @override
  String get notificationPageCommentsTitle => 'Notifications for comments';

  @override
  String get notificationPageHomeworkHeadline => 'Open homework';

  @override
  String get notificationPageHomeworkReminderTitle =>
      'Reminders for open homework';

  @override
  String get notificationPageInvalidHomeworkReminderTime =>
      'Only full and half hours are allowed, e.g. 18:00 or 18:30.';

  @override
  String get notificationPagePlusDialogDescription =>
      'With Sharezone Plus you can set homework reminder times individually in 30-minute steps, e.g. 15:00 or 15:30.';

  @override
  String get notificationPagePlusDialogTitle =>
      'Reminder time for the day before';

  @override
  String get notificationPageTimeTitle => 'Time';

  @override
  String notificationPageTimeValue(String time) {
    return '$time o\'clock';
  }

  @override
  String get notificationPageTitle => 'Notifications';

  @override
  String get notificationsDialogReplyAction => 'Reply';

  @override
  String get notificationsErrorDialogMoreInfo => 'More info.';

  @override
  String get notificationsErrorDialogShortDescription =>
      'Tapping the notification should have done something else.';

  @override
  String get onboardingNotificationsConfirmBody =>
      'Are you sure you do not want to receive notifications?\n\nIf someone posts a notice, adds a comment to homework or writes you a message, you would not receive push notifications.';

  @override
  String get onboardingNotificationsConfirmTitle => 'No push notifications? 🤨';

  @override
  String get onboardingNotificationsDescriptionGeneral =>
      'If someone posts a notice or writes you a message, you will receive a notification and stay up to date 💪';

  @override
  String get onboardingNotificationsDescriptionStudent =>
      'We can remind you about open homework 😉 You can also receive notifications when someone posts a notice or writes you a message.';

  @override
  String get onboardingNotificationsEnable => 'Enable';

  @override
  String get onboardingNotificationsTitle =>
      'Enable reminders and notifications';

  @override
  String get pastCalendricalEventsDummyTitleExam2 => 'Exam #2';

  @override
  String get pastCalendricalEventsDummyTitleExam3 => 'Exam #3';

  @override
  String get pastCalendricalEventsDummyTitleExam4 => 'Exam #4';

  @override
  String get pastCalendricalEventsDummyTitleExam5 => 'Exam #5';

  @override
  String get pastCalendricalEventsDummyTitleNoSchool => 'No school';

  @override
  String get pastCalendricalEventsDummyTitleParentTeacherDay =>
      'Parent-teacher day';

  @override
  String get pastCalendricalEventsDummyTitleSportsFestival => 'Sports festival';

  @override
  String get pastCalendricalEventsDummyTitleTest6 => 'Test #6';

  @override
  String get pastCalendricalEventsPageEmpty => 'No past events';

  @override
  String pastCalendricalEventsPageError(String error) {
    return 'Error while loading past events: $error';
  }

  @override
  String get pastCalendricalEventsPagePlusDescription =>
      'Get Sharezone Plus to view all past events.';

  @override
  String get pastCalendricalEventsPageSortAscending => 'Ascending';

  @override
  String get pastCalendricalEventsPageSortAscendingSubtitle =>
      'Oldest events first';

  @override
  String get pastCalendricalEventsPageSortDescending => 'Descending';

  @override
  String get pastCalendricalEventsPageSortDescendingSubtitle =>
      'Newest events first';

  @override
  String get pastCalendricalEventsPageSortOrderTooltip => 'Sort order';

  @override
  String get pastCalendricalEventsPageTitle => 'Past events';

  @override
  String get periodsEditAddLesson => 'Add lesson';

  @override
  String get periodsEditSaved => 'Class times were changed successfully.';

  @override
  String get periodsEditTimetableStart => 'Timetable start';

  @override
  String get predefinedGradeTypesOralParticipation => 'Oral participation';

  @override
  String get predefinedGradeTypesOther => 'Other';

  @override
  String get predefinedGradeTypesPresentation => 'Presentation';

  @override
  String get predefinedGradeTypesSchoolReportGrade => 'Report grade';

  @override
  String get predefinedGradeTypesVocabularyTest => 'Vocabulary test';

  @override
  String get predefinedGradeTypesWrittenExam => 'Written exam';

  @override
  String get privacyDisplaySettingsDensityComfortable => 'Comfortable';

  @override
  String get privacyDisplaySettingsDensityCompact => 'Compact';

  @override
  String get privacyDisplaySettingsDensityStandard => 'Standard';

  @override
  String get privacyDisplaySettingsShowReadIndicator =>
      'Show \"reading\" indicator';

  @override
  String get privacyDisplaySettingsTextScalingFactor => 'Text scaling factor';

  @override
  String get privacyDisplaySettingsThemeMode => 'Dark/Light mode';

  @override
  String get privacyDisplaySettingsThemeModeAutomatic => 'Automatic';

  @override
  String get privacyDisplaySettingsThemeModeDark => 'Dark mode';

  @override
  String get privacyDisplaySettingsThemeModeLight => 'Light mode';

  @override
  String get privacyDisplaySettingsTitle => 'Display settings';

  @override
  String get privacyDisplaySettingsVisualDensity => 'Visual density';

  @override
  String get privacyPolicyChangeAppearance => 'Change appearance';

  @override
  String get privacyPolicyDownloadPdf => 'Download as PDF';

  @override
  String get privacyPolicyPageTitle => 'Privacy policy';

  @override
  String get privacyPolicyPageUpdatedEffectiveDatePrefix =>
      'This updated privacy policy takes effect on';

  @override
  String get privacyPolicyPageUpdatedEffectiveDateSuffix => '.';

  @override
  String get privacyPolicyTableOfContents => 'Table of contents';

  @override
  String get profileAvatarTooltip => 'My profile';

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
  String get resetPasswordEmailFieldLabel => 'Email address of your account';

  @override
  String get resetPasswordErrorMessage =>
      'Email could not be sent. Please check your entered email address!';

  @override
  String get resetPasswordSentDialogTitle => 'Email sent';

  @override
  String get resetPasswordSuccessMessage =>
      'An email to reset your password has been sent.';

  @override
  String get schoolClassActionsDeleteUppercase => 'DELETE CLASS';

  @override
  String get schoolClassActionsKickUppercase => 'KICK FROM CLASS';

  @override
  String get schoolClassActionsLeaveUppercase => 'LEAVE CLASS';

  @override
  String get schoolClassAllowJoinExplanation =>
      'Use this setting to control whether new members can join the course.\n\nThis setting is directly applied to all courses linked to the school class.';

  @override
  String get schoolClassCoursesAddExisting => 'Add existing course';

  @override
  String get schoolClassCoursesAddNew => 'Add new course';

  @override
  String get schoolClassCoursesEmptyDescription =>
      'No courses have been added to this class yet.\n\nCreate a course now and link it to this class.';

  @override
  String get schoolClassCoursesSelectCourseDialogHint =>
      'You can only add courses where you are also an administrator.';

  @override
  String get schoolClassCoursesSelectCourseDialogTitle => 'Select a course';

  @override
  String get schoolClassCoursesTitle => 'Courses';

  @override
  String get schoolClassCreateTitle => 'Create school class';

  @override
  String get schoolClassEditSuccess =>
      'The school class was edited successfully!';

  @override
  String get schoolClassEditTitle => 'Edit school class';

  @override
  String get schoolClassLeaveConfirmationQuestion =>
      'Do you really want to leave the school class?';

  @override
  String get schoolClassLeaveDialogDeleteWithCourses => 'Delete with courses';

  @override
  String get schoolClassLeaveDialogDeleteWithoutCourses =>
      'Delete without courses';

  @override
  String get schoolClassLeaveDialogDescription =>
      'Do you really want to leave the class?\n\nYou can also decide whether to delete the school\'s courses as well or keep them. If courses are not deleted, they remain available.';

  @override
  String get schoolClassLeaveDialogTitle => 'Leave class';

  @override
  String get schoolClassLoadError => 'An error occurred while loading...';

  @override
  String schoolClassLongPressTitle(String schoolClassName) {
    return 'Class: $schoolClassName';
  }

  @override
  String get schoolClassMemberOptionsAloneHint =>
      'Since you are the only one in the school class, you cannot edit your role.';

  @override
  String get schoolClassMemberOptionsOnlyAdminHint =>
      'You are the only admin in this school class. Therefore, you cannot remove your own rights.';

  @override
  String get schoolClassWritePermissionsAnnotation =>
      'This setting is directly applied to all courses linked to the school class.';

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
  String get settingsLegalLicensesTitle => 'Licenses';

  @override
  String get settingsLegalTermsTitle => 'Terms of service';

  @override
  String get settingsOptionMyAccount => 'My account';

  @override
  String get settingsOptionSourceCode => 'Source code';

  @override
  String get settingsOptionWebApp => 'Web app';

  @override
  String get settingsPrivacyPolicyLinkText => 'Privacy policy';

  @override
  String get settingsPrivacyPolicySentencePrefix =>
      'More information can be found in our ';

  @override
  String get settingsPrivacyPolicySentenceSuffix => '.';

  @override
  String get settingsSectionAppSettings => 'App settings';

  @override
  String get settingsSectionLegal => 'Legal';

  @override
  String get settingsSectionMore => 'More';

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
  String get sharezoneV2DialogAnbAcceptanceCheckbox =>
      'I have read and accept the [terms and conditions](anb).';

  @override
  String get sharezoneV2DialogChangedLegalFormHeader => 'Changed legal form';

  @override
  String get sharezoneV2DialogPrivacyPolicyRevisionHeader =>
      'Privacy policy revision';

  @override
  String sharezoneV2DialogSubmitError(Object value) {
    return 'An error occurred: $value. If this keeps happening, contact us at support@sharezone.net';
  }

  @override
  String get sharezoneV2DialogTermsHeader => 'Terms of service';

  @override
  String get sharezoneV2DialogTitle => 'Sharezone v2.0';

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
  String get signInWithQrCodeLoadingMessage =>
      'Generating the QR code can take a few seconds...';

  @override
  String get signInWithQrCodeStep1 => 'Open Sharezone on your phone / tablet';

  @override
  String get signInWithQrCodeStep2 => 'Open settings in the side navigation';

  @override
  String get signInWithQrCodeStep3 => 'Tap \"Web app\"';

  @override
  String get signInWithQrCodeStep4 =>
      'Tap \"Scan QR code\" and point your camera at your screen';

  @override
  String get signInWithQrCodeTitle => 'How to sign in with a QR code:';

  @override
  String get signOutDialogConfirmation => 'Do you really want to sign out?';

  @override
  String get signUpAdvantageAllInOne => 'All-in-one app for school';

  @override
  String get signUpAdvantageCloud =>
      'Share your school planner with your class via the cloud';

  @override
  String get signUpAdvantageHomeworkReminder => 'Reminders for open homework';

  @override
  String get signUpAdvantageSaveTime =>
      'Save a lot of time by organizing together';

  @override
  String get signUpAdvantagesTitle => 'Benefits of Sharezone';

  @override
  String get signUpAlreadyHaveAccount =>
      'Du hast bereits ein Konto? Klicke hier, um dich einzuloggen.';

  @override
  String get signUpChooseTypeTitle => 'I am...';

  @override
  String get signUpDataProtectionAesTitle =>
      'AES 256-bit server-side encryption';

  @override
  String get signUpDataProtectionAnonymousSignInSubtitle =>
      'IP address is inevitably stored temporarily';

  @override
  String get signUpDataProtectionAnonymousSignInTitle =>
      'Sign in without personal data';

  @override
  String get signUpDataProtectionDeleteDataTitle => 'Easy data deletion';

  @override
  String get signUpDataProtectionIsoTitle =>
      'ISO27001, ISO27012 & ISO27018 certified*';

  @override
  String get signUpDataProtectionServerLocationSubtitle =>
      'Except for the authentication server';

  @override
  String get signUpDataProtectionServerLocationTitle =>
      'Server location: Frankfurt (Germany)';

  @override
  String get signUpDataProtectionSocSubtitle =>
      '* Certification of our hosting provider';

  @override
  String get signUpDataProtectionSocTitle => 'SOC1, SOC2, & SOC3 certified*';

  @override
  String get signUpDataProtectionTitle => 'Data protection';

  @override
  String get signUpDataProtectionTlsTitle =>
      'TLS encryption during transmission';

  @override
  String get signUpLegalConsentMarkdown =>
      'By using our platform, you agree to the [Terms of Service](https://sharezone.net/terms-of-service). We process your data according to our [Privacy Policy](https://sharezone.net/privacy-policy).';

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
  String get supportPageBody =>
      'Found a bug, have feedback, or just a question about Sharezone? Contact us and we\'ll help you!';

  @override
  String get supportPageDiscordIconSemanticsLabel => 'Discord icon';

  @override
  String get supportPageDiscordPrivacyContent =>
      'Please note that Discord\'s [privacy policy](https://discord.com/privacy) applies when using Discord.';

  @override
  String get supportPageDiscordPrivacyTitle => 'Discord privacy';

  @override
  String get supportPageDiscordSubtitle => 'Community support';

  @override
  String get supportPageDiscordTitle => 'Discord';

  @override
  String supportPageEmailAddress(String email) {
    return 'Email: $email';
  }

  @override
  String get supportPageEmailIconSemanticsLabel => 'Email icon';

  @override
  String get supportPageEmailTitle => 'Email';

  @override
  String get supportPageFreeSupportSubtitle =>
      'Please note that free support can take up to 2 weeks.';

  @override
  String get supportPageFreeSupportTitle => 'Free support';

  @override
  String get supportPageHeadline => 'Need help?';

  @override
  String get supportPagePlusAdvertisingBulletOne =>
      'Get an email response within a few hours (instead of up to 2 weeks)';

  @override
  String get supportPagePlusAdvertisingBulletTwo =>
      'Video call support by appointment (including screen sharing)';

  @override
  String get supportPagePlusEmailSubtitle =>
      'Get a response within a few hours.';

  @override
  String get supportPagePlusSupportSubtitle =>
      'As a Sharezone Plus user, you get access to our premium support.';

  @override
  String get supportPagePlusSupportTitle => 'Plus support';

  @override
  String get supportPageTitle => 'Support';

  @override
  String get supportPageVideoCallRequiresSignIn =>
      'You need to be signed in to schedule a video call.';

  @override
  String get supportPageVideoCallSubtitle =>
      'By appointment, screen sharing is also possible if needed.';

  @override
  String get supportPageVideoCallTitle => 'Video call support';

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
  String themeNavigationOptionTitle(int number, String optionName) {
    return 'Option $number: $optionName';
  }

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
  String get timetableAddAbWeeksPrefix => ' You can enable A/B weeks in ';

  @override
  String get timetableAddAbWeeksSettings => 'settings';

  @override
  String get timetableAddAbWeeksSuffix => '.';

  @override
  String get timetableAddAlternativeSelectPeriod =>
      'Alternatively, you can select a period';

  @override
  String get timetableAddAlternativeSetIndividualTime =>
      'Alternatively, you can set the time manually';

  @override
  String get timetableAddAutoRecurringInfo =>
      'Lessons are automatically added for upcoming weeks as well.';

  @override
  String get timetableAddChangeTimesInSettingsInfo =>
      'You can change lesson times in timetable settings.';

  @override
  String get timetableAddEarlyStartTimeHint =>
      'Please note that lessons are only shown starting at 7 AM.';

  @override
  String get timetableAddJoinCourseAction => 'Join course';

  @override
  String get timetableAddLessonTitle => 'Add lesson';

  @override
  String get timetableAddNoCourseMembershipHint =>
      'You are not a member of any course yet 😔\nCreate a new course or join one 😃';

  @override
  String get timetableAddRoomAndTeacherOptionalTitle =>
      'Add a room & a teacher (optional)';

  @override
  String get timetableAddSelectCourseTitle => 'Select a course';

  @override
  String get timetableAddSelectPeriodQuestion =>
      'In which period does the new lesson take place?';

  @override
  String get timetableAddSelectWeekTypeTitle => 'Select a week type';

  @override
  String get timetableAddSelectWeekdayTitle => 'Select a weekday';

  @override
  String get timetableAddUnknownError =>
      'An unknown error occurred. Please contact support!';

  @override
  String timetableDeleteAllDialogDeleteCountdown(int seconds) {
    return 'Delete ($seconds)';
  }

  @override
  String get timetableDeleteAllSuggestionAction => 'Delete timetable';

  @override
  String get timetableDeleteAllSuggestionBody =>
      'Do you want to delete your entire timetable? Click here to use the feature.';

  @override
  String get timetableDeleteAllSuggestionTitle => 'Delete entire timetable?';

  @override
  String get timetableEditCourseLocked =>
      'The course cannot be changed afterwards.';

  @override
  String get timetableEditEndTime => 'End time';

  @override
  String timetableEditEventTitle(String eventType) {
    return 'Edit $eventType';
  }

  @override
  String get timetableEditLessonTitle => 'Edit lesson';

  @override
  String get timetableEditNoPeriodSelected => 'No lesson selected';

  @override
  String timetableEditPeriodSelected(int number) {
    return 'Lesson $number';
  }

  @override
  String get timetableEditSelectTime => 'Choose a time';

  @override
  String timetableEditSelectTimeForPeriod(int number) {
    return 'Wähle eine Uhrzeit ($number. Stunde)';
  }

  @override
  String get timetableEditStartTime => 'Start time';

  @override
  String get timetableEditTeacherHint => 'e.g. Ms. Stark';

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
  String get timetableEventCardChangeColorAction => 'Change color';

  @override
  String timetableEventCardEventTitle(Object value) {
    return 'Event: $value';
  }

  @override
  String timetableEventCardExamTitle(Object value) {
    return 'Exam: $value';
  }

  @override
  String get timetableEventDetailsAddToCalendarButton => 'ADD TO CALENDAR';

  @override
  String get timetableEventDetailsAddToCalendarPlusDescription =>
      'With Sharezone Plus you can easily add Sharezone events to your local calendar (e.g. Apple or Google Calendar).';

  @override
  String get timetableEventDetailsAddToCalendarTitle => 'Add event to calendar';

  @override
  String get timetableEventDetailsDeleteDialog =>
      'Do you really want to delete this event?';

  @override
  String get timetableEventDetailsDeletedConfirmation => 'Event deleted';

  @override
  String get timetableEventDetailsEditedConfirmation =>
      'Event edited successfully';

  @override
  String get timetableEventDetailsExamTopics => 'Exam topics';

  @override
  String get timetableEventDetailsLabel => 'Details';

  @override
  String timetableEventDetailsReport(String itemType) {
    return 'Report $itemType';
  }

  @override
  String timetableEventDetailsRoom(String room) {
    return 'Room: $room';
  }

  @override
  String get timetableEventDialogDateSelectionNotPossible =>
      'Selection not possible';

  @override
  String get timetableEventDialogDateSelectionNotPossibleContent =>
      'It is currently not possible to create an event or exam spanning multiple days.';

  @override
  String get timetableEventDialogDescriptionHintEvent =>
      'Additional information';

  @override
  String get timetableEventDialogDescriptionHintExam => 'Exam topics';

  @override
  String get timetableEventDialogEmptyCourse => 'Keinen Kurs ausgewählt';

  @override
  String get timetableEventDialogEmptyCourseError => 'Please choose a course.';

  @override
  String get timetableEventDialogEmptyTitleError => 'Please enter a title.';

  @override
  String get timetableEventDialogEndTimeAfterStartTimeError =>
      'The end time must be after the start time.';

  @override
  String get timetableEventDialogNotifyCourseMembersEvent =>
      'Notify course members about the new event.';

  @override
  String get timetableEventDialogNotifyCourseMembersExam =>
      'Notify course members about the new exam.';

  @override
  String get timetableEventDialogNotifyCourseMembersTitle =>
      'Notify course members';

  @override
  String get timetableEventDialogSaveEventTooltip => 'Save event';

  @override
  String get timetableEventDialogSaveExamTooltip => 'Save exam';

  @override
  String get timetableEventDialogTitleHintEvent =>
      'Enter title (e.g. sports festival)';

  @override
  String get timetableEventDialogTitleHintExam =>
      'Title (e.g. statistics exam)';

  @override
  String get timetableFabAddTooltip => 'Add lesson/event';

  @override
  String get timetableFabLessonAddedConfirmation =>
      'The lesson was added successfully';

  @override
  String get timetableFabOptionEvent => 'Event';

  @override
  String get timetableFabOptionExam => 'Exam';

  @override
  String get timetableFabOptionLesson => 'Lesson';

  @override
  String get timetableFabOptionSubstitutions => 'Substitution plan';

  @override
  String get timetableFabSectionCalendar => 'Calendar';

  @override
  String get timetableFabSectionTimetable => 'Timetable';

  @override
  String get timetableFabSubstitutionsDialogTitle => 'Substitution plan';

  @override
  String get timetableFabSubstitutionsStepOne =>
      '1. Navigate to the affected lesson.';

  @override
  String get timetableFabSubstitutionsStepThree =>
      '3. Choose the substitution type.';

  @override
  String get timetableFabSubstitutionsStepTwo => '2. Tap on the lesson.';

  @override
  String get timetableLessonDetailsAddHomeworkTooltip => 'Add homework';

  @override
  String timetableLessonDetailsArrowLocation(String location) {
    return '-> $location';
  }

  @override
  String get timetableLessonDetailsChangeColor => 'Change color';

  @override
  String get timetableLessonDetailsCourseName => 'Course name: ';

  @override
  String get timetableLessonDetailsDeleteDialogConfirm =>
      'I understand that this lesson will be deleted for all course members.';

  @override
  String get timetableLessonDetailsDeleteDialogMessage =>
      'Do you really want to delete this lesson for the whole course?';

  @override
  String get timetableLessonDetailsDeleteTitle => 'Delete lesson';

  @override
  String get timetableLessonDetailsDeletedConfirmation => 'Lesson deleted';

  @override
  String get timetableLessonDetailsEditedConfirmation =>
      'Lesson edited successfully';

  @override
  String get timetableLessonDetailsRoom => 'Room: ';

  @override
  String get timetableLessonDetailsSubstitutionPlusDescription =>
      'Unlock the substitution plan with Sharezone Plus to mark e.g. canceled lessons.\n\nEven course members without Sharezone Plus can view the substitution plan (but cannot edit it).';

  @override
  String get timetableLessonDetailsTeacher => 'Teacher: ';

  @override
  String get timetableLessonDetailsTeacherInTimetableDescription =>
      'With Sharezone Plus you can add the teacher to each lesson in the timetable. The teacher is also shown for course members without Sharezone Plus.';

  @override
  String get timetableLessonDetailsTeacherInTimetableTitle =>
      'Teacher in timetable';

  @override
  String timetableLessonDetailsTimeRange(String endTime, String startTime) {
    return '$startTime - $endTime';
  }

  @override
  String timetableLessonDetailsWeekType(String weekType) {
    return 'Week type: $weekType';
  }

  @override
  String timetableLessonDetailsWeekday(String weekday) {
    return 'Weekday: $weekday';
  }

  @override
  String get timetablePageSettingsTooltip => 'Timetable settings';

  @override
  String get timetableQuickCreateEmptyTitle =>
      'You haven\'t joined a course or class yet!';

  @override
  String get timetableQuickCreateTitle => 'Add lesson';

  @override
  String get timetableSchoolClassFilterAllClasses => 'All school classes';

  @override
  String get timetableSchoolClassFilterAllShort => 'All';

  @override
  String timetableSchoolClassFilterLabel(Object value) {
    return 'School class: $value';
  }

  @override
  String get timetableSettingsABWeekTileTitle => 'A/B Weeks';

  @override
  String get timetableSettingsAWeeksAreEvenSwitch =>
      'A-weeks are even calendar weeks';

  @override
  String get timetableSettingsDeleteAllLessonsConfirmation =>
      'Lessons deleted.';

  @override
  String timetableSettingsDeleteAllLessonsDialogBody(int count) {
    return 'This will delete $count lessons from groups where you have write access. These hours will also be deleted for your group members. This cannot be undone.';
  }

  @override
  String get timetableSettingsDeleteAllLessonsDialogTitle =>
      'Delete all lessons?';

  @override
  String get timetableSettingsDeleteAllLessonsSubtitleNoAccess =>
      'No lessons with write access.';

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
  String get timetableSettingsOpenUpcomingWeekOnNonSchoolDaysSubtitle =>
      'If there are no enabled weekdays left in the current week, the timetable opens the next week.';

  @override
  String get timetableSettingsOpenUpcomingWeekOnNonSchoolDaysTitle =>
      'Open upcoming week on non-school days';

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
  String get timetableSubstitutionCancelDialogAction => 'Cancel lesson';

  @override
  String get timetableSubstitutionCancelDialogDescription =>
      'Do you really want to cancel this lesson for the entire course?';

  @override
  String get timetableSubstitutionCancelDialogNotify =>
      'Notify your course members that the lesson is canceled.';

  @override
  String get timetableSubstitutionCancelDialogTitle => 'Cancel lesson';

  @override
  String get timetableSubstitutionCancelLesson => 'Cancel lesson';

  @override
  String get timetableSubstitutionCancelRestored => 'Canceled lesson restored';

  @override
  String get timetableSubstitutionCancelSaved =>
      'Lesson marked as \"Canceled\"';

  @override
  String get timetableSubstitutionCanceledTitle => 'Lesson canceled';

  @override
  String get timetableSubstitutionChangeRoom => 'Change room';

  @override
  String get timetableSubstitutionChangeRoomDialogAction => 'Save room change';

  @override
  String get timetableSubstitutionChangeRoomDialogDescription =>
      'Do you really want to change the room for this lesson?';

  @override
  String get timetableSubstitutionChangeRoomDialogNotify =>
      'Notify your course members about the room change.';

  @override
  String get timetableSubstitutionChangeRoomDialogTitle => 'Room change';

  @override
  String get timetableSubstitutionChangeTeacher => 'Change teacher';

  @override
  String get timetableSubstitutionChangeTeacherDialogAction => 'Save teacher';

  @override
  String get timetableSubstitutionChangeTeacherDialogDescription =>
      'Do you really want to change the substitute teacher?';

  @override
  String get timetableSubstitutionChangeTeacherDialogNotify =>
      'Notify your course members about the teacher change.';

  @override
  String get timetableSubstitutionChangeTeacherDialogTitle =>
      'Change substitute teacher';

  @override
  String get timetableSubstitutionEditRoomTooltip => 'Edit room';

  @override
  String get timetableSubstitutionEditTeacherTooltip => 'Edit teacher';

  @override
  String timetableSubstitutionEnteredBy(String name) {
    return 'Entered by: $name';
  }

  @override
  String get timetableSubstitutionNewRoomHint => 'e.g. D203';

  @override
  String get timetableSubstitutionNewRoomLabel => 'New room';

  @override
  String get timetableSubstitutionNoPermissionSubtitle =>
      'Please contact your course administrator.';

  @override
  String get timetableSubstitutionNoPermissionTitle =>
      'You do not have permission to change the substitution plan.';

  @override
  String get timetableSubstitutionRemoveAction => 'Remove';

  @override
  String get timetableSubstitutionRemoveRoomDialogDescription =>
      'Do you really want to remove the room change for this lesson?';

  @override
  String get timetableSubstitutionRemoveRoomDialogNotify =>
      'Notify your course members about the removal.';

  @override
  String get timetableSubstitutionRemoveRoomDialogTitle => 'Remove room change';

  @override
  String get timetableSubstitutionRemoveTeacherDialogDescription =>
      'Do you really want to remove the substitute teacher for this lesson?';

  @override
  String get timetableSubstitutionRemoveTeacherDialogNotify =>
      'Notify your course members about the removal.';

  @override
  String get timetableSubstitutionRemoveTeacherDialogTitle =>
      'Remove substitute teacher';

  @override
  String timetableSubstitutionReplacement(String teacher) {
    return 'Substitute: $teacher';
  }

  @override
  String get timetableSubstitutionRestoreDialogAction => 'Restore';

  @override
  String get timetableSubstitutionRestoreDialogDescription =>
      'Do you really want to let this lesson take place again?';

  @override
  String get timetableSubstitutionRestoreDialogNotify =>
      'Notify your course members that the lesson takes place.';

  @override
  String get timetableSubstitutionRestoreDialogTitle =>
      'Restore canceled lesson';

  @override
  String timetableSubstitutionRoomChanged(String room) {
    return 'Room change: $room';
  }

  @override
  String get timetableSubstitutionRoomRemoved => 'Room change removed';

  @override
  String get timetableSubstitutionRoomSaved => 'Room change saved';

  @override
  String timetableSubstitutionSectionForDate(String date) {
    return 'For $date';
  }

  @override
  String get timetableSubstitutionSectionTitle => 'Substitution plan';

  @override
  String get timetableSubstitutionTeacherRemoved =>
      'Substitute teacher removed';

  @override
  String get timetableSubstitutionTeacherSaved => 'Substitute teacher saved';

  @override
  String get timetableSubstitutionUndoTooltip => 'Undo';

  @override
  String get typeOfUserParent => 'Parent';

  @override
  String get typeOfUserStudent => 'Student';

  @override
  String get typeOfUserTeacher => 'Teacher';

  @override
  String get typeOfUserUnknown => 'Unknown';

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
  String get userCommentFieldEmptyError =>
      'The comment doesn\'t have any text! 🧐';

  @override
  String get userCommentFieldHint => 'Share your thoughts...';

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
  String get webAppSettingsDescription =>
      'Visit https://web.sharezone.net for more information.';

  @override
  String get webAppSettingsHeadline => 'Sharezone for web!';

  @override
  String get webAppSettingsQrCodeHint =>
      'With QR code sign-in you can sign in to the web app without entering a password. This is especially helpful on public computers.';

  @override
  String get webAppSettingsScanQrCodeDescription =>
      'Go to web.sharezone.net and scan the QR code.';

  @override
  String get webAppSettingsScanQrCodeTitle => 'Scan QR code';

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
  String get weekdaysEditSaved => 'Active weekdays were changed successfully.';

  @override
  String get weekdaysEditTitle => 'School days';

  @override
  String get writePermissionEveryone => 'Everyone';

  @override
  String get writePermissionOnlyAdmins => 'Only admins';
}
