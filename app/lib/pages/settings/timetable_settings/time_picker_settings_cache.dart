// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:sharezone/util/cache/streaming_key_value_store.dart';

const _timePickerWithFifeMinutesIntervalKey =
    'time_icker_with_fife_minutes_interval_key';

class TimePickerSettingsCache extends BlocBase {
  final StreamingKeyValueStore streamingCache;

  TimePickerSettingsCache(this.streamingCache);

  void setTimePickerWithFifeMinutesInterval(bool newValue) {
    if (newValue != null) {
      streamingCache.setBool(_timePickerWithFifeMinutesIntervalKey, newValue);
    }
  }

  Stream<bool> isTimePickerWithFifeMinutesIntervalActiveStream() {
    return streamingCache.getBool(_timePickerWithFifeMinutesIntervalKey,
        defaultValue: true);
  }

  @override
  void dispose() {} // Required by BlocProvider
}
