// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

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

  bool isSubscriptionActive() {
    // Subscriptions feature is disabled, so every feature is unlocked.
    if (!_isEnabled) return true;

    if (_user?.subscription == null) return false;
    return clock.now().isBefore(_user!.subscription!.expiresAt);
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
    SharezonePlusFeature.homeworkDonyByUsersList,
  },
};

enum SharezonePlusFeature {
  submissionsList,
  infoSheetReadByUsersList,
  homeworkDonyByUsersList,
}

extension SubscriptionTierExtension on SubscriptionTier {
  bool hasUnlocked(SharezonePlusFeature feature) {
    return _featuresMap[this]?.contains(feature) ?? false;
  }
}
