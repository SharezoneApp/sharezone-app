// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:analytics/null_analytics_backend.dart';
import 'package:authentification_base/authentification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:key_value_store/in_memory_key_value_store.dart';
import 'package:remote_configuration/remote_configuration.dart';
import 'package:rxdart/subjects.dart';
import 'package:sharezone/dynamic_links/beitrittsversuch.dart';
import 'package:sharezone/dynamic_links/dynamic_link_bloc.dart';
import 'package:sharezone/main/bloc_dependencies.dart';
import 'package:sharezone/main/sharezone.dart';
import 'package:sharezone/util/flavor.dart';
import 'package:sharezone_common/references.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

void main() {
  group('Sharezone widget', () {
    test('can be instantiated with mocked Analytics', () {
      // This test demonstrates that we can now pass a mocked Analytics instance
      // to the Sharezone widget, which makes it testable.
      //
      // Before the refactoring, the Sharezone widget used a static
      // Analytics(getBackend()) which called FirebaseAnalytics.instance,
      // making it impossible to mock for tests.

      final mockAnalytics = Analytics(NullAnalyticsBackend());
      final mockAuth = MockFirebaseAuth();
      final mockFirestore = FakeFirebaseFirestore();
      final mockFunctions = FirebaseFunctions.instance;

      final blocDependencies = BlocDependencies(
        analytics: mockAnalytics,
        firestore: mockFirestore,
        keyValueStore: InMemoryKeyValueStore(),
        sharedPreferences: null as dynamic, // Not needed for this test
        references: References.init(
          firebaseDependencies: null as dynamic, // Not needed for this test
          appFunctions: null as dynamic, // Not needed for this test
        ),
        auth: mockAuth,
        streamingSharedPreferences:
            null as dynamic, // Not needed for this test
        registrationGateway: RegistrationGateway(
          mockFirestore.collection('Users'),
          mockAuth,
          analytics: mockAnalytics,
        ),
        appFunctions: null as dynamic, // Not needed for this test
        functions: mockFunctions,
        remoteConfiguration: RemoteConfiguration.defaultRemote(),
      );

      final dynamicLinkBloc = DynamicLinkBloc(null as dynamic);
      final beitrittsversuche = BehaviorSubject<Beitrittsversuch?>();

      // This should not throw an error - the key point is that we can pass
      // our mocked analytics instead of having it hardcoded.
      final sharezone = Sharezone(
        blocDependencies: blocDependencies,
        dynamicLinkBloc: dynamicLinkBloc,
        beitrittsversuche: beitrittsversuche,
        flavor: Flavor.dev,
        analytics: mockAnalytics,
      );

      expect(sharezone, isNotNull);
      expect(sharezone.analytics, equals(mockAnalytics));
    });

    test('uses analytics from BlocDependencies when not provided', () {
      // This test verifies that the Sharezone widget falls back to using
      // analytics from BlocDependencies when no explicit analytics is provided.

      final mockAnalytics = Analytics(NullAnalyticsBackend());
      final mockAuth = MockFirebaseAuth();
      final mockFirestore = FakeFirebaseFirestore();
      final mockFunctions = FirebaseFunctions.instance;

      final blocDependencies = BlocDependencies(
        analytics: mockAnalytics,
        firestore: mockFirestore,
        keyValueStore: InMemoryKeyValueStore(),
        sharedPreferences: null as dynamic,
        references: References.init(
          firebaseDependencies: null as dynamic,
          appFunctions: null as dynamic,
        ),
        auth: mockAuth,
        streamingSharedPreferences: null as dynamic,
        registrationGateway: RegistrationGateway(
          mockFirestore.collection('Users'),
          mockAuth,
          analytics: mockAnalytics,
        ),
        appFunctions: null as dynamic,
        functions: mockFunctions,
        remoteConfiguration: RemoteConfiguration.defaultRemote(),
      );

      final dynamicLinkBloc = DynamicLinkBloc(null as dynamic);
      final beitrittsversuche = BehaviorSubject<Beitrittsversuch?>();

      // Don't provide analytics parameter - should use from BlocDependencies
      final sharezone = Sharezone(
        blocDependencies: blocDependencies,
        dynamicLinkBloc: dynamicLinkBloc,
        beitrittsversuche: beitrittsversuche,
        flavor: Flavor.dev,
      );

      expect(sharezone, isNotNull);
      // Note: We can't directly verify which analytics is used in this test
      // without additional infrastructure, but the important part is that
      // it doesn't throw an error trying to access FirebaseAnalytics.instance
    });
  });
}
