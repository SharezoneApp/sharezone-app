// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('analytics', () {
    LocalAnalyticsBackend backend;
    Analytics analytics;

    setUp(() {
      backend = LocalAnalyticsBackend();
      analytics = Analytics(backend);
    });

    test('An Event with a null name will be ignored', () {
      final event = AnalyticsEvent(null);

      analytics.log(event);

      expect(backend.hasloggedEvents, false);
    });

    test('An Event with an empty name will be ignored', () {
      final event = AnalyticsEvent("");

      analytics.log(event);

      expect(backend.hasloggedEvents, false);
    });

    test('An Event a valid name gets logged', () {
      final event = AnalyticsEvent("valid_name");

      analytics.log(event);

      expect(backend.hasloggedEvents, true);
      expect(backend.wasLogged("valid_name"), true);
    });

    test(
      'An Event can have optional simple data that will be logged',
      () {
        const bar = 1;
        const zoink = "String";
        final data = {"foo": bar, "baz": zoink};
        final event =
            AnalyticsEvent("with_data", data: {"foo": bar, "baz": zoink});

        analytics.log(event);

        expect(backend.getSingleEventData("with_data"), data);
      },
    );

    test(
        'if an Event has null data it will be given as an empty map to the backend',
        () {
      analytics.log(AnalyticsEvent("name", data: null));

      expect(backend.getSingleEventData("name"), {});
    });
  });
}

class LocalAnalyticsBackend extends AnalyticsBackend {
  final List<Map<String, dynamic>> loggedEvents = [];
  bool get hasloggedEvents => loggedEvents.isNotEmpty;

  bool wasLogged(String s) {
    final logsWithName = getEvent(s);
    return logsWithName.isNotEmpty;
  }

  @override
  void log(String name, [Map<String, dynamic> data = const {}]) {
    loggedEvents.add({name: data});
  }

  List<Map<String, dynamic>> getEvent(String s) {
    return loggedEvents.where((map) => map.containsKey(s)).toList();
  }

  Map<String, dynamic> getSingleEventData(String s) {
    final event = getEvent(s).single;
    return event.values.first as Map<String, dynamic>;
  }

  @override
  Future<void> setAnalyticsCollectionEnabled(bool value) async {}

  @override
  Future<void> logSignUp({String signUpMethod}) async {}

  @override
  Future<void> setCurrentScreen({String screenName}) async {}

  @override
  Future<void> setUserProperty({String name, String value}) async {}
}
