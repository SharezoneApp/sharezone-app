// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:clock/clock.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_flag.dart';
import 'package:user/user.dart';

class SubscriptionService {
  final Stream<AppUser?> user;
  final Clock clock;
  final SubscriptionEnabledFlag isSubscriptionEnabledFlag;

  late AppUser? _user;
  bool _isEnabled = false;

  SubscriptionService({
    required this.user,
    required this.clock,
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

    if (appUser?.subscription == null) return false;
    return clock.now().isBefore(appUser!.subscription!.expiresAt);
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
    return _user!.subscription!.tier.hasUnlocked(feature);
  }
}

const _featuresMap = {
  SubscriptionTier.teacherPlus: {
    SharezonePlusFeature.submissionsList,
    SharezonePlusFeature.infoSheetReadByUsersList,
    SharezonePlusFeature.homeworkDoneByUsersList,
    SharezonePlusFeature.filterTimetableByClass,
  },
};

enum SharezonePlusFeature {
  submissionsList,
  infoSheetReadByUsersList,
  homeworkDoneByUsersList,
  filterTimetableByClass,
}

extension SubscriptionTierExtension on SubscriptionTier {
  bool hasUnlocked(SharezonePlusFeature feature) {
    return _featuresMap[this]?.contains(feature) ?? false;
  }
}
