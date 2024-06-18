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

/// The [HomeworkPageCompletionDispatcher] is a homework page sepecific input for
/// [HomeworkCompletionEvent]s.
///
/// Delegates all incomming Events to the [HomeworkCompletionDispatcher].
///
/// The fundamental difference between both classes is that this class is
/// tailored to the HomeworkPage e.g. through the
/// [AllOverdueHomeworkCompletionEvent] while the [HomeworkCompletionDispatcher]
/// is not bound to the homework page.
class HomeworkPageCompletionDispatcher {
  final StudentHomeworkPageApi _api;

  HomeworkPageCompletionDispatcher(this._api);

  Future<void> changeCompletionStatus(
      HomeworkId homeworkId, CompletionStatus newCompletionValue) async {
    _api.completeHomework(homeworkId, newCompletionValue);
  }

  Future<void> completeAllOverdueHomeworks() async {
    final hws = await _api.getOpenOverdueHomeworkIds();
    for (final hw in hws) {
      _api.completeHomework(hw, CompletionStatus.completed);
    }
  }
}
