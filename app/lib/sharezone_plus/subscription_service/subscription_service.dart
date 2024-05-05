// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:analytics/analytics.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:platform_check/platform_check.dart';
import 'package:retry/retry.dart';
import 'package:user/user.dart';

class SubscriptionService {
  final Stream<AppUser?> user;
  final FirebaseFunctions functions;

  late Stream<SharezonePlusStatus?> sharezonePlusStatusStream;
  late StreamSubscription<AppUser?> _userSubscription;
  late AppUser? _user;

  SubscriptionService({
    required this.user,
    required this.functions,
  }) {
    sharezonePlusStatusStream = user.map((event) => event?.sharezonePlus);
    _userSubscription = user.listen((event) {
      _user = event;
    });
  }

  bool isSubscriptionActive([AppUser? appUser]) {
    appUser ??= _user;

    final plus = appUser?.sharezonePlus;
    if (plus == null) return false;
    return plus.hasPlus;
  }

  Stream<bool> isSubscriptionActiveStream() {
    return user.map(isSubscriptionActive);
  }

  bool hasFeatureUnlocked(SharezonePlusFeature feature) {
    // Sharezone Plus is currently only available for students. Thus every other
    // type of user has all features unlocked.
    if (!_user!.typeOfUser.isStudent) return true;

    if (!isSubscriptionActive()) return false;
    return true;
  }

  Stream<bool> hasFeatureUnlockedStream(SharezonePlusFeature feature) {
    return user.map((event) => hasFeatureUnlocked(feature));
  }

  SubscriptionSource? getSource() {
    return _user?.sharezonePlus?.source;
  }

  Future<void> cancelStripeSubscription() async {
    await functions.httpsCallable('cancelStripeSubscription').call();
  }

  Future<bool> showLetParentsBuyButton() async {
    try {
      return retry(
        () async {
          final response = await functions
              .httpsCallable('showLetParentsBuyButton')
              .call<bool>({
            'platform': PlatformCheck.currentPlatform.name,
          });
          return response.data;
        },
        maxAttempts: 3,
      );
    } catch (e) {
      return false;
    }
  }

  Future<String?> getPlusWebsiteBuyToken() async {
    try {
      return retry(
        () async {
          final response = await functions
              .httpsCallable('createPlusWebsiteBuyToken')
              .call<Map<String, dynamic>>();
          return response.data['token'];
        },
        maxAttempts: 3,
      );
    } catch (e) {
      return null;
    }
  }

  void dispose() {
    _userSubscription.cancel();
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
  homeworkDueDateChips,
  iCalLinks,
  substitutions,
}

void trySetSharezonePlusAnalyticsUserProperties(Analytics analytics,
    CrashAnalytics crashAnalytics, SubscriptionService subscriptionService) {
  try {
    subscriptionService.sharezonePlusStatusStream.listen((final status) {
      if (status != null) {
        analytics.setUserProperty(
          name: 'has_plus',
          value: status.hasPlus.toString(),
        );
        if (status.hasPlus) {
          if (status.period != null) {
            analytics.setUserProperty(
              name: 'plus_period',
              value: status.period!,
            );
          }
          var source = status.source ?? SubscriptionSource.unknown;
          analytics.setUserProperty(
            name: 'plus_source',
            value: source.stableAnalyticsKey,
          );
        }
      }
    });
  } catch (e) {
    crashAnalytics
        .log('Error setting user properties regarding Sharezone Plus: $e');
    crashAnalytics.recordError(e, StackTrace.current);
  }
}
