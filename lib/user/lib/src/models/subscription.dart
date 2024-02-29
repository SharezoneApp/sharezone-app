// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:cloud_firestore_helper/cloud_firestore_helper.dart';

class Subscription {
  /// The date the user last purchased the subscription.
  ///
  /// This will be updated every month as the subscription is renewed.
  final DateTime purchasedAt;

  /// The date the latest user's subscription expires.
  final DateTime expiresAt;

  const Subscription(
    this.purchasedAt,
    this.expiresAt,
  );

  Map<String, dynamic> toJson() {
    return {
      'purchasedAt': purchasedAt,
      'expiresAt': expiresAt,
    };
  }

  static Subscription? fromData(Map<String, dynamic>? map) {
    if (map == null) return null;
    return Subscription.fromJson(map);
  }

  factory Subscription.fromJson(Map<String, dynamic> map) {
    return Subscription(
      dateTimeFromTimestamp(map['purchasedAt']),
      dateTimeFromTimestamp(map['expiresAt']),
    );
  }

  @override
  String toString() =>
      'Subscription(purchasedAt: $purchasedAt, expiresAt: $expiresAt)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Subscription &&
        other.purchasedAt == purchasedAt &&
        other.expiresAt == expiresAt;
  }

  @override
  int get hashCode => purchasedAt.hashCode ^ expiresAt.hashCode;
}
