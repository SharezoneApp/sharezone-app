// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:app_functions/app_functions.dart';
import 'package:app_functions/sharezone_app_functions.dart';
import 'package:async/async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holidays/holidays.dart';
import 'package:key_value_store/in_memory_key_value_store.dart';
import 'package:mockito/mockito.dart';
import 'package:sharezone/blocs/dashbord_widgets_blocs/holiday_bloc.dart';
import 'package:user/user.dart';

import 'holiday_bloc_unit_test.dart';

class MockAppSharezoneFunctions extends Mock implements SharezoneAppFunctions {}

void main() {
  test('Cache loads from API after empty cache and then from Cache', () async {
    StateEnum firstState = StateEnum.nordrheinWestfalen;
    StateEnum secondState = StateEnum.hamburg;
    final stateGateway = InMemoryHolidayStateGateway(initialValue: firstState);
    final szAppFunctions = MockAppSharezoneFunctions();

    final current = DateTime(2018, 03, 09);
    HolidayBloc holidayBloc = setupBloc(szAppFunctions, stateGateway, current);

    setMockAnswers(szAppFunctions);

    StreamQueue<List<Holiday?>> queue =
        StreamQueue<List<Holiday?>>(holidayBloc.holidays);
    stateGateway.changeState(secondState);

    areCorrectHolidaysForState(await queue.next, firstState);
    areCorrectHolidaysForState(await queue.next, secondState);
    verify(
      szAppFunctions.loadHolidays(
        stateCode: anyNamed('stateCode'),
        year: anyNamed('year'),
      ),
    ).called(4); // For each State 2018 and 2019

    /*Testing if Values are Cached.*/
    stateGateway.changeState(firstState);
    stateGateway.changeState(secondState);

    areCorrectHolidaysForState(await queue.next, firstState);
    areCorrectHolidaysForState(await queue.next, secondState);

    verifyNever(
      szAppFunctions.loadHolidays(
        stateCode: anyNamed('stateCode'),
        year: anyNamed('year'),
      ),
    ); // No calls added
  });
}

void setMockAnswers(MockAppSharezoneFunctions szAppFunctions) {
  setCfResponse(szAppFunctions, "NW", "2018", _jsonNrw2018);
  setCfResponse(szAppFunctions, "NW", "2019", _jsonNrw2019);
  setCfResponse(szAppFunctions, "HH", "2018", _jsonHamburg2018);
  setCfResponse(szAppFunctions, "HH", "2019", _jsonHamburg2019);
}

HolidayBloc setupBloc(MockAppSharezoneFunctions szAppFunctions,
    HolidayStateGateway stateGateway, DateTime currentTime) {
  HolidayApi api = HolidayApi(
    CloudFunctionHolidayApiClient(szAppFunctions),
    getCurrentTime: () => currentTime,
  ); // Return ended Holidays, as I can't manipulate DateTime.now(). This would lead to flaky tests.
  InMemoryKeyValueStore keyValueStore = InMemoryKeyValueStore();
  HolidayCache cache =
      HolidayCache(keyValueStore, getCurrentTime: () => currentTime);
  HolidayService holidayManager = HolidayService(api, cache);
  HolidayBloc holidayBloc = HolidayBloc(
      holidayManager: holidayManager,
      stateGateway: stateGateway,
      getCurrentTime: () => currentTime);
  return holidayBloc;
}

/// Checking if last and first Holiday are the same
bool areCorrectHolidaysForState(List<Holiday?> holidays, StateEnum stateEnum) {
  bool hContains(Holiday holiday) => holidays.contains(holiday);

  switch (stateEnum) {
    case StateEnum.nordrheinWestfalen:
      return hContains(_nrw2018FirstHoliday) &&
          hContains(_nrw2018LastHoliday) &&
          hContains(_nrw2019FirstHoliday) &&
          hContains(_nrw2019LastHoliday) &&
          holidays.length == nrw2018itemCount + nrw2019itemCount;
      break;
    case StateEnum.hamburg:
      return hContains(_hamburg2018FirstHoliday) &&
          hContains(_hamburg2018LastHoliday) &&
          hContains(_hamburg2019FirstHoliday) &&
          hContains(_hamburg2019LastHoliday) &&
          holidays.length == hamburg2018itemCount + hamburg2019itemCount;
      break;
    default:
      throw Exception("Wrong State: $stateEnum");
  }
}

