import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sharezone/models/extern_apis/holiday.dart';
import 'package:sharezone/models/serializers.dart';

import 'package:sharezone/util/holidays/state.dart';
import 'package:sharezone_utils/platform.dart';

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

class HolidayApi {
  final http.Client httpClient;
  final bool returnPassedHolidays;
  DateTime Function() getCurrentTime;

  HolidayApi(this.httpClient,
      {this.returnPassedHolidays = false, this.getCurrentTime}) {
    getCurrentTime ??= () => DateTime.now();
  }
  void dispose() {
    httpClient.close();
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
  ///
  Future<List<dynamic>> _getHolidayAPIResponse(
      int year, String stateCode) async {
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

  Future<List<Holiday>> _loadHolidaysForYear(int year, State state) async {
    List jsonHolidayList = await _getHolidayAPIResponse(year, state.code);
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

  static Uri getApiUrl(String stateCode, int year) => PlatformCheck.isWeb
      ? Uri.parse(
          "https://cors-anywhere.herokuapp.com/https://ferien-api.de/api/v1/holidays/$stateCode/$year")
      : Uri.parse("https://ferien-api.de/api/v1/holidays/$stateCode/$year");
}
