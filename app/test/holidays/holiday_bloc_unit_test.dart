// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holidays/holidays.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test_randomness/test_randomness.dart' as rdm;
import 'package:rxdart/subjects.dart';
import 'package:sharezone/holidays/holiday_bloc.dart';
import 'package:user/user.dart';

import 'holiday_bloc_unit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<HolidayApi>(), MockSpec<HolidayCache>()])
void main() {
  const nrwState = NordrheinWestfalen();
  const nrwStateEnum = StateEnum.nordrheinWestfalen;
  late MockHolidayCache mockCache;
  late MockHolidayApi mockAPI;

  setUp(() {
    mockCache = MockHolidayCache();
    mockAPI = MockHolidayApi();
  });

  HolidayService getMockManager() => HolidayService(mockAPI, mockCache);
  HolidayBloc getBlocWithMocks() => HolidayBloc(
    holidayManager: getMockManager(),
    stateGateway: InMemoryHolidayStateGateway(initialValue: nrwStateEnum),
  );

  void cacheReturnsInvalidHolidays(
    List<Holiday> expectedHolidays, [
    MockHolidayCache? mockCachePassed,
  ]) {
    when(
      mockCachePassed?.load(any) ?? mockCache.load(any),
    ).thenReturn(CacheResponse.invalid(expectedHolidays));
  }

  void cacheThrows() {
    when(mockCache.load(any)).thenThrow(Exception("Cache Exception"));
  }

  void apiAnswersWith(List<Holiday> expectedHolidays, {State? forState}) {
    when(
      mockAPI.load(any, forState ?? any),
    ).thenAnswer((_) => Future.value(expectedHolidays));
  }

  test(
    'If Cache can not load Holidays the API will be invoked and will save the data to cache again',
    () async {
      List<Holiday> apiResponse = [generateHoliday(), generateHoliday()];

      HolidayBloc bloc = getBlocWithMocks();

      cacheThrows();
      apiAnswersWith(apiResponse);
      when(
        mockCache.save(apiResponse, nrwState),
      ).thenAnswer((_) => Future.value());

      await bloc.holidays.first;

      expect(bloc.holidays, emits(apiResponse));
      verify(mockCache.save(apiResponse, nrwState)).called(1);
    },
  );

  test(
    'If Cache returns valid data then the API does not get called',
    () async {
      CacheResponse cachedHolidays = CacheResponse.valid([
        generateHoliday(),
        generateHoliday(),
      ]);
      HolidayBloc bloc = getBlocWithMocks();

      when(
        mockCache.load(const NordrheinWestfalen()),
      ).thenReturn(cachedHolidays);

      expect(bloc.holidays, emits(cachedHolidays.payload));
    },
  );

  test(
    'If cached Holidays are not valid anymore, then the API will get called, but will still return cached data when API call is failing',
    () {
      List<Holiday> expectedHolidays = generateHolidayList(4);
      when(
        mockCache.load(nrwState),
      ).thenReturn(CacheResponse.invalid(expectedHolidays));
      when(mockAPI.load(any, any)).thenThrow(Exception("Some Exception"));

      HolidayBloc bloc = getBlocWithMocks();

      expect(bloc.holidays, emits(expectedHolidays));
    },
  );

  test(
    "If cached Holidays are not valid anymore, then the API will get called and if successfull return",
    () {
      List<Holiday> expectedHolidays = generateHolidayList(4);
      cacheReturnsInvalidHolidays(generateHolidayList(4));
      apiAnswersWith(expectedHolidays);
      HolidayBloc bloc = getBlocWithMocks();

      expect(bloc.holidays, emits(expectedHolidays));
    },
  );

  test("Changing states from Stream yields correct holidays from stream", () {
    List<Holiday> expectedNrwResponse = [generateHoliday(), generateHoliday()];
    List<Holiday> expectedHessenResponse = [
      generateHoliday(),
      generateHoliday(),
    ];
    var holidayStateGateway = InMemoryHolidayStateGateway();
    HolidayBloc bloc = HolidayBloc(
      holidayManager: getMockManager(),
      stateGateway: holidayStateGateway,
    );

    cacheReturnsInvalidHolidays(generateHolidayList(2));
    apiAnswersWith(expectedNrwResponse, forState: const NordrheinWestfalen());
    apiAnswersWith(expectedHessenResponse, forState: const Hessen());

    holidayStateGateway.changeState(StateEnum.nordrheinWestfalen);
    holidayStateGateway.changeState(StateEnum.hessen);

    expect(
      bloc.holidays,
      emitsInOrder([expectedNrwResponse, expectedHessenResponse]),
    );
  });

  test('When giving wrong state an Exception is given back to the stream', () {
    var stateGateway = InMemoryHolidayStateGateway();
    HolidayBloc bloc = HolidayBloc(
      holidayManager: getMockManager(),
      stateGateway: stateGateway,
    );

    stateGateway.changeState(StateEnum.anonymous);
    expect(
      bloc.holidays,
      emitsError(const TypeMatcher<UnsupportedStateException>()),
    );

    stateGateway.changeState(StateEnum.notFromGermany);
    expect(
      bloc.holidays,
      emitsError(const TypeMatcher<UnsupportedStateException>()),
    );
  });

  test('When holidays can not be saved the api still returns as usual', () {
    List<Holiday> apiResponse = generateHolidayList(4);
    HolidayBloc bloc = getBlocWithMocks();
    when(mockCache.load(any)).thenThrow(Exception());
    apiAnswersWith(apiResponse);
    when(mockCache.save(any, any)).thenThrow(Exception());

    expect(bloc.holidays, emits(apiResponse));
  });

  test('bloc can be disposed', () async {
    when(mockCache.load(any)).thenReturn(CacheResponse.valid([]));
    getBlocWithMocks().dispose();
  });
}

class InMemoryHolidayStateGateway extends HolidayStateGateway {
  InMemoryHolidayStateGateway({StateEnum? initialValue}) {
    if (initialValue != null) {
      _userState.add(initialValue);
    }
  }

  // ignore: close_sinks
  final _userState = BehaviorSubject<StateEnum?>();

  @override
  Future<void> changeState(StateEnum? state) async {
    _userState.add(state);
  }

  @override
  Stream<StateEnum?> get userState => _userState;
}

List<Holiday> generateHolidayList(int length) {
  List<Holiday> holidays = [];
  for (int i = 0; i < length; i++) {
    final start = clock.now().add(Duration(days: i + 1));
    final end = start.add(Duration(days: i + 4));
    holidays.add(generateHoliday(start, end));
  }
  return holidays;
}

Holiday generateHoliday([DateTime? start, DateTime? end]) {
  if (start != null && end != null) {
    return Holiday(
      (b) =>
          b
            ..start = start
            ..end = end
            ..name = rdm.randomString(10)
            ..slug = "Slug"
            ..stateCode = "NW"
            ..year = end.year,
    );
  } else {
    return Holiday(
      (b) =>
          b
            ..start = DateTime.fromMicrosecondsSinceEpoch(123)
            ..end = DateTime.fromMillisecondsSinceEpoch(123)
            ..name = rdm.randomString(10)
            ..slug = "Slug"
            ..stateCode = "NW"
            ..year = 2018,
    );
  }
}
