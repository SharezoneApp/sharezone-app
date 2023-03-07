// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';
import 'package:optional/optional.dart';
import 'package:random_string/random_string.dart';
import 'package:sharezone/timetable/timetable_page/school_class_filter/school_class_filter_view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SchoolClassFilterView', () {
    SchoolClassView createSchoolClassView(
      String name, {
      bool isSelected = false,
    }) {
      return SchoolClassView(
        id: GroupId(randomAlpha(9)),
        name: name,
        isSelected: isSelected,
      );
    }

    final viewWithOneSelection = SchoolClassFilterView(schoolClassList: [
      createSchoolClassView('group1', isSelected: true),
      createSchoolClassView('group2'),
    ]);

    final viewWithNoSelection = SchoolClassFilterView(schoolClassList: [
      createSchoolClassView('group1'),
      createSchoolClassView('group2'),
    ]);

    test(
        'hasMoreThanOneSchoolClass is true, if the view contains more than one school class',
        () {
      final view = SchoolClassFilterView(schoolClassList: [
        createSchoolClassView('group1'),
        createSchoolClassView('group2'),
      ]);

      expect(view.hasMoreThanOneSchoolClass, true);
    });

    test(
        'hasMoreThanOneSchoolClass is false, if the view contains less than two school classes',
        () {
      final viewOneSchoolClass = SchoolClassFilterView(
          schoolClassList: [createSchoolClassView('group1')]);
      expect(viewOneSchoolClass.hasMoreThanOneSchoolClass, false,
          reason:
              'The view contains only one school class. This is not more than one.');

      final viewNoSchoolClasses = SchoolClassFilterView(schoolClassList: []);
      expect(viewNoSchoolClasses.hasMoreThanOneSchoolClass, false,
          reason:
              'The view contains no school classes. This is not more than one.');
    });

    test(
        'currentSchoolClassName returns the name of the current selected school class',
        () {
      final view = SchoolClassFilterView(schoolClassList: [
        createSchoolClassView('group1', isSelected: true),
        createSchoolClassView('group2'),
      ]);

      expect(view.currentSchoolClassName, 'group1');
    });

    test('currentSchoolClassName returns null if no school class is selected',
        () {
      expect(viewWithNoSelection.currentSchoolClassName, null);
    });

    test('hasSchoolClassSelected returns true, if one school class is selected',
        () {
      expect(viewWithOneSelection.hasSchoolClassSelected, true);
    });

    test('hasSchoolClassSelected returns false, if no school class is selected',
        () {
      expect(viewWithNoSelection.hasSchoolClassSelected, false);
    });

    test('shouldShowAllGroups returns true, if no school class is selected',
        () {
      expect(viewWithNoSelection.shouldShowAllGroups, true);
    });

    test('shouldShowAllGroups returns false, if a school class is selected',
        () {
      expect(viewWithOneSelection.shouldShowAllGroups, false);
    });

    test(
        'selectedSchoolClass returns empty Optional if no school class is selected',
        () {
      expect(viewWithNoSelection.selectedSchoolClass, Optional.empty());
    });

    test(
        'selectedSchoolClass returns the selected school class in an Optional if school class is selected',
        () {
      final selectedSchoolClassView =
          createSchoolClassView('group1', isSelected: true);

      final view = SchoolClassFilterView(schoolClassList: [
        selectedSchoolClassView,
        createSchoolClassView('group2'),
      ]);

      expect(view.selectedSchoolClass, Optional.of(selectedSchoolClassView));
    });

    test('throw argument error if more than one school class is selected', () {
      expect(
          () => SchoolClassFilterView(
                schoolClassList: [
                  createSchoolClassView('group1', isSelected: true),
                  createSchoolClassView('group2', isSelected: true),
                ],
              ),
          throwsA(const TypeMatcher<ArgumentError>()));
    });
  });
}
