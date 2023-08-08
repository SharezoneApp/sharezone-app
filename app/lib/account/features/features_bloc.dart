// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:bloc_base/bloc_base.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/account/features/feature_gateway.dart';
import 'package:sharezone/account/features/objects/all_colors.dart';

class FeatureBloc extends BlocBase {
  final _isAllColorsUnlockedSubject = BehaviorSubject<bool>();
  Stream<bool> get isAllColorsUnlocked => _isAllColorsUnlockedSubject;

  StreamSubscription _unlockedFeaturesSubscription;

  FeatureBloc(FeatureGateway featureGateway) {
    _loadIsDarkModeUnlocked(featureGateway);
  }

  void _loadIsDarkModeUnlocked(FeatureGateway featureGateway) {
    _unlockedFeaturesSubscription =
        featureGateway.unlockedFeatures.listen((featureSet) {
      final isAllColorsUnlocked = featureSet.contains(AllColors());

      _isAllColorsUnlockedSubject.sink.add(isAllColorsUnlocked);
    });
  }

  @override
  void dispose() {
    _isAllColorsUnlockedSubject.close();
    _unlockedFeaturesSubscription.cancel();
  }
}
