// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'models/homework.dart';
import 'models/subject.dart';

extension HomeworkListExtension on IList<BaseHomeworkReadModel> {
  IList<Subject> getDistinctOrderedSubjects() {
    final subjects = <Subject>{};
    for (final homework in this) {
      subjects.add(homework.subject);
    }
    return subjects.toIList();
  }
}
