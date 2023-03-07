// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import '../analytics.dart';

class NullAnalyticsBackend extends AnalyticsBackend {
  @override
  void log(String name, [Map<String, dynamic>? data]) {}

  @override
  Future<void> setAnalyticsCollectionEnabled(bool value) async {}

  @override
  Future<void> logSignUp({String? signUpMethod}) async {}

  @override
  Future<void> setCurrentScreen({String? screenName}) async {}

  @override
  Future<void> setUserProperty({String? name, String? value}) async {}
}

AnalyticsBackend getBackend() {
  return NullAnalyticsBackend();
}
