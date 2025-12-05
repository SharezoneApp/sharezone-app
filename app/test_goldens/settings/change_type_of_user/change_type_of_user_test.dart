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
import 'package:sharezone/settings/src/subpages/my_profile/change_type_of_user/change_type_of_user_controller.dart';
import 'package:sharezone/settings/src/subpages/my_profile/change_type_of_user/change_type_of_user_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:user/user.dart';

import 'change_type_of_user_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ChangeTypeOfUserController>()])
void main() {
  group(ChangeTypeOfUserPage, () {
    late MockChangeTypeOfUserController controller;

    setUp(() {
      controller = MockChangeTypeOfUserController();
      // Mockito does not support mocking sealed classes yet, so we have to
      // provide a dummy implementation of the state.
      //
      // Ticket: https://github.com/dart-lang/mockito/issues/675
      const state = ChangeTypeOfUserInitial();

      provideDummy<ChangeTypeOfUserState>(state);
      when(controller.state).thenReturn(state);
      when(controller.initialTypeOfUser).thenReturn(TypeOfUser.student);
    });

    Future<void> pumpChangeTypeOfUserPage(
      WidgetTester tester, {
      ThemeData? theme,
    }) async {
      await tester.pumpWidgetBuilder(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ChangeTypeOfUserController>.value(
              value: controller,
            ),
          ],
          child: const ChangeTypeOfUserPage(),
        ),
        wrapper: materialAppWrapper(theme: theme),
      );
    }

    testGoldens('renders as expected initial state (light mode)', (
      tester,
    ) async {
      await pumpChangeTypeOfUserPage(tester, theme: getLightTheme());

      await multiScreenGolden(tester, 'change_type_of_user_page_light');
    });

    testGoldens('renders as expected initial state (dark mode)', (
      tester,
    ) async {
      await pumpChangeTypeOfUserPage(tester, theme: getDarkTheme());

      await multiScreenGolden(tester, 'change_type_of_user_page_dark');
    });

    testGoldens('renders as expected successful state', (tester) async {
      await pumpChangeTypeOfUserPage(tester);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await screenMatchesGolden(tester, 'change_type_of_user_page_successful');
    });

    for (final failure in [
      ChangedTypeOfUserTooOftenException(
        blockedUntil: DateTime(2024, 3, 3, 14, 2),
      ),
      const NoTypeOfUserSelectedException(),
      const TypeUserOfUserHasNotChangedException(),
      const ChangeTypeOfUserUnknownException('Unknown error'),
    ]) {
      final runtimeType = failure.runtimeType;
      testGoldens(
        'renders as expected when showing a failure message ($runtimeType)',
        (tester) async {
          when(controller.changeTypeOfUser()).thenThrow(failure);
          await pumpChangeTypeOfUserPage(tester);

          await tester.tap(find.byType(FloatingActionButton));
          await tester.pumpAndSettle();

          await screenMatchesGolden(
            tester,
            'change_type_of_user_page_failure_${failure.runtimeType}',
          );
        },
      );
    }
  });
}