void setCfResponse(MockAppSharezoneFunctions szAppFunctions, String stateCode,
    String year, String jsonResponse) {
  when(szAppFunctions.loadHolidays(stateCode: stateCode, year: year))
      .thenAnswer(
    (_) => Future.value(
      AppFunctionsResult<Map<String, dynamic>>.data(
        {'rawResponseBody': jsonResponse},
      ),
    ),
  );
}

final now = DateTime(2018, 1, 1);

// {"start":"2018-10-15T00:00","end":"2018-10-28T00:00","year":2018,"stateCode":"NW","name":"herbstferien","slug":"herbstferien-2018-NW"}
final Holiday _nrw2018FirstHoliday = Holiday((b) => b
  ..start = DateTime(2018, 10, 15)
  ..end = DateTime(2018, 10, 28)
  ..year = 2018
  ..stateCode = "NW"
  ..name = "herbstferien"
  ..slug = "herbstferien-2018-NW");
// {"start":"2018-05-22T00:00","end":"2018-05-26T00:00","year":2018,"stateCode":"NW","name":"pfingstferien","slug":"pfingstferien-2018-NW"}
final Holiday _nrw2018LastHoliday = Holiday((b) => b
  ..start = DateTime(2018, 05, 22)
  ..end = DateTime(2018, 05, 26)
  ..year = 2018
  ..stateCode = "NW"
  ..name = "pfingstferien"
  ..slug = "pfingstferien-2018-NW");
// {"start":"2019-04-15T00:00","end":"2019-04-28T00:00","year":2019,"stateCode":"NW","name":"osterferien","slug":"osterferien-2019-NW"}
final Holiday _nrw2019FirstHoliday = Holiday((b) => b
  ..start = DateTime(2019, 04, 15)
  ..end = DateTime(2019, 04, 28)
  ..year = 2019
  ..stateCode = "NW"
  ..name = "osterferien"
  ..slug = "osterferien-2019-NW");
// {"start":"2019-12-23T00:00","end":"2020-01-07T00:00","year":2019,"stateCode":"NW","name":"weihnachtsferien","slug":"weihnachtsferien-2019-NW"}
final Holiday _nrw2019LastHoliday = Holiday((b) => b
  ..start = DateTime(2019, 12, 23)
  ..end = DateTime(2020, 01, 07)
  ..year = 2019
  ..stateCode = "NW"
  ..name = "weihnachtsferien"
  ..slug = "weihnachtsferien-2019-NW");

// {"start":"2018-10-01T00:00","end":"2018-10-13T00:00","year":2018,"stateCode":"HH","name":"herbstferien","slug":"herbstferien-2018-HH"}
final Holiday _hamburg2018FirstHoliday = Holiday((b) => b
  ..start = DateTime(2018, 10, 01)
  ..end = DateTime(2018, 10, 13)
  ..year = 2018
  ..stateCode = "HH"
  ..name = "herbstferien"
  ..slug = "herbstferien-2018-HH");
// {"start":"2018-05-07T00:00","end":"2018-05-12T00:00","year":2018,"stateCode":"HH","name":"pfingstferien","slug":"pfingstferien-2018-HH"}
final Holiday _hamburg2018LastHoliday = Holiday((b) => b
  ..start = DateTime(2018, 05, 07)
  ..end = DateTime(2018, 05, 12)
  ..year = 2018
  ..stateCode = "HH"
  ..name = "pfingstferien"
  ..slug = "pfingstferien-2018-HH");
// {"start":"2019-02-01T00:00","end":"2019-02-02T00:00","year":2019,"stateCode":"HH","name":"winterferien","slug":"winterferien-2019-HH"}
final Holiday _hamburg2019FirstHoliday = Holiday((b) => b
  ..start = DateTime(2019, 02, 01)
  ..end = DateTime(2019, 02, 02)
  ..year = 2019
  ..stateCode = "HH"
  ..name = "winterferien"
  ..slug = "winterferien-2019-HH");
// {"start":"2019-12-23T00:00","end":"2020-01-04T00:00","year":2019,"stateCode":"HH","name":"weihnachtsferien","slug":"weihnachtsferien-2019-HH"}
final Holiday _hamburg2019LastHoliday = Holiday((b) => b
  ..start = DateTime(2019, 12, 23)
  ..end = DateTime(2020, 01, 04)
  ..year = 2019
  ..stateCode = "HH"
  ..name = "weihnachtsferien"
  ..slug = "weihnachtsferien-2019-HH");

