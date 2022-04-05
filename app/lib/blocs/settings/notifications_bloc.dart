// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:bloc_base/bloc_base.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/util/api/user_api.dart';

class NotificationsBloc extends BlocBase {
  final UserGateway _userGateway;

  @visibleForTesting
  static const seedValue = TimeOfDay(hour: 18, minute: 0);
  final _notificationsForHomeworksSubject = BehaviorSubject<bool>();
  final _notificationsTimeForHomeworksSubject =
      BehaviorSubject<TimeOfDay>.seeded(seedValue);
  final _notificationsForBlackboardItemsSubject = BehaviorSubject.seeded(true);
  final _notificationsForCommentsSubject = BehaviorSubject.seeded(true);

  StreamSubscription subscription;

  NotificationsBloc(this._userGateway) {
    subscription = _userGateway.userStream.listen((user) {
      _notificationsForHomeworksSubject.sink.add(user.reminderTime != null);

      _notificationsTimeForHomeworksSubject.sink
          .add(convertReminderTimeToTimeOfDay(user.reminderTime));

      _notificationsForBlackboardItemsSubject.sink.add(
          user.blackboardNotifications == null ||
              user.blackboardNotifications == true);

      _notificationsForCommentsSubject.sink.add(
          user.commentsNotifications == null ||
              user.commentsNotifications == true);
    });
  }

  TimeOfDay convertReminderTimeToTimeOfDay(String reminderTime) {
    if (reminderTime == null) return null;
    final parts = reminderTime.split(":");
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  Stream<bool> get notificationsForHomeworks =>
      _notificationsForHomeworksSubject;
  Stream<bool> get notificationsForBlackboard =>
      _notificationsForBlackboardItemsSubject;
  Stream<bool> get notificationsForComments => _notificationsForCommentsSubject;

  Function(bool) get changeNotificationsForHomeworks =>
      _changeNotificationForHomeworksStatus;
  Function(bool) get changeNotificationsForBlackboard =>
      _changeNotificationsForBlackboardStatus;
  Function(bool) get changeNotificationsForComments =>
      _changeNotificationsForCommentsStatus;

  void _changeNotificationForHomeworksStatus(bool shouldEnable) {
    if (!shouldEnable) {
      _userGateway.setHomeworkReminderTime(null);
    } else {
      _userGateway.setHomeworkReminderTime(
          _notificationsTimeForHomeworksSubject.valueOrNull ?? seedValue);
    }
    return;
  }

  void _changeNotificationsForBlackboardStatus(bool enable) {
    _userGateway.setBlackboardNotifications(enable);
    return;
  }

  void _changeNotificationsForCommentsStatus(bool enable) {
    _userGateway.setCommentsNotifications(enable);
    return;
  }

  Stream<TimeOfDay> get notificationsTimeForHomeworks =>
      _notificationsTimeForHomeworksSubject.stream;
  Function(TimeOfDay) get changeNotificationsTimeForHomeworks =>
      _changeNotificationTime;
  Future<void> _changeNotificationTime(TimeOfDay tod) async {
    if (_notificationsForHomeworksSubject.valueOrNull != false &&
        _notificationsTimeForHomeworksSubject.valueOrNull != tod) {
      await _userGateway.setHomeworkReminderTime(tod);
    }
    return;
  }

  /// Returns a list with the times from 0:00 to 23:30 for every 30 min: 0:00, 0:30, 1:00, 1:30, etc.
  List<TimeOfDay> getTimeForHomeworkNotifications() {
    List<TimeOfDay> times = <TimeOfDay>[];
    for (int i = 0; i < 24; i++) {
      for (int j = 0; j < 60; j += 30) {
        times.add(TimeOfDay(hour: i, minute: j));
      }
    }
    return times.reversed.toList();
  }

  @override
  void dispose() {
    _notificationsForHomeworksSubject.close();
    _notificationsTimeForHomeworksSubject.close();
    _notificationsForBlackboardItemsSubject.close();
    _notificationsForCommentsSubject.close();
    subscription.cancel();
  }
}
