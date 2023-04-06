// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

library last_online_reporting;

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:flutter/material.dart';
import 'package:last_online_reporting/src/implementation.dart';
import 'package:rxdart/rxdart.dart';

/// Class to report to us when a person was last online. It does not report if a
/// person is currently online continously (called presence), but rather only
/// saves / updates a timestamp in the database.
class LastOnlineReporter {
  final Future<void> Function() _reportBeingCurrentlyOnlineToBackend;
  final CrashAnalytics _crashAnalytics;
  final Stream<AppLifecycleState> _lifecycleChanges;
  final Duration _debounceTime;
  StreamSubscription _streamSubscription;

  factory LastOnlineReporter.startReporting(
    FirebaseFirestore firestore,
    UserId userId,
    CrashAnalytics crashAnalytics, {
    /// Controls how often the client reports being online to the backend.
    /// If [minimumTimeBetweenReports] is e.g. 10 minutes the client will at max
    /// report being online every ten minutes (instead of reporting more often).
    /// This does not mean that there absolutely will be an update e.g. every 10
    /// minutes only that this is the miniumum allowed duration between reports.
    @required Duration minimumDurationBetweenReports,
  }) {
    final reporter = LastOnlineReporter.internal(
      FirestoreLastOnlineReporterBackend(firestore, userId)
          .reportCurrentlyOnline,
      AppLifecycleStateObserver().lifecycleChanges,
      crashAnalytics,
      debounceTime: minimumDurationBetweenReports,
    );

    reporter.startReporting();

    return reporter;
  }

  @visibleForTesting
  LastOnlineReporter.internal(
    this._reportBeingCurrentlyOnlineToBackend,
    this._lifecycleChanges,
    this._crashAnalytics, {
    @required Duration debounceTime,
  }) : _debounceTime = debounceTime;

  @visibleForTesting
  void startReporting() {
    _streamSubscription = _lifecycleChanges

        /// We don't want to report too many times being online just because
        /// [_lifecycleChanges] emits events in quick succession.
        .debounceTime(_debounceTime)

        /// We start with an own [AppLifecycleState] so that being online is
        /// being directly reported when calling this method because
        /// [_lifecycleChanges] may not directly emit an event.
        .startWith(AppLifecycleState.resumed)
        .listen((_) => _tryReportBeingCurrentlyOnlineToBackend());
  }

  Future<void> _tryReportBeingCurrentlyOnlineToBackend() async {
    try {
      await _reportBeingCurrentlyOnlineToBackend();
    } catch (e) {
      _crashAnalytics.log('Could not report being online: $e');
    }
  }

  void dispose() {
    _streamSubscription?.cancel();
  }
}
