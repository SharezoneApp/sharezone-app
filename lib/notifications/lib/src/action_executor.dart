// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import '../notifications.dart';
import 'action_request.dart';

class ActionExecutor {
  final Map<Type, Function> _executionMap;

  ActionExecutor._(this._executionMap);

  factory ActionExecutor(
      List<ActionRegistration<ActionRequest>> actionRegistrations) {
    final executorMap = <Type, Function>{};
    for (final actionRegistration in actionRegistrations) {
      executorMap[actionRegistration.actionRequestType] =
          actionRegistration.executeActionRequestCasted;
    }
    final executor = ActionExecutor._(executorMap);
    return executor;
  }

  /// Finds the corresponding [ActionRequestExecutorFunc] of the given
  /// [ActionRegistration] and calls it with the given [actionRequest].
  void executeAction(ActionRequest actionRequest) {
    final execute = _executionMap[actionRequest.runtimeType];
    execute?.call(actionRequest);
  }
}
