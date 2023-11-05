// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/notifications/notifications_bloc.dart';
import 'package:sharezone/notifications/notifications_bloc_factory.dart';
import 'package:sharezone/settings/src/subpages/notification.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:user/user.dart';

import 'notification_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<NotificationsBloc>(),
  MockSpec<NotificationsBlocFactory>(),
  MockSpec<SubscriptionService>(),
])
void main() {
  group(NotificationPage, () {
    late MockNotificationsBloc mockNotificationsBloc;
    late MockNotificationsBlocFactory mockNotificationsBlocFactory;
    late MockSubscriptionService mockSubscriptionService;

    setUp(() {
      mockNotificationsBloc = MockNotificationsBloc();
      mockNotificationsBlocFactory = MockNotificationsBlocFactory();
      mockSubscriptionService = MockSubscriptionService();

      when(mockNotificationsBlocFactory.create())
          .thenReturn(mockNotificationsBloc);
    });

    Future<void> pumpNotificationPage(
      WidgetTester tester, {
      TypeOfUser? typeOfUser,
    }) async {
      await tester.pumpWidgetBuilder(
        MultiProvider(
          providers: [
            Provider<TypeOfUser?>(
              create: (_) => typeOfUser,
            ),
            Provider<SubscriptionService>(
              create: (_) => mockSubscriptionService,
            ),
          ],
          child: BlocProvider<NotificationsBlocFactory>(
            bloc: mockNotificationsBlocFactory,
            child: const MaterialApp(
              home: NotificationPage(),
            ),
          ),
        ),
      );
    }

    group('homeworks', () {
      testWidgets(
          'does not display the homework notification section for non-student accounts',
          (tester) async {
        for (final typeOfUser
            in TypeOfUser.values.where((e) => e != TypeOfUser.student)) {
          await pumpNotificationPage(
            tester,
            typeOfUser: typeOfUser,
          );

          expect(
            find.byKey(const ValueKey('homework-notifications-card')),
            findsNothing,
          );
        }
      });

      testWidgets('displays homework notification section for student accounts',
          (tester) async {
        await pumpNotificationPage(
          tester,
          typeOfUser: TypeOfUser.student,
        );

        expect(
          find.byKey(const ValueKey('homework-notifications-card')),
          findsOneWidget,
        );
      });

      testWidgets('displays Sharezone Plus chip for non-plus accounts',
          (tester) async {
        when(mockSubscriptionService.hasFeatureUnlocked(
                SharezonePlusFeature.changeHomeworkReminderTime))
            .thenReturn(false);

        await pumpNotificationPage(
          tester,
          typeOfUser: TypeOfUser.student,
        );

        expect(
          find.byType(SharezonePlusChip),
          findsOneWidget,
        );
      });

      testWidgets('does not display Sharezone Plus chip for plus accounts',
          (tester) async {
        when(mockSubscriptionService.hasFeatureUnlocked(
                SharezonePlusFeature.changeHomeworkReminderTime))
            .thenReturn(true);

        await pumpNotificationPage(
          tester,
          typeOfUser: TypeOfUser.student,
        );

        expect(
          find.byType(SharezonePlusChip),
          findsNothing,
        );
      });

      testWidgets(
          'shows sharezone plus ad when tapping on homework reminder time tile',
          (tester) async {
        when(mockSubscriptionService.hasFeatureUnlocked(
                SharezonePlusFeature.changeHomeworkReminderTime))
            .thenReturn(false);

        await pumpNotificationPage(
          tester,
          typeOfUser: TypeOfUser.student,
        );

        await tester.tap(
            find.byKey(const ValueKey('homework-notifications-time-tile')));
        await tester.pumpAndSettle();

        expect(
          find.byKey(const Key('sharezone-plus-feature-info-dialog')),
          findsOneWidget,
        );
      });
    });
  });
}
