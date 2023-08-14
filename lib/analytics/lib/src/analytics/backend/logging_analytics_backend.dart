// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

// Using a import prefix to avoid conflicts with the analytics and developer
// `log` method.
import 'dart:developer' as developer;

import '../analytics.dart';

class LoggingAnalyticsBackend extends AnalyticsBackend {
  @override
  void log(String name, [Map<String, dynamic>? data]) {
    developer.log("AnalyticsEvent $name received. Data: $data");
  }

  @override
  Future<void> setAnalyticsCollectionEnabled(bool value) async {
    developer
        .log("setAnalyticsCollectionEnabled: $setAnalyticsCollectionEnabled");
  }

  @override
  Future<void> logSignUp({String? signUpMethod}) async {
    developer.log("logSignUp signUpMethod: $signUpMethod");
  }

  @override
  Future<void> setCurrentScreen({String? screenName}) async {
    developer.log("setCurrentScreen screenName: $screenName");
  }

  @override
  Future<void> setUserProperty({String? name, String? value}) async {
    developer.log("setUserProperty $name value $value");
  }
}

AnalyticsBackend getBackend() {
  return LoggingAnalyticsBackend();
}
