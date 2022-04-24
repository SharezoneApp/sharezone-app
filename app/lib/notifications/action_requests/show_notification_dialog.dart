// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notifications/notifications.dart';
import 'package:sharezone_widgets/adaptive_dialog.dart';
import 'package:url_launcher_extended/url_launcher_extended.dart';

ActionRegistration<ShowNotificationDialogRequest>
    showNotificationDialogRegistrationWith(
            ActionRequestExecutorFunc<ShowNotificationDialogRequest>
                executorFunc) =>
        ActionRegistration<ShowNotificationDialogRequest>(
          registerForActionTypeStrings:
              ShowNotificationDialogRequest.actionTypes,
          parseActionRequestFromNotification:
              _toShowNotificationDialogActionRequest,
          executeActionRequest: executorFunc,
        );

ShowNotificationDialogRequest _toShowNotificationDialogActionRequest(
    PushNotification notification,
    [PushNotificationParserInstrumentation instrumentation]) {
  final showSupportOption = instrumentation.parseAttributeOrLogFailure(
    'showSupportOption',
    fallbackValue: false,
    parse: () {
      final val = notification.actionData['showSupportOption'];
      if (val is bool) return val;
      if (val is String) {
        if (val == 'true') return true;
        if (val == 'false') return false;
      }
      if (val != null) {
        throw ArgumentError(
            'Expected $val to be String or bool. It was instead a ${val.runtimeType}');
      }
    },
  );

  return ShowNotificationDialogRequest(
    notification.title,
    notification.body,
    shouldShowAnswerToSupportOption: showSupportOption,
  );
}

/// Show a notifiation with given [title] and [body] inside a dialog to the
/// user. The dialog may include a "answer to support" button (see
/// [shouldShowAnswerToSupportOption]).
///
/// See also [ShowNotificationDialogExecutor].
class ShowNotificationDialogRequest extends ActionRequest {
  static const Set<String> actionTypes = {''};

  final String title;
  bool get hasTitle => title != null && title != '';
  final String body;
  bool get hasBody => body != null && body != '';

  /// Whether the user should have the option to answer the support in the
  /// dialog which shows the content of the notification. It usually opens the
  /// default email program and prefills the contents of this notification so we
  /// know the context of the answer of the user.
  ///
  /// This is used as a kind of workaround so a user can answer to a
  /// notification we sent to him. This happens e.g. if some user sent us a
  /// feedback previously and we send a notification to him that asks for
  /// further details regarding that feedback (so we can fix a problem for
  /// example).
  ///
  /// This button is then a quick and convienient way the user can give us more
  /// information.
  ///
  /// This is kind of a hacky thing because we don't have a way to answer to
  /// feedbacks currently which might replace this feature in the future.
  final bool shouldShowAnswerToSupportOption;

  @override
  List<Object> get props => [title, body, shouldShowAnswerToSupportOption];

  ShowNotificationDialogRequest(this.title, this.body,
      {@required this.shouldShowAnswerToSupportOption}) {
    final isTitleEmpty = _isEmptyString(title);
    final isBodyEmpty = _isEmptyString(body);
    if (isTitleEmpty && isBodyEmpty) {
      throw ArgumentError('Either title or body must be a non-empty string');
    }
  }

  bool _isEmptyString(String s) => s == null || s.trim() == '';
}

class ShowNotificationDialogExecutor
    extends ActionRequestExecutor<ShowNotificationDialogRequest> {
  final BuildContext Function() getCurrentContext;

  ShowNotificationDialogExecutor(this.getCurrentContext);

  @override
  FutureOr<void> execute(ShowNotificationDialogRequest actionRequest) {
    actionRequest.shouldShowAnswerToSupportOption
        ? _showSupportDialog(actionRequest)
        : _showDialog(actionRequest);
  }

  void _showSupportDialog(ShowNotificationDialogRequest actionRequest) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final confiremd = await showLeftRightAdaptiveDialog<bool>(
        context: getCurrentContext(),
        title: actionRequest.title,
        content: actionRequest.hasBody ? Text(actionRequest.body) : null,
        defaultValue: false,
        right: AdaptiveDialogAction<bool>(
          isDefaultAction: true,
          popResult: true,
          title: "Antworten",
        ),
      );
      if (confiremd) {
        UrlLauncherExtended().tryLaunchMailOrThrow(
          "support@sharezone.net",
          subject: 'Rückmeldung zur Support-Notifaction',
          body:
              'Liebes Sharezone-Team,\n\nihr habt folgende Nachricht geschreiben:\n${actionRequest.title}; ${actionRequest.body}\n\nMein Anliegen:\n_',
        );
      }
    });
  }

  void _showDialog(ShowNotificationDialogRequest actionRequest) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showLeftRightAdaptiveDialog<bool>(
        context: getCurrentContext(),
        title: actionRequest.title,
        content: actionRequest.hasBody ? Text(actionRequest.body) : null,
        defaultValue: false,
        left: AdaptiveDialogAction<bool>(
          isDefaultAction: true,
          title: "Ok",
        ),
      );
    });
  }
}
