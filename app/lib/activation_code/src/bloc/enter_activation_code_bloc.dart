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

import 'package:flutter/material.dart';
import 'package:key_value_store/key_value_store.dart';
import 'package:rxdart/rxdart.dart';
import 'package:helper_functions/helper_functions.dart';
import 'package:sharezone/l10n/feature_flag_l10n.dart';

import '../models/enter_activation_code_result.dart';
import 'enter_activation_code_activator.dart';

class EnterActivationCodeBloc extends BlocBase {
  final CrashAnalytics crashAnalytics;
  final Analytics analytics;
  final SharezoneAppFunctions appFunctions;
  final _enterActivationCodeSubject =
      BehaviorSubject<EnterActivationCodeResult>();
  final KeyValueStore keyValueStore;
  final FeatureFlagl10n featureFlagl10n;

  String? _lastEnteredValue;

  EnterActivationCodeBloc(
    this.analytics,
    this.crashAnalytics,
    this.appFunctions,
    this.keyValueStore,
    this.featureFlagl10n,
  ) {
    _changeEnterActivationCodeResult(NoDataEnterActivationCodeResult());
  }

  EnterActivationCodeActivator get enterActivationCodeFunction =>
      EnterActivationCodeActivator(appFunctions, crashAnalytics, analytics);

  Stream<EnterActivationCodeResult> get enterActivationCodeResult =>
      _enterActivationCodeSubject;

  Function(EnterActivationCodeResult) get _changeEnterActivationCodeResult =>
      _enterActivationCodeSubject.sink.add;

  Future<void> retry(BuildContext context) async {
    if (_lastEnteredValue != null) {
      return _enterValue(_lastEnteredValue!, context);
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

  Future<void> submit(BuildContext context) async {
    _enterValue(_lastEnteredValue!, context);
  }

  bool get isValidActivationCodeID {
    return _lastEnteredValue != null && _lastEnteredValue!.trim().isNotEmpty;
  }

  Future<void> _enterValue(String enteredValue, BuildContext context) async {
    if (isEmptyOrNull(enteredValue)) return;
    _lastEnteredValue = enteredValue;

    if (_lastEnteredValue?.trim().toLowerCase() == 'clearcache') {
      await _clearCache(context);
      return;
    }

    // Required for testing as long we run the A/B test.
    //
    // In case you are in A/B test group, you can't deactivate the ads by
    // entering 'ads' in the activation code field.
    if (_lastEnteredValue?.trim().toLowerCase() == 'ads') {
      _toggleAds();
      return;
    }

    if (_lastEnteredValue?.trim().toLowerCase() == 'l10n') {
      _togglel10nFeatureFlag();
      return;
    }

    _changeEnterActivationCodeResult(LoadingEnterActivationCodeResult());

    final enterActivationCodeResult = await _runAppFunction(enteredValue);
    _changeEnterActivationCodeResult(enterActivationCodeResult);
  }

  void _toggleAds() {
    final currentValue = keyValueStore.getBool('show-ads') ?? false;
    keyValueStore.setBool('show-ads', !currentValue);

    _changeEnterActivationCodeResult(
      SuccessfulEnterActivationCodeResult(
        'ads',
        'Ads wurden ${!currentValue ? 'aktiviert' : 'deaktiviert'}. Starte die App neu, um die Änderungen zu sehen.',
      ),
    );
  }

  void _togglel10nFeatureFlag() {
    final currentValue = featureFlagl10n.isl10nEnabled;
    featureFlagl10n.toggle();

    _changeEnterActivationCodeResult(
      SuccessfulEnterActivationCodeResult(
        'l10n',
        'l10n wurde ${!currentValue ? 'aktiviert' : 'deaktiviert'}. Starte die App neu, um die Änderungen zu sehen.',
      ),
    );
  }

  Future<void> _clearCache(BuildContext context) async {
    await Future.wait([
      keyValueStore.clear(),
    ]);

    _changeEnterActivationCodeResult(
      const SuccessfulEnterActivationCodeResult(
        'clear',
        'Cache geleert. Möglicherweise ist ein App-Neustart notwendig, um die Änderungen zu sehen.',
      ),
    );
  }

  Future<EnterActivationCodeResult> _runAppFunction(String value) {
    return enterActivationCodeFunction.activateCode(value);
  }

  @override
  void dispose() {
    _enterActivationCodeSubject.close();
  }
}
