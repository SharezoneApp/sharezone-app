// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

class Features {
  final bool allColors;

  Features({
    required this.allColors,
  });

  Map<String, dynamic> toJson() {
    return {
      'allColors': allColors,
    };
  }

  factory Features.fromJson(Map<String, dynamic>? map) {
    return Features(
      allColors: map == null ? true : map['allColors'] ?? true,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Features && other.allColors == allColors;
  }

  @override
  int get hashCode => allColors.hashCode;

  @override
  String toString() => 'Features(allColors: $allColors)';
}
