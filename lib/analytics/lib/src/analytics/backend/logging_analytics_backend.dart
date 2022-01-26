// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import '../analytics.dart';

class LoggingAnalyticsBackend extends AnalyticsBackend {
  @override
  void log(String name, [Map<String, dynamic> data]) {
    print("AnalyticsEvent $name received. Data: $data");
  }

  @override
  Future<void> setAnalyticsCollectionEnabled(bool value) async {
    print("setAnalyticsCollectionEnabled: $setAnalyticsCollectionEnabled");
  }

  @override
  Future<void> logSignUp({String signUpMethod}) async {
    print("logSignUp signUpMethod: $signUpMethod");
  }

  @override
  Future<void> setCurrentScreen({String screenName}) async {
    print("setCurrentScreen screenName: $screenName");
  }

  @override
  Future<void> setUserProperty({String name, String value}) async {
    print("setUserProperty $name value $value");
  }
}

AnalyticsBackend getBackend() {
  return LoggingAnalyticsBackend();
}
