// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter_test/flutter_test.dart';
import 'package:key_value_store/in_memory_key_value_store.dart';
import 'package:rxdart/subjects.dart';
import 'package:sharezone/navigation/scaffold/portable/bottom_navigation_bar/tutorial/bnb_tutorial_bloc.dart';
import 'package:sharezone/navigation/scaffold/portable/bottom_navigation_bar/tutorial/bnb_tutorial_cache.dart';

import 'mock_bnb_tutorial_analytics.dart';

void main() {
  group('BnB tutorial bloc', () {
    BnbTutorialBloc bloc;
    BnbTutorialCache cache;
    MockBnbTutorialAnalytics analytics;

    BehaviorSubject<bool> isGroupOnboardingFinished;

    setUp(() {
      cache = BnbTutorialCache(InMemoryKeyValueStore());
      analytics = MockBnbTutorialAnalytics();
      isGroupOnboardingFinished = BehaviorSubject.seeded(true);
      bloc = BnbTutorialBloc(cache, analytics, isGroupOnboardingFinished);
    });

    tearDown(() {
      isGroupOnboardingFinished.close();
    });

    test("don't show tutorial if user doesn't completed the group onboarding",
        () {
      isGroupOnboardingFinished.sink.add(false);
      expect(bloc.shouldShowBnbTutorial(), emits(false));
    });

    test(
        "don't show tutorial if already showed in runtime and already completed",
        () {
      bloc.markTutorialAsCompleted();
      bloc.setTutorialAsShown();
      expect(bloc.shouldShowBnbTutorial(), emits(false));
    });

    test('don\'t show tutorial if never showed in runtime, but completed', () {
      bloc.markTutorialAsCompleted();
      expect(bloc.shouldShowBnbTutorial(), emits(false));
    });

    test(
        'don\'t show tutorial if showed already in runtime, but never completed',
        () {
      bloc.setTutorialAsShown();
      expect(bloc.shouldShowBnbTutorial(), emits(false));
    });

    test('show tutorial if never showed in runtime and never completed', () {
      expect(bloc.shouldShowBnbTutorial(), emits(true));
    });

    test('loggs analytics if user skips the tutorial', () {
      bloc.markTutorialAsSkipped();
      expect(analytics.skippedBnbTutorailLogged, true);
    });

    test('loggs analytics if user complets the tutorial', () {
      bloc.markTutorialAsCompleted();
      expect(analytics.completedBnbTutorialLogged, true);
    });
  });
}
