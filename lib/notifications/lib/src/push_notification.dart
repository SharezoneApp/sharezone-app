// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:collection/collection.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotification {
  /// The [actionType] of the notifcation, e.g. "navigate-to-given-location".
  final String? actionType;
  bool get hasActionType => actionType != null && actionType != '';

  /// [actionData] is data for the action that is identified by [actionType].
  /// [actionData] can't be null, rather it will be an empty map if not data
  /// is available.
  ///
  /// For example:
  /// ```dart
  /// // If the action should be to show a homework...
  /// expect(pushNotification.actionType, 'show-homework');
  ///
  /// // ... then the actionData could contain the id of the homework that should be shown.
  /// expect(pushNotification.actionData, {'id':'N92bcP92MYw92müzhgacm'})
  /// ```
  ///
  ///
  // Kann nicht null sein (ist dann leere Map)
  /// The [actionData] is the data for a certain [actionType], e.g. if
  /// [actionType] is "navigate-to-given-location" then the [actionData] could
  /// be "homework-page".
  /// It is not guranteed which type the [actionData] has. As in the example
  /// above it could be a string but might also be a map with several entries.
  final Map<String, dynamic> actionData;
  final String? title;
  bool get hasNonEmptyTitle => title != null && title != '';

  final String? body;
  bool get hasNonEmptyBody => body != null && body != '';

  bool get hasDisplaybleText => hasNonEmptyTitle || hasNonEmptyBody;

  const PushNotification({
    required this.actionType,
    required this.title,
    required this.body,
    Map<String, dynamic>? actionData,
  }) : actionData = actionData ?? const {};

  factory PushNotification.fromFirebase(RemoteMessage message) {
    final actionType = message.data['actionType'];
    final actionData = message.data..remove('actionType');
    final title = message.notification?.title;
    final body = message.notification?.body;

    return PushNotification(
      title: title,
      body: body,
      actionType: actionType,
      actionData: actionData,
    );
  }

  PushNotification copyWith({
    String? actionType,
    dynamic actionData,
    String? title,
    String? body,
  }) {
    return PushNotification(
      actionType: actionType ?? this.actionType,
      actionData: actionData ?? this.actionData,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final mapEquals = const DeepCollectionEquality().equals;

    return other is PushNotification &&
        other.actionType == actionType &&
        mapEquals(other.actionData, actionData) &&
        other.title == title &&
        other.body == body;
  }

  @override
  int get hashCode {
    return actionType.hashCode ^
        actionData.hashCode ^
        title.hashCode ^
        body.hashCode;
  }

  @override
  String toString() {
    return 'PushNotification(actionType: $actionType, actionData: $actionData, title: $title, body: $body)';
  }
}
