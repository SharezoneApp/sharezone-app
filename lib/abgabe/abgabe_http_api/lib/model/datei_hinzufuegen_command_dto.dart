// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

        import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'datei_hinzufuegen_command_dto.g.dart';

abstract class DateiHinzufuegenCommandDto implements Built<DateiHinzufuegenCommandDto, DateiHinzufuegenCommandDtoBuilder> {

    
    @BuiltValueField(wireName: r'id')
    String get id;
    
    @BuiltValueField(wireName: r'name')
    String get name;

    // Boilerplate code needed to wire-up generated code
    DateiHinzufuegenCommandDto._();

    factory DateiHinzufuegenCommandDto([updates(DateiHinzufuegenCommandDtoBuilder b)]) = _$DateiHinzufuegenCommandDto;
    static Serializer<DateiHinzufuegenCommandDto> get serializer => _$dateiHinzufuegenCommandDtoSerializer;

}

