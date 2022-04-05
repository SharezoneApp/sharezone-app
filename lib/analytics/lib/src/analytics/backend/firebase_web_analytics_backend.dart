// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter/material.dart';
import '../analytics.dart';

class FirebaseWebAnalyticsBackend extends AnalyticsBackend {
  final firebase.Analytics _firebaseAnalytics;

  const FirebaseWebAnalyticsBackend(this._firebaseAnalytics);

  @override
  void log(String name, [Map<String, dynamic> data]) {
    _firebaseAnalytics.logEvent(name, data);
  }

  @override
  Future<void> setAnalyticsCollectionEnabled(bool value) async {
    _firebaseAnalytics.setAnalyticsCollectionEnabled(value);
  }

  @override
  Future<void> logSignUp({
    @required String signUpMethod,
  }) async {
    // LogSignUp is not implemented on firebasejs , therefore redirecting to logevent
    _firebaseAnalytics.logEvent("web_signUp", {"signUpMethod": signUpMethod});
  }

  @override
  Future<void> setCurrentScreen({String screenName}) async {
    _firebaseAnalytics.setCurrentScreen(screenName);
  }

  @override
  Future<void> setUserProperty({String name, String value}) async {
    return _firebaseAnalytics.setUserProperties({name: value});
  }
}

AnalyticsBackend getBackend() {
  return FirebaseWebAnalyticsBackend(firebase.analytics());
}
