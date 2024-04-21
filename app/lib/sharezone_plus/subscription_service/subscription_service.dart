// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:clock/clock.dart';
import 'package:user/user.dart';

class SubscriptionService {
  final Stream<AppUser?> user;
  final Clock clock;

  late AppUser? _user;

  SubscriptionService({
    required this.user,
    required this.clock,
  }) {
    user.listen((event) {
      _user = event;
    });
  }

  bool isSubscriptionActive([AppUser? appUser]) {
    appUser ??= _user;

    if (appUser?.subscription == null) return false;
    return clock.now().isBefore(appUser!.subscription!.expiresAt);
  }

  Stream<bool> isSubscriptionActiveStream() {
    return user.map(isSubscriptionActive);
  }

  bool hasFeatureUnlocked(SharezonePlusFeature feature) {
    if (!isSubscriptionActive()) return false;
    return _user!.subscription!.tier.hasUnlocked(feature);
  }

  Stream<bool> hasFeatureUnlockedStream(SharezonePlusFeature feature) {
    return user.map((event) => hasFeatureUnlocked(feature));
  }
}

const _featuresMap = {
  SubscriptionTier.teacherPlus: {
    SharezonePlusFeature.submissionsList,
    SharezonePlusFeature.infoSheetReadByUsersList,
    SharezonePlusFeature.homeworkDoneByUsersList,
    SharezonePlusFeature.filterTimetableByClass,
    SharezonePlusFeature.changeHomeworkReminderTime,
    SharezonePlusFeature.plusSupport,
    SharezonePlusFeature.moreGroupColors,
    SharezonePlusFeature.addEventToLocalCalendar,
    SharezonePlusFeature.viewPastEvents,
  },
};

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
  homeworkDueDateChips,
}

extension SubscriptionTierExtension on SubscriptionTier {
  bool hasUnlocked(SharezonePlusFeature feature) {
    return _featuresMap[this]?.contains(feature) ?? false;
  }
}
