// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:key_value_store/key_value_store.dart';

class MeetingCache {
  MeetingCache(this.keyValueStore);

  static const _meetingWarningKey = '_meetingWarningKey';
  final KeyValueStore keyValueStore;

  /// Returns [true] if the meeting warning has never been shown to the user.
  /// If it has been shown before, [false] is returned.
  bool hasWarningBeenShown() {
    return keyValueStore.containsKey(_meetingWarningKey);
  }

  void setMeetingWarningAsShown() {
    keyValueStore.setBool(_meetingWarningKey, true);
  }
}