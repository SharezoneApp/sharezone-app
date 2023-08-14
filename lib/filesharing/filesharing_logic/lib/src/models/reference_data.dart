// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/foundation.dart';

import 'reference_type.dart';

class ReferenceData {
  String id;
  ReferenceType type;

  ReferenceData({
    @required this.id,
    @required this.type,
  });

  factory ReferenceData.fromData(Map<String, dynamic> data) {
    return ReferenceData(
      id: data['id'],
      type: data['type'],
    );
  }

  factory ReferenceData.fromMapData(
      {@required String id, @required Map<String, dynamic> data}) {
    return ReferenceData(
      id: id,
      type: referenceTypeEnumFromString(data['type']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': referenceTypeEnumToString(type),
    };
  }

  ReferenceData copyWith({
    String id,
    ReferenceType type,
  }) {
    return ReferenceData(
      id: id ?? this.id,
      type: type ?? this.type,
    );
  }
}
