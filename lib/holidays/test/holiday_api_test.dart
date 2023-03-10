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
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockSharezoneFunctions extends Mock implements AppFunctions {}

class MockAppSharezoneFunctions extends Mock implements SharezoneAppFunctions {}

void main() {
  State state;
  MockSharezoneFunctions functions;
  HolidayApi api;

  HolidayApi apiWithCfResponse(http.Response validResponse) {
    when(
      functions.callCloudFunction<Map<String, dynamic>>(
        functionName: anyNamed('functionName'),
        parameters: anyNamed('parameters'),
      ),
    ).thenAnswer(
      (_) => Future.value(
        AppFunctionsResult<Map<String, dynamic>>.data(
          {'rawResponseBody': validResponse.body},
        ),
      ),
    );

    return api;
  }

  void expectToThrowAssertionErrorForInvalidYearInAdvance(int year) {
    expect(api.load(year, NordrheinWestfalen()),
        throwsA(TypeMatcher<AssertionError>()));
  }

  setUp(() {
    state = NordrheinWestfalen();
    functions = MockSharezoneFunctions();

    api = HolidayApi(
      CloudFunctionHolidayApiClient(
        SharezoneAppFunctions(functions),
      ),
    );
  });

  test("If Api gets valid data returns Holidays", () {
    HolidayApi api = apiWithCfResponse(validResponse);
    expect(api.load(0, state), completion(TypeMatcher<List<Holiday>>()));
  });

  test('If Api gets response with faulty error code throws Exception', () {
    when(
      functions.callCloudFunction<Map<String, dynamic>>(
        functionName: anyNamed('functionName'),
        parameters: anyNamed('parameters'),
      ),
    ).thenAnswer(
      (_) => Future.value(
        AppFunctionsResult.exception(
          UnknownAppFunctionsException(
            FirebaseFunctionsException(
              message: validResponse.body,
              code: 'unknown',
            ),
          ),
        ),
      ),
    );

    expect(api.load(0, state), throwsA(TypeMatcher<ApiResponseException>()));
  });
  test('If Api gets empty response gives back empty list', () {
    HolidayApi api = apiWithCfResponse(emptyResponse);
    expect(api.load(0, state), completion([]));
  });

  test('Api gets called for correct year', () async {
    final szAppFunction = MockAppSharezoneFunctions();

    HolidayApi api = HolidayApi(CloudFunctionHolidayApiClient(szAppFunction));
    int expectedYear = DateTime.now().year;

    when(szAppFunction.loadHolidays(stateCode: "NW", year: '$expectedYear'))
        .thenAnswer(
      (_) => Future.value(
        AppFunctionsResult<Map<String, dynamic>>.data(
          {'rawResponseBody': ""},
        ),
      ),
    );

    await api.load(0, state);

    verify(szAppFunction.loadHolidays(stateCode: "NW", year: '$expectedYear'));
  });

  test('Throws when given invalid years', () {
    expectToThrowAssertionErrorForInvalidYearInAdvance(-1);
    expectToThrowAssertionErrorForInvalidYearInAdvance(-10000);
  });
}

http.Response emptyResponse = http.Response("", 200);
http.Response invalidResponse = http.Response("OAWNDAI", 500);
http.Response validResponse = http.Response(validResponseString, 200);

String validResponseString = """
[{"start":"2018-10-15T00:00","end":"2018-10-28T00:00","year":2018,"stateCode":"NW","name":"herbstferien","slug":"herbstferien-2018-NW"},{"start":"2018-12-21T00:00","end":"2019-01-05T00:00","year":2018,"stateCode":"NW","name":"weihnachtsferien","slug":"weihnachtsferien-2018-NW"},{"start":"2018-07-16T00:00","end":"2018-08-29T00:00","year":2018,"stateCode":"NW","name":"sommerferien","slug":"sommerferien-2018-NW"},{"start":"2018-03-26T00:00","end":"2018-04-08T00:00","year":2018,"stateCode":"NW","name":"osterferien","slug":"osterferien-2018-NW"},{"start":"2018-05-22T00:00","end":"2018-05-26T00:00","year":2018,"stateCode":"NW","name":"pfingstferien","slug":"pfingstferien-2018-NW"}]
""";
