// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:user/user.dart';

class SubscriptionService {
  final Stream<AppUser?> user;

  late Stream<SharezonePlusStatus?> sharezonePlusStatusStream;
  late StreamSubscription<AppUser?> _userSubscription;
  late AppUser? _user;

  SubscriptionService({
    required this.user,
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
    if (!isSubscriptionActive()) return false;
    return true;
  }

  Stream<bool> hasFeatureUnlockedStream(SharezonePlusFeature feature) {
    return user.map((event) => hasFeatureUnlocked(feature));
  }

  SubscriptionSource? getSource() {
    return _user?.sharezonePlus?.source;
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
}
