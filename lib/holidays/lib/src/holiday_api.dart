// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:convert';

import 'package:app_functions/sharezone_app_functions.dart';

import 'api/holiday.dart';
import 'api/serializers.dart';
import 'state.dart';

class ApiResponseException implements Exception {
  final String message;

  ApiResponseException([this.message]);

  @override
  String toString() {
    return message != null
        ? "ApiResponseException: $message"
        : "ApiResponseException";
  }
}

class EmptyResponseException implements Exception {}

abstract class HolidayApiClient {
  /// Calls the API to get the Holidays for the [year] for the specified [stateCode].
  /// The [stateCode] has to be one of the following:
  /// BW	Baden-Württemberg
  /// BY	Bayern
  /// BE	Berlin
  /// BB	Brandenburg
  /// HB	Bremen
  /// HH	Hamburg
  /// HE	Hessen
  /// MV	Mecklenburg-Vorpommern
  /// NI	Niedersachsen
  /// NW	Nordrhein-Westfalen
  /// RP	Rheinland-Pfalz
  /// SL	Saarland
  /// SN	Sachsen
  /// ST	Sachsen-Anhalt
  /// SH	Schleswig-Holstein
  /// TH	Thüringen
  ///
  /// API Documentation/Information: https://www.ferien-api.de/
  Future<List<dynamic>> getHolidayAPIResponse(int year, String stateCode);

  Future<void> close() {
    return Future.value();
  }
}

/// Is used as a successor to [HttpHolidayApiClient] as the
/// [HttpHolidayApiClient] didn't work in the web because of missing CORS
/// headers on the server-side.
/// [CloudFunctionHolidayApiClient] calls our endpoint that we can use as a
/// reverse-proxy with correct CORS headers. In this way we could also add
/// caching via CF or change to our own implementation if we want.
class CloudFunctionHolidayApiClient extends HolidayApiClient {
  final SharezoneAppFunctions functions;

  CloudFunctionHolidayApiClient(this.functions);

  @override
  Future<List> getHolidayAPIResponse(int year, String stateCode) async {
    final result =
        await functions.loadHolidays(stateCode: stateCode, year: '$year');
    if (result.hasException) {
      throw ApiResponseException(
          "Got bad response: ${result.exception.code} ${result.exception.message}");
    }
    if (!result.hasData) {
      return [];
    }

    final responseBody = result.data['rawResponseBody'] as String;
    if (responseBody.isEmpty) {
      return [];
    }

    List<dynamic> holidayList = json.decode(responseBody) as List<dynamic>;
    return holidayList;
  }
}

class HolidayApi {
  final HolidayApiClient apiClient;
  final bool returnPassedHolidays;
  DateTime Function() getCurrentTime;

  HolidayApi(this.apiClient,
      {this.returnPassedHolidays = false, this.getCurrentTime}) {
    getCurrentTime ??= () => DateTime.now();
  }
  void dispose() {
    apiClient.close();
  }

  /// Returns a List of comming Holidays for [state] for this plus [yearsInAdvance] years.
  /// e.g. This year is 2019, [yearsInAdvance] == 0 -> Gets Holiday for 2019
  ///                        [yearsInAdvance] == 1 -> Gets Holiday for 2018 + 2019
  /// If [returnPassedHolidays] is false, then the Holidays which end have already passed,
  /// will not get returned.
  Future<List<Holiday>> load(int yearsInAdvance, State state,
      [bool returnPassedHolidays = false]) async {
    assert(yearsInAdvance >= 0);

    List<Holiday> holidays = [];

    for (int i = 0; i <= yearsInAdvance; i++) {
      int yearToLoad = getCurrentTime().year + i;
      try {
        List<Holiday> holidayList =
            await _loadHolidaysForYear(yearToLoad, state);
        holidays.addAll(holidayList);
      } on EmptyResponseException {
        print("Empty Response from API for year: $yearToLoad");
      }
    }

    return holidays;
  }

  List<Holiday> _deserializeHolidaysFromJSON(List jsonHolidayList) {
    List<Holiday> holidayList = jsonHolidayList
        .map((jsonHolidy) =>
            jsonSerializer.deserializeWith(Holiday.serializer, jsonHolidy))
        .toList();
    return holidayList;
  }

  Future<List<Holiday>> _loadHolidaysForYear(int year, State state) async {
    List jsonHolidayList =
        await apiClient.getHolidayAPIResponse(year, state.code);
    List<Holiday> holidayList = _deserializeHolidaysFromJSON(jsonHolidayList);
    removePassedHolidays(holidayList);
    return holidayList;
  }

  void removePassedHolidays(List<Holiday> holidayList) {
    if (!returnPassedHolidays) {
      holidayList
          .removeWhere((holiday) => getCurrentTime().isAfter(holiday.end));
    }
  }
}
