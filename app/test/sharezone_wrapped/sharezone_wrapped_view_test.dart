// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/sharezone_wrapped/sharezone_wrapped_view.dart';

void main() {
  group(SharezoneWrappedView, () {
    test('should format totalAmountOfLessonHours correctly', () {
      final view = SharezoneWrappedView.fromValues(
        totalAmountOfLessonHours: 91234,
        amountOfLessonHoursTopThreeCourses: [],
        totalAmountOfHomeworks: 0,
        amountOfHomeworksTopThreeCourses: [],
        totalAmountOfExams: 0,
        amountOfExamsTopThreeCourses: [],
      );
      expect(view.totalAmountOfLessonHours, '91.234 Std.');
    });

    test('should format amountOfLessonHoursTopThreeCourses correctly', () {
      final view = SharezoneWrappedView.fromValues(
        totalAmountOfLessonHours: 0,
        amountOfLessonHoursTopThreeCourses: [
          ('Deutsch', 12345),
          ('Mathematik', 9876),
          ('Englisch', 8765),
        ],
        totalAmountOfHomeworks: 0,
        amountOfHomeworksTopThreeCourses: [],
        totalAmountOfExams: 0,
        amountOfExamsTopThreeCourses: [],
      );
      expect(view.amountOfLessonHoursTopThreeCourses, [
        '1. Deutsch: 12.345 Std.',
        '2. Mathematik: 9.876 Std.',
        '3. Englisch: 8.765 Std.',
      ]);
    });

    test('should format totalAmountOfHomeworks correctly', () {
      final view = SharezoneWrappedView.fromValues(
        totalAmountOfLessonHours: 0,
        amountOfLessonHoursTopThreeCourses: [],
        totalAmountOfHomeworks: 1002,
        amountOfHomeworksTopThreeCourses: [],
        totalAmountOfExams: 0,
        amountOfExamsTopThreeCourses: [],
      );
      expect(view.totalAmountOfHomeworks, '1.002');
    });

    test('should format amountOfHomeworksTopThreeCourses correctly', () {
      final view = SharezoneWrappedView.fromValues(
        totalAmountOfLessonHours: 0,
        amountOfLessonHoursTopThreeCourses: [],
        totalAmountOfHomeworks: 0,
        amountOfHomeworksTopThreeCourses: [
          ('Deutsch', 1234),
          ('Mathematik', 98),
          ('Englisch', 87),
        ],
        totalAmountOfExams: 0,
        amountOfExamsTopThreeCourses: [],
      );
      expect(view.amountOfHomeworksTopThreeCourses, [
        '1. Deutsch: 1.234',
        '2. Mathematik: 98',
        '3. Englisch: 87',
      ]);
    });

    test('should format totalAmountOfExams correctly', () {
      final view = SharezoneWrappedView.fromValues(
        totalAmountOfLessonHours: 0,
        amountOfLessonHoursTopThreeCourses: [],
        totalAmountOfHomeworks: 0,
        amountOfHomeworksTopThreeCourses: [],
        totalAmountOfExams: 1001,
        amountOfExamsTopThreeCourses: [],
      );
      expect(view.totalAmountOfExams, '1.001');
    });

    test('should format amountOfExamsTopThreeCourses correctly', () {
      final view = SharezoneWrappedView.fromValues(
        totalAmountOfLessonHours: 0,
        amountOfLessonHoursTopThreeCourses: [],
        totalAmountOfHomeworks: 0,
        amountOfHomeworksTopThreeCourses: [],
        totalAmountOfExams: 0,
        amountOfExamsTopThreeCourses: [
          ('Deutsch', 1234),
          ('Mathematik', 98),
          ('Englisch', 87),
        ],
      );
      expect(view.amountOfExamsTopThreeCourses, [
        '1. Deutsch: 1.234',
        '2. Mathematik: 98',
        '3. Englisch: 87',
      ]);
    });
  });
}
