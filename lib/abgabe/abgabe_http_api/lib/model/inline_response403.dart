// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inline_response403.g.dart';

abstract class InlineResponse403
    implements Built<InlineResponse403, InlineResponse403Builder> {
  @BuiltValueField(wireName: r'error')
  String get error;
  /* The required scope for this operation. */
  @BuiltValueField(wireName: r'scope')
  String get scope;

  // Boilerplate code needed to wire-up generated code
  InlineResponse403._();

  factory InlineResponse403([Function(InlineResponse403Builder b) updates]) =
      _$InlineResponse403;
  static Serializer<InlineResponse403> get serializer =>
      _$inlineResponse403Serializer;
}
