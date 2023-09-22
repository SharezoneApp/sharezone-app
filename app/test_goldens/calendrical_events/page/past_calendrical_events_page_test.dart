// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:math';

import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/calendrical_events/models/calendrical_event.dart';
import 'package:sharezone/calendrical_events/page/past_calendrical_events_page.dart';
import 'package:sharezone/calendrical_events/provider/past_calendrical_events_page_controller.dart';
import 'package:sharezone/calendrical_events/provider/past_calendrical_events_page_controller_factory.dart';
import 'package:sharezone/timetable/src/widgets/events/event_view.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'past_calendrical_events_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<PastCalendricalEventsPageControllerFactory>(),
  MockSpec<PastCalendricalEventsPageController>(),
  MockSpec<CalendricalEvent>(),
])
void main() {
  late MockPastCalendricalEventsPageController controller;
  late MockPastCalendricalEventsPageControllerFactory controllerFactory;
  late Random random;

  EventView randomEventView() {
    return EventView(
      design: Design.random(random),
      // Generate random date
      dateText: DateTime(
        2021,
        random.nextInt(12) + 1,
        random.nextInt(28) + 1,
      ).toIso8601String(),
      event: MockCalendricalEvent(),
      groupID: '${random.nextInt(1000)}',
      courseName: 'Course ${random.nextInt(1000)}',
      title: 'Title ${random.nextInt(1000)}',
    );
  }

  setUp(() {
    controller = MockPastCalendricalEventsPageController();
    controllerFactory = MockPastCalendricalEventsPageControllerFactory();
    random = Random(42);

    when(controllerFactory.create()).thenReturn(controller);

    final state = PastCalendricalEventsPageLoadedState(
      [for (var i = 0; i < 10; i++) randomEventView()],
    );
    provideDummy<PastCalendricalEventsPageState>(state);
    when(controller.state).thenReturn(state);
  });

  group(PastCalendricalEventsPage, () {
    Future<void> pumpPage(WidgetTester tester, {ThemeData? theme}) async {
      await tester.pumpWidgetBuilder(
        Provider<PastCalendricalEventsPageControllerFactory>.value(
          value: controllerFactory,
          child: const PastCalendricalEventsPage(),
        ),
        wrapper: materialAppWrapper(theme: theme),
      );
    }

    testGoldens('renders correctly (light theme)', (tester) async {
      await pumpPage(tester, theme: lightTheme);

      await multiScreenGolden(
        tester,
        'past_calendrical_events_page_light_theme',
      );
    });

    testGoldens('renders correctly (dark theme)', (tester) async {
      await pumpPage(tester, theme: darkTheme);

      await multiScreenGolden(
        tester,
        'past_calendrical_events_page_dark_theme',
      );
    });
  });
}
