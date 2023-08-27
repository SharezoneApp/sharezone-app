// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:analytics/analytics.dart';

class EnterActivationCodeEvent extends AnalyticsEvent {
  static const _eventName = 'entered_activation_code';
  EnterActivationCodeEvent(String activationCode)
      : super(_eventName, data: {'activationCode': activationCode});
}

class SuccessfullEnterActivationCodeEvent extends AnalyticsEvent {
  static const _eventName = 'entered_activation_code_successfull';
  SuccessfullEnterActivationCodeEvent(String activationCode)
      : super(_eventName, data: {'activationCode': activationCode});
}

class FailedEnterActivationCodeEvent extends AnalyticsEvent {
  static const _eventName = 'entered_activation_code_failed';
  FailedEnterActivationCodeEvent(String activationCode)
      : super(_eventName, data: {'activationCode': activationCode});
}
