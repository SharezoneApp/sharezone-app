// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:app_functions/app_functions.dart';
import 'package:app_functions/exceptions.dart';
import 'package:app_functions/sharezone_app_functions.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:holidays/holidays.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'holiday_api_test.mocks.dart';

@GenerateMocks([AppFunctions, SharezoneAppFunctions])
void main() {
  late State state;
  late MockAppFunctions functions;
  late HolidayApi api;
  late DateTime dateTime;

  setUp(() {
    state = NordrheinWestfalen();
    functions = MockAppFunctions();
    dateTime = DateTime(2018, 1, 1);

    api = HolidayApi(
      CloudFunctionHolidayApiClient(
        SharezoneAppFunctions(functions),
      ),
      getCurrentTime: () => dateTime,
    );
  });

  test("If Api gets valid data returns Holidays", () async {
    when(
      functions.callCloudFunction<Map<String, dynamic>>(
        functionName: "loadHolidays",
        parameters: {
          "stateCode": "NW",
          "year": "2018",
        },
      ),
    ).thenAnswer(
      (_) => Future.value(
        AppFunctionsResult<Map<String, dynamic>>.data(
          {'rawResponseBody': validResponseString},
        ),
      ),
    );

    expect(await api.load(0, state), TypeMatcher<List<Holiday>>());
  });

  test('If Api gets response with faulty error code throws Exception', () {
    when(
      functions.callCloudFunction<Map<String, dynamic>>(
        functionName: "loadHolidays",
        parameters: {
          "stateCode": "NW",
          "year": "2018",
        },
      ),
    ).thenAnswer(
      (_) => Future.value(
        AppFunctionsResult.exception(
          UnknownAppFunctionsException(
            FirebaseFunctionsException(
              message: 'Could not return holidays',
              code: 'unknown',
            ),
          ),
        ),
      ),
    );

    expect(() async => await api.load(0, state),
        throwsA(TypeMatcher<ApiResponseException>()));
  });

  test('If Api gets empty response gives back empty list', () async {
    when(
      functions.callCloudFunction<Map<String, dynamic>>(
        functionName: "loadHolidays",
        parameters: {
          "stateCode": "NW",
          "year": "2018",
        },
      ),
    ).thenAnswer(
      (_) => Future.value(
        AppFunctionsResult<Map<String, dynamic>>.data(
          {'rawResponseBody': ""},
        ),
      ),
    );

    expect(await api.load(0, state), []);
  });

  test('Api gets called for correct year', () async {
    final szAppFunction = MockSharezoneAppFunctions();

    HolidayApi api = HolidayApi(
      CloudFunctionHolidayApiClient(szAppFunction),
      getCurrentTime: () => dateTime,
    );
    int expectedYear = dateTime.year;

    when(szAppFunction.loadHolidays(stateCode: "NW", year: '$expectedYear'))
        .thenAnswer(
      (_) => Future.value(
        AppFunctionsResult<Map<String, dynamic>>.data(
          // Doesn't matter what we return here, we just want to check that
          // loadHoliday is called.
          {'rawResponseBody': ""},
        ),
      ),
    );

    await api.load(0, state);

    verify(szAppFunction.loadHolidays(stateCode: "NW", year: '$expectedYear'));
  });

  void expectToThrowAssertionErrorForInvalidYearInAdvance(int year) {
    expect(api.load(year, NordrheinWestfalen()),
        throwsA(TypeMatcher<AssertionError>()));
  }

  test('Throws when given invalid years', () {
    expectToThrowAssertionErrorForInvalidYearInAdvance(-1);
    expectToThrowAssertionErrorForInvalidYearInAdvance(-10000);
  });
}

String validResponseString = """
[{"start":"2018-10-15T00:00","end":"2018-10-28T00:00","year":2018,"stateCode":"NW","name":"herbstferien","slug":"herbstferien-2018-NW"},{"start":"2018-12-21T00:00","end":"2019-01-05T00:00","year":2018,"stateCode":"NW","name":"weihnachtsferien","slug":"weihnachtsferien-2018-NW"},{"start":"2018-07-16T00:00","end":"2018-08-29T00:00","year":2018,"stateCode":"NW","name":"sommerferien","slug":"sommerferien-2018-NW"},{"start":"2018-03-26T00:00","end":"2018-04-08T00:00","year":2018,"stateCode":"NW","name":"osterferien","slug":"osterferien-2018-NW"},{"start":"2018-05-22T00:00","end":"2018-05-26T00:00","year":2018,"stateCode":"NW","name":"pfingstferien","slug":"pfingstferien-2018-NW"}]
""";
