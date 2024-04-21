// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:sharezone/sharezone_plus/subscription_service/subscription_flag.dart';
import 'package:user/user.dart';

class SubscriptionService {
  final Stream<AppUser?> user;
  final SubscriptionEnabledFlag isSubscriptionEnabledFlag;

  late AppUser? _user;
  bool _isEnabled = false;

  SubscriptionService({
    required this.user,
    required this.isSubscriptionEnabledFlag,
  }) {
    _isEnabled = isSubscriptionEnabledFlag.isEnabled;
    isSubscriptionEnabledFlag.addListener(() {
      _isEnabled = isSubscriptionEnabledFlag.isEnabled;
    });
    user.listen((event) {
      _user = event;
    });
  }

  bool isSubscriptionActive([AppUser? appUser]) {
    appUser ??= _user;

    // Subscriptions feature is disabled, so every feature is unlocked.
    if (!_isEnabled) return true;

    final plus = appUser?.sharezonePlus;
    if (plus == null) return false;
    return plus.hasPlus;
  }

  Stream<bool> isSubscriptionActiveStream() {
    // Subscriptions feature is disabled, so every feature is unlocked.
    if (!_isEnabled) return Stream.value(true);
    return user.map(isSubscriptionActive);
  }

  bool hasFeatureUnlocked(SharezonePlusFeature feature) {
    // Subscriptions feature is disabled, so every feature is unlocked.
    if (!_isEnabled) return true;

    if (!isSubscriptionActive()) return false;
    return true;
  }

  Stream<bool> hasFeatureUnlockedStream(SharezonePlusFeature feature) {
    // Subscriptions feature is disabled, so every feature is unlocked.
    if (!_isEnabled) return Stream.value(true);

    return user.map((event) => hasFeatureUnlocked(feature));
  }

  SubscriptionSource? getSource() {
    return _user?.sharezonePlus?.source;
  }
}

enum SharezonePlusFeature {
  submissionsList,
  infoSheetReadByUsersList,
  homeworkDoneByUsersList,
  filterTimetableByClass,
  changeHomeworkReminderTime,
  plusSupport,
  moreGroupColors,
  addEventToLocalCalendar,
  viewPastEvents,
}
