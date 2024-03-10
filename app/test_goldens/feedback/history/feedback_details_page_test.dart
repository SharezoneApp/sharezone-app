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
import 'package:sharezone/feedback/history/feedback_details_page.dart';
import 'package:sharezone/feedback/history/feedback_view.dart';

void main() {
  group(FeedbackDetailsPage, () {
    Future<void> pushFeedbackDetailsPage(
        WidgetTester tester, ThemeData theme) async {
      await tester.pumpWidgetBuilder(
        const FeedbackDetailsPage(
          feedback: FeedbackView(
            createdOn: '2022-01-01',
            rating: '4.0',
            likes: 'Everything!',
            // Long text to test text wrap
            dislikes:
                'I do not like rainy days 🌧️ Here my reasons: First, it can disrupt outdoor plans, events, and activities, leading to cancellations or the need for last-minute changes. Second, heavy rainfall can cause traffic delays and hazardous driving conditions, increasing the risk of accidents. Lastly, persistent or heavy rain can lead to flooding, causing damage to homes and infrastructure, and potentially displacing residents.',
            heardFrom: 'Google Play Store',
            missing: 'Nothing! 😊',
          ),
        ),
        wrapper: materialAppWrapper(theme: theme),
      );
    }

    testGoldens('renders as expected (light mode)', (tester) async {
      await pushFeedbackDetailsPage(tester, ThemeData.light());
      await multiScreenGolden(tester, 'feedback_details_page_light');
    });

    testGoldens('renders as expected (dark mode)', (tester) async {
      await pushFeedbackDetailsPage(tester, ThemeData.dark());
      await multiScreenGolden(tester, 'feedback_details_page_dark');
    });
  });
}
