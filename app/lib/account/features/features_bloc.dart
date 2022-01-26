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
import 'package:sharezone/account/features/objects/hide_donations.dart';

class FeatureBloc extends BlocBase {
  final _isAllColorsUnlockedSubject = BehaviorSubject<bool>();
  Stream<bool> get isAllColorsUnlocked => _isAllColorsUnlockedSubject;

  final _hideDonationsSubject = BehaviorSubject<bool>();
  Stream<bool> get hideDonations => _hideDonationsSubject;

  StreamSubscription _unlockedFeaturesSubscription;

  FeatureBloc(FeatureGateway featureGateway) {
    _loadIsDarkModeUnlocked(featureGateway);
  }

  void _loadIsDarkModeUnlocked(FeatureGateway featureGateway) {
    _unlockedFeaturesSubscription =
        featureGateway.unlockedFeatures.listen((featureSet) {
      final isAllColorsUnlocked = featureSet.contains(AllColors());
      final hideDonations = featureSet.contains(HideDonations());

      _isAllColorsUnlockedSubject.sink.add(isAllColorsUnlocked);
      _hideDonationsSubject.sink.add(hideDonations);
    });
  }

  @override
  void dispose() {
    _hideDonationsSubject.close();
    _isAllColorsUnlockedSubject.close();
    _unlockedFeaturesSubscription.cancel();
  }
}
