// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:crash_analytics/mock_crash_analytics.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:last_online_reporting/last_online_reporting.dart';
import 'package:last_online_reporting/src/implementation.dart';

class MockLastOnlineReporterBackend
    implements FirestoreLastOnlineReporterBackend {
  int reportedOnlineToBackend = 0;
  bool shouldThrow = false;

  @override
  Future<void> reportCurrentlyOnline() async {
    reportedOnlineToBackend += 1;
    if (shouldThrow) {
      throw Exception('MockLastOnlineReporterBackend Test Exception.');
    }
  }
}

void main() {
  group('$LastOnlineReporter', () {
    late MockLastOnlineReporterBackend backend;
    late StreamController<AppLifecycleState> lifecycleChanges;
    late LastOnlineReporter lastOnlineReporter;
    late MockCrashAnalytics crashAnalytics;
    const debounceTime = Duration(minutes: 10);

    setUp(() {
      crashAnalytics = MockCrashAnalytics();
      lifecycleChanges = StreamController<AppLifecycleState>();
      backend = MockLastOnlineReporterBackend();
      lastOnlineReporter = LastOnlineReporter.internal(
        backend.reportCurrentlyOnline,
        lifecycleChanges.stream,
        crashAnalytics,
        debounceTime: const Duration(seconds: 10),
      );
    });

    tearDown(() {
      lifecycleChanges.close();
    });

    /// Because [LastOnlineReporter] uses Streams and a Timer for debouncing
    /// events we need to use [FakeAsync] to manually control the time passed.
    /// Also [pumpEventQueue] doesn't work if not in [FakeAsync] here curiously.

    test('reports being online once when created/starting', () async {
      expect(backend.reportedOnlineToBackend, 0);
      lastOnlineReporter.startReporting();
      // We don't use FakeAsync here because there whatever time the debounce
      // was set to (e.g. 5 minutes) will just be skipped immediatly.
      //
      // This test tests that the class reports being online instantly, altough
      // we need to await something so that the underlying stream has time to
      // do its work.
      await Future.delayed(Duration.zero);
      expect(backend.reportedOnlineToBackend, 1);
    });
    test('debounces AppLifecycleState', () async {
      FakeAsync().run((fakeAsync) async {
        lastOnlineReporter.startReporting();

        /// These should be debounced (ignored) as when creating the class (or in
        /// the test case calling [lastOnlineReporter.startReporting] it reports
        /// being online - so the last report was too recent to update it again.
        lifecycleChanges.add(AppLifecycleState.detached);
        lifecycleChanges.add(AppLifecycleState.resumed);

        await pumpEventQueue();
        expect(backend.reportedOnlineToBackend, 1);

        /// We wait for the debounce time to elapse.
        fakeAsync.elapse(debounceTime);

        // This should now be reported as the debounce time elapsed.
        lifecycleChanges.add(AppLifecycleState.detached);

        await pumpEventQueue();
        expect(backend.reportedOnlineToBackend, 2);
      });
    });
    test('calls CrashAnalytics when reporting to Backend throws', () async {
      FakeAsync().run((fakeAsync) async {
        lastOnlineReporter.startReporting();
        await pumpEventQueue();
        expect(crashAnalytics.logCalledLog, true);
      });
    });

    test('cancels AppLifecycleState change stream when disposed', () {
      FakeAsync().run((fakeAsync) async {
        lastOnlineReporter.startReporting();
        await pumpEventQueue();
        lastOnlineReporter.dispose();
        expect(lifecycleChanges.isClosed, true);
      });
    });
  });
}
