// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'events/authentifaction_event.dart';

class LinkProviderAnalytics {
  static const google = "google";
  static const apple = "apple";
  static const emailAndPassword = "email_and_password";
  static const name = "linked_provider";

  final Analytics _analytics;

  LinkProviderAnalytics(this._analytics);

  void logGoogleLink() {
    _analytics.log(AuthentifactionEvent(provider: google, name: name));
  }

  void logAppleLink() {
    _analytics.log(AuthentifactionEvent(provider: apple, name: name));
  }

  void logEmailAndPasswordLink() {
    _analytics
        .log(AuthentifactionEvent(provider: emailAndPassword, name: name));
  }

  /// Wird ausgeführt, wenn der Nutzer versehentlicht einen
  /// zweiten Account erstellt hat und diesen mit einer bereits
  /// im System existierenden E-Mail verknpüfen möchte.
  /// Grund fürs Tracking: Herausfinden, wie viele User den Anmeldebutton
  /// im Onboarding übersehen
  void logCredentialAlreadyInUseError() {
    _analytics.log(const AnalyticsEvent("credential_already_in_use_error"));
  }

  /// Wird ausgeführt, wenn der Nutzer sich die Anleitung zur Nutzung von Sharezone
  /// auf mehreren Geräten anschaut. Mit dieser Angabe kann man herausfinden,
  /// wie viel Energie und Zeit in Zukunft in diese und ähnliche Anleitungen gesteckt
  /// werden soll.
  void logShowedUseMultipleDevicesInstruction() {
    _analytics
        .log(const AnalyticsEvent("showed_use_multiple_devices_instruction"));
  }
}
