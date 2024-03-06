// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/feedback/history/feedback_history_page.dart';
import 'package:sharezone/feedback/history/feedback_history_page_controller.dart';
import 'package:sharezone/feedback/history/feedback_view.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'feedback_history_page_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FeedbackHistoryPageController>()])
void main() {
  group(FeedbackHistoryPage, () {
    late MockFeedbackHistoryPageController controller;

    setUp(() {
      controller = MockFeedbackHistoryPageController();
    });

    void setControllerState(FeedbackHistoryPageState state) {
      // Mockito does not support mocking sealed classes yet, so we have to
      // provide a dummy implementation of the state.
      //
      // Ticket: https://github.com/dart-lang/mockito/issues/675
      provideDummy<FeedbackHistoryPageState>(state);
      provideDummy<FeedbackHistoryPageState>(state);
      when(controller.state).thenReturn(state);
    }

    void setLoadedState() {
      const views = <FeedbackView>[
        FeedbackView(
          createdOn: '2022-01-01',
          rating: '4.0',
          likes: 'Everything!',
          // Long text to test overflow
          dislikes:
              'I do not like rainy days 🌧️ Here my reasons: First, it can disrupt outdoor plans, events, and activities, leading to cancellations or the need for last-minute changes. Second, heavy rainfall can cause traffic delays and hazardous driving conditions, increasing the risk of accidents. Lastly, persistent or heavy rain can lead to flooding, causing damage to homes and infrastructure, and potentially displacing residents.',
          heardFrom: 'Google Play Store',
          missing: 'Nothing! 😊',
        ),
      ];
      setControllerState(FeedbackHistoryPageLoaded(views));
    }

    void setLoadingState() {
      setControllerState(FeedbackHistoryPageLoading());
    }

    void setErroredState() {
      setControllerState(FeedbackHistoryPageError('An error occurred'));
    }

    void setEmptyState() {
      setControllerState(FeedbackHistoryPageEmpty());
    }

    Future<void> pushFeedbackHistoryPage(
        WidgetTester tester, ThemeData theme) async {
      await tester.pumpWidgetBuilder(
        ChangeNotifierProvider<FeedbackHistoryPageController>.value(
          value: controller,
          child: const FeedbackHistoryPage(),
        ),
        wrapper: materialAppWrapper(theme: theme),
      );
    }

    testGoldens('renders as expected (light mode)', (tester) async {
      setLoadedState();
      await pushFeedbackHistoryPage(tester, getLightTheme());

      await multiScreenGolden(tester, 'feedback_history_page_light');
    });

    testGoldens('renders as expected (dark mode)', (tester) async {
      setLoadedState();
      await pushFeedbackHistoryPage(tester, getDarkTheme());

      await multiScreenGolden(tester, 'feedback_history_page_dark');
    });

    testGoldens('renders loading state as expected (light mode)',
        (tester) async {
      setLoadingState();

      await pushFeedbackHistoryPage(tester, getLightTheme());

      await multiScreenGolden(
        tester,
        'feedback_history_page_loading_light',
        // Custom pump to avoid timeout because of the loading spinner
        customPump: (tester) async =>
            await tester.pump(const Duration(milliseconds: 150)),
      );
    });

    testGoldens('renders loading state as expected (dark mode)',
        (tester) async {
      setLoadingState();

      await pushFeedbackHistoryPage(tester, getDarkTheme());

      await multiScreenGolden(
        tester,
        'feedback_history_page_loading_dark',
        // Custom pump to avoid timeout because of the loading spinner
        customPump: (tester) async =>
            await tester.pump(const Duration(milliseconds: 150)),
      );
    });

    testGoldens('renders error state as expected (light mode)', (tester) async {
      setErroredState();

      await pushFeedbackHistoryPage(tester, getLightTheme());

      await multiScreenGolden(
        tester,
        'feedback_history_page_error_light',
      );
    });

    testGoldens('renders error state as expected (dark mode)', (tester) async {
      setErroredState();

      await pushFeedbackHistoryPage(tester, getDarkTheme());

      await multiScreenGolden(
        tester,
        'feedback_history_page_error_dark',
      );
    });

    testGoldens('renders empty state as expected (light mode)', (tester) async {
      setEmptyState();

      await pushFeedbackHistoryPage(tester, getLightTheme());

      await multiScreenGolden(
        tester,
        'feedback_history_page_empty_light',
      );
    });

    testGoldens('renders empty state as expected (dark mode)', (tester) async {
      setEmptyState();

      await pushFeedbackHistoryPage(tester, getDarkTheme());

      await multiScreenGolden(
        tester,
        'feedback_history_page_empty_dark',
      );
    });
  });
}
