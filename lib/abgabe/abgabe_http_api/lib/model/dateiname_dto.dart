// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

        import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dateiname_dto.g.dart';

abstract class DateinameDto implements Built<DateinameDto, DateinameDtoBuilder> {

    
    @BuiltValueField(wireName: r'name')
    String get name;

    // Boilerplate code needed to wire-up generated code
    DateinameDto._();

    factory DateinameDto([updates(DateinameDtoBuilder b)]) = _$DateinameDto;
    static Serializer<DateinameDto> get serializer => _$dateinameDtoSerializer;

}

