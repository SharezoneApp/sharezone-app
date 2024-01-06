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
      ThemeData? themeData,
    }) async {
      await tester.pumpWidgetBuilder(
        MultiProvider(
          providers: [
            Provider<TypeOfUser?>(
              create: (_) => TypeOfUser.student,
            ),
            Provider<SubscriptionService>(
              create: (_) => mockSubscriptionService,
            ),
          ],
          child: BlocProvider<NotificationsBlocFactory>(
            bloc: mockNotificationsBlocFactory,
            child: const NotificationPage(),
          ),
        ),
        wrapper: materialAppWrapper(theme: themeData),
      );
    }

    testGoldens('renders as expected (light mode)', (tester) async {
      await pumpNotificationPage(tester, themeData: getLightTheme());

      await multiScreenGolden(tester, 'notification_page_light');
    });

    testGoldens('renders as expected (dark mode)', (tester) async {
      await pumpNotificationPage(tester, themeData: getDarkTheme());

      await multiScreenGolden(tester, 'notification_page_dark');
    });

    testGoldens('renders plus dialog as expected', (tester) async {
      when(mockSubscriptionService.hasFeatureUnlocked(
              SharezonePlusFeature.changeHomeworkReminderTime))
          .thenReturn(false);

      await pumpNotificationPage(tester, themeData: getLightTheme());

      await tester
          .tap(find.byKey(const Key('homework-notifications-time-tile')));
      await tester.pumpAndSettle();

      await screenMatchesGolden(
        tester,
        'notification_page_homework_time_plus_ad',
      );
    });
  });
}
