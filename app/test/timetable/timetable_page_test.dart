// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/timetable/src/bloc/timetable_bloc.dart';
import 'package:sharezone/timetable/timetable_page/school_class_filter/school_class_filter.dart';
import 'package:sharezone/util/api/timetable_gateway.dart';

import 'mock/mock_course_gateway.dart';
import 'mock/mock_school_class_filter_analytics.dart';
import 'mock/mock_school_class_gateway.dart';
import 'mock/mock_timetable_gateway.dart';
import 'mock/mock_user_gateway.dart';

void main() {
  group('TimetablePage', () {
    group('SchoolClassFilter', () {
      SchoolClass _createSchoolClass(String id) {
        final data = {
          'name': id,
          'myRole': 'standard',
          'publicKey': '123456',
          'joinLink': 'https://sharez.one/RpvEuUZMLEjb522N8',
          'personalSharecode': '654321',
          'personalJoinLink': 'https://sharez.one/RpvEuUZMLEjb522N7',
          'settings': null
        };

        return SchoolClass.fromData(data, id: id);
      }

      final klasse10a = _createSchoolClass('10a');
      final klasse5b = _createSchoolClass('5b');

      late TimetableBloc bloc;
      MockSchoolClassGateway schoolClassGateway;
      TimetableGateway timetableGateway;
      MockSchoolClassFilterAnalytics schoolClassFilterAnalytics;

      setUp(() {
        schoolClassGateway = MockSchoolClassGateway();
        timetableGateway = MockTimetableGateway();
        schoolClassFilterAnalytics = MockSchoolClassFilterAnalytics();

        bloc = TimetableBloc(
          schoolClassGateway,
          MockUserGateway(),
          timetableGateway,
          MockCourseGateway(),
          schoolClassFilterAnalytics,
        );

        schoolClassGateway.addSchoolClass(klasse10a);
        schoolClassGateway.addSchoolClass(klasse5b);
      });

      Future<void> _pumpSchoolClassSelection(WidgetTester tester) async {
        await tester.pumpWidget(
          FeatureDiscovery(
            child: MaterialApp(
              home: BlocProvider(
                bloc: bloc,
                child: SingleChildScrollView(
                  child: SchoolClassFilterBottomBar(),
                ),
              ),
            ),
          ),
        );
      }

      testWidgets(
          'If the user is member of one or zero school classes, the school class selection widget should not be shown',
          (tester) async {
        // Im Setup wird direkt zwei Schulklassen beigetreten. Deswegen muss
        // wieder eine Schulklasse verlassen werden, damit der Test
        // funktioniert.
        await bloc.schoolClassGateway.leaveSchoolClass(klasse5b.id);

        await _pumpSchoolClassSelection(tester);

        expect(find.byKey(const ValueKey('school-class-filter-widget-test')),
            findsNothing);
      });

      testWidgets(
          'If the user is member of two or more school classes, the school class selection widget should be shown',
          (tester) async {
        await _pumpSchoolClassSelection(tester);

        expect(find.byKey(const ValueKey('school-class-filter-widget-test')),
            findsOneWidget);
      });

      testWidgets(
          'If the user has not selected a school class, the word "Alle" should be used as the current school class',
          (tester) async {
        await _pumpSchoolClassSelection(tester);

        expect(find.text('Schulklasse: Alle'), findsOneWidget);
      });

      testWidgets(
          'If the user selects a school class, this school class should be passed to the bloc',
          (tester) async {
        await _pumpSchoolClassSelection(tester);

        // Öffne Schulklassen-Auswahl-Menü
        await tester.tap(find.byIcon(Icons.group));
        await tester.pumpAndSettle();

        // Klasse 10a auswählen
        await tester.tap(find.text(klasse10a.name));
        await tester.pumpAndSettle();

        expect(bloc.schoolClassFilterView.valueOrNull!.selectedSchoolClass!.id,
            klasse10a.groupId);
      });

      testWidgets(
          'If a user opens school class menu, all school classes should be shown',
          (tester) async {
        await _pumpSchoolClassSelection(tester);
        expect(find.text('Alle Schulklassen'), findsNothing);
        expect(find.text(klasse5b.name), findsNothing);
        expect(find.text(klasse10a.name), findsNothing);

        // Öffne Schulklassen-Auswahl-Menü
        await tester.tap(find.byIcon(Icons.group));
        await tester.pump();

        expect(find.text('Alle Schulklassen'), findsOneWidget);
        expect(find.text(klasse5b.name), findsOneWidget);
        expect(find.text(klasse10a.name), findsOneWidget);
      });
    });
  });
}
