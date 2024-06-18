// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik_lehrer.dart';
import 'package:key_value_store/key_value_store.dart';

class HausaufgabenheftDependencies {
  /// Used to load open and completed homeworks
  final HomeworkDataSource<HomeworkReadModel> dataSource;

  final HomeworkDataSource<TeacherHomeworkReadModel> teacherHomeworkDataSource;

  /// Used change the completion status of a homework
  final HomeworkCompletionDispatcher completionDispatcher;

  // TODO: Can't this be handled by the homework logic internally?
  /// Used to complete all overdue homeworks at once by using the completion
  /// dispatcher.
  final Future<IList<HomeworkId>> Function() getOpenOverdueHomeworkIds;

  final KeyValueStore keyValueStore;

  final DateTime Function()? getCurrentDateTime;

  HausaufgabenheftDependencies({
    required this.dataSource,
    required this.teacherHomeworkDataSource,
    required this.completionDispatcher,
    required this.getOpenOverdueHomeworkIds,
    required this.keyValueStore,
    this.getCurrentDateTime,
  });
}
