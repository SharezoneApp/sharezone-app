// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:abgabe_http_api/model/datei_hinzufuegen_command_dto.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dateien_hinzufuegen_command_dto.g.dart';

abstract class DateienHinzufuegenCommandDto
    implements
        Built<DateienHinzufuegenCommandDto,
            DateienHinzufuegenCommandDtoBuilder> {
  @BuiltValueField(wireName: r'hinzufuegenCommands')
  BuiltList<DateiHinzufuegenCommandDto> get hinzufuegenCommands;

  // Boilerplate code needed to wire-up generated code
  DateienHinzufuegenCommandDto._();

  factory DateienHinzufuegenCommandDto(
          [Function(DateienHinzufuegenCommandDtoBuilder b) updates]) =
      _$DateienHinzufuegenCommandDto;
  static Serializer<DateienHinzufuegenCommandDto> get serializer =>
      _$dateienHinzufuegenCommandDtoSerializer;
}
