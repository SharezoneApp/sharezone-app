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
