// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/subjects.dart';
import 'package:sharezone/account/features/objects/all_colors.dart';
import 'package:sharezone/account/features/objects/feature.dart';
import 'package:user/user.dart';

class FeatureGateway {
  final _unlockedFeaturesSubject = BehaviorSubject<Set<Feature>>();
  Stream<Set<Feature>> get unlockedFeatures => _unlockedFeaturesSubject;

  FeatureGateway(
      CollectionReference<Map<String, dynamic>> userCollection, String uid) {
    loadFeatures(userCollection, uid);
  }

  void loadFeatures(
      CollectionReference<Map<String, dynamic>> users, String uid) {
    final docStream = users.doc(uid).snapshots();
    docStream.listen((doc) {
      final featureSet = <Feature>{};

      final features =
          Features.fromJson(doc?.get('features') as Map<String, dynamic>);
      if (features != null) {
        if (features.allColors) featureSet.add(AllColors());
      }

      _unlockedFeaturesSubject.sink.add(featureSet);
    });
  }

  void dispose() {
    _unlockedFeaturesSubject.close();
  }
}
