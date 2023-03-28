// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:developer';

import 'package:key_value_store/key_value_store.dart';
import 'package:meta/meta.dart';

class FeedbackCache {
  final KeyValueStore _cache;

  @visibleForTesting
  static const String lastSubmitCacheKey = "last_feedback_submit";

  FeedbackCache(this._cache);

  Future<bool> hasFeedbackSubmissionCooldown(Duration feedbackCooldown) async {
    DateTime lastSubmit;
    try {
      lastSubmit = await _getLastSubmitTime();
      // ignore: avoid_catching_errors
    } on ArgumentError {
      log("Cache value could not be loaded");
      return false;
    } on Exception catch (e, s) {
      log("$e $s");
      return false;
    }

    assert(lastSubmit != null);

    final durationPassedFromLastSubmit =
        lastSubmit.difference(DateTime.now()).abs();
    if (durationPassedFromLastSubmit < feedbackCooldown) return true;
    return false;
  }

  Future<void> setLastSubmit() async {
    _cache.setString(lastSubmitCacheKey, DateTime.now().toIso8601String());
  }

  Future<DateTime> _getLastSubmitTime() async {
    String lastSubmitString = _cache.getString(lastSubmitCacheKey);
    DateTime lastSubmit = DateTime.parse(lastSubmitString);
    return lastSubmit;
  }
}
