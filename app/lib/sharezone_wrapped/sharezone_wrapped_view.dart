// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:collection/collection.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:intl/intl.dart';

class SharezoneWrappedView {
  /// The total amount of lesson hours formatted as [String].
  ///
  /// Example: `91.234 Std.`
  final String totalAmountOfLessonHours;

  /// The amount of lesson hours for the top three courses formatted as
  /// [List<String>].
  ///
  /// Example:
  /// ```
  /// [
  ///   '1. Deutsch: 12.345 Std.',
  ///   '2. Mathematik: 9.876 Std.',
  ///   '3. Englisch: 8.765 Std.',
  /// ]
  /// ```
  final List<String> amountOfLessonHoursTopThreeCourses;

  /// The total amount of homeworks formatted as [String].
  ///
  /// Example: `1.002`
  final String totalAmountOfHomeworks;

  /// The amount of homeworks for the top three courses formatted as
  /// [List<String>].
  ///
  /// Example:
  /// ```
  /// [
  ///   '1. Deutsch: 123',
  ///   '2. Mathematik: 98',
  ///   '3. Englisch: 87',
  /// ]
  /// ```
  final List<String> amountOfHomeworksTopThreeCourses;

  /// The total amount of exams formatted as [String].
  ///
  /// Example: `1,001`
  final String totalAmountOfExams;

  /// The amount of exams for the top three courses formatted as
  /// [List<String>].
  ///
  /// Example:
  /// ```
  /// [
  ///   '1. Deutsch: 123',
  ///   '2. Mathematik: 98',
  ///   '3. Englisch: 87',
  /// ]
  /// ```
  final List<String> amountOfExamsTopThreeCourses;

  SharezoneWrappedView({
    required this.totalAmountOfLessonHours,
    required this.amountOfLessonHoursTopThreeCourses,
    required this.totalAmountOfHomeworks,
    required this.amountOfHomeworksTopThreeCourses,
    required this.amountOfExamsTopThreeCourses,
    required this.totalAmountOfExams,
  });

  factory SharezoneWrappedView.fromValues({
    required int totalAmountOfLessonHours,
    required List<(CourseName, int)> amountOfLessonHoursTopThreeCourses,
    required int totalAmountOfHomeworks,
    required List<(CourseName, int)> amountOfHomeworksTopThreeCourses,
    required int totalAmountOfExams,
    required List<(CourseName, int)> amountOfExamsTopThreeCourses,
  }) {
    final formatter = NumberFormat.decimalPattern('de_DE');
    return SharezoneWrappedView(
      totalAmountOfLessonHours:
          '${formatter.format(totalAmountOfLessonHours)} Std.',
      amountOfLessonHoursTopThreeCourses: amountOfLessonHoursTopThreeCourses
          .mapIndexed((index, value) =>
              '${index + 1}. ${value.$1}: ${formatter.format(value.$2)} Std.')
          .toList(),
      totalAmountOfHomeworks: formatter.format(totalAmountOfHomeworks),
      amountOfHomeworksTopThreeCourses: amountOfHomeworksTopThreeCourses
          .mapIndexed((index, value) =>
              '${index + 1}. ${value.$1}: ${formatter.format(value.$2)}')
          .toList(),
      totalAmountOfExams: formatter.format(totalAmountOfExams),
      amountOfExamsTopThreeCourses: amountOfExamsTopThreeCourses
          .mapIndexed((index, value) =>
              '${index + 1}. ${value.$1}: ${formatter.format(value.$2)}')
          .toList(),
    );
  }
}
