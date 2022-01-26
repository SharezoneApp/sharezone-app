// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dateiname_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<DateinameDto> _$dateinameDtoSerializer =
    new _$DateinameDtoSerializer();

class _$DateinameDtoSerializer implements StructuredSerializer<DateinameDto> {
  @override
  final Iterable<Type> types = const [DateinameDto, _$DateinameDto];
  @override
  final String wireName = 'DateinameDto';

  @override
  Iterable<Object> serialize(Serializers serializers, DateinameDto object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  DateinameDto deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new DateinameDtoBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$DateinameDto extends DateinameDto {
  @override
  final String name;

  factory _$DateinameDto([void Function(DateinameDtoBuilder) updates]) =>
      (new DateinameDtoBuilder()..update(updates)).build();

  _$DateinameDto._({this.name}) : super._() {
    if (name == null) {
      throw new BuiltValueNullFieldError('DateinameDto', 'name');
    }
  }

  @override
  DateinameDto rebuild(void Function(DateinameDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DateinameDtoBuilder toBuilder() => new DateinameDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DateinameDto && name == other.name;
  }

  @override
  int get hashCode {
    return $jf($jc(0, name.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('DateinameDto')..add('name', name))
        .toString();
  }
}

class DateinameDtoBuilder
    implements Builder<DateinameDto, DateinameDtoBuilder> {
  _$DateinameDto _$v;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  DateinameDtoBuilder();

  DateinameDtoBuilder get _$this {
    if (_$v != null) {
      _name = _$v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DateinameDto other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$DateinameDto;
  }

  @override
  void update(void Function(DateinameDtoBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$DateinameDto build() {
    final _$result = _$v ?? new _$DateinameDto._(name: name);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
