// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:flutter/material.dart';
import 'package:sharezone_common/references.dart';

class FirestoreLastOnlineReporterBackend {
  final FirebaseFirestore _firestore;
  final String _userId;

  FirestoreLastOnlineReporterBackend(this._firestore, UserId userId)
      : _userId = userId.toString();

  /// Reports to our backend that the user has been online at this point of time.
  /// Uses the server timestamp for the current time.
  /// Throws if an error while reporting happens.
  Future<void> reportCurrentlyOnline() {
    // Do not use .set({merge: true}) here, because the Firestore library sets
    // 'lastOnline' instantly to null (might be web-only behaviour) which causes
    // that the user document only contains the 'lastOnline' attribute and
    // nothing else (missing typeOfUser, etc.).
    //
    // Additionally, .update() is here more best practice, set({merge: true})
    // would be executed even when the user document does not exist (like when
    // deleting the user of something). This can result into hard bug (hard bugs
    // means bugs that are hard to debug, hard to find, hard to locate, etc.)
    // and side effects, especially because there is no error. The .update()
    // method would throw an error if the user document does not exist.
    return _firestore.collection(CollectionNames.user).doc(_userId).update({
      'lastOnline': FieldValue.serverTimestamp(),
    });
  }
}

class AppLifecycleStateObserver with WidgetsBindingObserver {
  final _controller = StreamController<AppLifecycleState>();

  Stream<AppLifecycleState> get lifecycleChanges => _controller.stream;

  AppLifecycleStateObserver();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _controller.add(state);
    super.didChangeAppLifecycleState(state);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.close();
  }
}
