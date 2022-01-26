// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datei_hinzufuegen_command_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<DateiHinzufuegenCommandDto> _$dateiHinzufuegenCommandDtoSerializer =
    new _$DateiHinzufuegenCommandDtoSerializer();

class _$DateiHinzufuegenCommandDtoSerializer
    implements StructuredSerializer<DateiHinzufuegenCommandDto> {
  @override
  final Iterable<Type> types = const [
    DateiHinzufuegenCommandDto,
    _$DateiHinzufuegenCommandDto
  ];
  @override
  final String wireName = 'DateiHinzufuegenCommandDto';

  @override
  Iterable<Object> serialize(
      Serializers serializers, DateiHinzufuegenCommandDto object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  DateiHinzufuegenCommandDto deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new DateiHinzufuegenCommandDtoBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$DateiHinzufuegenCommandDto extends DateiHinzufuegenCommandDto {
  @override
  final String id;
  @override
  final String name;

  factory _$DateiHinzufuegenCommandDto(
          [void Function(DateiHinzufuegenCommandDtoBuilder) updates]) =>
      (new DateiHinzufuegenCommandDtoBuilder()..update(updates)).build();

  _$DateiHinzufuegenCommandDto._({this.id, this.name}) : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('DateiHinzufuegenCommandDto', 'id');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('DateiHinzufuegenCommandDto', 'name');
    }
  }

  @override
  DateiHinzufuegenCommandDto rebuild(
          void Function(DateiHinzufuegenCommandDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DateiHinzufuegenCommandDtoBuilder toBuilder() =>
      new DateiHinzufuegenCommandDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DateiHinzufuegenCommandDto &&
        id == other.id &&
        name == other.name;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, id.hashCode), name.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('DateiHinzufuegenCommandDto')
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class DateiHinzufuegenCommandDtoBuilder
    implements
        Builder<DateiHinzufuegenCommandDto, DateiHinzufuegenCommandDtoBuilder> {
  _$DateiHinzufuegenCommandDto _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  DateiHinzufuegenCommandDtoBuilder();

  DateiHinzufuegenCommandDtoBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _name = _$v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DateiHinzufuegenCommandDto other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$DateiHinzufuegenCommandDto;
  }

  @override
  void update(void Function(DateiHinzufuegenCommandDtoBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$DateiHinzufuegenCommandDto build() {
    final _$result =
        _$v ?? new _$DateiHinzufuegenCommandDto._(id: id, name: name);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
