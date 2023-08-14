// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inline_response400.g.dart';

abstract class InlineResponse400
    implements Built<InlineResponse400, InlineResponse400Builder> {
  @BuiltValueField(wireName: r'error')
  String get error;

  // Boilerplate code needed to wire-up generated code
  InlineResponse400._();

  factory InlineResponse400([Function(InlineResponse400Builder b) updates]) =
      _$InlineResponse400;
  static Serializer<InlineResponse400> get serializer =>
      _$inlineResponse400Serializer;
}
