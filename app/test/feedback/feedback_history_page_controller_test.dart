// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:feedback_shared_implementation/feedback_shared_implementation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sharezone/feedback/history/feedback_history_page_controller.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:sharezone/feedback/history/feedback_history_page_analytics.dart';
import 'dart:async';

import 'feedback_history_page_controller_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FeedbackApi>(),
  MockSpec<CrashAnalytics>(),
  MockSpec<FeedbackHistoryPageAnalytics>()
])
void main() {
  group(FeedbackHistoryPageController, () {
    late MockFeedbackApi mockFeedbackApi;
    late MockCrashAnalytics mockCrashAnalytics;
    late MockFeedbackHistoryPageAnalytics mockFeedbackHistoryPageAnalytics;
    late FeedbackHistoryPageController controller;
    late StreamController<List<UserFeedback>> feedbackStreamController;
    const userId = UserId('test-user');

    setUp(() {
      mockFeedbackApi = MockFeedbackApi();
      mockCrashAnalytics = MockCrashAnalytics();
      mockFeedbackHistoryPageAnalytics = MockFeedbackHistoryPageAnalytics();
      feedbackStreamController = StreamController<List<UserFeedback>>();
      when(mockFeedbackApi.streamFeedbacks(any))
          .thenAnswer((_) => feedbackStreamController.stream);

      controller = FeedbackHistoryPageController(
        api: mockFeedbackApi,
        userId: userId,
        crashAnalytics: mockCrashAnalytics,
        analytics: mockFeedbackHistoryPageAnalytics,
      );
    });

    tearDown(() {
      feedbackStreamController.close();
      controller.dispose();
    });

    test('should start streaming and handle empty feedback list', () async {
      controller.startStreaming();
      feedbackStreamController.add([]);
      await Future.delayed(Duration.zero); // Wait for the stream to emit.

      expect(controller.state, isA<FeedbackHistoryPageEmpty>());
    });

    test('should handle feedback list correctly', () async {
      final feedbacks = [UserFeedback.create()];
      controller.startStreaming();
      feedbackStreamController.add(feedbacks);
      await Future.delayed(Duration.zero); // Wait for the stream to emit.

      expect(controller.state, isA<FeedbackHistoryPageLoaded>());
      final state = controller.state as FeedbackHistoryPageLoaded;
      expect(state.feedbacks.length, 1);
    });

    test('should handle errors correctly', () async {
      controller.startStreaming();
      feedbackStreamController.addError('An error occurred');
      await Future.delayed(Duration.zero); // Wait for the stream to emit.

      expect(controller.state, isA<FeedbackHistoryPageError>());
      verify(mockCrashAnalytics.recordError(any, any)).called(1);
    });

    test('should log analytics when opened page', () {
      controller.logOpenedPage();
      verify(mockFeedbackHistoryPageAnalytics.logOpenedPage()).called(1);
    });
  });
}
