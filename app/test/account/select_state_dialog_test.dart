// Copyright (c) 2026 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sharezone/account/select_state_dialog.dart';
import 'package:sharezone/holidays/holiday_bloc.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:user/user.dart';

import 'select_state_dialog_test.mocks.dart';

@GenerateNiceMocks([MockSpec<HolidayBloc>()])
void main() {
  group('selectStateDialog', () {
    late MockHolidayBloc bloc;

    setUp(() {
      bloc = MockHolidayBloc();
    });

    testWidgets("shows states for selected country only", (tester) async {
      await tester.pumpScene(bloc);

      await tester.tap(find.text("Button"));
      await tester.pump();

      await tester.tap(find.byKey(const ValueKey(HolidayCountry.austria)));
      await tester.pump();

      // Salzburg is part of Austria
      expect(find.byKey(const ValueKey(StateEnum.salzburg)), findsOneWidget);
      // Nordrhein Westphalia is not part of Austria
      expect(
        find.byKey(const ValueKey(StateEnum.nordrheinWestfalen)),
        findsNothing,
      );
    });

    testWidgets("passes selected state to business logic", (tester) async {
      await tester.pumpScene(bloc);

      await tester.tap(find.text("Button"));
      await tester.pump();

      await tester.tap(find.byKey(const ValueKey(HolidayCountry.germany)));
      await tester.pump();

      const state = StateEnum.nordrheinWestfalen;
      await tester.ensureVisible(find.byKey(const ValueKey(state)));
      await tester.tap(find.byKey(const ValueKey(state)));
      await tester.pump();

      verify(bloc.changeState(state)).called(1);
    });

    testWidgets("shows a confirmation snackbar after selecting a state", (
      tester,
    ) async {
      await tester.pumpScene(bloc);

      await tester.tap(find.text("Button"));
      await tester.pump();

      await tester.tap(find.byKey(const ValueKey(HolidayCountry.germany)));
      await tester.pump();

      const state = StateEnum.nordrheinWestfalen;
      await tester.ensureVisible(find.byKey(const ValueKey(state)));
      await tester.tap(find.byKey(const ValueKey(state)));
      await tester.pump(const Duration(milliseconds: 200));

      final context = tester.element(find.byType(FilledButton));
      final expectedSnackBarText = context.l10n
          .selectStateDialogConfirmationSnackBar(state.getDisplayName(context));
      expect(find.text(expectedSnackBarText), findsOneWidget);
    });

    testWidgets("passes 'stay anonymous' to business logic when selected", (
      tester,
    ) async {
      await tester.pumpScene(bloc);

      await tester.tap(find.text("Button"));
      await tester.pump();

      const state = StateEnum.anonymous;
      await tester.ensureVisible(find.byKey(const ValueKey(state)));
      await tester.tap(find.byKey(const ValueKey(state)));
      await tester.pump();

      verify(bloc.changeState(state)).called(1);
    });

    testWidgets("goes back to country selection when pressing back", (
      tester,
    ) async {
      await tester.pumpScene(bloc);

      await tester.tap(find.text("Button"));
      await tester.pump();

      await tester.tap(find.byKey(const ValueKey(HolidayCountry.switzerland)));
      await tester.pump();

      await tester.tap(find.byKey(const Key('back-button')));
      await tester.pump();

      expect(
        find.byKey(const ValueKey(HolidayCountry.germany)),
        findsOneWidget,
      );
    });

    testWidgets("does not change something when pressing cancel", (
      tester,
    ) async {
      await tester.pumpScene(bloc);

      await tester.tap(find.text("Button"));
      await tester.pump();

      await tester.tap(find.byKey(const ValueKey(HolidayCountry.switzerland)));
      await tester.pump();

      await tester.tap(find.byKey(const Key('cancel-button')));
      verifyZeroInteractions(bloc);
    });
  });
}

extension on WidgetTester {
  Future<void> pumpScene(HolidayBloc bloc) async {
    await pumpWidget(
      BlocProvider<HolidayBloc>(
        bloc: bloc,
        child: MaterialApp(
          localizationsDelegates: SharezoneLocalizations.localizationsDelegates,
          supportedLocales: SharezoneLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return FilledButton(
                  onPressed: () => showStateSelectionDialog(context),
                  child: const Text("Button"),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
