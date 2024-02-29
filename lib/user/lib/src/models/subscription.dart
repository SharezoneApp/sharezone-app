// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:cloud_firestore_helper/cloud_firestore_helper.dart';
import 'package:helper_functions/helper_functions.dart';

class Subscription {
  /// The date the user last purchased the subscription.
  ///
  /// This will be updated every month as the subscription is renewed.
  final DateTime purchasedAt;

  /// The date the latest user's subscription expires.
  final DateTime expiresAt;

  /// The source where the subscription was purchased.
  final SubscriptionSource source;

  const Subscription(
    this.purchasedAt,
    this.expiresAt,
    this.source,
  );

  static Subscription? fromData(Map<String, dynamic>? map) {
    if (map == null) return null;
    return Subscription.fromJson(map);
  }

  factory Subscription.fromJson(Map<String, dynamic> map) {
    return Subscription(
      dateTimeFromTimestamp(map['purchasedAt']),
      dateTimeFromTimestamp(map['expiresAt']),
      SubscriptionSource.values.tryByName(
        map['source'],
        defaultValue: SubscriptionSource.unknown,
      ),
    );
  }

  @override
  String toString() =>
      'Subscription(purchasedAt: $purchasedAt, expiresAt: $expiresAt, source: $source)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Subscription &&
        other.purchasedAt == purchasedAt &&
        other.expiresAt == expiresAt &&
        other.source == source;
  }

  @override
  int get hashCode =>
      purchasedAt.hashCode ^ expiresAt.hashCode ^ source.hashCode;
}

enum SubscriptionSource {
  playStore('Play Store'),
  appStore('App Store'),
  stripe('Stripe'),
  unknown('Unknown');

  const SubscriptionSource(this.uiString);

  final String uiString;
}
