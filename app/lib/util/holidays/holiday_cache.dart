// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:built_collection/built_collection.dart';
import 'package:key_value_store/key_value_store.dart';
import 'package:sharezone/models/extern_apis/holiday.dart';
import 'package:sharezone/util/holidays/state.dart';

class HolidayCache {
  static const _kCacheKeyPrefix = "holidays";

  final KeyValueStore cache;
  final Duration maxValidDurationTillLastSaved;
  SavingDateTimeFunction getCurrentTime;

  HolidayCache(this.cache,
      {this.maxValidDurationTillLastSaved = const Duration(days: 30),
      this.getCurrentTime}) {
    getCurrentTime ??= () => DateTime.now();
  }

  CacheResponse load(State state) {
    String jsonHolidayCacheData = cache.getString(getKeyString(state));
    if (jsonHolidayCacheData == null) return null;
    HolidayCacheData cacheData =
        HolidayCacheData.fromJson(jsonHolidayCacheData);
    List<Holiday> holidays = cacheData.holidays.toList();
    holidays = removePassedHolidays(holidays);
    bool isValid = isCacheDataValid(cacheData, maxValidDurationTillLastSaved);
    return CacheResponse(holidays, isValid);
  }

  List<Holiday> removePassedHolidays(List<Holiday> holidays) {
    holidays.removeWhere((holiday) => holiday.end.isBefore(getCurrentTime()));
    if (holidays.isEmpty) throw OnlyPassedHolidaysInCacheException();
    return holidays;
  }

  Future<void> save(List<Holiday> holidays, State state) {
    HolidayCacheData cacheData = HolidayCacheData((b) => b
      ..holidays = ListBuilder(holidays)
      ..saved = getCurrentTime());

    cache.setString(getKeyString(state), cacheData.toJson());

    return Future.value();
  }

  bool isCacheDataValid(
      HolidayCacheData cacheData, Duration maxDurationTillLastSaved) {
    return getCurrentTime()
            .difference(cacheData.saved)
            .compareTo(maxDurationTillLastSaved) <
        0;
  }

  static String getKeyString(State state) {
    return "$_kCacheKeyPrefix-${state.code}";
  }
}

typedef SavingDateTimeFunction = DateTime Function();

class CacheResponse {
  final List<Holiday> payload;
  final bool inValidTimeframe;

  CacheResponse(this.payload, this.inValidTimeframe);
  CacheResponse.valid(this.payload) : inValidTimeframe = true;
  CacheResponse.invalid(this.payload) : inValidTimeframe = false;

  @override
  String toString() {
    return "Payload: $payload, valid:$inValidTimeframe";
  }
}

class OnlyPassedHolidaysInCacheException implements Exception {}
