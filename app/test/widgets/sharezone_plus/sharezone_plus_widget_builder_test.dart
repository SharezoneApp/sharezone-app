// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';
import 'package:sharezone/widgets/sharezone_plus/sharezone_plus_widget_builder.dart';

import 'sharezone_plus_widget_builder_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SubscriptionService>()])
void main() {
  group(SharezonePlusWidgetBuilder, () {
    late MockSubscriptionService subscriptionService;

    setUp(() {
      subscriptionService = MockSubscriptionService();
    });

    Future<void> pumpSharezonePlusWidgetBuilder(
      WidgetTester tester, {
      required Widget onHasPlus,
      required Widget onHasNoPlus,
    }) async {
      await tester.pumpWidget(
        Provider<SubscriptionService>(
          create: (context) => subscriptionService,
          child: MaterialApp(
            home: Scaffold(
              body: SharezonePlusWidgetBuilder(
                onHasPlus: onHasPlus,
                onHasNoPlus: onHasNoPlus,
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('should display onHasPlus widget when user has Sharezone Plus',
        (tester) async {
      when(subscriptionService.isSubscriptionActiveStream())
          .thenAnswer((_) => Stream.value(true));

      await pumpSharezonePlusWidgetBuilder(
        tester,
        onHasPlus: const Text('onHasPlus'),
        onHasNoPlus: const Text('onHasNoPlus'),
      );
      await tester.pump();

      expect(find.text('onHasPlus'), findsOneWidget);
    });

    testWidgets(
        'should display onHasNoPlus widget when user does not have Sharezone Plus',
        (tester) async {
      when(subscriptionService.isSubscriptionActiveStream())
          .thenAnswer((_) => Stream.value(false));

      await pumpSharezonePlusWidgetBuilder(
        tester,
        onHasPlus: const Text('onHasPlus'),
        onHasNoPlus: const Text('onHasNoPlus'),
      );
      await tester.pump();

      expect(find.text('onHasNoPlus'), findsOneWidget);
    });

    testWidgets('should display onHasNoPlus widget when stream is empty',
        (tester) async {
      when(subscriptionService.isSubscriptionActiveStream())
          .thenAnswer((_) => const Stream.empty());

      await pumpSharezonePlusWidgetBuilder(
        tester,
        onHasPlus: const Text('onHasPlus'),
        onHasNoPlus: const Text('onHasNoPlus'),
      );
      await tester.pump();

      expect(find.text('onHasNoPlus'), findsOneWidget);
    });
  });
}
