import '../notifications.dart';
import 'action_request.dart';
import 'instrumentation.dart';
import 'push_notification.dart';

class PushNotificationParser {
  final Map<String, PushNotificationParsingFunc> _parsingMap;
  final PushNotificationParserInstrumentationFactory _instrumentationFactory;

  const PushNotificationParser._(
      this._parsingMap, this._instrumentationFactory);

  factory PushNotificationParser(
    List<ActionRegistration<ActionRequest>> actionRegistrations,
    PushNotificationActionHandlerInstrumentation _instrumentation,
  ) {
    final parserMap = <String, PushNotificationParsingFunc>{};

    for (final registration in actionRegistrations) {
      for (final actionTypeString
          in registration.registerForActionTypeStrings) {
        /// If an action registration is registered for an empty action type ('')
        /// it should be used if a notification has:
        /// * [PushNotification.actionType] == `null`
        /// * [PushNotification.actionType] == `''` (empty String)
        if (actionTypeString == '') {
          parserMap[null] = registration.parseActionRequestFromNotification;
        }

        parserMap[actionTypeString] =
            registration.parseActionRequestFromNotification;
      }
    }

    return PushNotificationParser._(parserMap,
        PushNotificationParserInstrumentationFactory(_instrumentation));
  }

  /// Finds the corresponding parsing function for the [notification] by looking
  /// at the [PushNotification.actionType], uses it to build an [ActionRequest]
  /// and returns it.
  ///
  /// If no corresponding parsing function for [notification] can be found it
  /// will throw an [UnknownActionTypeException].
  ActionRequest parseNotification(PushNotification notification) {
    if (!_hasActionTypeRegistered(notification.actionType)) {
      throw UnknownActionTypeException(notification.actionType, notification);
    }

    final buildActionRequest = _getParsingFunctionFor(notification.actionType);

    assert(buildActionRequest != null);

    return buildActionRequest(
        notification, _instrumentationFactory.forNotification(notification));
  }

  bool _hasActionTypeRegistered(String actionType) {
    return _parsingMap.containsKey(actionType);
  }

  PushNotificationParsingFunc _getParsingFunctionFor(String actionType) {
    return _parsingMap[actionType];
  }
}

/// The [PushNotificationParser] could not find an [ActionRegistration] where
/// [ActionRegistration.registerForActionTypeStrings] equals the
/// [actionTypeString] of the [notification].
class UnknownActionTypeException implements Exception {
  final String actionTypeString;
  final PushNotification notification;

  UnknownActionTypeException(this.actionTypeString, this.notification);

  @override
  String toString() =>
      'UnhandledActionTypeException(actionTypeString: $actionTypeString, notification: $notification)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UnknownActionTypeException &&
        other.actionTypeString == actionTypeString &&
        other.notification == notification;
  }

  @override
  int get hashCode => actionTypeString.hashCode ^ notification.hashCode;
}
