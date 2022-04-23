// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:hausaufgabenheft_logik/src/models/homework/homework.dart';
import 'package:hausaufgabenheft_logik/src/models/date.dart';
import 'package:hausaufgabenheft_logik/src/models/homework/models_used_by_homework.dart';
import 'package:hausaufgabenheft_logik/src/models/homework_list.dart';
import 'package:hausaufgabenheft_logik/src/open_homeworks/sort_and_subcategorization/sort/smallest_date_subject_and_title_sort.dart';
import 'package:hausaufgabenheft_logik/src/open_homeworks/sort_and_subcategorization/sort/subject_smallest_date_and_title_sort.dart';
import 'package:test/test.dart';

import 'create_homework_util.dart';
import 'test_data/homeworks.dart';

void main() {
  group('HomeworkList', () {
    group('sort with SubjectSmallestDateAndTitleSort', () {
      testSubjectSort('firstly sorts by Subject',
          (homeworks) => homeworks.sortWith(SubjectSmallestDateAndTitleSort()));

      testDateSort(
          'then by date, only if the subject of two homeworks are the same',
          (homeworks) => homeworks.sortWith(SubjectSmallestDateAndTitleSort()));

      testTitleSort(
          'lastly sorts by title, only if subject and date are the same',
          (homeworks) => homeworks.sortWith(SubjectSmallestDateAndTitleSort()));

      testSort(
        'integration test',
        unsorted: HomeworkList(unsortedHomework),
        sorted: sortedHomeworksForSortBySubjectDateTitle,
        sort: (homeworks) =>
            homeworks.sortWith(SubjectSmallestDateAndTitleSort()),
      );
    });
    group('sort with SmallestDateSubjectAndTitleSort', () {
      testDateSort('firstly sorts by Date',
          (homeworks) => homeworks.sortWith(SmallestDateSubjectAndTitleSort()));

      testSubjectSort(
          'then by Subject, only if the date of two homeworks are the same',
          (homeworks) => homeworks.sortWith(SmallestDateSubjectAndTitleSort()));

      testTitleSort(
          'lastly by title, only if the date and subject are the same',
          (homeworks) => homeworks.sortWith(SmallestDateSubjectAndTitleSort()));

      testSort(
        'integration test',
        unsorted: HomeworkList(unsortedHomework),
        sorted: sortedHomeworksForSortByDateSubjectTitle,
        sort: (homeworks) =>
            homeworks.sortWith(SmallestDateSubjectAndTitleSort()),
      );

      final sorted = List<HomeworkReadModel>.generate(
        15,
        (i) => createHomework(
            todoDate: Date(year: 2019, month: 02, day: 03),
            subject: 'Subject',
            title: '$i'),
      );
      final unsorted = List<HomeworkReadModel>.from(sorted)..shuffle();
      testSort('does sort titles starting with numbers by their value',
          unsorted: HomeworkList(unsorted),
          sorted: sorted,
          sort: (hw) => hw.sortWith(SmallestDateSubjectAndTitleSort()),
          skip: true);
    });
  });
  test('getDistinctSubjects', () {
    var mathe = Subject('Mathe');
    var englisch = Subject('Englisch');
    var deutsch = Subject('Deutsch');
    final subjects = [mathe, englisch, mathe, mathe, deutsch];
    final homeworks = [
      for (final subject in subjects) createHomework(subject: subject.name)
    ];
    final homeworkList = HomeworkList(homeworks);

    final result = homeworkList.getDistinctOrderedSubjects();

    expect(result, [mathe, englisch, deutsch]);
  });
}

void testDateSort(String title, ListCallback sort) => testSort(
      title,
      unsorted:
          HomeworkList([haDate_23_02_19, haDate_02_01_19, haDate_30_2_2020]),
      sorted: [haDate_02_01_19, haDate_23_02_19, haDate_30_2_2020],
      sort: sort,
    );

void testSort(String title,
    {HomeworkList unsorted,
    List<HomeworkReadModel> sorted,
    ListCallback sort,
    bool skip = false}) {
  test(title, () {
    sort(unsorted);
    expect(unsorted, sorted);
  }, skip: skip);
}

void testSubjectSort(String title, ListCallback sort) => testSort(
      title,
      unsorted: HomeworkList(
          [haSubjectInformatics, haSubjectEnglish, haSubjectMaths]),
      sorted: [haSubjectEnglish, haSubjectInformatics, haSubjectMaths],
      sort: sort,
    );

void testTitleSort(String title, ListCallback sort) => testSort(
      title,
      unsorted: HomeworkList([haTitleBlatt, haTitleAufgaben, haTitleClown]),
      sorted: [haTitleAufgaben, haTitleBlatt, haTitleClown],
      sort: sort,
    );

typedef ListCallback = void Function(HomeworkList);
