// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'events/authentifaction_event.dart';
import 'package:analytics/analytics.dart';

class RegistrationAnalytics {
  static const anonymous = "anonymous_with_onboarding";
  static const oAuth = "o_auth_with_onboarding";

  final Analytics _analytics;

  RegistrationAnalytics(this._analytics);

  void logAnonymousRegistration() {
    _analytics
        .log(AuthentifactionEvent(provider: anonymous, name: "registered"));
  }

  void logOAuthRegistration() {
    _analytics.log(AuthentifactionEvent(provider: oAuth, name: "registered"));
  }
}

/// As FirebaseAnalytics shows some special graphs with the preconfigured events
/// we will additionally use them to our Analytics.
class RegistrationAnalyticsAnalyticsWithInternalFirebaseEvents
    extends RegistrationAnalytics {
  RegistrationAnalyticsAnalyticsWithInternalFirebaseEvents(super.analytics);

  @override
  void logAnonymousRegistration() {
    _analytics.logSignUp(signUpMethod: RegistrationAnalytics.anonymous);
    super.logAnonymousRegistration();
  }
}
