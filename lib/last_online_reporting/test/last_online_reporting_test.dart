import 'dart:async';

import 'package:common_domain_models/src/ids/user_id.dart';
import 'package:crash_analytics/mock_crash_analytics.dart';
import 'package:flutter/material.dart';
import 'package:last_online_reporting/last_online_reporting.dart';
import 'package:last_online_reporting/src/implementation.dart';
import 'package:quiver/testing/async.dart';
import 'package:test/test.dart';

class MockLastOnlineReporterBackend extends FirestoreLastOnlineReporterBackend {
  int reportedOnlineToBackend = 0;
  bool shouldThrow = false;

  MockLastOnlineReporterBackend() : super(null, UserId('userId'));

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
    MockLastOnlineReporterBackend backend;
    StreamController<AppLifecycleState> _lifecycleChanges;
    LastOnlineReporter lastOnlineReporter;
    MockCrashAnalytics crashAnalytics;
    final _debounceTime = Duration(minutes: 10);

    setUp(() {
      crashAnalytics = MockCrashAnalytics();
      _lifecycleChanges = StreamController<AppLifecycleState>();
      backend = MockLastOnlineReporterBackend();
      lastOnlineReporter = LastOnlineReporter.internal(
        backend.reportCurrentlyOnline,
        _lifecycleChanges.stream,
        crashAnalytics,
        debounceTime: Duration(seconds: 10),
      );
    });

    tearDown(() {
      _lifecycleChanges.close();
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
        _lifecycleChanges.add(AppLifecycleState.detached);
        _lifecycleChanges.add(AppLifecycleState.resumed);

        await pumpEventQueue();
        expect(backend.reportedOnlineToBackend, 1);

        /// We wait for the debounce time to elapse.
        fakeAsync.elapse(_debounceTime);

        // This should now be reported as the debounce time elapsed.
        _lifecycleChanges.add(AppLifecycleState.detached);

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
        expect(_lifecycleChanges.isClosed, true);
      });
    });
  });
}
