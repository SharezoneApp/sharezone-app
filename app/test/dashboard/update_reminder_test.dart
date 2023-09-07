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
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sharezone/blocs/dashbord_widgets_blocs/holiday_bloc.dart';
import 'package:sharezone/dashboard/bloc/dashboard_bloc.dart';
import 'package:sharezone/dashboard/dashboard_page.dart';
import 'package:sharezone/dashboard/tips/dashboard_tip_system.dart';
import 'package:sharezone/dashboard/update_reminder/update_reminder_bloc.dart';
import 'package:sharezone_utils/platform.dart';

import 'update_reminder_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<UpdateReminderBloc>(),
  MockSpec<HolidayBloc>(),
  MockSpec<DashboardTipSystem>(),
  MockSpec<DashboardBloc>(),
])
void main() {
  group('Update-Reminder Card', () {
    late MockUpdateReminderBloc mockUpdateReminderBloc;
    final updateCardFinder = find.byKey(ValueKey('UpdatePromptCard'));

    setUp(() {
      mockUpdateReminderBloc = MockUpdateReminderBloc();
    });

    testWidgets(
        'is shown when user should be reminded of update and the current platform is anything other than web',
        (widgetTester) async {
      // Arrange
      // Wir testen hier nicht wirklich alle Plattformen, aber das wäre für eine
      // einzelne if-Bedingung overkill. Android steht hier für alle anderen
      // Plattformen ein.
      PlatformCheck.setCurrentPlatformForTesting(Platform.android);
      when(mockUpdateReminderBloc.shouldRemindToUpdate())
          .thenAnswer((_) => Future.value(true));
      final dashboardPage = _buildDashboardPage(mockUpdateReminderBloc);

      // Act
      await widgetTester.pumpDashboardPage(dashboardPage);

      // Assert
      expect(updateCardFinder, findsOneWidget);
    });

    testWidgets(
        'is not shown when user should be reminded of update ist available and the current platform is Web '
        'because the user cant manually update web and therefore just has to wait until we push an update. '
        'This means an update reminder would be useless.',
        (widgetTester) async {
      // Arrange
      PlatformCheck.setCurrentPlatformForTesting(Platform.web);
      when(mockUpdateReminderBloc.shouldRemindToUpdate())
          .thenAnswer((_) => Future.value(true));
      final dashboardPage = _buildDashboardPage(mockUpdateReminderBloc);

      // Act
      await widgetTester.pumpDashboardPage(dashboardPage);

      // Assert
      expect(updateCardFinder, findsNothing);
    });

    testWidgets('is not shown when user should not be reminded of update',
        (widgetTester) async {
      // Arrange
      PlatformCheck.setCurrentPlatformForTesting(Platform.web);
      when(mockUpdateReminderBloc.shouldRemindToUpdate())
          .thenAnswer((_) => Future.value(false));
      final dashboardPage = _buildDashboardPage(mockUpdateReminderBloc);

      // Act
      await widgetTester.pumpDashboardPage(dashboardPage);

      // Assert
      expect(updateCardFinder, findsNothing);
    });
  });
}

extension on WidgetTester {
  Future<void> pumpDashboardPage(Widget dashboardPage) async {
    await pumpWidget(dashboardPage);
    // Warte auf build von Update-Karte
    await pump();
  }
}

Widget _buildDashboardPage(UpdateReminderBloc updateReminderBloc) {
  return MultiBlocProvider(
    blocProviders: [
      BlocProvider<DashboardBloc>(bloc: MockDashboardBloc()),
      BlocProvider<UpdateReminderBloc>(bloc: updateReminderBloc),
      BlocProvider<DashboardTipSystem>(bloc: MockDashboardTipSystem()),
      BlocProvider<HolidayBloc>(bloc: MockHolidayBloc()),
    ],
    child: (c) => MaterialApp(home: DashboardPageBody()),
  );
}
