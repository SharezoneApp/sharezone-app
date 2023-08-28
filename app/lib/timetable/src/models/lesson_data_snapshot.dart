// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:group_domain_models/group_domain_models.dart';

import 'lesson.dart';

class LessonDataSnapshot {
  final List<Lesson> lessons;
  final Map<String, GroupInfo> groupInfos;

  const LessonDataSnapshot({
    required this.lessons,
    required this.groupInfos,
  });
}
