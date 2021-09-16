import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notifications/notifications.dart';
import 'package:sharezone/util/launch_link.dart';

ActionRegistration<OpenLinkRequest> openLinkRegistrationWith(
        ActionRequestExecutorFunc<OpenLinkRequest> executorFunc) =>
    ActionRegistration<OpenLinkRequest>(
      registerForActionTypeStrings: OpenLinkRequest.actionTypes,
      parseActionRequestFromNotification: _toOpenLinkActionRequest,
      executeActionRequest: executorFunc,
    );

OpenLinkRequest _toOpenLinkActionRequest(PushNotification notification,
        PushNotificationParserInstrumentation instrumentation) =>
    OpenLinkRequest(notification.actionData['link'] as String);

/// Open a given link/url inside a browser (may be outside the app or in a
/// WebView inside the app).
///
/// See also [OpenLinkExecutor].
class OpenLinkRequest extends ActionRequest {
  static const Set<String> actionTypes = {'open-given-link'};

  // Because the flutter side (especially package:`url_launcher`) accepts a
  // String and not an URL (partly because of
  // https://github.com/dart-lang/sdk/issues/43838) we will use a String here
  // instead of an URL.
  final String linkToOpen;

  @override
  List<Object> get props => [linkToOpen];

  OpenLinkRequest(this.linkToOpen) {
    _throwIfNullOrEmptyString(linkToOpen, 'linkToOpen');
  }
}

class OpenLinkExecutor extends ActionRequestExecutor<OpenLinkRequest> {
  final BuildContext Function() _getCurrentContext;

  OpenLinkExecutor(this._getCurrentContext);

  @override
  FutureOr<void> execute(OpenLinkRequest actionRequest) {
    return launchURL(actionRequest.linkToOpen, context: _getCurrentContext());
  }
}

void _throwIfNullOrEmptyString(String value, String name) {
  ArgumentError.checkNotNull(value, name);
  if (value.isEmpty) {
    throw ArgumentError('$name must not be an empty String.');
  }
}
