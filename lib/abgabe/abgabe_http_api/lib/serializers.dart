// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

library serializers;

import 'package:abgabe_http_api/model/datei_hinzufuegen_command_dto.dart';
import 'package:abgabe_http_api/model/dateien_hinzufuegen_command_dto.dart';
import 'package:abgabe_http_api/model/dateiname_dto.dart';
import 'package:abgabe_http_api/model/inline_response400.dart';
import 'package:abgabe_http_api/model/inline_response403.dart';
import 'package:abgabe_http_api/model/submission_dto.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

part 'serializers.g.dart';

@SerializersFor([
  DateiHinzufuegenCommandDto,
  DateienHinzufuegenCommandDto,
  DateinameDto,
  InlineResponse400,
  InlineResponse403,
  SubmissionDto,
])

// allow all models to be serialized within a list
Serializers serializers = (_$serializers.toBuilder()
      ..addBuilderFactory(
          const FullType(BuiltList, [FullType(DateiHinzufuegenCommandDto)]),
          () => ListBuilder<DateiHinzufuegenCommandDto>())
      ..addBuilderFactory(
          const FullType(BuiltList, [FullType(DateienHinzufuegenCommandDto)]),
          () => ListBuilder<DateienHinzufuegenCommandDto>())
      ..addBuilderFactory(const FullType(BuiltList, [FullType(DateinameDto)]),
          () => ListBuilder<DateinameDto>())
      ..addBuilderFactory(
          const FullType(BuiltList, [FullType(InlineResponse400)]),
          () => ListBuilder<InlineResponse400>())
      ..addBuilderFactory(
          const FullType(BuiltList, [FullType(InlineResponse403)]),
          () => ListBuilder<InlineResponse403>())
      ..addBuilderFactory(const FullType(BuiltList, [FullType(SubmissionDto)]),
          () => ListBuilder<SubmissionDto>()))
    .build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
