// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/grades_page/grades_page.dart';
import 'package:sharezone/grades/pages/grades_page/grades_page_controller.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';

void main() {
  group('Grades Page', () {
    testWidgets('Creating a simple term works', (tester) async {
      await pumpGradesPage(tester);
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      await tester.tap(find.byKey(const ValueKey('add-term-tile')));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(const ValueKey('term-name-field')), 'Halbjahr 01/2022');
      await tester.tap(find.byKey(const ValueKey('save-button')));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(find.text('Halbjahr 01/2022'), findsOneWidget);
    });
  });
}

Future<void> pumpGradesPage(WidgetTester tester) async {
  final gradesService = GradesService();

  await tester.pumpWidget(BlocProvider(
    bloc: NavigationBloc(),
    child: MultiProvider(
      providers: [
        Provider<GradesService>(
          create: (context) => gradesService,
        ),
        ChangeNotifierProvider<GradesPageController>(
          create: (BuildContext context) =>
              GradesPageController(gradesService: gradesService),
        ),
      ],
      child: const MaterialApp(home: Scaffold(body: GradesPageBody())),
    ),
  ));
}
