import 'package:logging/logging.dart';
import 'package:notifications/notifications.dart';

class PushNotificationActionHandlerInstrumentationImpl
    extends PushNotificationActionHandlerInstrumentation {
  final Logger _logger;

  PushNotificationActionHandlerInstrumentationImpl(this._logger);

  @override
  void actionExecutedSuccessfully(ActionRequest actionRequest) {
    _logger.info('Successfully executed the action request: $actionRequest');
  }

  @override
  void actionExecutionFailed(
      ActionRequest actionRequest, exception, StackTrace stacktrace) {
    _logger.warning('Executing action request $actionRequest failed.',
        exception, stacktrace);
  }

  @override
  void parsingFailedFataly(
      PushNotification pushNotification, exception, StackTrace stacktrace) {
    _logger.severe('Parsing notification $pushNotification failed fataly.',
        exception, stacktrace);
  }

  @override
  void parsingFailedNonFatalyOnAttribute(String attributeName,
      {fallbackValueChosenInstead, PushNotification notification, error}) {
    _logger.warning(
      "Parsing notificiation $notification had non-fatal failure. The attribute $attributeName couldn't be parsed, the value $fallbackValueChosenInstead will be used instead.",
      error,
    );
  }

  @override
  void parsingFailedOnUnknownActionType(PushNotification pushNotification) {
    _logger.warning('The action type of $pushNotification is unknown.');
  }

  @override
  void parsingSucceeded(
      PushNotification pushNotification, ActionRequest actionRequest) {
    _logger.fine('$pushNotification was successfully parsed to $actionRequest');
  }

  @override
  void startHandlingPushNotification(PushNotification pushNotification) {
    _logger.fine('Handling push notification: $pushNotification');
  }
}
