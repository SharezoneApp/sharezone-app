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
    return _firestore.collection(CollectionNames.user).doc(_userId).set(
      {'lastOnline': FieldValue.serverTimestamp()},
      SetOptions(merge: true),
    );
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
