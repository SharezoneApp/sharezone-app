// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:math';

import 'package:common_domain_models/common_domain_models.dart';
import 'package:hausaufgabenheft_logik/src/models/homework/homework.dart';
import 'package:hausaufgabenheft_logik/src/models/date.dart';
import 'package:hausaufgabenheft_logik/src/models/homework/models_used_by_homework.dart';
import 'package:hausaufgabenheft_logik/src/views/color.dart';

HomeworkReadModel createHomework(
    {Date todoDate = const Date(day: 1, month: 1, year: 2019),
    String subject = 'Subject',
    String title = 'Title',
    String id = 'willBeRandom',
    bool done = false,
    bool withSubmissions = false,
    Color subjectColor}) {
  id = id == 'willBeRandom' ? randomString(5) : id;
  return HomeworkReadModel(
    id: HomeworkId(id),
    todoDate: todoDate.asDateTime(),
    subject: Subject(subject, color: subjectColor),
    title: Title(title),
    withSubmissions: withSubmissions,
    status: done ? CompletionStatus.completed : CompletionStatus.open,
  );
}

String randomString(int length) {
  var rand = Random();
  var codeUnits = List.generate(length, (index) {
    return rand.nextInt(33) + 89;
  });

  return String.fromCharCodes(codeUnits);
}
