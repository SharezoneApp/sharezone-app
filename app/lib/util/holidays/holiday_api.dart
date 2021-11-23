import 'dart:async';
import 'dart:convert';

import 'package:app_functions/app_functions.dart';
import 'package:app_functions/sharezone_app_functions.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:http/http.dart' as http;
import 'package:sharezone/models/extern_apis/holiday.dart';
import 'package:sharezone/models/serializers.dart';

import 'package:sharezone/util/holidays/state.dart';

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
  @override
  Future<List> getHolidayAPIResponse(int year, String stateCode) async {
    final functions = SharezoneAppFunctions(
        AppFunctions(FirebaseFunctions.instanceFor(region: 'europe-west1')));
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

    List<dynamic> holidayList = json.decode(responseBody) as List<dynamic>;
    return holidayList;
  }
}

/// See [CloudFunctionHolidayApiClient].
class HttpHolidayApiClient extends HolidayApiClient {
  final http.Client httpClient;

  HttpHolidayApiClient(this.httpClient);

  static Uri getApiUrl(String stateCode, int year) =>
      Uri.parse("https://ferien-api.de/api/v1/holidays/$stateCode/$year");

  @override
  Future<List> getHolidayAPIResponse(int year, String stateCode) async {
    Uri apiURL = getApiUrl(stateCode, year);
    final response = await httpClient.get(apiURL);
    if (response.statusCode == 200) {
      // If okay
      if (response.body.isEmpty) throw EmptyResponseException();
      List<dynamic> holidayList = json.decode(response.body) as List<dynamic>;
      return holidayList;
    } else {
      throw ApiResponseException(
          "Expected response status 200, got: ${response.statusCode}");
    }
  }

  @override
  Future<void> close() async {
    httpClient.close();
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