int nrw2018itemCount = 5;
int nrw2019itemCount = 5;
int hamburg2018itemCount = 6;
int hamburg2019itemCount = 6;

const String _jsonNrw2018 =
    """[{"start":"2018-10-15T00:00","end":"2018-10-28T00:00","year":2018,"stateCode":"NW","name":"herbstferien","slug":"herbstferien-2018-NW"},{"start":"2018-12-21T00:00","end":"2019-01-05T00:00","year":2018,"stateCode":"NW","name":"weihnachtsferien","slug":"weihnachtsferien-2018-NW"},{"start":"2018-07-16T00:00","end":"2018-08-29T00:00","year":2018,"stateCode":"NW","name":"sommerferien","slug":"sommerferien-2018-NW"},{"start":"2018-03-26T00:00","end":"2018-04-08T00:00","year":2018,"stateCode":"NW","name":"osterferien","slug":"osterferien-2018-NW"},{"start":"2018-05-22T00:00","end":"2018-05-26T00:00","year":2018,"stateCode":"NW","name":"pfingstferien","slug":"pfingstferien-2018-NW"}]""";
const String _jsonNrw2019 =
    """[{"start":"2019-04-15T00:00","end":"2019-04-28T00:00","year":2019,"stateCode":"NW","name":"osterferien","slug":"osterferien-2019-NW"},{"start":"2019-05-31T00:00","end":"2019-06-01T00:00","year":2019,"stateCode":"NW","name":"pfingstferien","slug":"pfingstferien-2019-NW"},{"start":"2019-07-15T00:00","end":"2019-08-28T00:00","year":2019,"stateCode":"NW","name":"sommerferien","slug":"sommerferien-2019-NW"},{"start":"2019-10-14T00:00","end":"2019-10-27T00:00","year":2019,"stateCode":"NW","name":"herbstferien","slug":"herbstferien-2019-NW"},{"start":"2019-12-23T00:00","end":"2020-01-07T00:00","year":2019,"stateCode":"NW","name":"weihnachtsferien","slug":"weihnachtsferien-2019-NW"}]""";
const String _jsonHamburg2018 =
    """[{"start":"2018-10-01T00:00","end":"2018-10-13T00:00","year":2018,"stateCode":"HH","name":"herbstferien","slug":"herbstferien-2018-HH"},{"start":"2018-12-20T00:00","end":"2019-01-05T00:00","year":2018,"stateCode":"HH","name":"weihnachtsferien","slug":"weihnachtsferien-2018-HH"},{"start":"2018-07-05T00:00","end":"2018-08-16T00:00","year":2018,"stateCode":"HH","name":"sommerferien","slug":"sommerferien-2018-HH"},{"start":"2018-03-05T00:00","end":"2018-03-17T00:00","year":2018,"stateCode":"HH","name":"osterferien","slug":"osterferien-2018-HH"},{"start":"2018-02-02T00:00","end":"2018-02-03T00:00","year":2018,"stateCode":"HH","name":"winterferien","slug":"winterferien-2018-HH"},{"start":"2018-05-07T00:00","end":"2018-05-12T00:00","year":2018,"stateCode":"HH","name":"pfingstferien","slug":"pfingstferien-2018-HH"}]""";
const String _jsonHamburg2019 =
    """[{"start":"2019-02-01T00:00","end":"2019-02-02T00:00","year":2019,"stateCode":"HH","name":"winterferien","slug":"winterferien-2019-HH"},{"start":"2019-03-04T00:00","end":"2019-03-16T00:00","year":2019,"stateCode":"HH","name":"osterferien","slug":"osterferien-2019-HH"},{"start":"2019-05-13T00:00","end":"2019-05-18T00:00","year":2019,"stateCode":"HH","name":"pfingstferien","slug":"pfingstferien-2019-HH"},{"start":"2019-06-27T00:00","end":"2019-08-08T00:00","year":2019,"stateCode":"HH","name":"sommerferien","slug":"sommerferien-2019-HH"},{"start":"2019-10-04T00:00","end":"2019-10-19T00:00","year":2019,"stateCode":"HH","name":"herbstferien","slug":"herbstferien-2019-HH"},{"start":"2019-12-23T00:00","end":"2020-01-04T00:00","year":2019,"stateCode":"HH","name":"weihnachtsferien","slug":"weihnachtsferien-2019-HH"}]""";
