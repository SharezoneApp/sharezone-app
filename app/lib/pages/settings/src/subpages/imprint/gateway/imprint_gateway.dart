// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharezone/pages/settings/src/subpages/imprint/models/imprint.dart';

class ImprintGateway {
  final FirebaseFirestore _firestore;

  ImprintGateway(this._firestore);

  Stream<Imprint> get imprintStream => _firestore
      .collection('Legal')
      .doc('imprint')
      .snapshots()
      .map((doc) => Imprint.fromDocumentSnapshot(doc));
}
