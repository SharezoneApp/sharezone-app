// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:math';

class Id {
  final String id;

  const Id(this.id) : assert(id != "");

  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is Id && other.id == id;
  }

  /// Generates a new random [Id] with a the given [length] using characters
  /// from a-z, A-Z and 0-9.
  static Id generate({
    int length = 20,
    Random? random,
  }) {
    random ??= Random();
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final id =
        List.generate(length, (index) => chars[random!.nextInt(chars.length)])
            .join();
    return Id(id);
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return id;
  }
}
