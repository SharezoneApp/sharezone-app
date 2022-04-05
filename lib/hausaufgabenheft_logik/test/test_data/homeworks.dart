// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:hausaufgabenheft_logik/src/models/homework/models_used_by_homework.dart';

import '../create_homework_util.dart';

const english = 'English';
const maths = 'Maths';
const informatics = 'Informatics';
const title = 'Aufgaben S.23';
final d28_01_2019 = Date(day: 28, month: 01, year: 2019);

final haDate_02_01_19 = createHomework(
  todoDate: Date(day: 2, month: 01, year: 2019),
);
final haDate_23_02_19 = createHomework(
  todoDate: Date(day: 23, month: 2, year: 2019),
);
final haDate_30_2_2020 = createHomework(
  todoDate: Date(day: 30, month: 2, year: 2020),
);

final haSubjectEnglish = createHomework(subject: english);
final haSubjectInformatics = createHomework(subject: informatics);
final haSubjectMaths = createHomework(subject: maths);

final haTitleAufgaben = createHomework(title: 'Aufgaben 1-3');
final haTitleBlatt = createHomework(title: 'Blatt zur Erderwärmung');
final haTitleClown = createHomework(title: 'Clown');

final haIntegration1 = createHomework(
  todoDate: Date(day: 1, month: 1, year: 2019),
  subject: english,
  title: 'AB',
);
final haIntegration2 = createHomework(
  todoDate: Date(day: 1, month: 1, year: 2019),
  subject: english,
  title: 'CD hören',
);
final haIntegration3 = createHomework(
  todoDate: Date(day: 1, month: 1, year: 2019),
  subject: informatics,
  title: 'Buch S. 33',
);
final haIntegration4 = createHomework(
  todoDate: Date(day: 1, month: 1, year: 2019),
  subject: informatics,
  title: 'Vortrag',
);
final haIntegration5 = createHomework(
  todoDate: Date(day: 1, month: 1, year: 2019),
  subject: maths,
  title: 'Buch S.34',
);
final haIntegration6 = createHomework(
  todoDate: Date(day: 6, month: 10, year: 2020),
  subject: informatics,
  title: 'Buch S. 35',
);
final haIntegration7 = createHomework(
  todoDate: Date(day: 6, month: 10, year: 2020),
  subject: maths,
  title: 'Buch S.37',
);

final unsortedHomework = [
  haIntegration7,
  haIntegration1,
  haIntegration6,
  haIntegration2,
  haIntegration3,
  haIntegration5,
  haIntegration4,
];

final sortedHomeworksForSortByDateSubjectTitle = [
  haIntegration1,
  haIntegration2,
  haIntegration3,
  haIntegration4,
  haIntegration5,
  haIntegration6,
  haIntegration7
];
final sortedHomeworksForSortBySubjectDateTitle = [
  haIntegration1,
  haIntegration2,
  haIntegration3,
  haIntegration4,
  haIntegration6,
  haIntegration5,
  haIntegration7,
];
