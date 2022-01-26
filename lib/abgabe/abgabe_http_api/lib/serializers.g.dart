// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

// GENERATED CODE - DO NOT MODIFY BY HAND

part of serializers;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers = (new Serializers().toBuilder()
      ..add(DateiHinzufuegenCommandDto.serializer)
      ..add(DateiHinzufuegenCommandDto1.serializer)
      ..add(DateienHinzufuegenCommandDto.serializer)
      ..add(DateinameDto.serializer)
      ..add(InlineResponse400.serializer)
      ..add(InlineResponse403.serializer)
      ..add(SubmissionDto.serializer)
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(DateiHinzufuegenCommandDto1)]),
          () => new ListBuilder<DateiHinzufuegenCommandDto1>()))
    .build();

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
