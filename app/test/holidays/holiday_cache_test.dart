// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:built_collection/built_collection.dart';
import 'package:sharezone/models/extern_apis/holiday.dart';
import 'package:sharezone/util/cache/key_value_store.dart';
import 'package:sharezone/util/holidays/holiday_cache.dart';
import 'package:sharezone/util/holidays/state.dart';
import "package:test/test.dart";

import 'holiday_bloc_unit_test.dart';

void main() {
  InMemoryKeyValueStore kVstore;
  State state;
  setUp(() {
    state = NordrheinWestfalen();
    kVstore = InMemoryKeyValueStore();
  });
  test('Can save and load Holidays from Cache', () async {
    State state = NordrheinWestfalen();
    HolidayCache cache = HolidayCache(kVstore);
    var expectedHolidays = generateHolidayList(5);

    cache.save(expectedHolidays, state);
    CacheResponse cacheResponse = cache.load(state);

    expect(cacheResponse.payload, expectedHolidays);
  });

  test('Does not return holidays which are over/in the past.', () {
    HolidayCache cache = HolidayCache(kVstore);
    HolidayCacheData holidayCacheData;
    State state = NordrheinWestfalen();

    Holiday holidayInTheFuture = generateHoliday(
        DateTime.now().add(Duration(days: 1)),
        DateTime.now().add(Duration(days: 5)));
    Holiday holidayInThePast = generateHoliday(
        DateTime.now().subtract(Duration(days: 10)),
        DateTime.now().subtract(Duration(days: 5)));
    holidayCacheData = HolidayCacheData((b) => b
      ..holidays = ListBuilder([holidayInThePast, holidayInTheFuture])
      ..saved = DateTime.now());
    kVstore.setString(
        HolidayCache.getKeyString(state), holidayCacheData.toJson());

    CacheResponse expectedResonse = CacheResponse.valid([holidayInTheFuture]);
    expect(cache.load(state).payload, expectedResonse.payload);
  });

  group('Correctly returns if Holidays are past valid duration', () {
    List<Holiday> expectedHolidays;
    setUp(() {
      expectedHolidays = generateHolidayList(3);
    });
    test("Correctly returns true", () async {
      HolidayCache cache = HolidayCache(kVstore);

      await cache.save(expectedHolidays, state);
      CacheResponse cacheResponse = cache.load(state);

      expect(cacheResponse.inValidTimeframe, true);
    });
    test("Correctly returns false", () async {
      final sixtyDaysBefore = DateTime.now().subtract(Duration(days: 60));
      final now = DateTime.now();
      var currentTimeReturnedToCache = sixtyDaysBefore;
      HolidayCache cache = HolidayCache(kVstore,
          getCurrentTime: () => currentTimeReturnedToCache);

      await cache.save(expectedHolidays, state);
      currentTimeReturnedToCache = now;

      CacheResponse cacheResponse = cache.load(state);

      expect(cacheResponse.inValidTimeframe, false);
    });
  });
}
