// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:bloc_provider/multi_bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:key_value_store/in_memory_key_value_store.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/navigation/analytics/navigation_analytics.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/navigation/scaffold/portable/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:sharezone/navigation/scaffold/portable/bottom_navigation_bar/extendable_bottom_navigation_bar.dart';
import 'package:sharezone/navigation/scaffold/portable/bottom_navigation_bar/navigation_experiment/navigation_experiment_cache.dart';
import 'package:sharezone/navigation/scaffold/portable/bottom_navigation_bar/navigation_experiment/navigation_experiment_option.dart';
import 'package:sharezone/navigation/scaffold/portable/bottom_navigation_bar/tutorial/bnb_tutorial_bloc.dart';
import 'package:sharezone/navigation/scaffold/portable/bottom_navigation_bar/tutorial/bnb_tutorial_cache.dart';
import 'package:sharezone/util/cache/streaming_key_value_store.dart';

import 'mock_bnb_tutorial_analytics.dart';
import 'mock_navigation_analytics.dart';

void main() {
  group('ExtendableBottomNavigationBar', () {
    // Navigation
    NavigationBloc navigationBloc;
    MockNavigationAnalytics navigationAnalytics;
    NavigationExperimentCache navigationExperimentCache;

    // Tutorial
    BnbTutorialBloc tutorialBloc;
    BnbTutorialCache cache;
    MockBnbTutorialAnalytics analytics;
    BehaviorSubject<bool> isGroupOnboardingFinished;

    setUp(() {
      cache = BnbTutorialCache(InMemoryKeyValueStore());
      analytics = MockBnbTutorialAnalytics();
      isGroupOnboardingFinished = BehaviorSubject.seeded(true);
      tutorialBloc =
          BnbTutorialBloc(cache, analytics, isGroupOnboardingFinished);
      navigationBloc = NavigationBloc();
      navigationAnalytics = MockNavigationAnalytics();
      navigationExperimentCache =
          NavigationExperimentCache(InMemoryStreamingKeyValueStore());
    });

    tearDown(() {
      isGroupOnboardingFinished.close();
    });

    testWidgets('should not be shown, if as navigation drawer + bnb is selected', (tester) async {
      await tester.pumpWidget(
        MultiBlocProvider(
          blocProviders: [
            BlocProvider<NavigationBloc>(bloc: navigationBloc),
            BlocProvider<BnbTutorialBloc>(bloc: tutorialBloc),
            BlocProvider<NavigationAnalytics>(bloc: navigationAnalytics),
            BlocProvider<NavigationExperimentCache>(
                bloc: navigationExperimentCache),
          ],
          child: (context) => MaterialApp(
            home: ExtendableBottomNavigationBar(
              page: Scaffold(body: Container(height: 800, width: 800)),
              option: NavigationExperimentOption.drawerAndBnb,
              currentNavigationItem: NavigationItem.overview,
            ),
          ),
        ),
      );

      expect(find.byType(FirstNavigationRow), findsNothing);
      expect(find.byType(SecondNavigationRow), findsNothing);
    });
  });
}
