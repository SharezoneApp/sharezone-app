// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:sharezone/models/extern_apis/holiday.dart';
import 'package:sharezone/util/holidays/holiday_api.dart';
import 'package:sharezone/util/holidays/state.dart';
import 'package:test/test.dart';

class HttpClientMock extends Mock implements http.Client {}

/// Fixes HandshakeException:<HandshakeException: Handshake error in client (OS
/// Error: CERTIFICATE_VERIFY_FAILED: certificate has
/// expired(../../third_party/boringssl/src/ssl/handshake.cc:359))>
/// when running tests locally
class IgnoreCertificateErrorsHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  State state;
  setUp(() {
    state = NordrheinWestfalen();
    HttpOverrides.global = IgnoreCertificateErrorsHttpOverrides();
  });

  tearDown(() {
    HttpOverrides.global = null;
  });

  test("If Api gets valid data returns Holidays", () {
    HolidayApi api = apiWithHttpReponse(validResponse);
    expect(api.load(0, state), completion(TypeMatcher<List<Holiday>>()));
  });

  test('If Api gets response with faulty error code throws Exception', () {
    HolidayApi api = apiWithHttpReponse(invalidResponse);
    expect(api.load(0, state), throwsA(TypeMatcher<ApiResponseException>()));
  });
  test('If Api gets empty response gives back empty list', () {
    HolidayApi api = apiWithHttpReponse(emptyResponse);
    expect(api.load(0, state), completion([]));
  });

  test('Api gets called for correct year', () async {
    HttpClientMock httpClient = HttpClientMock();
    HolidayApi api = HolidayApi(HttpHolidayApiClient(httpClient));
    int expectedYear = DateTime.now().year;
    Uri expectedUrl = HttpHolidayApiClient.getApiUrl("NW", expectedYear);

    when(httpClient.get(any)).thenThrow(Exception("Should not get called"));
    when(httpClient.get(expectedUrl))
        .thenAnswer((_) => Future.value(validResponse));

    await api.load(0, state);
    verify(httpClient.get(expectedUrl)).called(1);
  });

  test('Throws when given invalid years', () {
    expectToThrowAssertionErrorForInvalidYearInAdvance(-1);
    expectToThrowAssertionErrorForInvalidYearInAdvance(-10000);
  });

  test("Can call dispose", () {
    HolidayApi holidayAPI = HolidayApi(HttpHolidayApiClient(http.Client()));
    holidayAPI.dispose();
  });
}

void expectToThrowAssertionErrorForInvalidYearInAdvance(int year) {
  expect(
      HolidayApi(HttpHolidayApiClient(http.Client()))
          .load(year, NordrheinWestfalen()),
      throwsA(TypeMatcher<AssertionError>()));
}

HolidayApi apiWithHttpReponse(http.Response validResponse) {
  HttpClientMock client = HttpClientMock();
  when(client.get(any)).thenAnswer((_) => Future.value(validResponse));
  HolidayApi api = HolidayApi(HttpHolidayApiClient(client));
  return api;
}

http.Response emptyResponse = http.Response("", 200);
http.Response invalidResponse = http.Response("OAWNDAI", 500);
http.Response validResponse = http.Response(validResponseString, 200);

String validResponseString = """
[{"start":"2018-10-15T00:00","end":"2018-10-28T00:00","year":2018,"stateCode":"NW","name":"herbstferien","slug":"herbstferien-2018-NW"},{"start":"2018-12-21T00:00","end":"2019-01-05T00:00","year":2018,"stateCode":"NW","name":"weihnachtsferien","slug":"weihnachtsferien-2018-NW"},{"start":"2018-07-16T00:00","end":"2018-08-29T00:00","year":2018,"stateCode":"NW","name":"sommerferien","slug":"sommerferien-2018-NW"},{"start":"2018-03-26T00:00","end":"2018-04-08T00:00","year":2018,"stateCode":"NW","name":"osterferien","slug":"osterferien-2018-NW"},{"start":"2018-05-22T00:00","end":"2018-05-26T00:00","year":2018,"stateCode":"NW","name":"pfingstferien","slug":"pfingstferien-2018-NW"}]
""";
