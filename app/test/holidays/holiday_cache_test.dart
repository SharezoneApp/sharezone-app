// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:built_collection/built_collection.dart';
import 'package:clock/clock.dart';
import "package:flutter_test/flutter_test.dart";
import 'package:holidays/holidays.dart';
import 'package:key_value_store/in_memory_key_value_store.dart';

import 'holiday_bloc_unit_test.dart';

void main() {
  late InMemoryKeyValueStore kVstore;
  late State state;
  setUp(() {
    state = const NordrheinWestfalen();
    kVstore = InMemoryKeyValueStore();
  });
  test('Can save and load Holidays from Cache', () async {
    State state = const NordrheinWestfalen();
    HolidayCache cache = HolidayCache(kVstore);
    var expectedHolidays = generateHolidayList(5);

    cache.save(expectedHolidays, state);
    CacheResponse cacheResponse = cache.load(state)!;

    expect(cacheResponse.payload, expectedHolidays);
  });

  test('Does not return holidays which are over/in the past.', () {
    HolidayCache cache = HolidayCache(kVstore);
    HolidayCacheData holidayCacheData;
    State state = const NordrheinWestfalen();

    Holiday holidayInTheFuture = generateHoliday(
        clock.now().add(const Duration(days: 1)),
        clock.now().add(const Duration(days: 5)));
    Holiday holidayInThePast = generateHoliday(
        clock.now().subtract(const Duration(days: 10)),
        clock.now().subtract(const Duration(days: 5)));
    holidayCacheData = HolidayCacheData((b) => b
      ..holidays = ListBuilder([holidayInThePast, holidayInTheFuture])
      ..saved = clock.now());
    kVstore.setString(
        HolidayCache.getKeyString(state), holidayCacheData.toJson());

    CacheResponse expectedResonse = CacheResponse.valid([holidayInTheFuture]);
    expect(cache.load(state)!.payload, expectedResonse.payload);
  });

  group('Correctly returns if Holidays are past valid duration', () {
    late List<Holiday> expectedHolidays;
    setUp(() {
      expectedHolidays = generateHolidayList(3);
    });
    test("Correctly returns true", () async {
      HolidayCache cache = HolidayCache(kVstore);

      await cache.save(expectedHolidays, state);
      CacheResponse cacheResponse = cache.load(state)!;

      expect(cacheResponse.inValidTimeframe, true);
    });
    test("Correctly returns false", () async {
      final sixtyDaysBefore = clock.now().subtract(const Duration(days: 60));
      final now = clock.now();
      var currentTimeReturnedToCache = sixtyDaysBefore;
      HolidayCache cache = HolidayCache(kVstore,
          getCurrentTime: () => currentTimeReturnedToCache);

      await cache.save(expectedHolidays, state);
      currentTimeReturnedToCache = now;

      CacheResponse cacheResponse = cache.load(state)!;

      expect(cacheResponse.inValidTimeframe, false);
    });
  });
}
