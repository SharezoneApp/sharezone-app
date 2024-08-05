// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:hausaufgabenheft_logik/src/shared/models/homework.dart';

import 'sort_with_operations.dart';

ComparisonResult dateSort<T extends BaseHomeworkReadModel>(T ha1, T ha2) =>
    ComparisonResult(ha1.todoDate.compareTo(ha2.todoDate));

ComparisonResult subjectSort<T extends BaseHomeworkReadModel>(T ha1, T ha2) =>
    ComparisonResult(ha1.subject.name.compareTo(ha2.subject.name));

ComparisonResult titleSort<T extends BaseHomeworkReadModel>(T ha1, T ha2) =>
    ComparisonResult(ha1.title.compareTo(ha2.title));
