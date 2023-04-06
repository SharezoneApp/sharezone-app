// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:convert';

import 'package:built_value/serializer.dart';

/// Format the given parameter object into string.
String parameterToString(Serializers serializers, dynamic value) {
  if (value == null) {
    return '';
  } else if (value is String || value is num) {
    return value.toString();
  } else {
    return json.encode(serializers.serialize(value));
  }
}
