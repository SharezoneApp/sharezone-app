// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:hausaufgabenheft_logik/src/models/homework.dart';

import 'student_sort_with_operations.dart';

ComparisonResult dateSort(
        StudentHomeworkReadModel ha1, StudentHomeworkReadModel ha2) =>
    ComparisonResult(ha1.todoDate.compareTo(ha2.todoDate));

ComparisonResult subjectSort(
        StudentHomeworkReadModel ha1, StudentHomeworkReadModel ha2) =>
    ComparisonResult(ha1.subject.name.compareTo(ha2.subject.name));

ComparisonResult titleSort(
        StudentHomeworkReadModel ha1, StudentHomeworkReadModel ha2) =>
    ComparisonResult(ha1.title.compareTo(ha2.title));
