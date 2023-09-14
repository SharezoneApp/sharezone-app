// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';

class EnterActivationCodeEvent extends AnalyticsEvent {
  static const _eventName = 'entered_activation_code';
  EnterActivationCodeEvent(String activationCode)
      : super(_eventName, data: {'activationCode': activationCode});
}

class SuccessfulEnterActivationCodeEvent extends AnalyticsEvent {
  // Even "successfull" is a typo, it's the name of the event in the backend
  // and we can't change it.
  static const _eventName = 'entered_activation_code_successfull';
  SuccessfulEnterActivationCodeEvent(String activationCode)
      : super(_eventName, data: {'activationCode': activationCode});
}

class FailedEnterActivationCodeEvent extends AnalyticsEvent {
  static const _eventName = 'entered_activation_code_failed';
  FailedEnterActivationCodeEvent(String activationCode)
      : super(_eventName, data: {'activationCode': activationCode});
}
