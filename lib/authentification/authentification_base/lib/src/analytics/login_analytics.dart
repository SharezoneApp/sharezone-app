// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'events/authentifaction_event.dart';

import 'package:analytics/analytics.dart';

class LoginAnalytics {
  static const google = "google";
  static const apple = "apple";
  static const customToken = "customToken";
  static const emailAndPassword = "email_and_password";
  static const name = "loggedIn";

  final Analytics _analytics;

  LoginAnalytics(this._analytics);

  void logGoolgeLogin() {
    _analytics.log(AuthentifactionEvent(provider: google, name: name));
  }

  void logAppleLogin() {
    _analytics.log(AuthentifactionEvent(provider: apple, name: name));
  }

  void logQrCodeCustomTokenWebLogin() {
    _analytics.log(AuthentifactionEvent(
      provider: customToken,
      name: name,
    ));
  }

  void logEmailAndPasswordLogin() {
    _analytics
        .log(AuthentifactionEvent(provider: emailAndPassword, name: name));
  }
}
