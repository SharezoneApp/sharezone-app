// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:crash_analytics/crash_analytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import '../analytics.dart';

class FirebaseAnalyticsBackend extends AnalyticsBackend {
  final FirebaseAnalytics _firebaseAnalytics;
  final CrashAnalytics crashAnalytics;

  const FirebaseAnalyticsBackend(this._firebaseAnalytics, this.crashAnalytics);

  @override
  void log(String name, [Map<String, dynamic>? data]) {
    _firebaseAnalytics.logEvent(name: name, parameters: data);
    crashAnalytics.log(name);
  }

  @override
  Future<void> setAnalyticsCollectionEnabled(bool value) {
    return _firebaseAnalytics.setAnalyticsCollectionEnabled(value);
  }

  @override
  Future<void> logSignUp({
    required String signUpMethod,
  }) async {
    await _firebaseAnalytics.logSignUp(signUpMethod: signUpMethod);
    crashAnalytics.log('signUp: $signUpMethod');
  }

  @override
  Future<void> setCurrentScreen({String? screenName}) async {
    await _firebaseAnalytics.setCurrentScreen(screenName: screenName);
    crashAnalytics.log('setCurrentScreen: $screenName');
  }

  /// Sets a user property to a given value.
  ///
  /// Up to 25 user property names are supported. Once set, user property
  /// values persist throughout the app lifecycle and across sessions.
  ///
  /// [name] is the name of the user property to set. Should contain 1 to 24
  /// alphanumeric characters or underscores and must start with an alphabetic
  /// character. The "firebase_" prefix is reserved and should not be used for
  /// user property names.
  Future<void> setUserProperty({required String name, required String value}) =>
      _firebaseAnalytics.setUserProperty(name: name, value: value);
}

AnalyticsBackend getBackend() {
  return FirebaseAnalyticsBackend(
      FirebaseAnalytics.instance, getCrashAnalytics());
}
