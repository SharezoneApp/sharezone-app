// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:sharezone/timetable/src/models/lesson_length/lesson_length.dart';
import 'package:sharezone/util/cache/streaming_key_value_store.dart';

const lessonLengthSharedPreferenceKey = 'timetable_length_key';

class LessonLengthCache extends BlocBase {
  final StreamingKeyValueStore streamingCache;

  LessonLengthCache(this.streamingCache);

  void setLessonLength(LessonLength lessonLength) {
    if (lessonLength.isValid) {
      streamingCache.setInt(
          lessonLengthSharedPreferenceKey, lessonLength.minutes);
    }
  }

  Stream<LessonLength> streamLessonLength() {
    return streamingCache
        .getInt(lessonLengthSharedPreferenceKey, defaultValue: -1)
        .map((lengthInMinutes) => lengthInMinutes != -1
            ? LessonLength(lengthInMinutes)
            : LessonLength.standard());
  }

  Future<bool> hasUserSavedLessonLengthInCache() async {
    return await streamingCache.containsKey(lessonLengthSharedPreferenceKey);
  }

  @override
  void dispose() {}
}
