// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'holiday_api.dart';
import 'holiday_cache.dart';
import 'api/holiday.dart';
import 'state.dart';

class HolidayManager {
  final HolidayApi api;
  final HolidayCache cache;

  HolidayManager(this.api, this.cache);

  Future<List<Holiday>> load(State state,
      {bool ignoreCachedData = false}) async {
    CacheResponse cached;
    if (!ignoreCachedData) {
      cached = _tryToloadCachedData(state);
    }

    List<Holiday> apiResponse;
    if (cached?.payload == null || !cached.inValidTimeframe) {
      apiResponse = await _tryCallingApi(apiResponse, state);
      if (apiResponse != null) await _trySavingToCache(apiResponse, state);
    }

    List<Holiday> response = apiResponse ?? cached?.payload;
    // Don't retrun null, as in most StreamBuilers there will be just a loading indicator.
    if (response == null)
      throw HolidayLoadingException("Loading from Cache and Api both failed");

    return response;
  }

  Future<List<Holiday>> _tryCallingApi(
      List<Holiday> response, State state) async {
    try {
      response = await api.load(1, state);
    } on Exception catch (e) {
      print("Exception when loading Holidays from API: $e");
    }
    return response;
  }

  Future<void> _trySavingToCache(List<Holiday> response, State state) async {
    try {
      await cache.save(response, state);
    } on Exception catch (e) {
      print("Could not save in Cache: $e");
    }
    return;
  }

  CacheResponse _tryToloadCachedData(State state) {
    try {
      return cache.load(state);
    } catch (e) {
      print("Could not load Cache data: $e");
    }
    return null;
  }
}

class HolidayLoadingException implements Exception {
  final String message;

  HolidayLoadingException([this.message]);

  @override
  String toString() {
    String report = "HolidayLoadingException";
    if (message != null || message == "") report += ": $message";
    report += ".";
    return report;
  }
}
