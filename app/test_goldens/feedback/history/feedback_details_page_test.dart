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
import 'package:sharezone/feedback/history/feedback_details_page.dart';
import 'package:sharezone/feedback/history/feedback_details_page_controller.dart';
import 'package:sharezone/feedback/history/feedback_view.dart';
import 'package:sharezone/feedback/shared/feedback_id.dart';

import 'feedback_details_page_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FeedbackDetailsPageController>()])
void main() {
  group(FeedbackDetailsPage, () {
    late MockFeedbackDetailsPageController controller;
    final feedbackId = FeedbackId('feedbackId');

    setUp(() {
      controller = MockFeedbackDetailsPageController();
    });

    void setControllerState(FeedbackDetailsPageState state) {
      // Mockito does not support mocking sealed classes yet, so we have to
      // provide a dummy implementation of the state.
      //
      // Ticket: https://github.com/dart-lang/mockito/issues/675
      provideDummy<FeedbackDetailsPageState>(state);
      when(controller.state).thenReturn(state);
    }

    Future<void> pushFeedbackDetailsPage(
        WidgetTester tester, ThemeData theme) async {
      await tester.pumpWidgetBuilder(
        ChangeNotifierProvider<FeedbackDetailsPageController>.value(
          value: controller,
          child: FeedbackDetailsPage(feedbackId: feedbackId),
        ),
        wrapper: materialAppWrapper(theme: theme),
      );
    }

    group('loaded', () {
      setUp(() {
        setControllerState(
          FeedbackDetailsPageLoaded(
            feedback: FeedbackView(
              id: feedbackId,
              createdOn: '2022-01-01',
              rating: '4.0',
              likes: 'Everything!',
              // Long text to test overflow
              dislikes:
                  'I do not like rainy days 🌧️ Here my reasons: First, it can disrupt outdoor plans, events, and activities, leading to cancellations or the need for last-minute changes. Second, heavy rainfall can cause traffic delays and hazardous driving conditions, increasing the risk of accidents. Lastly, persistent or heavy rain can lead to flooding, causing damage to homes and infrastructure, and potentially displacing residents.',
              heardFrom: 'Google Play Store',
              missing: 'Nothing! 😊',
              hasUnreadMessages: null,
              lastMessage: null,
            ),
            chatMessages: null,
          ),
        );
      });

      testGoldens('renders as expected (light mode)', (tester) async {
        await pushFeedbackDetailsPage(tester, ThemeData.light());
        await multiScreenGolden(tester, 'feedback_details_page_loaded_light');
      });

      testGoldens('renders as expected (dark mode)', (tester) async {
        await pushFeedbackDetailsPage(tester, ThemeData.dark());
        await multiScreenGolden(tester, 'feedback_details_page_loaded_dark');
      });
    });

    group('error', () {
      setUp(() {
        setControllerState(
          FeedbackDetailsPageError('An error occurred'),
        );
      });

      testGoldens('renders as expected (light mode)', (tester) async {
        await pushFeedbackDetailsPage(tester, ThemeData.light());
        await multiScreenGolden(tester, 'feedback_details_page_error_light');
      });

      testGoldens('renders as expected (dark mode)', (tester) async {
        await pushFeedbackDetailsPage(tester, ThemeData.dark());
        await multiScreenGolden(tester, 'feedback_details_page_error_dark');
      });
    });

    group('loading', () {
      setUp(() {
        setControllerState(FeedbackDetailsPageLoading());
      });

      testGoldens('renders as expected (light mode)', (tester) async {
        await pushFeedbackDetailsPage(tester, ThemeData.light());
        await multiScreenGolden(
          tester,
          'feedback_details_page_loading_light',
          customPump: (tester) =>
              tester.pump(const Duration(milliseconds: 100)),
        );
      });

      testGoldens('renders as expected (dark mode)', (tester) async {
        await pushFeedbackDetailsPage(tester, ThemeData.dark());
        await multiScreenGolden(
          tester,
          'feedback_details_page_loading_dark',
          customPump: (tester) =>
              tester.pump(const Duration(milliseconds: 100)),
        );
      });
    });
  });
}
