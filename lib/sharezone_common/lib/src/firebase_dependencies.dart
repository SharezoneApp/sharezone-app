// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseDependencies {
  const FirebaseDependencies._({
    this.auth,
    this.firestore,
  });
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  factory FirebaseDependencies.get() {
    return FirebaseDependencies._(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
    );
  }
}
