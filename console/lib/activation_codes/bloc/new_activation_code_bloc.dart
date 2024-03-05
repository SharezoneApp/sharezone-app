// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:sharezone_console/bloc/bloc_base.dart';

class NewActivationCodeBloc extends BlocBase {
  static const allPossibleActions = [
    'No',
    'Unlock_Darkmode',
    'Unlock_AllColors',
    'Unlock_Referral_Features'
  ];

  final _codeSubject = BehaviorSubject<String>.seeded("");
  final _codeNameSubject = BehaviorSubject<String>.seeded("");
  final _codeDescriptionSubject = BehaviorSubject<String>.seeded("");
  final _totalAmountSubject = BehaviorSubject<int>.seeded(0);
  final _endTimeSubject = BehaviorSubject<DateTime>();
  final _actionsSubject = BehaviorSubject<List<String>>();
  NewActivationCodeBloc();

  Function(String) get changeCode => _codeSubject.add;
  Function(String) get changeCodeName => _codeNameSubject.add;
  Function(String) get changeCodeDescription => _codeDescriptionSubject.add;
  Function(int) get changeTotalAmount => _totalAmountSubject.add;
  Function(DateTime) get changeDateTime => _endTimeSubject.add;
  Function(List<String>) get changeActions => _actionsSubject.add;

  Stream<String> get code => _codeSubject;
  Stream<String> get codeName => _codeNameSubject;
  Stream<String> get codeDescription => _codeDescriptionSubject;
  Stream<int> get totalAmount => _totalAmountSubject;
  Stream<DateTime> get endTime => _endTimeSubject;
  Stream<List<String>> get actions => _actionsSubject;

  Future<HttpsCallableResult> submit(BuildContext context) async {
    final activationCodeValue = _codeSubject.value;
    final endTimeValue =
        _endTimeSubject.value.toIso8601String().substring(0, 10);
    final actionsValue = _actionsSubject.value;
    final codeNameValue = _codeNameSubject.value;
    final codeDescriptionValue = _codeDescriptionSubject.value;
    final totalAmountValue = _totalAmountSubject.value;
    final cfs = FirebaseFunctions.instanceFor(region: 'europe-west1');
    final function = cfs.httpsCallable('GenerateActivationCode');
    final parameters = {
      'activationCode': activationCodeValue,
      'endDate': endTimeValue,
      'actions': actionsValue,
      'codeName': codeNameValue,
      'codeDescription': codeDescriptionValue,
      'totalAmount': totalAmountValue,
    };
    print("parameters");
    print(parameters);
    final result = await function.call(parameters);
    return result;
  }

  @override
  void dispose() {
    _codeSubject.close();
    _endTimeSubject.close();
    _actionsSubject.close();
    _codeNameSubject.close();
    _codeDescriptionSubject.close();
    _totalAmountSubject.close();
  }
}
