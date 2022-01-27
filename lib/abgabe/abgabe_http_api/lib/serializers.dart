// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

library serializers;

import 'package:abgabe_http_api/model/datei_hinzufuegen_command_dto.dart';
import 'package:abgabe_http_api/model/datei_hinzufuegen_command_dto1.dart';
import 'package:abgabe_http_api/model/dateien_hinzufuegen_command_dto.dart';
import 'package:abgabe_http_api/model/dateiname_dto.dart';
import 'package:abgabe_http_api/model/inline_response400.dart';
import 'package:abgabe_http_api/model/inline_response403.dart';
import 'package:abgabe_http_api/model/submission_dto.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

part 'serializers.g.dart';

@SerializersFor(const [
  DateiHinzufuegenCommandDto,
  DateiHinzufuegenCommandDto1,
  DateienHinzufuegenCommandDto,
  DateinameDto,
  InlineResponse400,
  InlineResponse403,
  SubmissionDto,
])

// allow all models to be serialized within a list
Serializers serializers = (_$serializers.toBuilder()
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(DateiHinzufuegenCommandDto)]),
          () => new ListBuilder<DateiHinzufuegenCommandDto>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(DateiHinzufuegenCommandDto1)]),
          () => new ListBuilder<DateiHinzufuegenCommandDto1>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(DateienHinzufuegenCommandDto)]),
          () => new ListBuilder<DateienHinzufuegenCommandDto>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DateinameDto)]),
          () => new ListBuilder<DateinameDto>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(InlineResponse400)]),
          () => new ListBuilder<InlineResponse400>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(InlineResponse403)]),
          () => new ListBuilder<InlineResponse403>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(SubmissionDto)]),
          () => new ListBuilder<SubmissionDto>()))
    .build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
