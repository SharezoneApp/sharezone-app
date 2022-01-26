// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:app_functions/sharezone_app_functions.dart';
import 'package:bloc_base/bloc_base.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone_common/helper_functions.dart';
import '../models/enter_activation_code_result.dart';
import 'enter_activation_code_activator.dart';

class EnterActivationCodeBloc extends BlocBase {
  final CrashAnalytics crashAnalytics;
  final Analytics analytics;
  final SharezoneAppFunctions appFunctions;
  final _enterActivationCodeSubject =
      BehaviorSubject<EnterActivationCodeResult>();

  String _lastEnteredValue;

  EnterActivationCodeBloc(
    this.analytics,
    this.crashAnalytics,
    this.appFunctions,
  ) {
    _changeEnterActivationCodeResult(NoDataEnterActivationCodeResult());
  }

  EnterActivationCodeActivator get enterActivationCodeFunction =>
      EnterActivationCodeActivator(appFunctions, crashAnalytics, analytics);

  Stream<EnterActivationCodeResult> get enterActivationCodeResult =>
      _enterActivationCodeSubject;

  Function(EnterActivationCodeResult) get _changeEnterActivationCodeResult =>
      _enterActivationCodeSubject.sink.add;

  Future<void> retry() async {
    if (_lastEnteredValue != null) {
      return _enterValue(_lastEnteredValue);
    }
  }

  Future<void> clear() async {
    _lastEnteredValue = null;
    _changeEnterActivationCodeResult(NoDataEnterActivationCodeResult());
  }

  // ignore:use_setters_to_change_properties
  void updateFieldText(String currentText) {
    _lastEnteredValue = currentText;
  }

  Future<void> submit() async {
    _enterValue(_lastEnteredValue);
  }

  bool get isValidActivationCodeID {
    return _lastEnteredValue != null && _lastEnteredValue.trim().isNotEmpty;
  }

  Future<void> _enterValue(String enteredValue) async {
    if (isEmptyOrNull(enteredValue)) return;
    _lastEnteredValue = enteredValue;
    _changeEnterActivationCodeResult(LoadingEnterActivationCodeResult());

    final enterActivationCodeResult = await _runAppFunction(enteredValue);
    _changeEnterActivationCodeResult(enterActivationCodeResult);
  }

  Future<EnterActivationCodeResult> _runAppFunction(String value) {
    return enterActivationCodeFunction.activateCode(value);
  }

  @override
  void dispose() {
    _enterActivationCodeSubject.close();
  }
}
